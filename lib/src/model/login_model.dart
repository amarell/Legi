class Login {
  final String idUser;
  final String namaUser;
  final String emailUser;

  Login(this.idUser, this.namaUser, this.emailUser);

  Login.fromJson(Map<String, dynamic> json)
      : idUser = json['id'],
        namaUser = json['nama'],
        emailUser = json['email'];

  // Map<String, dynamic> toJson() =>
  //   {
  //     'id': idUser,
  //     'nama':namaUser,
  //     'email': emailUser,
  //   };
}