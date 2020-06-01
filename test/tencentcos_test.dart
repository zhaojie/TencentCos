import 'package:flutter_test/flutter_test.dart';
import 'package:tencentcos/tencentcos.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
void main() {

  
  test('adds one to input values', () async {
   
    DateTime now=DateTime.now();
    //.suffix  文件名后缀  上传保存 用 filePath  访问 用 cdn + filePath  确保文件名唯一 用uuid
    String filePath='/UploadFile${now.year}/${now.month}/${now.day}/${Uuid().v1()}.suffix';

    print(filePath);
    String cdn='https://cdn-qiudj-sh.zhcerp.com';
    String url=cdn+filePath;
    print(url);
    
    
    // Response response = await Dio().get("http://qiudj.com/api/file/sts");

    // String bucket = "qiudj-sh-1255938726";
    // String region = "ap-shanghai";
    // TencentCos cos = TencentCos(
    //     response.data['result']['credentials']['TmpSecretId'],
    //     response.data['result']['credentials']['TmpSecretKey'],
    //     response.data['result']['credentials']['Token'],
    //     response.data['result']['expiredTime'],
    //     bucket,
    //     region);
    // Map<String, String> params=Map<String, String>();
    // Map<String, String> headers=Map<String, String>();
    // String url = "/1.txt";
    // String sign=cos.sign("put", url, headers: headers, params: params);

    // print(sign);
    // String path = 'example.jpg'; //'test.mp4';
    // var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    //  var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    //  var file =  await MultipartFile.fromFile(path, filename:'example.txt');

    // File file=File('example.jpg');
    // print(file.readAsBytesSync());
    // String ur =
    //     await cos.upload("/example.jpg", File('example.jpg').readAsBytesSync());

    // print(ur);
  
    // String ur2 =
    //     await cos.upload("/test1.mp4", File('test.mp4').readAsBytesSync());
 
    // print(ur2);

    // String ur3 =
    //     await cos.upload("/README.md", File('README.md').readAsBytesSync());

    // print(ur3);

    // String ur4=await cos.upload("/testtxt.txt", File('testtxt.txt').readAsBytesSync());
    // print(ur4);
  });
}
