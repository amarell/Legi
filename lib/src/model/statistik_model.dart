class StatistikModel{
  final int jmlCampaign;
  final int jmlDonasi;
  final String success;
  final String message;

  StatistikModel({this.jmlCampaign, this.jmlDonasi,this.success, this.message});

  factory StatistikModel.fromJson(Map<String, dynamic> json){
    return new StatistikModel(
      jmlCampaign: int.parse(json['jmlCampaign']),
      jmlDonasi: int.parse(json['jmlDonasi']),
      success: json['success'],
      message: json['message'],
    );
  }
  
}