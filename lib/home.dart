import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unsplash Images"),
      ),
      body: FutureBuilder(
        future: getImages(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<dynamic> data = snapshot.data;
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to get response from the server',
                style: TextStyle(color: Colors.red, fontSize: 22.0),
              ),
            );
          } else if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                  padding: EdgeInsets.only(top: 10),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(10, (index) {
                    return Container(
                      child: InkWell(
                        child: GridTile(
                          header: Container(
                            color: Colors.black26,
                            child: ListTile(
                              leading: Text(
                                '${data[index]['user']['name']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          child: Hero(
                            tag: "zoom-$index",
                            child: Image.network(
                              ('${data[index]['urls']['small']}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          footer: Container(
                            color: Colors.black26,
                            child: ListTile(
                              leading: Text(
                                '${data[index]['description']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewer(
                                      url: data[index]['urls']['full'],
                                      index: index,
                                    )),
                          );
                        },
                      ),
                    );
                  })),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<List<dynamic>> getImages() async {
  String url =
      'https://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
