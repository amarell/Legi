class ListUpdateModel{
  final String idBerita;
  final String berita;
  final String namaKegiatan;
  final String tanggal;

  ListUpdateModel({this.idBerita, this.berita,this.namaKegiatan, this.tanggal});

  factory ListUpdateModel.fromJson(Map<String,dynamic> json){
    return ListUpdateModel(
      idBerita: json['id_berita'],
      berita: json['berita'],
      namaKegiatan: json['nama_kegiatan'],
      tanggal: json['tanggal'],
    );
  }
}