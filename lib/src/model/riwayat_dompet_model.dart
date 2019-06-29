class RiwayatDompetModel{
  final String idTransaksi;
  final String idDompet;
  final String idBank;
  final String namaBank;
  final String noRek;
  final String atasNama;
  final int jumlahDana;
  final String statusTransaksi;
  final String tanggalTransaksi;
  final String gunaPembayaran;

  RiwayatDompetModel({this.idTransaksi, this.idDompet, this.idBank, this.jumlahDana, this.statusTransaksi, this.tanggalTransaksi, this.gunaPembayaran, this.atasNama, this.namaBank, this.noRek});

  factory RiwayatDompetModel.fromJson(Map<String, dynamic> json){
    return new RiwayatDompetModel(
      idTransaksi: json['id_transaksi'],
      idDompet: json['id_dompet'],
      idBank: json['id_bank'],
      namaBank: json['nama_bank'],
      noRek: json['no_rek'],
      atasNama: json['nama_pemilik'],
      jumlahDana: int.parse(json['jumlah_dana']),
      statusTransaksi: json['status_transaksi'],
      tanggalTransaksi: json['tanggal_transaksi'],
      gunaPembayaran: json['guna_pembayaran'],

    );
  }

}