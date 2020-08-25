import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'clientsScreen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

final _firestore = Firestore.instance;

class ClientsTransactionTable extends StatefulWidget {
  static const String id = 'ClientsTransaction_table';
  static String header;

  @override
  _ClientsTransactionTableState createState() => _ClientsTransactionTableState();
}

class _ClientsTransactionTableState extends State<ClientsTransactionTable> {
  List<trans> child = [];
  bool sort;
  void getrow() {
    for (var index = 0; index < ClientsScreen.dtransaction.length; index++) {
      setState(() {
        child.add(trans(
            ClientsScreen.dtransaction[index]['client'].toString(),
            ClientsScreen.dtransaction[index]['qtt'],
            ClientsScreen.dtransaction[index]['id'].toString(),
            ClientsScreen.dtransaction[index]['time'].toDate(),
            ClientsScreen.dtransaction[index]['debt'],
            ClientsScreen.dtransaction[index]['name'].toString(),
            ClientsScreen.dtransaction[index]['price'],
            ClientsScreen.dtransaction[index]['description']));
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
          'Report',
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
                    'name',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
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
                        '${trans.name}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,fontSize: 16),
                      ),
                    ),
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
                    DataCell(Text('${-trans.qtt}',
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
//                                            await _firestore
//                                                .collection('transaction')
//                                                .document('${trans.id}')
//                                                .delete();
//                                            Navigator.of(context).pop();
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
