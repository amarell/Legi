class DetailBankUserModel{
  final String idRekening;
  final String namaBank;
  final String namaPemilik;
  final String noRek;

  DetailBankUserModel({this.idRekening, this.namaBank, this.namaPemilik, this.noRek});

  factory DetailBankUserModel.fromJson(Map<String, dynamic> json){
   return new DetailBankUserModel(
      idRekening: json['id_rekening'],
      namaBank: json['nama_bank'],
      namaPemilik: json['nama_pemilik'],
      noRek: json['no_rek'],
   );
  }
}