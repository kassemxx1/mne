import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'Rounded_Button.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
final _firestore = Firestore.instance;
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
var out = 0.0;
var IN = 0.0;
var opening=0.0;
var currency = 'L.L.';

TextEditingController _textEditingController1 = TextEditingController();
TextEditingController _textEditingController2 = TextEditingController();
TextEditingController _textEditingController3 = TextEditingController();



class OMTScreen extends StatefulWidget {
  static const String id = 'OMT_Screen';
  @override
  _OMTScreenState createState() => _OMTScreenState();
}

class _OMTScreenState extends State<OMTScreen> {
  var transaction = [];
  var startDate = DateTime(
      year,
      month,
      day,
      0,
      0,
      0,
      0,
      0);
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);




    void getopen() async {
      final messages = await _firestore.collection('oppening').getDocuments();
      for (var msg in messages.documents) {
        setState(() {
          opening = msg.data['openning'];
        });
      }
    }

    void gettransaction() async {
      final messages = await _firestore.collection('omt').where(
          'timestamp', isGreaterThan: startDate).getDocuments();
      transaction.clear();
      for (var msg in messages.documents) {
        final IIN = msg.data['in'];
        final oout = msg.data['out'];
        final ccurency = msg.data['currency'];
        final ttime = msg.documentID;
        setState(() {
          transaction.add({
            'in': IIN,
            'out': oout,
            'curency': ccurency,
            'id': ttime
          });
          print(transaction);
        });
      }
    }
  void gettransactiondate(DateTime start, DateTime end) async {
    final messages = await _firestore.collection('omt').where(
        'timestamp', isGreaterThan: start).where('timestamp',isLessThan: end).getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final IIN = msg.data['in'];
      final oout = msg.data['out'];
      final ccurency = msg.data['currency'];
      final ttime = msg.documentID;
      setState(() {
        transaction.add({
          'in': IIN,
          'out': oout,
          'curency': ccurency,
          'id': ttime
        });
        print(transaction);
      });
    }
  }

    Future<double> getqtt(String name, DateTime today, String currencyy) async {
      var qtts = [0.0];

      final messages = await _firestore
          .collection('omt').where('currency', isEqualTo: currencyy)
          .where('timestamp', isGreaterThan: today)
          .getDocuments();
      for (var msg in messages.documents) {
        final qtt = msg[name];
        setState(() {
          qtts.add(qtt);
        });
      }

      var result = qtts.reduce((sum, element) => sum + element);
      return new Future(() => result);
    }
    Future<double> getsum(DateTime today, String currencyy) async {
      var qtts = [0.0];

      final messages = await _firestore
          .collection('omt').where('currency', isEqualTo: currencyy)
          .where('timestamp', isGreaterThan: today)
          .getDocuments();
      for (var msg in messages.documents) {
        final iin = msg['in'];
        final outt = -msg['out'];
        setState(() {
          qtts.add(iin);
          qtts.add(outt);
        });
      }

      var result = qtts.reduce((sum, element) => sum + element);
      return new Future(() => result);
    }
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getopen();
      gettransaction();
      print(transaction);
    }
    @override
    Widget build(BuildContext context) {
      var open = 0.0;


      return Scaffold(
        resizeToAvoidBottomPadding: false,

        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

          title: Text(
            'OMT', style: TextStyle(color: Colors.black, fontSize: 30),),
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Enter Opening Balance'),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 10),
                                    child: new TextField(

                                      controller: _textEditingController3,
                                      decoration: KTextFieldImputDecoration
                                          .copyWith(
                                          hintText: 'Opening Balance'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) async {
                                        setState(() {
                                          open = double.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      _firestore.collection('oppening')
                                          .document('open')
                                          .updateData({
                                        'openning': open,
                                      });
                                      _textEditingController3.clear();
                                      Navigator.of(context).pop();
                                      getopen();
                                    },
                                    child: Text('Done'),
                                  ),

                                ],
                              ),

                            );
                          }
                      );
                    },
                    child: Text('Enter Opening Balance', style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20,),),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Opening Balance =  ',
                      style: TextStyle(color: Colors.black,),),
                    Text('$opening',
                      style: TextStyle(color: Colors.green, fontSize: 20),),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomRadioButton(
                    buttonColor: Theme
                        .of(context)
                        .canvasColor,
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
                    selectedColor: Theme
                        .of(context)
                        .accentColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: new TextField(
                    controller: _textEditingController1,
                    decoration: KTextFieldImputDecoration.copyWith(
                        hintText: 'IN'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        IN = double.parse(value);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
                  child: new TextField(
                    decoration: KTextFieldImputDecoration.copyWith(
                        hintText: 'Out'),
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
                RoundedButton(
                  title: 'Send',
                  colour: Colors.blueAccent,

                  onPressed: () async {
                    await _firestore.collection('omt').add({
                      'in': IN,
                      'out': out,
                      'timestamp': Timestamp.now(),
                      'currency': currency,
                    });
                    _textEditingController1.clear();
                    _textEditingController2.clear();
                    setState(() {
                      out = 0.0;
                      IN = 0.0;
                    });
                    getqtt('in', startDate, 'L.L.');
                    getqtt('in', startDate, '\$');
                    gettransaction();
                    FocusScope.of(context).unfocus();
                  },

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          builder:
                              (BuildContext context, AsyncSnapshot<
                              double> qttnumbr) {
                            return Center(
                              child: Text(
                                'In  : ${qttnumbr.data.round()} L.L',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                            );
                          },
                          initialData: 1.0,
                          future: getqtt('in', startDate, 'L.L.')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          builder:
                              (BuildContext context, AsyncSnapshot<
                              double> qttnumbr) {
                            return Center(
                              child: Text(
                                'Out  : ${qttnumbr.data.round()} L.L',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 18),
                              ),
                            );
                          },
                          initialData: 1.0,
                          future: getqtt('out', startDate, 'L.L.')),
                    ),
                  ],
                ),

                FutureBuilder(
                    builder:
                        (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Text(
                          'Tolal  : ${qttnumbr.data.round() } L.L',
                          style: TextStyle(color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      );
                    },
                    initialData: 1.0,
                    future: getsum(startDate, 'L.L.')),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          builder:
                              (BuildContext context, AsyncSnapshot<
                              double> qttnumbr) {
                            return Center(
                              child: Text(
                                'In  : ${qttnumbr.data} \$', style: TextStyle(
                                  color: Colors.green, fontSize: 18),
                              ),
                            );
                          },
                          initialData: 1.0,
                          future: getqtt('in', startDate, '\$')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          builder:
                              (BuildContext context, AsyncSnapshot<
                              double> qttnumbr) {
                            return Center(
                              child: Text(
                                'Out  : ${qttnumbr.data} \$', style: TextStyle(
                                  color: Colors.red, fontSize: 18),
                              ),
                            );
                          },
                          initialData: 1.0,
                          future: getqtt('out', startDate, '\$')),
                    ),
                  ],
                ),

                FutureBuilder(
                    builder:
                        (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                      return Center(
                        child: Text(
                          'Tolal  : ${qttnumbr.data} \$',
                          style: TextStyle(color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      );
                    },
                    initialData: 1.0,
                    future: getsum(startDate, '\$')),
                MaterialButton(
                  onPressed: () {
                    gettransaction();
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
                                          await _firestore.collection('omt')
                                              .document(
                                              '${transaction[index]['id']}')
                                              .delete();
                                          gettransaction();
                                          transaction.remove(
                                              transaction[index]);
                                        },
                                        key: Key(transaction[index].toString()),

                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  '${transaction[index]['in']
                                                      .toString()}',
                                                  style: TextStyle(
                                                      color: Colors.green),),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              width: 85,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              width: 85,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  '${transaction[index]['out']
                                                      .toString()}',
                                                  style: TextStyle(
                                                      color: Colors.red),),
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
                                                      .blueAccent),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),

                          );
                        }
                    );
                  },
                  child: Text('Daily Report', style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),

                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: <Widget>[
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
                      ],
                    ),
                  ),
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
                                          await _firestore.collection('omt')
                                              .document(
                                              '${transaction[index]['id']}')
                                              .delete();
                                          gettransaction();
                                          transaction.remove(
                                              transaction[index]);
                                        },
                                        key: Key(transaction[index].toString()),

                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  '${transaction[index]['in']
                                                      .toString()}',
                                                  style: TextStyle(
                                                      color: Colors.green),),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              width: 85,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              width: 85,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  '${transaction[index]['out']
                                                      .toString()}',
                                                  style: TextStyle(
                                                      color: Colors.red),),
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
                                                      .blueAccent),),
                                              ),
                                            ),
                                          ],
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
          ),
        ),
      );
    }
  }

