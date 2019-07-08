class StatistikModel{
  final int jmlCampaign;
  final int donasiLunas;
  final int donasiProses;
  final int donasiTolak;
  final String success;
  final String message;

  StatistikModel({this.jmlCampaign, this.donasiProses, this.donasiLunas, this.donasiTolak,this.success, this.message});

  factory StatistikModel.fromJson(Map<String, dynamic> json){
    return new StatistikModel(
      jmlCampaign: int.parse(json['jmlCampaign']),
      donasiProses: int.parse(json['donasiProses']),
      donasiLunas: int.parse(json['donasiLunas']),
      donasiTolak: int.parse(json['donasiTolak']),
      success: json['success'],
      message: json['message'],
    );
  }
  
}