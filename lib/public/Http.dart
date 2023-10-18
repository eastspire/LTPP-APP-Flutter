/*
 * @Author: 18855190718 1491579574@qq.com
 * @Date: 2023-03-04 19:57:18
 * @LastEditors: wmzn-ltpp 1491579574@qq.com
 * @LastEditTime: 2023-10-18 15:42:18
 * @FilePath: \LTPP-APP-Flutter\lib\public\Http.dart
 * @Description: Email:1491579574@qq.com
 * QQ:1491579574
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
// 封装http请求
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ltpp/public/MyWebSocket.dart';
import 'package:ltpp/views/public/LoginPage.dart';
import 'dart:convert' as convert;
import '../assembly/MyDialog.dart';
import 'Global.dart';

Dio http = Dio();

class Http {
  // ignore: constant_identifier_names
  // 服务器地址
  // ignore: constant_identifier_names
  static const public_root_url = 'https://api.ltpp.vip';
  // ignore: constant_identifier_names
  static const private_root_url = 'http://hbnuoj.ltpp.vip:48787';
  // ignore: unused_element, slash_for_doc_comments
  /**
   * post请求
   */
  // ignore: non_constant_identifier_names
  static Future<Map<String, dynamic>> sendPost(
      BuildContext context, String http_url,
      {Map<String, String>? headers, Object? body}) async {
    // ignore: non_constant_identifier_names, unused_local_variable
    String old_url = http_url;
    String root_url =
        Global.public_network ? Http.public_root_url : Http.private_root_url;
    try {
      if (!http_url.contains('http')) {
        http_url = root_url + http_url;
      }
      if (headers != null) {
        http.options.headers = headers;
      }
      // ignore: prefer_interpolation_to_compose_strings
      http.options.headers['authorization'] = 'Bearer ' + Global.authorization;
      http.options.headers['key'] = Global.key;

      Response response = await http.post(http_url, data: body);
      Map<String, dynamic> response_json =
          convert.jsonDecode(response.toString()) as Map<String, dynamic>;
      if (response_json['code'] == 500) {
        await Global.setKey('authorization', '');
        await Global.setKey('key', '');
        await MyWebSocket.close();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false,
        );
      }
      if (response_json['code'] <= 0) {
        // ignore: use_build_context_synchronously
        MyDialog(context, content: response_json['msg'] ?? '请求失败');
      }
      return response_json;
    } catch (e) {
      // ignore: unnecessary_brace_in_string_interps
      return {'msg': '请求失败，错误信息:${e}'};
    }
  }

  // ignore: unused_element, slash_for_doc_comments
  /**
   * get请求
   */
  // ignore: non_constant_identifier_names
  static Future<Map<String, dynamic>> sendGet(
    // ignore: non_constant_identifier_names
    BuildContext context,
    String http_url, {
    Map<String, String>? headers,
  }) async {
    String root_url =
        Global.public_network ? Http.public_root_url : Http.private_root_url;
    try {
      if (!http_url.contains('http')) {
        http_url = root_url + http_url;
      }
      if (headers != null) {
        http.options.headers = headers;
      }

      http.options.headers['authorization'] = Global.authorization;
      http.options.headers['key'] = Global.key;
      Response response = await http.get(http_url);
      Map<String, dynamic> response_json =
          convert.jsonDecode(response.toString()) as Map<String, dynamic>;
      if (response_json['code'] == 500) {
        await Global.setKey('authorization', '');
        await Global.setKey('key', '');
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false,
        );
      }
      if (response_json['code'] != 1) {
        // ignore: use_build_context_synchronously
        MyDialog(context, content: response_json['msg'] ?? '请求失败');
      }
      return response_json;
    } catch (e) {
      return throw Exception(e);
    }
  }
}
