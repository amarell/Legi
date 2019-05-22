class ListUpdateModel{
  final String idBerita;
  final String berita;

  ListUpdateModel({this.idBerita, this.berita});

  factory ListUpdateModel.fromJson(Map<String,dynamic> json){
    return ListUpdateModel(
      idBerita: json['id_berita'],
      berita: json['berita'],
    );
  }
}