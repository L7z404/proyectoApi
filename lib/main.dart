import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VideoGameData(),
  ));
}

class VideoGameData extends StatefulWidget {
  @override
  _VideoGameDataState createState() => _VideoGameDataState();
}

class _VideoGameDataState extends State<VideoGameData> {
  final String url = "https://videogamesapi.herokuapp.com/api/games";
  List data;

  Future<String> getVGData() async {
    var respuesta = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var cuerpoRes = json.decode(respuesta.body);
      data = cuerpoRes["results"];
    });

    return "Exito!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          sleep(Duration(seconds: 5));
        },
        icon: Icon(
          Icons.warning,
          size: 30.0,
        ),
        label: Text(
          "Freeze App 😏",
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Colors.black45,
        foregroundColor: Colors.amber,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "//---Videogames---//",
          style: TextStyle(fontSize: 26.0, fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                        color: Colors.indigoAccent,
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Name: ",
                              style: TextStyle(
                                  fontSize: 24.0, color: Colors.white),
                            ),
                            Text(
                              data[index]["title"],
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ],
                        )),
                  ),
                  _cardImagen(data[index]["cover"], data[index]["title"]),
                  _cardTestCosaColumn("Developer", data[index]["developer"]),
                  _cardTestCosaRow("Publisher", data[index]["publisher"]),
                  _cardTestCosaColumn(
                      "Description", data[index]["description"]),
                  _cardTestCosaRow("Release Date", data[index]["release_date"]),
                  Divider(
                    height: 50.0,
                    thickness: 5.0,
                    indent: 50.0,
                    endIndent: 50.0,
                    color: Colors.deepPurpleAccent,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getVGData();
  }

  Widget _cardImagen(String cover, String title) {
    final card = Container(
      //clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(cover),
            placeholder: AssetImage('assets/jar-loading.gif'),
            fadeInDuration: Duration(milliseconds: 200),
            height: 300.0,
            fit: BoxFit.cover,
          ),
          Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                title + " cover art",
                style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
              ))
        ],
      ),
    );

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 10.0))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: card,
        ));
  }

  Widget _cardTestCosaColumn(String cosa, String detalle) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$cosa: ",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              Text(
                detalle,
                style: TextStyle(fontSize: 18.0, color: Colors.black54),
              ),
            ],
          )),
    );
  }

  Widget _cardTestCosaRow(String cosa, String detalle) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$cosa: ",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              Text(
                detalle,
                style: TextStyle(fontSize: 18.0, color: Colors.black54),
              ),
            ],
          )),
    );
  }
}
