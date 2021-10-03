import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:zapit_test/models/coinData.dart';
import 'package:zapit_test/utils/apiUtils.dart';
import 'package:zapit_test/widgets/listTileElement.dart';

///Shows hw list of coins on the main screen
class CoinsList extends StatefulWidget {
  const CoinsList({ Key key }) : super(key: key);

  @override
  _CoinsListState createState() => _CoinsListState();
}

class _CoinsListState extends State<CoinsList> {
  ValueNotifier<bool> connected=ValueNotifier(null);
  Future<void> checkConnection() async {
try{
var response =await http.get(Uri.parse('https://www.google.com/')).timeout(Duration(seconds:3));
if(response.statusCode==200){
  connected?.value=true;
}
}catch(e){
  connected?.value=false;
}

  }
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 3), (timer) { 
      checkConnection();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coins List'),
      ),
      body:ValueListenableBuilder(
        valueListenable: connected,
        builder: (context,data,_){
          return  connected?.value==null?
      Center(child: CircularProgressIndicator(),):
             FutureBuilder<List<CoinData>>(
              future: ApiUtils.getCoinsList(4,connected?.value),
              builder: (context,coinData){
                if(coinData.hasError){
                  print(coinData.error);
                  return Center(child: Text(coinData.error.toString()),);
                }else if(!coinData.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }else{
                  return coinData.data.isEmpty?
                  Center(child: Text(connected.value?'No coins available to show':'No cached data to show'),):
                  ListView(
                    children: [
                      ListTile(
                        title: !connected.value?
                        Text('Offline (cached data)',style:TextStyle(color: Colors.red)):
                        Text('Online',style:TextStyle(color: Colors.green)),
                      ),
                      Column(
                        children: List.generate(coinData.data.length, (index) => 
                        ListTileElement(
                          coinElementData: coinData.data[index],
                        )
                        ),
                      )
                    ],
                  );
                }
              },
            );
        },
      )
    );
  }
}