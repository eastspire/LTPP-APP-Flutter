/*
 * @Author: 18855190718 1491579574@qq.com
 * @Date: 2023-03-04 15:56:59
 * @LastEditors: eastspire 1491579574@qq.com
 * @LastEditTime: 2023-11-20 14:11:33
 * @FilePath: \LTPP-APP-Flutter\lib\views\public\OjPage.dart
 * @Description: Email:1491579574@qq.com
 * QQ:1491579574
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

// 一道题目详情页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../assembly/MyHeadimage.dart';
import '../../assembly/MyLoading.dart';
import '../../assembly/MyMarkdown.dart';
import '../../public/Global.dart';
import '../../public/Http.dart';

// ignore: must_be_immutable
class OjPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String _oj_id = '';
  // ignore: non_constant_identifier_names, unused_field
  String _contest_id = '';
  // ignore: non_constant_identifier_names
  OjPage(String? oj_id, {super.key, String? contest_id}) {
    if (oj_id != null) {
      _oj_id = oj_id;
    }
    if (contest_id != null) {
      _contest_id = contest_id;
    }
  }
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _OjState createState() => _OjState(_oj_id);
}

class _OjState extends State<OjPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Map _oj = {};
  Map _creater = {};
  // ignore: non_constant_identifier_names
  bool _has_data = false;
  // ignore: non_constant_identifier_names
  _OjState(String oj_id) {
    _oj['id'] = oj_id;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_has_data) {
      return const MyLoading();
    }

    return Scaffold(
        appBar: AppBar(
            title: TextButton.icon(
              onPressed: () => Global.toUserPage(context, _creater['id']),
              // ignore: prefer_interpolation_to_compose_strings
              icon: MyHeadimage(_creater['headimage'],
                  width: Global.app_bar_height * 0.8,
                  height: Global.app_bar_height * 0.8),
              // ignore: prefer_interpolation_to_compose_strings
              label: Text('本题创建者：' + _creater['name'],
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
                  _oj['problemName'],
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: Global.app_bar_font_size,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  child: MyMarkdown(
                    data: _oj['problemContent'],
                  ),
                ),
              ]),
        )));
  }

  _getData() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost('/Oj/lookOneProblem',
        context: context,
        body: {'problem_id': _oj['id'], 'contest_id': widget._contest_id});
    if (res['code'] == 1) {
      // ignore: unused_local_variable, use_build_context_synchronously
      Map<String, dynamic> creater = await Http.sendPost('/User/lookUserData',
          context: context, body: {'user_id': res['data']['createrid']});
      if (creater['code'] == 1) {
        setState(() {
          _oj = res['data'];
          _creater = creater['data'];
          _has_data = true;
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      Global.backPage(context);
    }
  }
}
