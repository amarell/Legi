

class ListDonaturModel{
  final String namaUser;
  final int jumlahDana;

  ListDonaturModel({this.namaUser, this.jumlahDana});

  factory ListDonaturModel.fromJson(Map<String, dynamic> json){
    return new ListDonaturModel(
      namaUser: json['nama_user'],
      jumlahDana: int.parse(json['jumlah_dana']),

    );
  }
}