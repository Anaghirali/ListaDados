import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dataFromApi.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// criar uma lista para puxar os dados da api
Future<String> fetchData(String nome) async {
  Map data = {
    "nome": nome,
    "data": DateFormat("yy/MM/dd HH:mm:ss").format(DateTime.now())
  };

  String resp = json.encode(data);

  var response = await http.post(
      Uri.parse("https://www.slmm.com.br/CTC/insere.php"),
      headers: {"Content-Type": "application/json"},
      body: resp);
  debugPrint(resp);
  if (response.statusCode == 200) {
    //String json? = jsonEncode(response.body);
    return (response.body);
  } else {
    throw Exception('Erro inesperado....');
  }
}


class Insere extends StatefulWidget {
  const Insere({Key? key}) : super(key: key);

  @override
  State<Insere> createState() => _InsereState();
}

class _InsereState extends State<Insere> {
 
  late Future<List<String>> futureData;
  Future<String>? _futureData2;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Insere"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.person),
                    hintText: 'Informe o nome'),
                controller: _controller,
              ),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    _futureData2 = fetchData(_controller.text);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Admitir usuario'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 25, 120, 244),
          foregroundColor: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.add),
        ));
  }
}
