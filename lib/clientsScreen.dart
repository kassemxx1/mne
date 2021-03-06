import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:mne/MainScreen.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'Table_Screen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'ClientsTransactionTable.dart';
import 'All_CLients.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';


final _firestore = Firestore.instance;
var name = '';
var phonenumber = '';
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
var description = '';

class ClientsScreen extends StatefulWidget {
  static const String id = 'Clients_Screen';
  static var transaction = [];
  static var dtransaction = [];
  static var ListOfPhones = [];
  static var ListOfallClients = [];
  @override
  _ClientsScreenState createState() => new _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  TextEditingController _textEditingController5 = TextEditingController();
  TextEditingController _textEditingController6 = TextEditingController();
  String mytext = '';
  String currentText = "";
  var ListOfItems = [];
  var categorieValue = '';
  var itemValue = '';
  var listcat = ['phones', 'recharge', 'accessories'];
  var catlist = [];
  var qtt = -1.0;
  var debt = 0.0;
  var DebtAnalysis = 0.0;
  var PhoneNumber = '';
  var deb = 'select client';
  var all = '';
  var showall = '';
  bool _saving = true;
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate = DateTime(year, month, day, 0, 0, 0, 0, 0);
  var today = DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  Future delay() async {
    await new Future.delayed(new Duration(seconds: 5), () {
      setState(() {
        _saving = false;
      });
    });
  }

  void getPhonesList() async {
    ClientsScreen.ListOfPhones.clear();
    try {
      final messages =
          await _firestore.collection('nameofclients').getDocuments();
      for (var msg in messages.documents) {
        final name = msg['name'].toString();
        final phone=msg['phone'].toString();

        setState(() {
          ClientsScreen.ListOfPhones.add({
            'phonename': name,
            'phone':phone,
          });
        });
        ClientsScreen.ListOfPhones.sort((a, b) {
          return a['phonename']
              .toLowerCase()
              .compareTo(b['phonename'].toLowerCase());
        });
      }
    } catch (e) {
      print(e);
    }
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

  void getphone(String name) async {
    final messages = await _firestore
        .collection('nameofclients')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final phone = msg.data['phone'].toString();

      setState(() {
        PhoneNumber = phone;
      });
    }
  }

  void getcategories(String cat) async {
    setState(() {
      _saving = true;
    });
    ListOfItems.clear();
    if (cat == 'phones') {
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
          _saving = false;
        });
        ListOfItems.sort((a, b) {
          return a['display']
              .toLowerCase()
              .compareTo(b['display'].toLowerCase());
        });
      }
    }
    if (cat == 'accessories') {
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
          _saving = false;
        });
        ListOfItems.sort((a, b) {
          return a['display']
              .toLowerCase()
              .compareTo(b['display'].toLowerCase());
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
        _saving = false;
      });
      ListOfItems.sort((a, b) {
        return a['display'].toLowerCase().compareTo(b['display'].toLowerCase());
      });
    }
  }

  void gettransactiondate(String name) async {
    setState(() {
      _saving = true;
    });

    final messages = await _firestore
        .collection('transaction')
        .where('client', isEqualTo: name)
        .getDocuments();
    ClientsScreen.transaction.clear();
    for (var msg in messages.documents) {
      final name = msg.data['client'];
      final qtt = msg.data['qtt'];
      final debt = msg.data['debt'];
      final product = msg.data['name'];
      final time = msg.data['timestamp'] as Timestamp;
      final ttime = msg.documentID;
      final price = msg.data['price'];
      final description = msg.data['description'];
      setState(() {
        ClientsScreen.transaction.add({
          'name': name,
          'debt': debt,
          'price': price,
          'product': product,
          'time': time,
          'id': ttime,
          'description': description,
          'qtt': qtt,
        });
        _saving = false;
      });
    }
  }

  void gettransaction(DateTime start, DateTime end, String name) async {
    setState(() {
      _saving = true;
    });
    final messages = await _firestore
        .collection('transaction')
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .where('cat', isEqualTo: 'client')
        .getDocuments();
    ClientsScreen.dtransaction.clear();
    for (var msg in messages.documents) {
      final name = msg.data['name'];
      final debt = msg.data['debt'];
      final price = msg.data['price'];
      final time = msg.data['timestamp'] as Timestamp;
      final ttime = msg.documentID;
      final qt = msg.data['qtt'];
      final client = msg.data['client'];
      final description = msg.data['description'];
      setState(() {
        ClientsScreen.dtransaction.add({
          'name': name,
          'debt': debt,
          'price': price,
          'time': time,
          'id': ttime,
          'qtt': qt,
          'client': client,
          'description': description,
        });
        _saving = false;
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
          getphone(mytext);
//          getqtt(mytext);
          getdebt(mytext);
          gettransactiondate(mytext);
          gettransaction(today, tomorow, mytext);
        });
  }

  void getdebt(String name) async {
    setState(() {
      deb = '';
    });
    var url = MainScreen.url + 'getclient/$name';
    var response = await http.get(url);
    Map data = json.decode(response.body);
    print(data['value']);
    var jjj = double.parse(data['value']);
    setState(() {
      deb =
          '${FlutterMoneyFormatter(amount: jjj).output.withoutFractionDigits} L.L';
    });
  }

  void getall() async {
    setState(() {
      showall = 'yes';
    });
    var url = MainScreen.url + 'getall';
    var response = await http.get(url);
    Map data = (json.decode(response.body));
    setState(() {
      all = double.parse(data['value']).toString();
    });
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
        _saving = false;
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
//    delay();
    gettransaction(today, tomorow, mytext);
    getPhonesList();
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
                      var _validate = false;
                      return StatefulBuilder(
                          builder: (context, setState) {
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
                                      print(_validate);
                                    },
                                    decoration:
                                        InputDecoration(
                                          errorText: _validate
                                              ? 'Name already Exists'
                                              : null,
                                          hintText: 'Enter Name Of Client',
                                        ),


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
                                    for(var i in ClientsScreen.ListOfPhones){
                                      if (i==name){

                                          print(name);

                                      }
                                    }
                                    if(_validate==false){
                                    _firestore.collection('nameofclients').add({
                                    'name': name,
                                    'phone': phonenumber,
                                    });
                                    _textEditingController4.clear();
                                    _textEditingController5.clear();
                                    getclients();
                                    Navigator.of(context).pop();
                                    }
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
                    }
                      );
                    });
              })
        ],
        title: new Text(
          'Clients',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.black54,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        dismissible: true,
        child: Container(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                          style: TextStyle(fontSize: 25, color: Colors.yellow),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: deb == ''
                            ? LoadingFlipping.circle(
                                borderColor: Colors.yellow,
                                borderSize: 3.0,
                                size: 20.0,
                              )
                            : Text(
                                '${deb}',
                                style:
                                    TextStyle(fontSize: 25, color: Colors.blue),
                              ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'PhoneNumber:   $PhoneNumber',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold),
                    ),
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
                        _saving = false;
                      });
                      print(categorieValue);
                    },
                    onChanged: (value) {
                      setState(() {
                        categorieValue = value;
                        getcategories(value);
                        _saving = false;
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
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        qtt = -(double.parse(value));
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
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        debt = (double.parse(value));
                      });
                    },
                    decoration:
                        KTextFieldImputDecoration.copyWith(hintText: 'Debt'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: TextField(
                    controller: _textEditingController3,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        DebtAnalysis = (double.parse(value));
                      });
                    },
                    decoration: KTextFieldImputDecoration.copyWith(
                        hintText: 'Debt analysis'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: TextField(
                    controller: _textEditingController6,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    decoration: KTextFieldImputDecoration.copyWith(
                        hintText: 'description'),
                  ),
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      if (mytext == '') {
                      } else {
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
                                        _saving = true;
                                      });
                                      if (DebtAnalysis == 0) {
                                        if (itemValue == 'mtc\$\$\$') {
                                          if ((qtt / 10).round() > qtt / 10) {
                                            _firestore
                                                .collection('transaction')
                                                .add({
                                              'name': itemValue,
                                              'qtt': (qtt +
                                                  (((qtt / 10).round() - 1) *
                                                      0.45)),
                                              'price': 0.0,
                                              'timestamp': DateTime.now(),
                                              'currency': 'L.L',
                                              'client': mytext,
                                              'debt': debt,
                                              'cat': 'client',
                                              'description': description,
                                            });
                                            print('yes yes');
                                          } else {
                                            _firestore
                                                .collection('transaction')
                                                .add({
                                              'name': itemValue,
                                              'qtt': (qtt +
                                                  ((qtt / 10).round() * 0.45)),
                                              'price': 0.0,
                                              'timestamp': DateTime.now(),
                                              'currency': 'L.L',
                                              'client': mytext,
                                              'debt': debt,
                                              'cat': 'client',
                                              'description': description,
                                            });
                                            print('no no');
                                          }
                                        } else if (itemValue == 'alfa\$\$\$') {
                                          if ((qtt / 10).round() > qtt / 10) {
                                            _firestore
                                                .collection('transaction')
                                                .add({
                                              'name': itemValue,
                                              'qtt': (qtt +
                                                  (((qtt / 10).round() - 1) *
                                                      0.4)),
                                              'price': 0.0,
                                              'timestamp': DateTime.now(),
                                              'currency': 'L.L',
                                              'client': mytext,
                                              'debt': debt,
                                              'cat': 'client',
                                              'description': description,
                                            });
                                            print('yes yes');
                                          } else {
                                            _firestore
                                                .collection('transaction')
                                                .add({
                                              'name': itemValue,
                                              'qtt': (qtt +
                                                  ((qtt / 10).round() * 0.4)),
                                              'price': 0.0,
                                              'timestamp': DateTime.now(),
                                              'currency': 'L.L',
                                              'client': mytext,
                                              'debt': debt,
                                              'cat': 'client',
                                              'description': description,
                                            });
                                            print('no no');
                                          }
                                        } else if (itemValue == 'alfa Days') {
                                          _firestore
                                              .collection('transaction')
                                              .add({
                                            'name': 'alfa22\$',
                                            'price': 0.0,
                                            'qtt': -1.0,
                                            'timestamp': Timestamp.now(),
                                            'currency': 'L.L',
                                            'client': mytext,
                                            'debt': debt,
                                            'cat': 'client',
                                            'description': '$qtt $description',
                                          });
                                          _firestore
                                              .collection('transaction')
                                              .add({
                                            'name': 'alfa\$\$\$',
                                            'qtt': -qtt,
                                            'timestamp': Timestamp.now(),
                                          });
                                        } else if (itemValue == 'mtc Days') {
                                          _firestore
                                              .collection('transaction')
                                              .add({
                                            'name': 'mtc 22\$',
                                            'price': 0.0,
                                            'qtt': -1.0,
                                            'timestamp': Timestamp.now(),
                                            'currency': 'L.L',
                                            'client': mytext,
                                            'debt': debt,
                                            'cat': 'client',
                                            'description': '$qtt $description',
                                          });
                                          _firestore
                                              .collection('transaction')
                                              .add({
                                            'name': 'mtc\$\$\$',
                                            'qtt': -qtt,
                                            'timestamp': Timestamp.now(),
                                          });
                                        } else {
                                          _firestore
                                              .collection('transaction')
                                              .add({
                                            'name': itemValue,
                                            'price': 0.0,
                                            'qtt': qtt,
                                            'timestamp': Timestamp.now(),
                                            'currency': 'L.L',
                                            'client': mytext,
                                            'debt': debt,
                                            'cat': 'client',
                                            'description': description,
                                          });
                                        }
                                      } else {
                                        _firestore
                                            .collection('transaction')
                                            .add({
                                          'client': mytext,
                                          'price': DebtAnalysis,
                                          'timestamp': Timestamp.now(),
                                          'currency': 'L.L',
                                          'debt': 0.0,
                                          'name': 'cash',
                                          'qtt': 0.0,
                                          'cat': 'client',
                                          'description': description,
                                        });
                                      }

                                      setState(() {
                                        itemValue = '';
                                        qtt = -1.0;
                                        debt = 0.0;
                                        DebtAnalysis = 0.0;
                                        _saving = false;
                                        description = '';
                                      });

                                      _textEditingController1.clear();
                                      _textEditingController2.clear();
                                      _textEditingController3.clear();
                                      _textEditingController6.clear();
                                      gettransactiondate(mytext);
                                      gettransaction(today, tomorow, mytext);
                                      getdebt(mytext);

                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.yellow, fontSize: 30),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      gettransactiondate(mytext);
                    });
                    TableScreen.header = mytext;
                    Navigator.pushNamed(context, TableScreen.id);
                  },
                  child: Text(
                    'Client Report',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    gettransaction(today, tomorow, mytext);
                    Navigator.pushNamed(context, ClientsTransactionTable.id);
                  },
                  child: Text(
                    'Daily Report',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AllClients.id);
                    },
                    child: Text(
                      'All Clients',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white.withOpacity(0.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Text(
                        'Transaction Report',
                        style: TextStyle(color: Colors.black54),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('start Date:'),
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

                                          print(startDate);
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
                                            color: Colors.yellow, fontSize: 10),
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('End Date:'),
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
                                            color: Colors.yellow, fontSize: 10),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          gettransaction(startDate, endDate, mytext);
                          Navigator.pushNamed(
                              context, ClientsTransactionTable.id);
                        },
                        child: Text(
                          'Transaction',
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
                showall == ''
                    ? FlatButton(
                        onPressed: () {
                          getall();
                        },
                        child: Text(
                          'get the Sum of Debts',
                          style: TextStyle(color: Colors.yellow, fontSize: 25),
                        ),
                      )
                    : all == ''
                        ? LoadingFlipping.circle(
                            borderColor: Colors.yellow,
                            borderSize: 3.0,
                            size: 20.0,
                            duration: Duration(hours: 1),
                          )
                        : Center(
                            child: Text(
                            'Sum = ${all.toString()}',
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 25),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
