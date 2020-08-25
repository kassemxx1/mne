import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:mne/MainScreen.dart';
import 'package:mne/clientsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_sms/flutter_sms.dart';

class AllClients extends StatefulWidget {
  static const String id = 'AllClient_Screen';
  @override
  _AllClientsState createState() => _AllClientsState();
}

class _AllClientsState extends State<AllClients> {
  List<trans> child = [];
  bool sort;
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        child.sort((a, b) => a.name.compareTo(b.name));
      } else {
        child.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }
//
//  void _sendSMS(String message, List<String> recipents) async {
//    await FlutterSms.sendSMS(message: message, recipients: recipents);
//  }

  void getqtt() async {
    for (var i in ClientsScreen.ListOfPhones) {
      var sum1 = 0.0;
      var url = MainScreen.url + 'getclient/${i['phonename']}';
      var response = await http.get(url);
      Map data = (json.decode(response.body));
//    sum1=double.parse(data['value']);
      if (double.parse(data['value']) != 0) {
        setState(() {
          child.add(trans(
              i['phonename'], double.parse(data['value']), i['phone'], false));
        });
      }
      child.sort((a, b) => b.sum.compareTo(a.sum));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sort = false;
    getqtt();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text(
          'Report',
          style: TextStyle(color: Colors.yellow),
        ),

//          Center(
//                  child: FutureBuilder(
//                      builder:
//                          (BuildContext context, AsyncSnapshot<
//                          double> qttnumbr) {
//                        return Center(
//                          child: Text(
//                            'All  : ${FlutterMoneyFormatter(amount: qttnumbr.data).formattedNonSymbol} ', style: TextStyle(
//                              color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
//                          ),
//                        );
//                      },
//                      initialData: 1.0,
//                      future: getall()),
//
//                ),,
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortColumnIndex: 0,
                sortAscending: sort,
                columns: [
                  DataColumn(
                    label: Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        sort = !sort;
                      });
                      onSortColum(columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Send Message',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: child
                    .map((trans) => DataRow(selected: true, cells: [
                          DataCell(
                            Text(
                              '${trans.name}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          DataCell(
                            Text(
                              FlutterMoneyFormatter(amount: trans.sum)
                                  .output
                                  .withoutFractionDigits,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          DataCell(
                            trans.isSended
                                ? Text('Message has been Sent')
                                : IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                            if (await canLaunch('sms:${trans.phone}?body=ان رصيد حسابكم لدى مؤسسة MNE Store هو : ${trans.sum}  لذلك يرجى من جميع الزبائن الكرام تسديد "كامل" حساباتهم قبل ال٥ من الشهر و شكراً لتفهمكم')) {
                                              await launch('sms:${trans
                                                  .phone}?body=ان رصيد حسابكم لدى مؤسسة MNE Store هو : ${trans
                                                  .sum}  لذلك يرجى من جميع الزبائن الكرام تسديد "كامل" حساباتهم قبل ال٥ من الشهر و شكراً لتفهمكم');
                                            }
//                                      if (Theme.of(context).platform ==
//                                          TargetPlatform.android) {
//                                        _sendSMS(
//                                            'ان رصيد حسابكم لدى مؤسسة MNE Store هو : ${trans.sum}  لذلك يرجى من جميع الزبائن الكرام تسديد "كامل" حساباتهم قبل ال٥ من الشهر و شكراً لتفهمكم ',
//                                            ['${trans.phone}']);
//                                      }
//                                      setState(() {
//                                        trans.isSended = true;
//                                      });
                                    },
                                  ),
                          ),
                        ]))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class trans {
  String name;
  double sum;
  String phone;
  bool isSended;
  trans(this.name, this.sum, this.phone, this.isSended);
}
