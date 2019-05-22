class RiwayatDompetWithdrawModel{
  final String idTransaksi;
  final String idDompet;
  final int jumlahDana;
  final String statusTransaksi;
  final String tanggalTransaksi;
  final String gunaPembayaran;

  RiwayatDompetWithdrawModel({this.idTransaksi, this.idDompet, this.jumlahDana, this.statusTransaksi, this.tanggalTransaksi, this.gunaPembayaran});

  factory RiwayatDompetWithdrawModel.fromJson(Map<String, dynamic> json){
    return new RiwayatDompetWithdrawModel(
      idTransaksi: json['id_transaksi'],
      idDompet: json['id_dompet'],
      jumlahDana: int.parse(json['jumlah_dana']),
      statusTransaksi: json['status_transaksi'],
      tanggalTransaksi: json['tanggal_transaksi'],
      gunaPembayaran: json['guna_pembayaran'],

    );
  }

}