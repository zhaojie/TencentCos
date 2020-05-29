library tencentcos;

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';


class TencentCos {
  Dio dio = Dio();

  String secretId;
  String secretKey;
  String token;
  dynamic expireTime;
  String bucket;
  String region;

  TencentCos(this.secretId, this.secretKey, this.token, this.expireTime,
      this.bucket, this.region);

  Future<String> upload(String cosPath, List<int> bytes,
      {Map<String, String> params,
      Map<String, String> headers,
      Function(int, int) progress}) async {
    String host = 'https://${this.bucket}.cos.${this.region}.myqcloud.com';
    String url = host + cosPath;
    params = params ?? Map<String, String>();
    Options options = Options();
    options.headers = headers ?? Map<String, String>();
    options.headers['content-length'] = bytes.length.toString();

    options.headers['Authorization'] =
        sign('put', cosPath, headers: options.headers, params: params);
    
    try {
      options.contentType = getContentType(cosPath);

      Response response = await dio.put(url,
          data: Stream.fromIterable(bytes.map((e) => [e])),
          onSendProgress: progress ??
              (int count, int total) {
                double progress = (count / total) * 100;
                if (progress % 5 == 0) print('progress====> ${progress.round()}%');
              },
          queryParameters: params,
          options: options);
      return response.statusCode == 200 ? url : '';
    } on DioError catch (e) {
      print('Error:' + e.message);
      return '';
    }
  }

  String getContentType(file) {
    var name = file.substring(file.lastIndexOf("/") + 1, file.length);
    var suffix =
        name.substring(name.lastIndexOf(".") + 1, name.length).toLowerCase();
    var res = "";
    if (suffix == "jpg" ||
        suffix == "gif" ||
        suffix == "png" ||
        suffix == "bmp" ||
        suffix == "jpeg") {
      res = "image/$suffix";
    } else if (suffix == "mp4"){
      res = "video/mp4";
    }
    else if(suffix=="txt" || suffix=="md"){
      res="text/plain";
    }
    else {
      res = "application/octet-stream";
    }
    return res;
  }

  String sign(String httpMethod, String costPath,
      {Map<String, String> headers,
      Map<String, String> params,
      int expire = 7200}) {
    String host = '${this.bucket}.cos.${this.region}.myqcloud.com';
    if (token != "" && headers != null) {
      headers.putIfAbsent("x-cos-security-token", () => token);
    }
    headers.putIfAbsent("host", () => host);
    headers = headers ?? Map();
    params = params ?? Map();
    headers = headers.map((key, value) => MapEntry(key.toLowerCase(), value));
    params = params.map((key, value) => MapEntry(key.toLowerCase(), value));
    List<String> headerKeys = headers.keys.toList();
    headerKeys.sort();
    String headerList = headerKeys.join(';');
    String httpHeaders = headerKeys
        .map((item) => '$item=${Uri.encodeFull(headers[item])}')
        .join('&');
    List<String> paramKeys = params.keys.toList();
    paramKeys.sort();
    String urlParamList = paramKeys.join(';');
    String httpParameters = paramKeys
        .map((item) => '$item=${Uri.encodeFull(params[item])}')
        .join('&');
    String httpString =
        '${httpMethod.toLowerCase()}\n$costPath\n$httpParameters\n$httpHeaders\n';
    print("httpString:" + httpString);
    String httpStringData = sha1.convert(utf8.encode(httpString)).toString();
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String keyTime = '$timestamp;${timestamp + expire}';
    String signKey = Hmac(sha1, utf8.encode(secretKey))
        .convert(utf8.encode(keyTime))
        .toString();
    print("signKey:" + signKey);
    String stringToSign = 'sha1\n$keyTime\n$httpStringData\n';
    String signature = Hmac(sha1, utf8.encode(signKey))
        .convert(utf8.encode(stringToSign))
        .toString();
    return 'q-sign-algorithm=sha1&q-ak=$secretId&q-sign-time=$keyTime&q-key-time=$keyTime&q-header-list=$headerList&q-url-param-list=$urlParamList&q-signature=$signature';
  }
}
