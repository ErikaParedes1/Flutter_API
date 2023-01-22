import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nuevo/models/deber.dart';

import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Deber>> _listadoDeber;

  Future<List<Deber>> _getDeber() async {
    var url =
        "https://api.giphy.com/v1/gifs/trending?api_key=3BO63LFKaJOmTdoV4SXP3O2c5AAw1YmB&limit=30&rating=g";
    final response = await http.get(
      Uri.parse(url),
    );

    List<Deber> deber = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData["data"]) {
        deber.add(Deber(item["title"], item["images"]["downsized"]["url"]));
      }
      return deber;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoDeber = _getDeber();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extaer una API de la nube',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Extaer una API de la nube'),
        ),
        body: FutureBuilder(
          future: _listadoDeber,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                children: _listDeber(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text("error");
            }
            return const Text("ya no jalo");
          },
        ),
      ),
    );
  }

  List<Widget> _listDeber(data) {
    List<Widget> deber = [];

    for (var deberes in data) {
      deber.add(Card(
          child: Column(
        children: [
          Expanded(
            child: Image.network(
              deberes.url,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(deberes.name),
          ),
        ],
      )));
    }
    return deber;
  }
}
