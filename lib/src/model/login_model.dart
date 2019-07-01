class Login {
  final String idUser;
  final String namaUser;
  final String emailUser;
  final String idDompet;
  final String saldoDompet;
  final String foto;

  Login(this.idUser, this.namaUser, this.emailUser, this.idDompet, this.saldoDompet, this.foto);

  Login.fromJson(Map<String, dynamic> json)
      : idUser = json['id'],
        namaUser = json['nama'],
        emailUser = json['email'],
        idDompet= json['id_dompet'],
        foto= json['foto'],
        saldoDompet = json['saldo_dompet'];

  // Map<String, dynamic> toJson() =>
  //   {
  //     'id': idUser,
  //     'nama':namaUser,
  //     'email': emailUser,
  //   };
}