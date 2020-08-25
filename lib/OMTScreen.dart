import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mne/MainScreen.dart';
import 'package:mne/OMT_Table.dart';
import 'constants.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_format/date_format.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
final _firestore = Firestore.instance;
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
var out = 0.0;
var IN = 0.0;
var description = '';
var opening = 0.0;
var opend = 0.0;
var currency = 'L.L.';

TextEditingController _textEditingController1 = TextEditingController();
TextEditingController _textEditingController2 = TextEditingController();
TextEditingController _textEditingController3 = TextEditingController();
TextEditingController _textEditingController4 = TextEditingController();
TextEditingController _textEditingController5 = TextEditingController();

var lebin='';
var lebout='';
var lebtotal='';
var dolarin='';
var dolarout='';
var dolartotal='';


class OMTScreen extends StatefulWidget {
  static const String id = 'OMT_Screen';
  static var transaction = [];
  @override
  _OMTScreenState createState() => _OMTScreenState();
}

class _OMTScreenState extends State<OMTScreen> {
  Runes runes;
  var sumsum;

  var startDate = DateTime(year, month, day, 0, 0, 0, 0, 0);
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  bool _saving = true;

  void getopen() async {
    final messages = await _firestore.collection('oppening').getDocuments();
    for (var i in messages.documents) {
      if (i.documentID == startDate.toString()) {
        setState(() {
          opening = i.data['openning'];
          i.data['opendolar']==null?0.0:opend=i.data['opendolar'];
        });
      }
    }
    _saving = false;
  }

  void gettransaction() async {
    final messages = await _firestore
        .collection('omt')
        .where('timestamp', isGreaterThan: startDate)
        .getDocuments();
    OMTScreen.transaction.clear();
    for (var msg in messages.documents) {
      final IIN = msg.data['in'];
      final oout = msg.data['out'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      final time = msg.data['timestamp'];
      final des = msg.data['description'].toString();
      setState(() {
        OMTScreen.transaction.add({
          'in': IIN,
          'out': oout,
          'curency': ccurency,
          'id': ttime,
          'time': time,
          'description': des,
        });
        _saving = false;
      });
    }
  }

  void gettransactiondate(DateTime start, DateTime end) async {
    final messages = await _firestore
        .collection('omt')
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    OMTScreen.transaction.clear();
    for (var msg in messages.documents) {
      final IIN = msg.data['in'];
      final oout = msg.data['out'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      final time = msg.data['timestamp'];
      final des = msg.data['description'];
      setState(() {
        OMTScreen.transaction.add({
          'in': IIN,
          'out': oout,
          'curency': ccurency,
          'id': ttime,
          'time': time,
          'description': des,
        });
      });
    }
  }

//  Future<double> getqtt(String name, DateTime today, String currencyy) async {
//    var qtts = [0.0];
//    final messages = await _firestore
//        .collection('omt')
//        .where('currency', isEqualTo: currencyy)
//        .where('timestamp', isGreaterThan: today)
//        .getDocuments();
//    for (var msg in messages.documents) {
//      final qtt = msg[name];
//      setState(() {
//        qtts.add(qtt);
//      });
//    }
//    var result = qtts.reduce((sum, element) => sum + element);
//    return new Future(() => result);
//
//
//    var sum1=0.0;
//    var url=MainScreen.url +'getqttomt/$name/${today.toIso8601String()}/$currencyy';
//    var response = await http.get(url);
//    Map data = (json.decode(response.body));
//    sum1=double.parse(data['value']);
//    return new Future(() => sum1);
//  }

  void getlebin(String name, DateTime today,DateTime end, String currencyy) async{
    setState(() {
      lebin='';
    });
    var url=MainScreen.url +'getqttomt/$name/${today.toIso8601String()}/${end.toIso8601String()}/$currencyy';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      lebin=double.parse(data['value']).toString();
    });
  }
  void getlebout(String name, DateTime today,DateTime end, String currencyy) async{
    setState(() {
      lebout='';
    });
    var url=MainScreen.url +'getqttomt/$name/${today.toIso8601String()}/${end.toIso8601String()}/$currencyy';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      lebout=double.parse(data['value']).toString();
    });
  }
  void getdolarin(String name, DateTime today,DateTime end, String currencyy) async{
    setState(() {
      dolarin='';
    });
    var url=MainScreen.url +'getqttomt/$name/${today.toIso8601String()}/${end.toIso8601String()}/$currencyy';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      dolarin=double.parse(data['value']).toString();
    });
  }
  void getdolarout(String name, DateTime today,DateTime end, String currencyy) async{
    setState(() {
      lebin=dolarout;
    });
    var url=MainScreen.url +'getqttomt/$name/${today.toIso8601String()}/${end.toIso8601String()}/$currencyy';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      dolarout=double.parse(data['value']).toString();
    });
  }


//  Future<double> getsum(DateTime today, String currencyy) async {
////    var qtts = [0.0];
////
////    final messages = await _firestore
////        .collection('omt')
////        .where('currency', isEqualTo: currencyy)
////        .where('timestamp', isGreaterThan: today)
////        .getDocuments();
////    for (var msg in messages.documents) {
////      final iin = msg['in'];
////      final outt = -msg['out'];
////      setState(() {
////        qtts.add(iin);
////        qtts.add(outt);
////      });
////    }
////
////    var result = qtts.reduce((sum, element) => sum + element);
////    return new Future(() => result);
//    var sum1=0.0;
//    var url=MainScreen.url +'getomtoday/${today.toIso8601String()}/$currencyy';
//    var response = await http.get(url);
//    Map data = (json.decode(response.body));
//
//
//    sum1=double.parse(data['value']);
//    return new Future(() => sum1);
//  }

//  Future<double> getsumsum(DateTime today, String currencyy) async {
//    var qtts = [0.0];
//
//    final messages = await _firestore
//        .collection('omt')
//        .where('currency', isEqualTo: currencyy)
//        .where('timestamp', isGreaterThan: today)
//        .getDocuments();
//    for (var msg in messages.documents) {
//      final iin = msg['in'];
//      final outt = -msg['out'];
//      setState(() {
//        qtts.add(iin);
//        qtts.add(outt);
//      });
//    }
//    setState(() {
//      qtts.add(opening);
//    });
////    final opening = await _firestore.collection('oppening').getDocuments();
////    for(var msg in opening.documents){
////      final qtt = msg['opening'];
////      setState(() {
////        qtts.add(qtt);
////      });
////    }
//
//    var result = qtts.reduce((sum, element) => sum + element);
//
//    return new Future(() => result);
//  }
  Future<double> getnewsum(double sum1,double sum2) async{
    var result=0.0;
    result = await (sum1 - sum2);
    return new Future(() => result);
  }
  Future<double> getnewsumopening(double sum1,double sum2,double theopening) async{
    var result=0.0;
    result = await (sum1 - sum2 + theopening);
    return new Future(() => result);
  }
  @override
  void initState() {
    super.initState();
    opening = 0.0;
    opend=0.0;
    getopen();
    gettransaction();
    print(startDate);
    getlebin('in', startDate,tomorow, 'L.L.');
    getlebout('out', startDate,tomorow, 'L.L.');
    getdolarin('in', startDate,tomorow, '\$');
    getdolarout('out', startDate,tomorow, '\$');
  }

  @override
  Widget build(BuildContext context) {
    var open = 0.0;
    var openn=0.0;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'OMT',
          style: TextStyle(color: Colors.yellow, fontSize: 30),
        ),
        backgroundColor: Colors.black54,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        dismissible: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.black54,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.0),
                    elevation: 20,
                    child: Column(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Enter Opening Balance',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 40, right: 40, top: 10),
                                          child: new TextField(
                                            controller: _textEditingController3,
                                            decoration:
                                                KTextFieldImputDecoration
                                                    .copyWith(
                                                        hintText:
                                                            'Opening Balance'),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) async {
                                              setState(() {
                                                open = double.parse(value);
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 40, right: 40, top: 10),
                                          child: new TextField(
                                            controller: _textEditingController5,
                                            decoration:
                                            KTextFieldImputDecoration
                                                .copyWith(
                                                hintText:
                                                'Opening Dolar'),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) async {
                                              setState(() {
                                                openn = double.parse(value);
                                              });
                                            },
                                          ),

                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            _firestore
                                                .collection('oppening')
                                                .document('$startDate')
                                                .setData({
                                              'openning': open,
                                              'opendolar':openn,
                                            });
                                            _textEditingController3.clear();
                                            _textEditingController5.clear();
                                            getopen();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Done'),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            'Enter Opening Balance',
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                          ),
                          color: Colors.black54,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Opening Balance =  ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${FlutterMoneyFormatter(amount: opening).output.withoutFractionDigits} L.L',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Opening Balance =  ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${FlutterMoneyFormatter(amount: opend).output.withoutFractionDigits} \$',
                              style:
                              TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomRadioButton(
                    buttonColor: Colors.black54,
                    buttonLables: [
                      'L.L.',
                      '\$',
                    ],
                    buttonValues: [
                      'L.L.',
                      '\$',
                    ],
                    radioButtonValue: (value) {
                      setState(() {
                        currency = value;
                      });
                    },
                    selectedColor: Colors.yellow,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: new TextField(
                    controller: _textEditingController1,
                    decoration:
                        KTextFieldImputDecoration.copyWith(hintText: 'IN'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        IN = double.parse(value);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: new TextField(
                    decoration:
                        KTextFieldImputDecoration.copyWith(hintText: 'Out'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        out = double.parse(value);
                      });
                      print(out);
                    },
                    controller: _textEditingController2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: new TextField(
                    decoration: KTextFieldImputDecoration.copyWith(
                        hintText: 'Description'),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    controller: _textEditingController4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.black54,
                    onPressed: ()  {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text('Are You Sure ?'),
                                actions: <Widget>[
                                  MaterialButton(
                                    child: Text('cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  MaterialButton(
                                      child: Text('yes'),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _saving = true;
                                        });
                                        await _firestore.collection('omt').add({
                                          'in': IN,
                                          'out': out,
                                          'timestamp': Timestamp.now(),
                                          'currency': currency,
                                          'description': description
                                        });
                                        _textEditingController1.clear();
                                        _textEditingController2.clear();
                                        _textEditingController4.clear();
                                        setState(() {
                                          out = 0.0;
                                          IN = 0.0;
                                        });
//                                        getqtt('in', startDate, 'L.L.');
//                                        getqtt('in', startDate, '\$');
                                        if (currency =='L.L.'){
                                          getlebin('in', startDate,endDate, 'L.L.');
                                          getlebout('out', startDate,tomorow, 'L.L.');
                                        }
                                        if(currency =='\$' ){
                                          getdolarin('in', startDate,tomorow, '\$');
                                          getdolarout('out', startDate,tomorow, '\$');
                                        }
                                        gettransaction();
                                        FocusScope.of(context).unfocus();

                                      }),
                                ]);
                          });
                    },
                  ),
                ),

                //////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.0),
                    elevation: 20,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
//                              child: FutureBuilder(
//                                  builder: (BuildContext context,
//                                      AsyncSnapshot<double> qttnumbr) {
//                                    return Center(
//                                      child: Text(
//                                        'In  : ${FlutterMoneyFormatter(amount: qttnumbr.data).amount} L.L',
//                                        style: TextStyle(
//                                            color: Colors.black, fontSize: 18),
//                                 c      ),
//                                    );
//                                  },
//                                  initialData: 1.0,
//                                  future: getqtt('in', startDate, 'L.L.')),
                            child: Center(
                              child: lebin==''?LoadingFlipping.circle(
                                borderColor: Colors.yellow,
                                borderSize: 3.0,
                                size: 20.0,
                              ):Text(
                                'In  : ${FlutterMoneyFormatter(amount: double.parse(lebin)).output.withoutFractionDigits} L.L',
                                style: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                            ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
//                              child: FutureBuilder(
//                                  builder: (BuildContext context,
//                                      AsyncSnapshot<double> qttnumbr) {
//                                    return Center(
//                                      child: Text(
//                                        'Out  : ${FlutterMoneyFormatter(amount: qttnumbr.data).amount} L.L',
//                                        style: TextStyle(
//                                            color: Colors.black, fontSize: 18),
//                                      ),
//                                    );
//                                  },
//                                  initialData: 1.0,
//                                  future: getqtt('out', startDate, 'L.L.')),
                              child: Center(
                                child: lebout==''?LoadingFlipping.circle(
                                  borderColor: Colors.yellow,
                                  borderSize: 3.0,
                                  size: 20.0,
                                ):Text(
                                  'OUT  : ${FlutterMoneyFormatter(amount: double.parse(lebout)).output.withoutFractionDigits} L.L',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                            builder: (BuildContext context,
                                AsyncSnapshot<double> qttnumbr) {
                              return Center(
                                child: Text(
                                  'Tolal  : ${FlutterMoneyFormatter(amount: qttnumbr.data).output.withoutFractionDigits} L.L',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              );
                            },
                            initialData: 1.0,
                            future: getnewsum(lebin==''?0:double.parse(lebin), lebout==''?0:double.parse(lebout))),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.0),
                    elevation: 20,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
//                              child: FutureBuilder(
//                                  builder: (BuildContext context,
//                                      AsyncSnapshot<double> qttnumbr) {
//                                    return Center(
//                                      child: Text(
//                                        'In  : ${FlutterMoneyFormatter(amount: qttnumbr.data).amount} \$',
//                                        style: TextStyle(
//                                            color: Colors.black, fontSize: 18),
//                                      ),
//                                    );
//                                  },
//                                  initialData: 1.0,
//                                  future: getqtt('in', startDate, '\$')),
                              child: Center(
                                child: dolarin==''?LoadingFlipping.circle(
                                  borderColor: Colors.yellow,
                                  borderSize: 3.0,
                                  size: 20.0,
                                ):Text(
                                  'In  : ${FlutterMoneyFormatter(amount: double.parse(dolarin)).output.nonSymbol} \$',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
//                              child: FutureBuilder(
//                                  builder: (BuildContext context,
//                                      AsyncSnapshot<double> qttnumbr) {
//                                    return Center(
//                                      child: Text(
//                                        'Out  : ${FlutterMoneyFormatter(amount: qttnumbr.data).amount} \$',
//                                        style: TextStyle(
//                                            color: Colors.black, fontSize: 18),
//                                      ),
//                                    );
//                                  },
//                                  initialData: 1.0,
//                                  future: getqtt('out', startDate, '\$')),
                              child: Center(
                                child: dolarout==''?LoadingFlipping.circle(
                                  borderColor: Colors.yellow,
                                  borderSize: 3.0,
                                  size: 20.0,
                                ):Text(
                                  'OUT  : ${FlutterMoneyFormatter(amount: double.parse(dolarout)).output.nonSymbol} \$',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                        FutureBuilder(
                            builder: (BuildContext context,
                                AsyncSnapshot<double> qttnumbr) {
                              return Center(
                                child: Text(
                                  'Tolal  : ${FlutterMoneyFormatter(amount: qttnumbr.data).output.nonSymbol} \$',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              );
                            },
                            initialData: 1.0,
                            future: getnewsum(dolarin==''?0:double.parse(dolarin), dolarout==''?0:double.parse(dolarout))),
                      ],
                    ),
                  ),
                ),
                //////////////////////////////////////////////////
                MaterialButton(
                  onPressed: () {
                    gettransaction();

//                      showDialog(
//
//                          context: context,
//                          builder: (BuildContext context) {
//                            return AlertDialog(
//                              shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.all(
//                                      Radius.circular(10.0))
//                              ),
//                              content: Scaffold(
//                                body: Container(
//                                  child: new ListView.builder(
//                                      itemCount: transaction.length,
//
//                                      itemBuilder: (BuildContext cntxt,
//                                          int index) {
//                                        return Dismissible(
//                                          background: Material(
//                                            color: Colors.red,
//                                          ),
//                                          onDismissed: (
//                                              DismissDirection direction)  {
//                                            return showDialog(
//                                                context: context,
//                                                builder: (BuildContext context) {
//                                                  return AlertDialog(
//                                                    title: Text(
//                                                        'Are You Sure To delete ?'),
//                                                    actions: <Widget>[
//                                                      MaterialButton(
//                                                        child: Text('Cancel'),
//                                                        onPressed: () {
//                                                          Navigator.of(context)
//                                                              .pop();
//                                                        },
//                                                      ),
//                                                      MaterialButton(
//                                                        child: Text('Yes'),
//                                                        onPressed: () async {
//                                                          print('${transaction[index]['id']}');
//                                                          print(transaction[index]);
//                                                          await _firestore.collection('omt')
//                                                              .document(
//                                                              '${transaction[index]['id']}')
//                                                              .delete();
//                                                          gettransaction();
//                                                          transaction.remove(
//                                                              transaction[index]);
//                                                        },
//                                                      )
//                                                    ],
//                                                  );
//                                                });
//
//
//
//
////                                    await _firestore.collection('messages').getDocuments().then((snapshot) {
////                                      for (DocumentSnapshot ds in snapshot.documents){
////                                        ds.reference.delete();
////                                      });
////                                    }
//
//
//                                          },
//                                          key: Key(transaction[index].toString()),
//
//                                          child: Row(
//                                            children: <Widget>[
//                                              Container(
//                                                child: Padding(
//                                                  padding: const EdgeInsets.all(
//                                                      8.0),
//                                                  child: Text(
//                                                    '${transaction[index]['in']
//                                                        .toString()}',
//                                                    style: TextStyle(
//                                                        color: Colors.green),),
//                                                ),
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(
//                                                        color: Colors.black)),
//                                                width: 85,
//                                              ),
//                                              Container(
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(
//                                                        color: Colors.black)),
//                                                width: 85,
//                                                child: Padding(
//                                                  padding: const EdgeInsets.all(
//                                                      8.0),
//                                                  child: Text(
//                                                    '${transaction[index]['out']
//                                                        .toString()}',
//                                                    style: TextStyle(
//                                                        color: Colors.red),),
//                                                ),
//                                              ),
//                                              Container(
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(
//                                                        color: Colors.black)),
//                                                width: 50,
//                                                child: Padding(
//                                                  padding: const EdgeInsets.all(
//                                                      8.0),
//                                                  child: Text(
//                                                    '${transaction[index]['curency']
//                                                        .toString()}',
//                                                    style: TextStyle(color: Colors
//                                                        .blueAccent),),
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        );
//                                      }),
//                                ),
//                              ),
//
//                            );
//                          }
//                      );
                    Navigator.pushNamed(context, OmtTable.id);
                  },
                  child: Text(
                    'Daily Report',
                    style: TextStyle(
                      color: Colors.yellow,
                      backgroundColor: Colors.black54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Card(
                      color: Colors.white.withOpacity(0.0),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          getopen();

                                          print(startDate);
                                          getlebin('in', startDate,endDate, 'L.L.');
                                          getlebout('out', startDate, endDate,'L.L.');
                                          getdolarin('in', startDate,endDate, '\$');
                                          getdolarout('out', startDate, endDate,'\$');
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
                                        style: TextStyle(
                                            color: Colors.yellow, fontSize: 20),
                                      )),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          getlebin('in', startDate,endDate ,'L.L.');
                                          getlebout('out', startDate,endDate, 'L.L.');
                                          getdolarin('in', startDate,endDate ,'\$');
                                          getdolarout('out', startDate,endDate, '\$');
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
                                        style: TextStyle(
                                            color: Colors.yellow, fontSize: 20),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          MaterialButton(
                            onPressed: () {
                              gettransactiondate(startDate, endDate);
                              Navigator.pushNamed(context, OmtTable.id);
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
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: FutureBuilder(
                      builder: (BuildContext context,
                          AsyncSnapshot<double> qttnumbr) {
                        return Center(
                          child: Text(
                            'Total : ${FlutterMoneyFormatter(amount: qttnumbr.data).amount} L.L',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      initialData: 1.0,
                      future: getnewsumopening(lebin==''?0:double.parse(lebin),lebout==''?0:double.parse(lebout),opening)),
                ),
                Center(
                  child: FutureBuilder(
                      builder: (BuildContext context,
                          AsyncSnapshot<double> qttnumbr) {
                        return Center(
                          child: Text(
                            'Total : ${FlutterMoneyFormatter(amount: qttnumbr.data).amount} \$',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      initialData: 1.0,
                      future: getnewsumopening(dolarin==''?0:double.parse(dolarin),dolarout==''?0:double.parse(dolarout),opend)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
