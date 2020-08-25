import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;

class Servertest extends StatefulWidget {
  static const String id = 'Server_secreen';
  @override
  _ServertestState createState() => _ServertestState();
}

class _ServertestState extends State<Servertest> {
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate = DateTime(year, month, day, 0, 0, 0, 0, 0);
  var sumText="";
  Future<String> getdataFromServer(DateTime start,DateTime end) async{
  var url="http://localhost:3000/getsum/${start.toIso8601String()}/${end.toIso8601String()}";
  print(url);
  var response = await http.get(url);
  print(response.body);
  print(start.toIso8601String());
  print(end.toIso8601String());
  print(url);

  return new Future(() => response.body);

  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   getdataFromServer();req.params.startdate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            builder: (BuildContext context,
                AsyncSnapshot<String> qttnumbr){
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${qttnumbr.data}',
                      style: TextStyle(
                          fontSize: 8, color: Colors.black),
                    ),
                  ],
                ),
              );

            },

          future:getdataFromServer(startDate,tomorow),
        ),
      ),
    );
  }
}
