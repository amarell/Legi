class Login {
  final String idUser;
  final String namaUser;
  final String emailUser;
  final String idDompet;
  final String saldoDompet;

  Login(this.idUser, this.namaUser, this.emailUser, this.idDompet, this.saldoDompet);

  Login.fromJson(Map<String, dynamic> json)
      : idUser = json['id'],
        namaUser = json['nama'],
        emailUser = json['email'],
        idDompet= json['id_dompet'],
        saldoDompet = json['saldo_dompet'];

  // Map<String, dynamic> toJson() =>
  //   {
  //     'id': idUser,
  //     'nama':namaUser,
  //     'email': emailUser,
  //   };
}