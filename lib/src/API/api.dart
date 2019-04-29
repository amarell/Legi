import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = 'http://192.168.43.64/API';

class API {
  static Future getListCampaign(idKat){
    var url =baseUrl+ '/list_campaign.php';
    return http.post(url, body: {
      "id_kategori":idKat,
    });
  }

  static Future getListHistory(idUser){
    var url=baseUrl+'/history_donasi.php';
    print(idUser);
    return http.post(url, body: {
      "id_user":'$idUser',
    });
  }

  static Future getDetailUser(idUser){
    var url=baseUrl+'/read_profile.php';
    print(idUser);
    return http.post(url, body: {
      "id_user":'$idUser',
    });
  }
}