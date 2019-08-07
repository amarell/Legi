class ListUpdateModel{
  final String idBerita;
  final String berita;
  final String namaKegiatan;
  final String tanggal;
  final String fotoKegiatan;

  ListUpdateModel({this.idBerita, this.berita,this.namaKegiatan, this.tanggal, this.fotoKegiatan});

  factory ListUpdateModel.fromJson(Map<String,dynamic> json){
    return ListUpdateModel(
      idBerita: json['id_berita'],
      berita: json['berita'],
      namaKegiatan: json['nama_kegiatan'],
      tanggal: json['tanggal'],
      fotoKegiatan: json['foto_kegiatan'],
    );
  }
}