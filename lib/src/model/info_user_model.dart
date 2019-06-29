class InfoUserModel{
  final String status;

  InfoUserModel({this.status});

  factory InfoUserModel.fromJson(Map<String, dynamic> json){
    return new InfoUserModel(
      status: json['status_profil'],
    );
  }
  
}