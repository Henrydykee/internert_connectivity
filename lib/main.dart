import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.purple),
      home: Home(),
    );
  }
}
 class Home extends StatefulWidget {
   @override
   _HomeState createState() => _HomeState();
 }

 class _HomeState extends State<Home> {
  var _connectionStatus ='Unknown';
  Connectivity  connectivity;
  StreamSubscription<ConnectivityResult>subscription;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      print(result);
      if(result==ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        setState(() {
        });
      }
    });
  }

  @override
  void dispose(){
    subscription.cancel();
    super.dispose();
  }

  Future getData() async{
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/posts/");
    if(response.statusCode == HttpStatus.ok){
      var result = jsonDecode(response.body);
      return result;
    }
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Conectivity"),
         centerTitle: true,
         elevation: 0.0,
       ),
       body: FutureBuilder(
         future: getData(),
         builder: (context,snapshot) {
           if (snapshot.hasData) {
             var myData = snapshot.data;
             return ListView.builder(itemBuilder: (context, i) =>
                 ListTile(
                   title: Text(myData[i]['title']),
                   subtitle: Text(myData[1]['body']),
                 ),
               itemCount: myData.length,
             );
           } else {
             return Center(
               child: Icon(Icons.network_check,size: 25,),
             );
           }
         }
       ),
     );
   }
 }




