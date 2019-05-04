class BankModel{
  final String idBank;
  final String namaBank;
  final String noRek;

  BankModel({this.idBank, this.namaBank, this.noRek});

  factory BankModel.fromJson(Map<String, dynamic> json){
    return new BankModel(
      idBank: json['id_bank'],
      namaBank: json['nama_bank'],
      noRek: json['no_rek'],
    );
  }  
}