/*
 * @Author: 18855190718 1491579574@qq.com
 * @Date: 2023-03-04 15:56:59
 * @LastEditors: eastspire 1491579574@qq.com
 * @LastEditTime: 2023-11-20 14:10:27
 * @FilePath: \LTPP-APP-Flutter\lib\views\public\ArticlePage.dart
 * @Description: Email:1491579574@qq.com
 * QQ:1491579574
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

// 一篇文章详情页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltpp/assembly/MyArticleFabulousAndCollectionButton.dart';
import '../../assembly/MyHeadimage.dart';
import '../../assembly/MyLoading.dart';
import '../../assembly/MyMarkdown.dart';
import '../../public/Global.dart';
import '../../public/Http.dart';

// ignore: must_be_immutable
class ArticlePage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String _article_id = '';
  // ignore: non_constant_identifier_names
  ArticlePage(String? article_id, {super.key}) {
    if (article_id != null) {
      _article_id = article_id;
    }
  }
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ArticleState createState() => _ArticleState(_article_id);
}

class _ArticleState extends State<ArticlePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Map _article = {};
  Map _writer = {};
  // ignore: non_constant_identifier_names
  bool _has_data = false;
  // ignore: non_constant_identifier_names
  _ArticleState(String article_id) {
    _article['id'] = article_id;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_has_data &&
        _article['islove'] == null &&
        _article['isfabulous'] == null) {
      return const MyLoading();
    }

    return Scaffold(
        appBar: AppBar(
            title: TextButton.icon(
              onPressed: () => Global.toUserPage(context, _writer['id']),
              // ignore: prefer_interpolation_to_compose_strings
              icon: MyHeadimage(_writer['headimage'],
                  width: Global.app_bar_height * 0.8,
                  height: Global.app_bar_height * 0.8),
              // ignore: prefer_interpolation_to_compose_strings
              label: Text('作者：' + _writer['name'],
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none)),
            ),
            toolbarHeight: Global.app_bar_height,
            centerTitle: true),
        body: CupertinoPageScaffold(
            child: SafeArea(
          child: ListView(
              padding: const EdgeInsets.all(10.0),
              // ignore: sized_box_for_whitespace
              children: <Widget>[
                Text(
                  _article['name'],
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: Global.app_bar_font_size,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                    child: Column(children: [
                  MyMarkdown(data: _article['article']),
                  MyArticleFabulousAndCollectionButton(
                    id: _article['id'] ?? '',
                    name: _article['name'] ?? '',
                    is_fabulous: _article['isfabulous'] ?? false,
                    is_love: _article['islove'] ?? false,
                  ),
                ])),
              ]),
        )));
  }

  _getData() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost('/Article/loadOneArticle',
        context: context, body: {'article_id': _article['id']});
    if (res['code'] == 1) {
      // ignore: unused_local_variable, use_build_context_synchronously
      Map<String, dynamic> writer = await Http.sendPost('/User/lookUserData',
          context: context, body: {'user_id': res['data']['writerid']});
      if (writer['code'] == 1) {
        setState(() {
          _writer = writer['data'];
          _article = res['data'];
          _article['islove'] = res['love'];
          _article['isfabulous'] = res['fabulous'];
          _has_data = true;
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      Global.backPage(context);
    }
  }
}
