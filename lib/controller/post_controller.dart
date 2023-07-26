import 'package:dio/dio.dart';
import 'package:flutter_assignmentproject/model/post_model.dart';
//import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostController {
  Ref ref;
  PostController(this.ref);
  //var id = 0.obs;
  //RxList<PostModel> posts = RxList<PostModel>();

  Future<List<PostModel>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 3));
    try {
      var response = await Dio().get(
        'https://jsonplaceholder.typicode.com/posts',
        options: Options(responseType: ResponseType.json),
      );
      if (response.statusCode == 200) {
        List<dynamic> posts = response.data;
        print(response.statusCode.toString());
        return posts.map((item) => PostModel.fromJson(item)).toList();
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

final postsListProvider = FutureProvider.autoDispose<List<PostModel>>(
  (ref) {
    return PostController(ref).fetchPosts();
  },
);
