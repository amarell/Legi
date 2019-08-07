class UpdateBeritaUserModel{
  final String idBerita;
  final String berita;
  final String namaKegiatan;
  final String tanggal;
  final String fotoKegiatan;
  final String judulCampaign;

  UpdateBeritaUserModel({this.idBerita, this.berita,this.namaKegiatan, this.tanggal, this.fotoKegiatan, this.judulCampaign});

  factory UpdateBeritaUserModel.fromJson(Map<String,dynamic> json){
    return UpdateBeritaUserModel(
      idBerita: json['id_berita'],
      berita: json['berita'],
      namaKegiatan: json['nama_kegiatan'],
      tanggal: json['tanggal'],
      fotoKegiatan: json['foto_kegiatan'],
      judulCampaign: json['judul_campaign'],
    );
  }
}