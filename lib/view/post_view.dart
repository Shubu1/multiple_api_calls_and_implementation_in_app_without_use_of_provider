import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BoxFit,
        BuildContext,
        Center,
        CircularProgressIndicator,
        ClipRect,
        Colors,
        Column,
        Divider,
        EdgeInsets,
        GestureDetector,
        Image,
        ListTile,
        ListView,
        MaterialPageRoute,
        Navigator,
        Scaffold,
        Text,
        Widget;
import 'package:flutter_assignmentproject/AppString.dart';
import 'package:flutter_assignmentproject/model/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cardview.dart';
import '../controller/post_controller.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  //List<PostModel> posts = [].obs;
  //final postCtrl = PostController();
  //final PostController postCtrl = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(postsListProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppString.postList),
        ),
        body: _data.when(
            data: (_data) {
              List<PostModel> userList = _data.map((e) => e).toList();
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: userList.length,
                      padding: const EdgeInsets.all(16.0),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HamroApp(
                                        postID: userList[index]
                                            .id))); //'https://jsonplaceholder.typicode.com/posts/index';
                            //fetchPosts(posts[index]['id']);
                          },
                          child: Column(
                            children: [
                              ListTile(
                                leading: ClipRect(
                                  child: Image.network(
                                    'https://picsum.photos/seed/${userList[index].id}/50/50',
                                    fit: BoxFit.fill,
                                    // color: AppColor.purpleColor,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                title: Text(userList[index].title),
                                subtitle: Text('id : ${userList[index].id}'),
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                                height: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (err, s) => Text(err.toString()),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
