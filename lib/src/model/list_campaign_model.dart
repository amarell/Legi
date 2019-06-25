class Campaign{
  final String id_campaign;
  final String nama_kategori;
  final String nama_user;
  final String judul_campaign;
  final String no_hp;
  final String ajakan;
  final String deskripsi;
  final int target_donasi;
  //final int jumlah_dana;
  final String dibuatOleh;
  final String batas_waktu;
  final String foto_campaign;
  final String link;
  final int dana_terkumpul;
  final String tanggal_mulai;
  

  Campaign({this.id_campaign, this.nama_kategori, this.nama_user, this.judul_campaign, this.no_hp, this.ajakan, this.deskripsi, this.target_donasi, this.batas_waktu, this.foto_campaign, this.link, this.dana_terkumpul, this.tanggal_mulai, this.dibuatOleh});
  
   factory Campaign.fromJson(Map<String, dynamic> json) {
    return new Campaign(
      id_campaign: json['id_campaign'],
      nama_kategori: json['nama_kategori'],
      nama_user: json['nama_user'],
      judul_campaign: json['judul_campaign'],
      no_hp: json['no_hp'],
      ajakan: json['ajakan'],
      deskripsi: json['deskripsi'],
      dibuatOleh: (json['dibuat_oleh']!=null) ? json['dibuat_oleh']:'Admin',
      target_donasi: int.parse(json['target_donasi']),
      batas_waktu: (json['batas_waktu']!=null) ? json['batas_waktu']:'Admin',
      foto_campaign: json['foto_campaign'],
      link: json['link'],
      dana_terkumpul: int.parse(json['dana_terkumpul']),
      tanggal_mulai: json['tanggal_mulai'],

    );
  }
    

    
}

