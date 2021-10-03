import 'package:flutter/material.dart';
import 'package:zapit_test/models/coinData.dart';
import 'package:zapit_test/screens/coinDetails.dart';

///Single element inside the list of coins in the CoinsList class
class ListTileElement extends StatefulWidget {
  final CoinData coinElementData;
  const ListTileElement({ Key key, @required this.coinElementData }) : super(key: key);

  @override
  _ListTileElementState createState() => _ListTileElementState();
}

class _ListTileElementState extends State<ListTileElement> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.coinElementData.name),
      subtitle: Text(widget.coinElementData.quote.uSD.price.toString()),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: (){
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CoinDetails(coinData: widget.coinElementData)),
  );
      },
    );
  }
}