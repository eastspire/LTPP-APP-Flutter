// ignore_for_file: unused_field

/*
 * @Author: 18855190718 1491579574@qq.com
 * @Date: 2023-03-04 15:56:59
 * @LastEditors: eastspire 1491579574@qq.com
 * @LastEditTime: 2023-11-20 14:12:01
 * @FilePath: \LTPP-APP-Flutter\lib\views\public\ContestPage.dart
 * @Description: Email:1491579574@qq.com
 * QQ:1491579574
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

// 一道题目详情页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ltpp/assembly/MyDialog.dart';
import '../../assembly/MyHeadimage.dart';
import '../../assembly/MyLoading.dart';
import '../../assembly/MyMarkdown.dart';
import '../../public/Global.dart';
import '../../public/Http.dart';

// ignore: must_be_immutable
class ContestPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String _contest_id = '';
  // ignore: non_constant_identifier_names
  ContestPage(String? contest_id, {super.key}) {
    if (contest_id != null) {
      _contest_id = contest_id;
    }
  }
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ContestState createState() => _ContestState(_contest_id);
}

class _ContestState extends State<ContestPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool seeCodeCheck = true;
  bool seeCleanCache = true;
  Map _contest = {};
  Map _creater = {};
  bool _is_mycontest = false;
  bool _is_join = false;
  List<dynamic> _problem_list = [];
  String rank_url = '';
  // ignore: non_constant_identifier_names
  bool _has_data = false;
  bool _has_password = true;
  TextEditingController password_controller = TextEditingController();
  _ContestState(String contest_id) {
    _contest['id'] = contest_id;
    // ignore: prefer_interpolation_to_compose_strings
    rank_url =
        // ignore: prefer_interpolation_to_compose_strings
        Global.back_url +
            '/Contest/publicContestRank?contest_id=' +
            _contest['id'];
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _judgeIsJoin();
    _frontendJudgeIsMyContests();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_has_data) {
      return const MyLoading();
    }
    // ignore: non_constant_identifier_names, unused_local_variable
    List<Widget> main_list_view = [];
    main_list_view.add(
      Text(
        _contest['name'] ?? '无',
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontSize: Global.app_bar_font_size, fontWeight: FontWeight.bold),
      ),
    );
    main_list_view.add(const SizedBox(height: 16));
    main_list_view.add(const Text('竞赛介绍：',
        style: TextStyle(
            fontSize: Global.app_content_font_size,
            fontWeight: FontWeight.bold)));
    main_list_view.add(SingleChildScrollView(
        child: MyMarkdown(
      data: _contest['content'],
    )));
    main_list_view.add(const SizedBox(height: 16));
    main_list_view.add(Text(
        // ignore: prefer_interpolation_to_compose_strings
        '报名人数：' + (_contest['allpeople'] ?? 0).toString() + '人',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
    main_list_view.add(const SizedBox(height: 16));
    if (_is_join && _problem_list.isNotEmpty) {
      main_list_view.add(const Text('题目列表：',
          style: TextStyle(
              fontSize: Global.app_content_font_size,
              fontWeight: FontWeight.bold)));
      main_list_view.add(
        const SizedBox(height: 16),
      );
      for (var tem in _problem_list) {
        main_list_view.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    side: BorderSide(width: 0, color: Colors.white),
                  ),
                ),
                // ignore: sort_child_properties_last
                child: Text(tem['problemName'] ?? '无'),
                onPressed: () => Global.toProblemPage(context, tem['id'],
                    contest_id: _contest['id'])),
          ],
        ));
        main_list_view.add(
          const SizedBox(height: 6),
        );
      }
    }
    main_list_view.add(
      const SizedBox(height: 36),
    );
    if (!_is_join) {
      if (_has_password) {
        main_list_view.add(FractionallySizedBox(
            widthFactor: 0.86,
            child: TextField(
              controller: password_controller,
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: '参赛密码',
                  hintText: '参赛密码',
                  prefixIcon: Icon(Icons.person)),
            )));
        main_list_view.add(
          const SizedBox(height: 36),
        );
      }
      main_list_view.add(FractionallySizedBox(
        widthFactor: 0.86,
        child: ElevatedButton(
            // ignore: sort_child_properties_last
            child: const Text('报名竞赛'),
            onPressed: () => _joinContest()),
      ));
      main_list_view.add(
        const SizedBox(height: 16),
      );
    }
    if (rank_url != '') {
      main_list_view.add(FractionallySizedBox(
        widthFactor: 0.86,
        child: ElevatedButton(
            // ignore: sort_child_properties_last
            child: const Text('实时排名'),
            onPressed: () => Global.toHtmlPage(
                context,
                // ignore: prefer_interpolation_to_compose_strings
                'LTPP ' + (_contest['name'] ?? '') + ' 竞赛实时排名',
                rank_url,
                true)),
      ));
      main_list_view.add(
        const SizedBox(height: 16),
      );
    }
    if (_is_mycontest && seeCodeCheck) {
      main_list_view.add(FractionallySizedBox(
          widthFactor: 0.86,
          child: ElevatedButton(
            // ignore: sort_child_properties_last
            child: const Text('代码查重'),
            onPressed: () => _codeCheckSimilarity(),
          )));
      main_list_view.add(
        const SizedBox(height: 16),
      );
    }
    if (_is_mycontest && seeCleanCache) {
      main_list_view.add(FractionallySizedBox(
        widthFactor: 0.86,
        child: ElevatedButton(
            // ignore: sort_child_properties_last
            child: const Text('清理缓存'),
            onPressed: () => _clearCache()),
      ));
      main_list_view.add(
        const SizedBox(height: 16),
      );
    }
    return Scaffold(
        appBar: AppBar(
            title: TextButton.icon(
              onPressed: () => Global.toUserPage(context, _creater['id']),
              // ignore: prefer_interpolation_to_compose_strings
              icon: MyHeadimage(_creater['headimage'] ?? '无',
                  width: Global.app_bar_height * 0.8,
                  height: Global.app_bar_height * 0.8),
              // ignore: prefer_interpolation_to_compose_strings
              label: Text('本竞赛创建者：' + (_creater['name'] ?? '无'),
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
              children: main_list_view),
        )));
  }

  _judgeIsJoin() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost('/Contest/judgeIsJoin',
        context: context, body: {'contest_id': _contest['id']});
    if (res['code'] == 1) {
      setState(() {
        _is_join = true;
      });
      _lookContestProblem();
    }
  }

  _joinContest() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost('/Contest/joinContest',
        context: context,
        body: {
          'contest_id': _contest['id'],
          'password': password_controller.text
        });
    if (res['code'] == 1) {
      setState(() {
        _is_join = true;
        ++_contest['allpeople'];
      });
      _lookContestProblem();
    }
  }

  _getData() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost('/Contest/userLookContest',
        context: context, body: {'contest_id': _contest['id']});
    if (res['code'] == 1) {
      // ignore: unused_local_variable, use_build_context_synchronously
      Map<String, dynamic> creater = await Http.sendPost('/User/lookUserData',
          context: context, body: {'user_id': res['data']['createrid']});
      if (creater['code'] == 1) {
        setState(() {
          _contest = res['data'];
          _creater = creater['data'];
          _has_password = _contest['password'];
          _has_data = true;
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      Global.backPage(context);
    }
  }

  _lookContestProblem() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost(
        '/Contest/lookContestProblem',
        context: context,
        body: {'contest_id': _contest['id']});
    if (res['code'] == 1) {
      setState(() {
        _problem_list = res['data'];
      });
    }
  }

  _frontendJudgeIsMyContests() async {
    if (!mounted) {
      return;
    }
    Map<String, dynamic> res = await Http.sendPost(
        '/Contest/frontendJudgeIsMyContest',
        context: context,
        body: {'contest_id': _contest['id']});
    if (res['code'] == 1) {
      setState(() {
        _is_mycontest = res['data'] == 1 ? true : false;
      });
    }
  }

  _clearCache() async {
    if (!mounted) {
      return;
    }
    setState(() {
      seeCleanCache = false;
    });
    await Http.sendPost('/Contest/DeleteRank',
        context: context, body: {'contest_id': _contest['id']});
    setState(() {
      seeCleanCache = true;
    });
  }

  _codeCheckSimilarity() async {
    if (!mounted) {
      return;
    }
    setState(() {
      seeCodeCheck = false;
    });
    Map<String, dynamic> res = await Http.sendPost(
        '/Contest/codeCheckSimilarity',
        context: context,
        body: {'contest_id': _contest['id']});
    setState(() {
      seeCodeCheck = true;
    });
    if (res['code'] == 1) {
      // ignore: use_build_context_synchronously
      MyDialog(context, content: res['msg'] ?? '请求失败');
    }
  }
}
