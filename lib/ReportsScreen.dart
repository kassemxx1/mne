import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mne/MainScreen.dart';
import 'package:mne/MaintenanceTable.dart';
import 'package:mne/Report_Table.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';

var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
final _firestore = Firestore.instance;

class ReportsScreen extends StatefulWidget {
  static const String id = 'Reports_Screen';
  static var transaction = [];
  static var Mtransaction = [];
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  var Stransaction = [];
  var items = [];
  var sumitems = [];
  var summdolar = '';
  var summleb = '';

  var alfa9 = '';
  var alfa22 = '';
  var mtc12 = '';
  var mtc22 = '';
  var sos = '';
  var alfa$ = '';
  var mtc$ = '';
  var smart = '';
  var cards = '';
  var reports = '';

  bool isreport = true;

  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate = DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  bool _saving = true;

  void getreports() {
    setState(() {
      reports = 'yes';
    });
    gettransactiondate(startDate, endDate);
    getmaintenance(startDate, endDate, 'maintenance', ReportsScreen.Mtransaction);
    getmaintenance(startDate, endDate, 'spending', Stransaction);
  }

  void getcard() {
    setState(() {
      cards = 'yes';
    });
    getalfa$('alfa\$\$\$');
    getalfa9('alfa9\$');
    getalfa22('alfa22\$');
    getmtc$('mtc\$\$\$');
    getmtc12('MTC 12\$');
    getmtc22('mtc 22\$');
    getsmart('Start');
    getsos('SOS Start');
  }

  Future delay() async {
    await new Future.delayed(new Duration(seconds: 5), () {
      setState(() {
        _saving = false;
      });
    });
  }

  void gettodayleb(DateTime start, DateTime end, String currency) async {
    var sum1 = 0.0;
    setState(() {
      summleb = '';
    });
    var url = MainScreen.url +
        'getsum/transaction/${start.toIso8601String()}/${end.toIso8601String()}/${currency}';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    sum1 = double.parse(data['value']);

    var url2 = MainScreen.url +
        'getsum/others/${start.toIso8601String()}/${end.toIso8601String()}/${currency}';
    var response1 = await http.get(url2);
    Map data2 = (json.decode(response1.body));

    sum1 = double.parse(data['value']) + double.parse(data2['value']);

    setState(() {
      summleb =
          FlutterMoneyFormatter(amount: sum1).output.withoutFractionDigits;
      isreport = false;
    });
  }

  void gettodaydolar(DateTime start, DateTime end, String currency) async {
    var sum1 = 0.0;
    setState(() {
      summdolar = '';
    });
    var url = MainScreen.url +
        'getsum/transaction/${start.toIso8601String()}/${end.toIso8601String()}/${currency}';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    sum1 = double.parse(data['value']);
    var url2 = MainScreen.url +
        'getsum/others/${start.toIso8601String()}/${end.toIso8601String()}/${currency}';
    var response1 = await http.get(url2);
    Map data2 = (json.decode(response1.body));
    sum1 = double.parse(data['value']) + double.parse(data2['value']);
    setState(() {
      summdolar =
          FlutterMoneyFormatter(amount: sum1).output.withoutFractionDigits;
    });
  }

  void getmaintenance(
      DateTime s, DateTime e, String name, List Otransaction) async {
    final messages = await _firestore
        .collection('others')
        .where('timestamp', isGreaterThan: s)
        .where('timestamp', isLessThan: e)
        .where('name', isEqualTo: name)
        .getDocuments();
    Otransaction.clear();
    for (var msg in messages.documents) {
      final des = msg.data['description'];
      final price = msg.data['price'];
      final id = msg.documentID;
      final time = msg.data['timestamp'];
      setState(() {
        Otransaction.add(
            {'description': des, 'price': price, 'id': id, 'time': time});
      });
    }
  }

  void getalfa9(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      alfa9 = double.parse(data['value']).toString();
    });
  }

  void getalfa22(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      alfa22 = double.parse(data['value']).toString();
    });
  }

  void getmtc22(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      mtc22 = double.parse(data['value']).toString();
    });
  }

  void getmtc12(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      mtc12 = double.parse(data['value']).toString();
    });
  }

  void getmtc$(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      mtc$ = double.parse(data['value']).toStringAsFixed(2).toString();
    });
  }

  void getalfa$(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      alfa$ = double.parse(data['value']).toStringAsFixed(2).toString();
    });
  }

  void getsos(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      sos = double.parse(data['value']).toString();
    });
  }

  void getsmart(String name) async {
    var url = MainScreen.url + 'getcards/$name';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      smart = double.parse(data['value']).toString();
    });
  }

  void gettransactiondate(DateTime start, DateTime end) async {
    final messages = await _firestore
        .collection('transaction')
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    ReportsScreen.transaction.clear();
    for (var msg in messages.documents) {
      final name = msg.data['name'];
      final price = msg.data['price'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      final time = msg.data['timestamp'];
      final qtt = msg.data['qtt'];
      final client = msg.data['client'];
      setState(() {
        ReportsScreen.transaction.add({
          'name': name,
          'price': price,
          'curency': ccurency,
          'id': ttime,
          'time': time,
          'qtt': qtt,
          'client': client,
        });
        _saving = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = DateTime.now();
    gettodayleb(startDate, endDate, 'L.L');
    gettodaydolar(startDate, endDate, '\$');
  }

  @override
  Widget build(BuildContext context) {
    var today = new DateTime(year, month, day, 0, 0, 0, 0, 0);
    return Scaffold(
        backgroundColor: Colors.black54,
        body: ModalProgressHUD(
          inAsyncCall: false,
          dismissible: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                  child: Card(
                    color: Colors.white.withOpacity(0.0),
                    elevation: 20,
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                          'Monthly Report',
                          style: TextStyle(color: Colors.black54),
                        )),
                        Column(children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('start Date:',style: TextStyle(fontSize: 20),),
                                FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2019, 1, 1),
                                          maxTime: DateTime(2025, 6, 7),
                                          onChanged: (date) {},
                                          onConfirm: (date) {
                                        setState(() {
                                          startDate = date;
                                        });
                                        gettodayleb(startDate, endDate, 'L.L');
                                        gettodaydolar(startDate, endDate, '\$');
                                      },
                                          currentTime: DateTime.now(),

                                          locale: LocaleType.en);
                                    },
                                    child: Text(
                                      '${formatDate(startDate, [
                                        yyyy,
                                        '-',
                                        mm,
                                        '-',
                                        dd
                                      ])}',
                                      style: TextStyle(color: Colors.yellow,fontSize: 20),
                                    )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('End Date:',style: TextStyle(fontSize: 20),),
                              FlatButton(
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2019, 1, 1),
                                        maxTime: DateTime(2025, 6, 7),
                                        onChanged: (date) {},
                                        onConfirm: (date) {
                                      setState(() {
                                        endDate = date.add(new Duration(
                                            hours: 23,
                                            minutes: 59,
                                            seconds: 59));
                                      });
                                      gettodayleb(startDate, endDate, 'L.L');
                                      gettodaydolar(startDate, endDate, '\$');
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                                  child: Text(
                                    '${formatDate(endDate, [
                                      yyyy,
                                      '-',
                                      mm,
                                      '-',
                                      dd
                                    ])}',
                                    style: TextStyle(color: Colors.yellow,fontSize: 20),
                                  )),
                            ],
                          ),
                        ]),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('\$  ',style: TextStyle(fontSize: 20),),
                              summdolar == ''
                                  ? LoadingFlipping.circle(
                                      borderColor: Colors.yellow,
                                      borderSize: 3.0,
                                      size: 20.0,
                                    )
                                  : Text(
                                      '${summdolar.toString()}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.yellow),
                                    ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('L.L  ',style: TextStyle(fontSize: 20),),
                              summleb == ''
                                  ? LoadingFlipping.circle(
                                      borderColor: Colors.yellow,
                                      borderSize: 3.0,
                                      size: 20.0,
                                    )
                                  : Text(
                                      '${summleb.toString()}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.yellow),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: cards == ''
                      ? FlatButton(
                          onPressed: () {
                            getcard();
                          },
                          child: Text(
                            'Show Cards',
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 25),
                          ))
                      : Card(
                          color: Colors.white.withOpacity(0.0),
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Recharge Report',
                                style: TextStyle(color: Colors.black54),
                              ),
                              //////////////////////////////////////////////
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'alfa 9\$',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          alfa9 == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${alfa9}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'alfa 22\$',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          alfa22 == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${alfa22}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'alfa \$\$',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          alfa$ == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${alfa$}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'MTC 12\$',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          mtc12 == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${mtc12}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'MTC 22\$',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          mtc22 == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${mtc22}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'MTC \$\$',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          mtc$ == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${mtc$}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'start',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          smart == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${smart}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'SOS',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          sos == ''
                                              ? LoadingFlipping.circle(
                                                  borderColor: Colors.yellow,
                                                  borderSize: 3.0,
                                                  size: 15.0,
                                                  duration: Duration(hours: 1),
                                                )
                                              : Text(
                                                  '${sos}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.yellow),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                ),

                /////////////////////////////////////////////////
                reports == ''
                    ? FlatButton(
                        onPressed: () {
                          getreports();
                        },
                        child: Text(
                          'Show Reports',
                          style: TextStyle(color: Colors.yellow, fontSize: 25),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              gettransactiondate(startDate, endDate);
                              Navigator.pushNamed(context, ReportTable.id);
                            },
                            child: Text(
                              'Transaction Report',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              getmaintenance(startDate, endDate, 'maintenance',
                                  ReportsScreen.Mtransaction);
                              Navigator.pushNamed(context, MaintenaceTable.id);
//
//                              showDialog(
//                                  context: context,
//                                  builder: (BuildContext context) {
//                                    return AlertDialog(
//                                      shape: RoundedRectangleBorder(
//                                          borderRadius: BorderRadius.all(
//                                              Radius.circular(10.0))),
//                                      content: Scaffold(
//                                        body: Container(
//                                          child: new ListView.builder(
//                                              itemCount: Mtransaction.length,
//                                              itemBuilder: (BuildContext cntxt,
//                                                  int index) {
//                                                return Dismissible(
//                                                  background: Material(
//                                                    color: Colors.red,
//                                                  ),
//                                                  onDismissed: (DismissDirection
//                                                      direction) {
//                                                    return showDialog(
//                                                        context: context,
//                                                        builder: (BuildContext
//                                                            context) {
//                                                          return AlertDialog(
//                                                            title: Text(
//                                                                'Are You Sure To delete ?'),
//                                                            actions: <Widget>[
//                                                              MaterialButton(
//                                                                child: Text(
//                                                                    'Cancel'),
//                                                                onPressed: () {
//                                                                  Navigator.of(
//                                                                          context)
//                                                                      .pop();
//                                                                },
//                                                              ),
//                                                              MaterialButton(
//                                                                child:
//                                                                    Text('Yes'),
//                                                                onPressed:
//                                                                    () async {
//                                                                  await _firestore
//                                                                      .collection(
//                                                                          'others')
//                                                                      .document(
//                                                                          '${Mtransaction[index]['id']}')
//                                                                      .delete();
//                                                                  getmaintenance(
//                                                                      startDate,
//                                                                      endDate,
//                                                                      'maintenance',
//                                                                      Mtransaction);
//                                                                  Mtransaction.remove(
//                                                                      Mtransaction[
//                                                                          index]);
//                                                                  Navigator.of(
//                                                                          context)
//                                                                      .pop();
//                                                                },
//                                                              )
//                                                            ],
//                                                          );
//                                                        });
//                                                  },
//                                                  key: Key(Mtransaction[index]
//                                                      .toString()),
//                                                  child: Card(
//                                                    child: ListTile(
//                                                      title: Text(
//                                                        '${formatDate(DateTime.parse(Mtransaction[index]['time'].toDate().toString()), [
//                                                          yyyy,
//                                                          '-',
//                                                          mm,
//                                                          '-',
//                                                          dd
//                                                        ])}',
//                                                        style: TextStyle(
//                                                            color: Colors.grey,
//                                                            fontSize: 12),
//                                                      ),
//                                                      subtitle: Row(
//                                                        children: <Widget>[
//                                                          Container(
//                                                            child: Padding(
//                                                              padding:
//                                                                  const EdgeInsets
//                                                                      .all(8.0),
//                                                              child: Text(
//                                                                '${Mtransaction[index]['description'].toString()}',
//                                                                style: TextStyle(
//                                                                    color: Colors
//                                                                        .green,
//                                                                    fontSize:
//                                                                        10),
//                                                              ),
//                                                            ),
//                                                            decoration:
//                                                                BoxDecoration(
//                                                                    border:
//                                                                        Border
//                                                                            .all(
//                                                              color:
//                                                                  Colors.black,
//                                                            )),
//                                                            width: 70,
//                                                          ),
//                                                          Container(
//                                                            decoration: BoxDecoration(
//                                                                border: Border.all(
//                                                                    color: Colors
//                                                                        .black)),
//                                                            width: 70,
//                                                            child: Padding(
//                                                              padding:
//                                                                  const EdgeInsets
//                                                                      .all(8.0),
//                                                              child: Text(
//                                                                '${Mtransaction[index]['price'].toString()}',
//                                                                style: TextStyle(
//                                                                    color: Colors
//                                                                        .red,
//                                                                    fontSize:
//                                                                        10),
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ],
//                                                      ),
//                                                    ),
//                                                  ),
//                                                );
//                                              }),
//                                        ),
//                                      ),
//                                    );
//                                  });
                            },
                            child: Text(
                              'Maintenance Report',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              getmaintenance(
                                  startDate, endDate, 'spending', Stransaction);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      content: Scaffold(
                                        body: Container(
                                          child: new ListView.builder(
                                              itemCount: Stransaction.length,
                                              itemBuilder: (BuildContext cntxt,
                                                  int index) {
                                                return Dismissible(
                                                  background: Material(
                                                    color: Colors.red,
                                                  ),
                                                  onDismissed: (DismissDirection
                                                      direction) {
                                                    return showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Are You Sure To delete ?'),
                                                            actions: <Widget>[
                                                              MaterialButton(
                                                                child: Text(
                                                                    'Cancel'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              MaterialButton(
                                                                child:
                                                                    Text('Yes'),
                                                                onPressed:
                                                                    () async {
                                                                  await _firestore
                                                                      .collection(
                                                                          'others')
                                                                      .document(
                                                                          '${Stransaction[index]['id']}')
                                                                      .delete();
                                                                  getmaintenance(
                                                                      startDate,
                                                                      endDate,
                                                                      'spending',
                                                                      Stransaction);
                                                                  Stransaction.remove(
                                                                      Stransaction[
                                                                          index]);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  key: Key(Stransaction[index]
                                                      .toString()),
                                                  child: Card(
                                                    child: ListTile(
                                                      title: Text(
                                                        '${formatDate(DateTime.parse(Stransaction[index]['time'].toDate().toString()), [
                                                          yyyy,
                                                          '-',
                                                          mm,
                                                          '-',
                                                          dd
                                                        ])}',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                '${Stransaction[index]['description'].toString()}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                            width: 70,
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black)),
                                                            width: 70,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                '${Stransaction[index]['price'].toString()}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        10),
                                                              ),
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
                                  });
                            },
                            child: Text(
                              'Spending Report',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MaterialButton(
                            child: Text('Print'),
                            onPressed: () {
                              Printer.connect('RPP200', port: 9100)
                                  .then((printer) {
                                printer.println('kassem');
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}
