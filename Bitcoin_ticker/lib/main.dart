import 'package:bitcoin_ticker/currencydata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io'show Platform;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage(), debugShowCheckedModeBanner: false);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String Selectedcurrency = "USD";

  DropdownButton<String> getdropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (final currency in currenciesList) {
      var item = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownItems.add(item);
    }
   return  DropdownButton<String>(
      value: Selectedcurrency,
      dropdownColor: Colors.black,
      iconSize: 20,
      style: TextStyle(color: Colors.white),
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          Selectedcurrency = value!;
        });
      },
    );
  }

CupertinoPicker picker(){
  List<Text> pickerlist = [];
  for (String currency in currenciesList) {
    var item = Text(currency);
    pickerlist.add(item);
  }
  return CupertinoPicker(
    itemExtent: 32.0,
    onSelectedItemChanged: (Selectedcurrency) {},
    children: pickerlist,
  );
}

Widget? getpicker()
{
  if(Platform.isAndroid){
    return getdropdown();
  } else if (Platform.isIOS){
    return picker();
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "BitCoinTicker",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Card(
              color: Colors.blueAccent,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 15,
                ),
                child: Text(
                  "BTC = ? $Selectedcurrency",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Platform.isIOS?picker():getdropdown(),
          ),
        ],
      ),
    );
  }
}
