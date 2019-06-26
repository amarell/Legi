class RiwayatCampaignModel{
  final String idCampaign;
  final String namaKategori;
  final String namaUser;
  final String judulCampaign;
  final String noHp;
  final int targetDonasi;
  //final int jumlah_dana;
  final String dibuatOleh;
  final String batasWaktu;
  final String fotoCampaign;
  final String link;
  final int danaTerkumpul;
  final String tanggalMulai;
  final String status;
  

  RiwayatCampaignModel({this.idCampaign, this.status,this.namaKategori, this.namaUser, this.judulCampaign, this.noHp, this.targetDonasi, this.batasWaktu, this.fotoCampaign, this.link, this.danaTerkumpul, this.tanggalMulai, this.dibuatOleh});
  
   factory RiwayatCampaignModel.fromJson(Map<String, dynamic> json) {
    return new RiwayatCampaignModel(
      idCampaign: json['id_campaign'],
      namaKategori: json['nama_kategori'],
      namaUser: json['nama_user'],
      judulCampaign: json['judul_campaign'],
      noHp: json['no_hp'],
      dibuatOleh: json['dibuat_oleh'],
      targetDonasi: int.parse(json['target_donasi']),
      batasWaktu: (json['batas_waktu']!=null) ? json['batas_waktu']:'Admin',
      fotoCampaign: json['foto_campaign'],
      link: json['link'],
      status: json['status_campaign'],
      danaTerkumpul: int.parse(json['dana_terkumpul']),
      tanggalMulai: json['tanggal_mulai'],

    );
  }
    

    
}

