/*
 * @Author: SQS 1491579574@qq.com
 * @Date: 2023-05-19 14:01:51
 * @LastEditors: eastspire 1491579574@qq.com
 * @LastEditTime: 2023-10-18 16:26:00
 * @FilePath: \LTPP-APP-Flutter\lib\assembly\MyArticleFabulousAndCollectionButton.dart
 * @Description: Email:1491579574@qq.com
 * QQ:1491579574
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
// ignore: file_names
// 文章点赞收藏按钮
import 'package:flutter/material.dart';
import 'package:ltpp/public/Global.dart';
import 'package:ltpp/public/Http.dart';

// ignore: must_be_immutable
class MyArticleFabulousAndCollectionButton extends StatefulWidget {
  String id = '';
  bool is_love = false;
  bool is_fabulous = false;
  String name = '';

  MyArticleFabulousAndCollectionButton(
      {super.key,
      required this.id,
      required this.name,
      required this.is_love,
      required this.is_fabulous});

  @override
  // ignore: library_private_types_in_public_api
  _MyArticleFabulousAndCollectionButtonState createState() =>
      _MyArticleFabulousAndCollectionButtonState();
}

class _MyArticleFabulousAndCollectionButtonState
    extends State<MyArticleFabulousAndCollectionButton> {
  String id = '';
  bool is_love = false;
  bool is_fabulous = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    id = widget.id;
    is_love = widget.is_love;
    is_fabulous = widget.is_fabulous;
    name = widget.name;
  }

  void _collection() async {
    Map<String, dynamic> res = await Http.sendPost(
        '/Article/collectionOneArticle',
        context: context,
        body: {
          'article_id': id,
        });
    if (res['code'] == 1) {
      // ignore: use_build_context_synchronously
      setState(() {
        is_love = true;
      });
    } else {
      setState(() {
        is_love = false;
      });
    }
  }

  void _delCollection() async {
    Map<String, dynamic> res = await Http.sendPost('/Article/deleteLoveArticle',
        context: context,
        body: {
          'article_id': id,
        });
    if (res['code'] == 1) {
      // ignore: use_build_context_synchronously
      setState(() {
        is_love = false;
      });
    } else {
      setState(() {
        is_love = true;
      });
    }
  }

  void _fabulous() async {
    // ignore: use_build_context_synchronously
    Map<String, dynamic> res = await Http.sendPost(
        '/Article/fabulousOneArticle',
        context: context,
        body: {
          'article_id': id,
        });

    if (res['code'] == 1) {
      // ignore: use_build_context_synchronously
      setState(() {
        is_fabulous = true;
      });
    } else {
      setState(() {
        is_fabulous = false;
      });
    }
  }

  // ignore: unused_element
  void _toShareArticle() async {
    Map<String, dynamic> res = await Http.sendPost(
      '/Url/getBackUrl',
      context: context,
    );
    if (res['code'] == 1) {
      // ignore: use_build_context_synchronously
      Global.toHtmlPage(
          context, name, res['data'] + '/Article/oneArticle?path=' + id, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 36),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          is_fabulous
              ? Container(
                  margin: const EdgeInsets.only(right: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.thumb_up),
                    color: Colors.red,
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _fabulous();
                    },
                    icon: const Icon(Icons.thumb_up),
                    color: Colors.blue,
                  ),
                ),
          is_love
              ? Container(
                  margin: const EdgeInsets.only(right: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _delCollection();
                    },
                    icon: const Icon(Icons.favorite),
                    color: Colors.red,
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _collection();
                    },
                    icon: const Icon(Icons.favorite),
                    color: Colors.blue,
                  ),
                ),
          Container(
              margin: const EdgeInsets.only(right: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Global.toArticleCommentPage(context, id);
                },
                icon: const Icon(Icons.comment),
                color: Colors.green,
              )),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  _toShareArticle();
                },
                icon: const Icon(Icons.share),
                color: Colors.pinkAccent,
              )),
        ],
      ),
      const SizedBox(height: 36)
    ]);
  }
}
