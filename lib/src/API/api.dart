import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = 'http://192.168.43.64/legi/API';

class API {
  static Future getListCampaign(idKat) async{
    var url =baseUrl+ '/list_campaign.php';
    return await http.post(url, body: {
      "id_kategori":idKat,
    });
  }

  static Future getListHistory(idUser) async{
    var url=baseUrl+'/history_donasi.php';
    print(idUser);
    return await http.post(url, body: {
      "id_user":'$idUser',
    });
  }

  static Future getDetailUser(idUser) async{
    var url=baseUrl+'/read_profile.php';
    print(idUser);
    return await http.post(url, body: {
      "id_user":'$idUser',
    });
  }

  static Future getKategori() async{
    var url=baseUrl+'/list_kategori.php';
    return await http.post(url);
  }

   static Future getListZakat() async{
    var url=baseUrl+'/list_zakat.php';
    return await http.post(url);
  }

  static Future getLisRiwayatDompet(idDompet) async{
    var url=baseUrl+'/riwayat_dompet.php';
    return await http.post(url, body: {
      "id_dompet":'$idDompet',
    });
  }

  static Future getDataDompet(idUser) async{
    var url=baseUrl+'/info_dompet.php';
    return await http.post(url, body: {
      "id_user":'$idUser',
    });
  }

  static Future getLisRiwayatDompetDonasi(idDompet) async{
    var url=baseUrl+'/riwayat_dompet_donasi.php';
    return await http.post(url, body: {
      "id_dompet":'$idDompet',
    });
  }

  static Future getLisRiwayatDompetWithdraw(idDompet) async{
    var url=baseUrl+'/riwayat_dompet_withdraw.php';
    return await http.post(url, body: {
      "id_dompet":'$idDompet',
    });
  }

  static Future getLisDonatur(idCampaign) async{
    var url=baseUrl+'/list_donatur.php';
    return await http.post(url, body: {
      "id_campaign":'$idCampaign',
    });
  }

  static Future getLisUpdateBerita(idCampaign) async{
    var url=baseUrl+'/list_berita.php';
    return await http.post(url, body: {
      "id_campaign":'$idCampaign',
    });
  }

  static Future getRiwayatCampaign(idUser) async{
    var url=baseUrl+'/list_campaign_user.php';
    return await http.post(url, body: {
      "id_user":'$idUser',
    });
  }

  static Future getInfoUser(idUser) async{
    var url=baseUrl+'/info_user.php';
    return await http.post(url, body: {
      "id_user":'$idUser',
    });
  }

  static Future getStatistikUser(idUser) async{
    var url=baseUrl+'/statistik_user.php';
    return await http.post(url, body: {
      "id_user":'$idUser',
    });
  }

}