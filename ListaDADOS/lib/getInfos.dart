import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_final_project/dataFromApi.dart';
import 'package:flutter_final_project/ListaAlunos.dart';
import 'Insere.dart';
import 'package:http/http.dart' as http;
import 'dataFromApi.dart';
import 'Insere.dart';
import 'dart:async';
import 'dart:convert';

Future<List<dataFromApi>>fetchDataUser(String value) async {
  var response = await http.get(
      Uri.parse("https://www.slmm.com.br/CTC/getDetalhe.php?id=${value}"),
      headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    // print(response.body);
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new dataFromApi.fromJson(data)).toList();
  } else {
    throw Exception('Erro inesperado....');
  }
}

class getInfos extends StatefulWidget {
  // recebe id do aluno
  const getInfos({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  State<getInfos> createState() => _getInfosState();
}

class _getInfosState extends State<getInfos> {
  late Future<List<dataFromApi>> futureDataUser;

  @override
  void initState() {
    super.initState();
    futureDataUser = fetchDataUser(widget.value);
  }

  delete(String id) async {
    var res = http.delete(
      Uri.parse('https://www.slmm.com.br/CTC/delete.php?id=${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.value}"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<dataFromApi>>(
              future: futureDataUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dataFromApi> data = snapshot.data!;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          margin: EdgeInsets.all(10),
                          elevation: 50,
                            child: ListTile(
                                title: Text(data[index].id.toString()),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // exibe todos os dados do aluno
                                    Text(data[index].id.toString()+"   "),
                                    Text(data[index].nome+"   "),
                                    Text(data[index].data+"   "),
                                    IconButton(
                                      onPressed: () {
                                        delete(data[index].id.toString());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const listacoord()),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                )));
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // by default
                return CircularProgressIndicator();
              }),
        ),);
  }
}