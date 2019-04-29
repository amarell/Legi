class ReadProfile{
  final String nama;
  final String email;
  final String idUser;
  final String telpon;
  final String alamat;
  final String avatar;
  final String ktp;

  ReadProfile({this.nama, this.email, this.idUser, this.telpon, this.alamat, this.avatar, this.ktp});

  factory ReadProfile.fromJson(Map<String, dynamic> json){
   return new ReadProfile(
      nama: json['nama'],
      email: json['email'],
      idUser: json['id'],
      telpon: json['telepon_user'],
      alamat: json['alamat_user'],
      avatar: json['avatar'],
      ktp:  json['ktp'],
   );
  }
}