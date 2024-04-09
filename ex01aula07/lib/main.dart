import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int postId = 1;
  late Future<Poste> futuroPoste;

  Future<Poste> buscaPOSTE(int id) async {
    final resposta = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

    if (resposta.statusCode == 200) {
      return Poste.fromJson(jsonDecode(resposta.body));
    } else {
      throw Exception('Falha ao carregar poste.');
    }
  }

  @override
  void initState() {
    super.initState();
    futuroPoste = buscaPOSTE(postId);
  }

  void buscarProximoPoste() {
    setState(() {
      postId += 1;
      futuroPoste = buscaPOSTE(postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: Center(
        child: FutureBuilder<Poste>(
          future: futuroPoste,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!.titulo, style: TextStyle(fontSize: 16)),
                  ElevatedButton(
                    onPressed: buscarProximoPoste,
                    child: Text('Carregar próximo post'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Poste {
  final int idUsuario;
  final int id;
  final String titulo;
  final String corpo;

  Poste(
      {required this.idUsuario,
      required this.id,
      required this.titulo,
      required this.corpo});

  factory Poste.fromJson(Map<String, dynamic> json) {
    return Poste(
      idUsuario: json['userId'],
      id: json['id'],
      titulo: json['title'],
      corpo: json['body'],
    );
  }
}
