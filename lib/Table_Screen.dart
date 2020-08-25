import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'clientsScreen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
final _firestore = Firestore.instance;

class TableScreen extends StatefulWidget {
  static const String id = 'Table_Screen';
  static String header;

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List<trans> child = [];
  bool sort;
  void getrow() {
    for (var index = 0; index < ClientsScreen.transaction.length; index++) {
      setState(() {
        child.add(trans(
            ClientsScreen.transaction[index]['name'].toString(),
            ClientsScreen.transaction[index]['qtt'],
            ClientsScreen.transaction[index]['id'].toString(),
            ClientsScreen.transaction[index]['time'].toDate(),
            ClientsScreen.transaction[index]['debt'],
            ClientsScreen.transaction[index]['product'],
            ClientsScreen.transaction[index]['price'],
            ClientsScreen.transaction[index]['description']));
      });
    }
    print('kassem kassem ${child.length}');
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        child.sort((a, b) => a.time.compareTo(a.time));
      } else {
        child.sort((a, b) => b.time.compareTo(a.time));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sort = false;
    getrow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text(
          TableScreen.header,
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: 0,
              sortAscending: sort,
              columns: [
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    'Debt',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                    label: Text(
                  'Debt analysis',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Item',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                      'QTT',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                  'Description',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  'Action',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
              ],
              rows: child
                  .map((trans) => DataRow(

//                            showDialog(
//                                context: context,
//                                builder: (BuildContext context) {
//                                  return AlertDialog(
//                                    title: Text('Are You Sure to Delete?'),
//                                    actions: <Widget>[
//                                      MaterialButton(
//                                        child: Text('Cancel'),
//                                        onPressed: () {
//                                          Navigator.of(context).pop();
//                                        },
//                                      ),
//                                      MaterialButton(
//                                          child: Text('Yes'),
//                                          onPressed: () async {
//                                            await _firestore
//                                                .collection('transaction')
//                                                .document('${trans.id}')
//                                                .delete();
//                                          }),
//                                    ],
//                                  );
//                                });

                          selected: true,
                          cells: [
                            DataCell(Text(
                              '${formatDate(DateTime.parse(trans.time.toString()), [
                                yyyy,
                                '-',
                                mm,
                                '-',
                                dd
                              ])}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(
                              Text(
                                  '${FlutterMoneyFormatter(amount: trans.Debt).output.withoutFractionDigits}',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(Text('${FlutterMoneyFormatter(amount: trans.Price).output.withoutFractionDigits}',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('${trans.Product}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('${trans.qtt}',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('${trans.Description}',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                             IconButton(icon: Icon(Icons.delete,color: Colors.blue,),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Are You Sure to Delete?'),
                                        actions: <Widget>[
                                          MaterialButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          MaterialButton(
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                await _firestore
                                                    .collection('transaction')
                                                    .document('${trans.id}')
                                                    .delete();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    });
                              },
                            )),
                          ]))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

//
//DataCell(Text(
//'${formatDate(DateTime.parse(ClientsScreen.transaction[index]['time'].toDate().toString()), [
//yyyy,
//'-',
//mm,
//'-',
//dd
//])}',
//style: TextStyle(color: Colors.grey, fontSize: 12),
//)),
//DataCell(Text('${
//ClientsScreen.transaction[index]['debt'].toString()}',
//style: TextStyle(
//color: Colors.green,
//fontSize: 10),)),
//DataCell(Text('${ClientsScreen.transaction[index]['price'].toString()}'
//)),
//DataCell(Text('${ClientsScreen.transaction[index]['product'].toString()}',
//style: TextStyle(
//color: Colors.blueAccent,
//fontSize: 10),)),
//DataCell(Text('${ClientsScreen.transaction[index]['description']}',
//style: TextStyle(
//color: Colors.green,
//fontSize: 10),)),
class trans {
  DateTime time;
  double Debt;
  double Price;
  String Product;
  String Description;
  String name;
  String id;
  double qtt;
  trans(this.name,this.qtt, this.id, this.time, this.Debt, this.Product, this.Price,
      this.Description);
}
