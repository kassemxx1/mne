
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  var transaction = [];
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  bool _saving=true;
  Future delay() async{
    await new Future.delayed(new Duration(seconds: 5), ()
    {
      setState(() {
        _saving=false;
      });

    });
  }

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
  void gettransactiondate(DateTime start, DateTime end) async {
    final messages = await _firestore.collection('transaction').where(
        'timestamp', isGreaterThan: start).where('timestamp',isLessThan: end).getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final name = msg.data['name'];
      final price = msg.data['price'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      final time = msg.data['timestamp'];
      final qtt = msg.data['qtt'];
      setState(() {
        transaction.add({
          'name': name,
          'price': price,
          'curency': ccurency,
          'id': ttime,
          'time':time,
          'qtt':qtt,
        });
        _saving=false;
      });
    }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    gettransactiondate(startDate, endDate);
    delay();
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
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          dismissible: true,
          child: Column(
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
              MaterialButton(
                onPressed: () {
                  gettransactiondate(startDate, endDate);
                  print(transaction);
                  showDialog(

                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0))
                          ),
                          content: Scaffold(
                            body: Container(
                              child: new ListView.builder(
                                  itemCount: transaction.length,

                                  itemBuilder: (BuildContext cntxt,
                                      int index) {
                                    return Dismissible(
                                      background: Material(
                                        color: Colors.red,
                                      ),
                                      onDismissed: (
                                          DismissDirection direction) async {
//                                    await _firestore.collection('messages').getDocuments().then((snapshot) {
//                                      for (DocumentSnapshot ds in snapshot.documents){
//                                        ds.reference.delete();
//                                      });
//                                    }

                                        print('${transaction[index]['id']}');
                                        print(transaction[index]);
                                        await _firestore.collection('transaction')
                                            .document(
                                            '${transaction[index]['id']}')
                                            .delete();
                                        gettransactiondate(startDate, endDate);
                                        transaction.remove(
                                            transaction[index]);
                                      },
                                      key: Key(transaction[index].toString()),

                                      child: Card(
                                        child: ListTile(
                                          title: Text('${formatDate(DateTime.parse(transaction[index]['time'].toDate().toString()), [yyyy, '-', mm, '-', dd])}',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${transaction[index]['name']
                                                        .toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,fontSize: 10),),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,)),
                                                width: 70,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${transaction[index]['price']
                                                        .toString()}',
                                                    style: TextStyle(
                                                        color: Colors.red,fontSize: 10),),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 50,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Text(
                                                    '${transaction[index]['curency']
                                                        .toString()}',
                                                    style: TextStyle(color: Colors
                                                        .blueAccent,fontSize: 10),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),

                        );
                      }
                  );
                },
                child: Text('Transaction Report', style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),

              ),

            ],
          ),
        ));
  }
}
