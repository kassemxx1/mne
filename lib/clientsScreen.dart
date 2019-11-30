import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
final _firestore = Firestore.instance;
var name = '';
var phonenumber = '';
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;

class ClientsScreen extends StatefulWidget {
  static const String id = 'Clients_Screen';
  @override
  _ClientsScreenState createState() => new _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  var transaction = [];
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  TextEditingController _textEditingController5 = TextEditingController();
  String mytext = '';
  String currentText = "";
  var ListOfItems = [];
  var categorieValue = '';
  var itemValue = '';
  var listcat = ['phones', 'recharge', 'accessories'];
  var catlist = [];
  var qtt = 1.0;
  var debt = 0.0;
  var DebtAnalysis = 0.0;
  bool _saving=true;
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var today =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  Future delay() async{
    await new Future.delayed(new Duration(seconds: 5), ()
    {
      setState(() {
        _saving=false;
      });

    });
  }

  void getcat() {
    catlist.clear();
    for (var i in listcat) {
      catlist.add({
        'display': i,
        'value': i,
      });
    }
  }

  void getcategories(String cat) async {
    setState(() {
      _saving=true;
    });
    ListOfItems.clear();
    if(cat=='phones'){
      final Messages = await _firestore
          .collection('tele')
          .where('categories', isEqualTo: cat)
          .getDocuments();
      for (var msg in Messages.documents) {
        final name = msg.data['phonename'].toString();
        setState(() {
          ListOfItems.add({
            'display': '$name',
            'value': '$name',
          });
          _saving=false;
        });
      }
    }
    if(cat=='accessories'){
      final Messages = await _firestore
          .collection('accessories')
          .where('categories', isEqualTo: cat)
          .getDocuments();
      for (var msg in Messages.documents) {
        final name = msg.data['phonename'].toString();
        setState(() {
          ListOfItems.add({
            'display': '$name',
            'value': '$name',
          });
          _saving=false;
        });
      }
    }
    final Messages = await _firestore
        .collection('phones')
        .where('categories', isEqualTo: cat)
        .getDocuments();
    for (var msg in Messages.documents) {
      final name = msg.data['phonename'].toString();
      setState(() {
        ListOfItems.add({
          'display': '$name',
          'value': '$name',
        });
        _saving=false;
      });
    }
  }

  void gettransactiondate(String name) async {
    setState(() {
      _saving=true;
    });
    final messages = await _firestore
        .collection('clients')
        .where('name', isEqualTo: name)
        .getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final name =msg.data['name'];
      final debt = msg.data['debt'];
      final den = msg.data['den'];
      final product = msg.data['product'];
      final time = msg.data['timestamp'] as Timestamp;
      final ttime = msg.documentID;
      setState(() {
        transaction.add({
          'name':name,
          'debt': debt,
          'den': den,
          'product': product,
          'time': time,
          'id': ttime,
        });
        _saving=false;
      });
    }
  }
  void gettransaction(DateTime start,DateTime end) async {
    setState(() {
      _saving=true;
    });
    final messages = await _firestore
        .collection('clients').where('timestamp',isGreaterThan: start).where('timestamp',isLessThan: end)
        .getDocuments();
    transaction.clear();
    for (var msg in messages.documents) {
      final name =msg.data['name'];
      final debt = msg.data['debt'];
      final den = msg.data['den'];
      final product = msg.data['product'];
      final time = msg.data['timestamp'] as Timestamp;
      final ttime = msg.documentID;
      setState(() {
        transaction.add({
          'name':name,
          'debt': debt,
          'den': den,
          'product': product,
          'time': time,
          'id': ttime,
        });
        _saving=false;
      });
    }
  }

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  _ClientsScreenState() {
    textField = SimpleAutoCompleteTextField(
        key: key,
        controller: TextEditingController(text: mytext),
        suggestions: suggestions,
        textChanged: (text) => currentText = text,
        submitOnSuggestionTap: true,
        textSubmitted: (text) {
          setState(() {
            mytext = text;
          });
          getqtt(mytext);
          gettransactiondate(mytext);
        });
  }
  Future<double> getqtt(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('clients')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['debt'];
      final den = msg['den'];
      qtts.add(qtt.toDouble());
      qtts.add(den.toDouble());
    }
    setState(() {
      _saving=false;
    });

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result.toDouble());
  }

  List<String> suggestions = [];
  void getclients() async {
    suggestions.clear();
    final messages =
        await _firestore.collection('nameofclients').getDocuments();
    for (var msg in messages.documents) {
      final nn = msg.data['name'].toString();
      final pp = msg.data['phonenumber'];
      setState(() {
        suggestions.add(nn);
        _saving=false;
      });
    }
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcat();
    getclients();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                child: TextField(
                                  controller: _textEditingController4,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                  decoration:
                                      KTextFieldImputDecoration.copyWith(
                                          hintText: 'Enter Name Of Client'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                child: TextField(
                                  controller: _textEditingController5,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      phonenumber = value;

                                    });
                                  },
                                  decoration:
                                      KTextFieldImputDecoration.copyWith(
                                          hintText:
                                              'Enter PhoneNumber Of Client'),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _firestore.collection('nameofclients').add({
                                    'name': name,
                                    'phone': phonenumber,
                                  });
                                  _textEditingController4.clear();
                                  _textEditingController5.clear();
                                  getclients();
                                },
                                child: Text(
                                  'Send',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              })
        ],
        title: new Text(
          'Clients',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        dismissible: true,
        child: ListView(
          children: <Widget>[
            textField,
            Center(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      mytext,
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<double> qttnumbr) {
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Debt:',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ),
                                Text(
                                  '${qttnumbr.data.round()}',
                                  style:
                                      TextStyle(fontSize: 25, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                        initialData: 0.0,
                        future: getqtt(mytext)),
                  ),
                ],
              ),
            ),
            Container(
              child: DropDownFormField(
                titleText: 'Select Categorie',
                hintText: 'Please choose one',
                value: categorieValue,
                onSaved: (value) {
                  setState(() {
                    categorieValue = value;
                    getcategories(value);
                    _saving=false;
                  });
                  print(categorieValue);
                },
                onChanged: (value) {
                  setState(() {
                    categorieValue = value;
                    getcategories(value);
                    _saving=false;
                  });
                },
                dataSource: catlist,
                textField: 'display',
                valueField: 'value',
              ),
            ),
            Container(
              child: DropDownFormField(
                titleText: 'Select Item',
                hintText: 'Please choose one',
                value: itemValue,
                onSaved: (value) {
                  setState(() {
                    itemValue = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    itemValue = value;
                  });
                },
                dataSource: ListOfItems,
                textField: 'display',
                valueField: 'value',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: TextField(
                controller: _textEditingController1,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    qtt = (double.parse(value));
                  });
                },
                decoration: KTextFieldImputDecoration.copyWith(
                    hintText: 'Enter Your Qtt'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: TextField(
                controller: _textEditingController2,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    debt = (double.parse(value));
                  });
                },
                decoration: KTextFieldImputDecoration.copyWith(hintText: 'Debt'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: TextField(
                controller: _textEditingController3,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    DebtAnalysis = (double.parse(value));
                  });
                },
                decoration:
                    KTextFieldImputDecoration.copyWith(hintText: 'Debt analysis'),
              ),
            ),
            Center(
              child: MaterialButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are You Sure?'),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('cancel'),
                            ),
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  _saving=true;
                                });
                                if(DebtAnalysis==0){
                                  _firestore.collection('clients').add({
                                    'name': mytext,
                                    'product': itemValue,
                                    'qtt': qtt,
                                    'debt': debt,
                                    'den': -DebtAnalysis,
                                    'timestamp': Timestamp.now(),
                                    'currnecy': 'L.L',
                                  });
                                  _firestore.collection('transaction').add({
                                    'name': mytext,
                                    'price': 0,
                                    'qtt': qtt,
                                    'timestamp': Timestamp.now(),
                                    'currnecy': 'L.L',
                                  });
                                }
                                else{
                                  _firestore.collection('clients').add({
                                    'name': mytext,
                                    'product': itemValue,
                                    'qtt': qtt,
                                    'debt': debt,
                                    'den': -DebtAnalysis,
                                    'timestamp': Timestamp.now(),
                                    'currnecy': 'L.L',
                                  });

                                }


                                setState(() {
                                  qtt = 1.0;
                                  debt = 0.0;
                                  DebtAnalysis = 0.0;
                                  _saving=false;
                                });

                                _textEditingController1.clear();
                                _textEditingController2.clear();
                                _textEditingController3.clear();

                                Navigator.of(context).pop();
                                gettransactiondate(mytext);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.blue, fontSize: 30),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                gettransactiondate(mytext);
                print(transaction);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        content: Scaffold(
                          appBar: AppBar(
                            title: Text(
                              mytext.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          body: Container(
                            child: new ListView.builder(
                                itemCount: transaction.length,
                                itemBuilder: (BuildContext cntxt, int index) {
                                  return Dismissible(
                                    background: Material(
                                      color: Colors.red,
                                    ),
                                    onDismissed:
                                        (DismissDirection direction) async {
//                                    await _firestore.collection('messages').getDocuments().then((snapshot) {
//                                      for (DocumentSnapshot ds in snapshot.documents){
//                                        ds.reference.delete();
//                                      });
//                                    }

                                      await _firestore
                                          .collection('clients')
                                          .document('${transaction[index]['id']}')
                                          .delete();
                                      gettransactiondate(mytext);
                                      transaction.remove(transaction[index]);
                                    },
                                    key: Key(transaction[index].toString()),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                          '${formatDate(DateTime.parse(transaction[index]['time'].toDate().toString()), [
                                            yyyy,
                                            '-',
                                            mm,
                                            '-',
                                            dd
                                          ])}',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                        subtitle: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['debt'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['den']}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['product'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                        fontSize: 10),
                                                  ),
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
                'Client Report',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  gettransaction(today,tomorow);
                });

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0))),
                        content: Scaffold(

                          body: Container(
                            child: new ListView.builder(
                                itemCount: transaction.length,
                                itemBuilder: (BuildContext cntxt, int index) {
                                  return Dismissible(
                                    background: Material(
                                      color: Colors.red,
                                    ),
                                    onDismissed:
                                        (DismissDirection direction) async {
//                                    await _firestore.collection('messages').getDocuments().then((snapshot) {
//                                      for (DocumentSnapshot ds in snapshot.documents){
//                                        ds.reference.delete();
//                                      });
//                                    }

                                      await _firestore
                                          .collection('clients')
                                          .document('${transaction[index]['id']}')
                                          .delete();
                                      gettransaction(today,tomorow);
                                      transaction.remove(transaction[index]);
                                    },
                                    key: Key(transaction[index].toString()),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                          transaction[index]['name'],
                                        ),
                                        subtitle: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['debt'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['den']}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['product'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                        fontSize: 10),
                                                  ),
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
                'Daily Report',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                              style: TextStyle(color: Colors.blue,fontSize: 11),
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
                              style: TextStyle(color: Colors.blue,fontSize: 11),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  gettransaction(startDate,endDate);
                });

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0))),
                        content: Scaffold(

                          body: Container(
                            child: new ListView.builder(
                                itemCount: transaction.length,
                                itemBuilder: (BuildContext cntxt, int index) {
                                  return Dismissible(
                                    background: Material(
                                      color: Colors.red,
                                    ),
                                    onDismissed:
                                        (DismissDirection direction) async {
//                                    await _firestore.collection('messages').getDocuments().then((snapshot) {
//                                      for (DocumentSnapshot ds in snapshot.documents){
//                                        ds.reference.delete();
//                                      });
//                                    }

                                      await _firestore
                                          .collection('clients')
                                          .document('${transaction[index]['id']}')
                                          .delete();
                                      gettransaction(today,tomorow);
                                      transaction.remove(transaction[index]);
                                    },
                                    key: Key(transaction[index].toString()),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                          '${transaction[index]['name']}  ${formatDate(DateTime.parse(transaction[index]['time'].toDate().toString()), [yyyy, '-', mm, '-', dd])}',style: TextStyle(color: Colors.grey,fontSize: 12),
                                        ),
                                        subtitle: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['debt'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                width: 70,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['den']}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${transaction[index]['product'].toString()}',
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                        fontSize: 10),
                                                  ),
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
                'Transaction',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
