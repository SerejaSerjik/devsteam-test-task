import 'package:flutter/material.dart';

class Viewer extends StatelessWidget {
  final String url;
  final int index;

  Viewer({Key key, @required this.url, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Hero(
          tag: "zoom-$index",
          child: Image.network(
            (url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
