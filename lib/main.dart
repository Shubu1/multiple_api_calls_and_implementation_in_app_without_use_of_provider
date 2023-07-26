import 'package:dio/dio.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        AsyncSnapshot,
        BoxFit,
        BuildContext,
        Card,
        Center,
        CircularProgressIndicator,
        ClipRect,
        Colors,
        Column,
        ConnectionState,
        Divider,
        EdgeInsets,
        FutureBuilder,
        GestureDetector,
        Image,
        Key,
        ListTile,
        ListView,
        MaterialApp,
        MaterialPageRoute,
        Navigator,
        Scaffold,
        StatelessWidget,
        Text,
        TextStyle,
        ThemeData,
        Widget,
        runApp;
import 'package:flutter_assignmentproject/cardview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Networking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Future<List<dynamic>> _fetchPosts() async {
    await Future.delayed(const Duration(seconds: 3));
    try {
      var response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print(response.statusCode);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post Lists",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          } else {
            List<dynamic> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HamroApp(postID: posts[index]['id'])));
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipRect(
                            child: Image.network(
                              'https://picsum.photos/seed/${posts[index]['id']}/50/50',
                              fit: BoxFit.fill,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(posts[index]['title']),
                          subtitle: Text('id : ${posts[index]['id']}'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
