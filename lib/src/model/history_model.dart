class HistoryDonasi{
  final String idDonasi;
  final String judulCampaign;
  final int jumlahDana;
  final String tanggalDonasi;
  final String statusDonasi;

  HistoryDonasi({this.idDonasi, this.judulCampaign, this.jumlahDana, this.tanggalDonasi, this.statusDonasi});

  factory HistoryDonasi.fromJson(Map<String, dynamic> json){
    return new HistoryDonasi(
      idDonasi: json['id_donasi'],
      judulCampaign: json['judul_campaign'],
      jumlahDana: int.parse(json['jumlah_dana']),
      tanggalDonasi: json['tanggal_donasi'],
      statusDonasi: json['status_donasi'],

    );
  }
}