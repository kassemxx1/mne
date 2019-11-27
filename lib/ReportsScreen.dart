
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
final _firestore = Firestore.instance;

class ReportsScreen extends StatefulWidget {
  static const String id = 'Reports_Screen';
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);

  Future<double> getTodayIn(
      DateTime start, DateTime end, List list, String currency) async {
    list.clear();
    final messsages1 = await _firestore
        .collection('clients')
        .where('currnecy', isEqualTo: currency)
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    final messsages = await _firestore
        .collection('transaction')
        .where('currency', isEqualTo: currency)
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    for (var msg in messsages.documents) {
      final price = msg.data['price'];
      setState(() {
        list.add(
          price,
        );
      });
    }
    for (var msg in messsages1.documents) {
      final price = msg.data['den'];
      setState(() {
        list.add(
          -price,
        );
      });
    }
    var result = list.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }
  Future<double> getqtt(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['qtt'];

        qtts.add(qtt);


      print(qtt);
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }
  Future<double> getqttmtc(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['qtt'];

      qtts.add(qtt);


      print(qtt);
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  @override
  Widget build(BuildContext context) {

    var today = new DateTime(year, month, day, 0, 0, 0, 0, 0);



    var IN$ = [];
    var INLL = [];
    var rangeIn$ = [];
    var rangeInLL = [];
    return Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('\$'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(today, tomorow, IN$, '\$'),
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('L.L'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(today, tomorow, INLL, 'L.L'),
            ),
            Row(
              children: <Widget>[
                Text('start Date:'),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2019, 1, 1),
                          maxTime: DateTime(2025, 6, 7), onChanged: (date) {

                      }, onConfirm: (date) {
                        setState(() {
                          startDate =date;
                        });



                        print(startDate);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      '${formatDate(startDate, [yyyy, '-', mm, '-', dd])}',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Text('End Date:'),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2019, 1, 1),
                          maxTime: DateTime(2025, 6, 7), onChanged: (date) {

                          }, onConfirm: (date) {
                            setState(() {
                              endDate =date.add(new Duration(hours: 23,minutes: 59,seconds: 59));
                            });




                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      '${formatDate(endDate, [yyyy, '-', mm, '-', dd])}',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('\$'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(startDate, endDate, rangeIn$, '\$'),
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('L.L'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(startDate, endDate, rangeInLL, 'L.L'),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Row(
                          children: <Widget>[
                            Text('alfa 9\$'),
                            Text(
                              '${qttnumbr.data}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                    initialData: 0.0,
                    future: getqtt('alfa9\$'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Row(
                          children: <Widget>[
                            Text('alfa 22\$'),
                            Text(
                              '${qttnumbr.data}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                    initialData: 0.0,
                    future: getqtt('alfa22\$'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Row(
                          children: <Widget>[
                            Text('alfa \$\$'),
                            Text(
                              '${qttnumbr.data}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                    initialData: 0.0,
                    future: getqtt('alfa\$\$\$'),
                  ),
                ),

              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Row(
                          children: <Widget>[
                            Text('MTC 12\$'),
                            Text(
                              '${qttnumbr.data}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                    initialData: 0.0,
                    future: getqtt('MTC 12\$'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Row(
                          children: <Widget>[
                            Text('MTC 22\$'),
                            Text(
                              '${qttnumbr.data}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                    initialData: 0.0,
                    future: getqttmtc('mtc 22\$'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Row(
                          children: <Widget>[
                            Text('MTC \$\$'),
                            Text(
                              '${qttnumbr.data.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                    initialData: 0.0,
                    future: getqtt('mtc\$\$\$'),
                  ),
                ),

              ],
            ),

          ],
        ));
  }
}
