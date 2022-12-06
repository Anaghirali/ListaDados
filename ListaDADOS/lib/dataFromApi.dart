class dataFromApi {
  int id;
  String nome;
  String data;

  dataFromApi(this.id, this.nome, this.data);

  Map toJson() => {'id': id, 'nome': nome, 'data': data};

  factory dataFromApi.fromJson(dynamic json) {
    if (json['data'] == null) json['data'] = "01/01/2022 00:00:00";
    if (json['nome'] == null) json['nome'] = 'Sem Nome';
    if (json['id'] == null) json['id'] = 0;

    return dataFromApi(json['id'] as int, json['nome'] as String, json['data'] as String);
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{${this.id}, ${this.nome}, ${this.data}}';
  }
}
