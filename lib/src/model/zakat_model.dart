class ZakatModel{
  final String idCampaign;
  final String namaKategori;
  final String judulCampaign;
  final String ajakan;
  final String deskripsi;
  //final int jumlah_dana;
  final String fotoCampaign;
  final String link;
  final int danaTerkumpul;
  

  ZakatModel({this.idCampaign, this.namaKategori, this.judulCampaign, this.ajakan, this.deskripsi, this.fotoCampaign, this.link, this.danaTerkumpul});
  
   factory ZakatModel.fromJson(Map<String, dynamic> json) {
    return new ZakatModel(
      idCampaign: json['id_campaign'],
      namaKategori: json['nama_kategori'],
      judulCampaign: json['judul_campaign'],
      ajakan: json['ajakan'],
      deskripsi: json['deskripsi'],
      fotoCampaign: json['foto_campaign'],
      link: json['link'],
      danaTerkumpul: int.parse(json['dana_terkumpul']),

    );
  }
    

    
}

