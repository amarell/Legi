class Campaign{
  final String id_campaign;
  final String nama_kategori;
  final String nama_user;
  final String judul_campaign;
  final String no_hp;
  final String ajakan;
  final String deskripsi;
  final int target_donasi;
  final String ditujukan;
  final int batas_waktu;
  final String foto_campaign;

  Campaign({this.id_campaign, this.nama_kategori, this.nama_user, this.judul_campaign, this.no_hp, this.ajakan, this.deskripsi, this.target_donasi, this.ditujukan, this.batas_waktu, this.foto_campaign});
  
   factory Campaign.fromJson(Map<String, dynamic> json) {
    return new Campaign(
      id_campaign: json['id_campaign'],
      nama_kategori: json['nama_kategori'],
      nama_user: json['nama_user'],
      judul_campaign: json['judul_campaign'],
      no_hp: json['no_hp'],
      ajakan: json['ajakan'],
      deskripsi: json['deskripsi'],
      target_donasi: int.parse(json['target_donasi']),
      ditujukan: json['ditujukan'],
      batas_waktu: int.parse(json['batas_waktu']),
      foto_campaign: json['foto_campaign'],
    );
  }
    

    
}

