class RiwayatDompetWithdrawModel{
  final String idPencairan;
  final String idDompet;
  final String namaBank;
  final String namaRek;
  final String noRek;
  final int jumlahDana;
  final String tglPencairan;
  final String status;

  RiwayatDompetWithdrawModel({this.status, this.tglPencairan, this.idPencairan, this.idDompet, this.namaBank, this.namaRek, this.noRek, this.jumlahDana});

  factory RiwayatDompetWithdrawModel.fromJson(Map<String, dynamic> json){
    return new RiwayatDompetWithdrawModel(
      idPencairan: json['id_pencairan'],
      idDompet: json['id_dompet'],
      namaBank: json['nama_bank_tujuan'],
      namaRek: json['nama_pemilik_rek'],
      noRek: json['no_rek_bank'],
      jumlahDana: int.parse(json['jumlah_pencairan_dana']),
      tglPencairan: json['tgl_pencairan'],
      status: json['status_pencairan'],

    );
  }

}