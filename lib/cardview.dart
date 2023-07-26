import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'commentview.dart';

class HamroApp extends StatefulWidget {
  final int postID;
  const HamroApp({required this.postID});
  //const HamroApp({postID = 1});

  @override
  State<HamroApp> createState() => _HamroAppState();
}

class _HamroAppState extends State<HamroApp> {
  late Future<Map<String, dynamic>> _postFuture;
  @override
  void initState() {
    super.initState();
    _postFuture = _fetchPost(widget.postID);
  }

  Future<Map<String, dynamic>> _fetchPost(int postId) async {
    await Future.delayed(const Duration(seconds: 3));
    final response =
        await Dio().get('https://jsonplaceholder.typicode.com/posts/$postId');
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of Post'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else {
            final post = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  'User ID:${post['userId']}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Gap(150),
                                Text(
                                  ' Post ID :${post['id']}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 1.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              ' Title : ${post["title"]}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              ' Body :${post['body']}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  Container(
                    height: 50,
                    width: 370,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HamroApp2(postId: post['id']),
                          ),
                        );
                      },
                      child: const Text("View Comments"),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
