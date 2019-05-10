class InfoDompetModel{
  final String idDompet;
  final String saldoDompet;

  InfoDompetModel({this.idDompet, this.saldoDompet});

  factory InfoDompetModel.fromJson(Map<String, dynamic> json){
    return new InfoDompetModel(
      idDompet: json['id_dompet'],
      saldoDompet: json['saldo_dompet'],
    );
  }
  
}