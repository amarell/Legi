class StatistikModel{
  final int jmlCampaign;
  final int donasiLunas;
  final int donasiProses;
  final int donasiTolak;
  final int jmlLunas;
  final int jmlProses;
  final int jmlTolak; 
  final String success;
  final String message;

  StatistikModel({this.jmlLunas, this.jmlProses, this.jmlTolak, this.jmlCampaign, this.donasiProses, this.donasiLunas, this.donasiTolak,this.success, this.message});

  factory StatistikModel.fromJson(Map<String, dynamic> json){
    return new StatistikModel(
      jmlCampaign: int.parse(json['jmlCampaign']),
      donasiProses: int.parse(json['donasiProses']),
      donasiLunas: int.parse(json['donasiLunas']),
      donasiTolak: int.parse(json['donasiTolak']),
      jmlLunas: (json['jmlLunas']!=null)?int.parse(json['jmlLunas']):0,
      jmlProses: (json['jmlProses']!=null)?int.parse(json['jmlProses']):0,
      jmlTolak: (json['jmlTolak']!=null)?int.parse(json['jmlTolak']):0,
      success: json['success'],
      message: json['message'],
    );
  }
  
}