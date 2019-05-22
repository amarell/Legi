class RiwayatDompetDonasiModel{
  final String idTransaksi;
  final String idDompet;
  final int jumlahDana;
  final String statusTransaksi;
  final String tanggalTransaksi;
  final String gunaPembayaran;

  RiwayatDompetDonasiModel({this.idTransaksi, this.idDompet, this.jumlahDana, this.statusTransaksi, this.tanggalTransaksi, this.gunaPembayaran});

  factory RiwayatDompetDonasiModel.fromJson(Map<String, dynamic> json){
    return new RiwayatDompetDonasiModel(
      idTransaksi: json['id_transaksi'],
      idDompet: json['id_dompet'],
      jumlahDana: int.parse(json['jumlah_dana']),
      statusTransaksi: json['status_transaksi'],
      tanggalTransaksi: json['tanggal_transaksi'],
      gunaPembayaran: json['guna_pembayaran'],

    );
  }

}