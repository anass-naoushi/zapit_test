import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:zapit_test/models/coinData.dart';

///Functions to interact with coinbase api
class ApiUtils{
  //Main coinmarket cap url
  static String mainUrl='https://pro-api.coinmarketcap.com/v1';
  ///Get the list of latest release coins
  static Future<List<CoinData>> getCoinsList(int limit,bool connected)async{
    String url=mainUrl+'/cryptocurrency/listings/latest?limit=$limit';
    List<CoinData> coinDataList=[];
    Box box = Hive.box('coinData');
    //await box.delete('coinsList');
    if(!connected){
      print('no connection,getting data from cache');
      List data=await box.get('coinsList',defaultValue: []);
      print('fetched box');
     //log('message',error: jsonEncode(data));
      coinDataList=List.generate(data.length, (index) {
        return CoinData.fromJson(Map.from(data[index]));});
    }else{
      print('getting realtime data');
      var response= await http.get(Uri.parse(url,),headers: {'X-CMC_PRO_API_KEY':'42e2e8d0-2227-4c47-8113-705f551c3f37'});
    if(response.statusCode==200){
     Map parsedData=await jsonDecode(response.body);
     coinDataList=List.generate(parsedData['data'].length, (index) => CoinData.fromJson(Map.from(parsedData['data'][index])));
     await box.put('coinsList', List.generate(coinDataList.length, (index) => Map.from(coinDataList[index].toJson())));
    }else{
      throw('unable to connect to connect to coinmarketcap api, error code: ${response.statusCode}');
    }
    }
   // print(coinDataList);
    return coinDataList;
  }
}