import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      title: 'flutter networking',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.purple,
          onPrimary: Colors.white,
          secondary: Colors.purple,
        ),
        scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 0.831),
      ),
      debugShowCheckedModeBanner: false,
      home: HamroApp2(postId: 1),
    ));

class HamroApp2 extends StatefulWidget {
  final int? postId;
  const HamroApp2({required this.postId});

  @override
  State<HamroApp2> createState() => _HamroAppState();
}

class _HamroAppState extends State<HamroApp2> {
  late Future<List<dynamic>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments(widget.postId!);
  }

  Future<List<dynamic>> _fetchComments(int postId) async {
    await Future.delayed(const Duration(seconds: 3));
    final response = await Dio()
        .get('https://jsonplaceholder.typicode.com/posts/$postId/comments');
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details of Post'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _commentsFuture,
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
            final comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index] ?? {};
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipRect(
                            child: Image.network(
                              'https://picsum.photos/seed/${comment['id']}/50/50',
                              fit: BoxFit.fill,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(
                            'Name : ${comment['name']}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email :${comment['email']}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15.0),
                              ),
                              Text(
                                'body : ${comment['body']}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          height: 0,
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
