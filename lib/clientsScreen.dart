import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'constants.dart';

final _firestore = Firestore.instance;

class ClientsScreen extends StatefulWidget {
  static const String id = 'Clients_Screen';
  @override
  _ClientsScreenState createState() => new _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3= TextEditingController();
  String mytext = '';
  String currentText = "";
  var ListOfItems = [];
  var categorieValue = '';
  var itemValue = '';
  var listcat = ['phones', 'recharge', 'accessories'];
  var catlist = [];
  var qtt = 0.0;
  var debt = 0.0;
  var DebtAnalysis=0.0;

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
    ListOfItems.clear();
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
      }

    );
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

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result.toDouble());
  }

  List<String> suggestions = [
    "Apple",
    "Armidillo",
    "Actual",
    "Actuary",
    "America",
    "Argentina",
    "Australia",
    "Antarctica",
    "Blueberry",
    "Cheese",
    "Danish",
    "Eclair",
    "Fudge",
    "Granola",
    "Hazelnut",
    "Ice Cream",
    "Jely",
    "Kiwi Fruit",
    "Lamb",
    "Macadamia",
    "Nachos",
    "Oatmeal",
    "Palm Oil",
    "Quail",
    "Rabbit",
    "Salad",
    "T-Bone Steak",
    "Urid Dal",
    "Vanilla",
    "Waffles",
    "Yam",
    "Zest"
  ];

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcat();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('AutoComplete TextField Demo Simple'),
      ),
      body: Column(
        children: <Widget>[
          textField,
          Row(
            children: <Widget>[
              Text(mytext),
              FutureBuilder(
                  builder: (BuildContext context,
                      AsyncSnapshot<double> qttnumbr) {
                    return Center(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Debt:'),
                          Text(
                            '${qttnumbr.data}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    );
                  },
                  initialData: 0.0,
                  future:
                  getqtt(mytext)),
            ],
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
                });
                print(categorieValue);
              },
              onChanged: (value) {
                setState(() {
                  categorieValue = value;
                  getcategories(value);
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
              decoration: KTextFieldImputDecoration.copyWith(
                  hintText: 'Debt'),
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
              decoration: KTextFieldImputDecoration.copyWith(
                  hintText: 'Debt analysis'),
            ),
          ),
          Center(
            child: MaterialButton(onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Are You Sure?'),
                      actions: <Widget>[
                        MaterialButton(onPressed: () {
                          Navigator.of(context).pop();
                        },
                          child: Text('cancel'),
                        ),
                        MaterialButton(onPressed: () {

                          _firestore.collection('clients').add({
                            'name':mytext,
                            'product':itemValue,
                            'qtt':qtt,
                            'debt':debt,
                            'den':-DebtAnalysis,

                          });
                          setState(() {
                            qtt=0.0;
                            debt=0.0;
                            DebtAnalysis=0.0;
                          });


                          _textEditingController1.clear();
                          _textEditingController2.clear();
                          _textEditingController3.clear();




                          Navigator.of(context).pop();
                        },
                          child: Text('Yes'),
                        ),

                      ],
                    );

                  }
                );

            },
            child: Text('Send',style: TextStyle(color: Colors.blue,fontSize: 30),),

            ),
          ),


        ],
      ),
    );
  }
}
