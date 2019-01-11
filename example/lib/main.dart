import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pattern Input'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Integer Number'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(),
                    LengthLimitingTextInputFormatter(16)
                  ],
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Decimal Number'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(allowFraction: true),
                    LengthLimitingTextInputFormatter(16)
                  ],
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CreditCardFormatter(),
                    LengthLimitingTextInputFormatter(19)
                  ],
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'dd/MM/yyyy'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp(r'\d+|-|/')),
                    DateInputFormatter(),
                  ],
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
