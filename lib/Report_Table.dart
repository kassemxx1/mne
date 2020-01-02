import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'clientsScreen.dart';
import 'package:date_format/date_format.dart';
import 'ReportsScreen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

final _firestore = Firestore.instance;

class ReportTable extends StatefulWidget {
  static const String id = 'report_Table';
  static String header;

  @override
  _ReportTableState createState() => _ReportTableState();
}

class _ReportTableState extends State<ReportTable> {
  List<trans> child = [];
  bool sort;
  void getrow() {
    for (var index = 0; index < ReportsScreen.transaction.length; index++) {
      setState(() {
        child.add(trans(
            ReportsScreen.transaction[index]['name'].toString(),
            ReportsScreen.transaction[index]['qtt'],
            ReportsScreen.transaction[index]['id'].toString(),
            ReportsScreen.transaction[index]['time'].toDate(),
            ReportsScreen.transaction[index]['price'],
            ReportsScreen.transaction[index]['curency'],
            ReportsScreen.transaction[index]['client'],
        ));
      });
    }

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
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                      'Price',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'currency',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'Client',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      '#',
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
                    DataCell(
                      Text(
                      '${formatDate(DateTime.parse(trans.time.toString()), [
                        yyyy,
                        '-',
                        mm,
                        '-',
                        dd,
                        '   ',
                        hh,
                        ':',
                        nn
                      ])}',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                    ),

                    ),
                    DataCell(
                      Text(
                        '${trans.name}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text('${-trans.qtt}',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold))),
                    DataCell(Text(trans.Price!=null?'${trans.Price}':'\$ for You',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold))),
                    DataCell(trans.curremcy!=null?Text('${trans.curremcy}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)):Text('🤪',style: TextStyle(fontSize: 25),)),
                    DataCell(Text(trans.client!=null?'${trans.client}':'---',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,fontSize: 18))),
                    DataCell(
                        IconButton(icon: Icon(Icons.delete,color: Colors.red,),
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


class trans {
  DateTime time;
  double Price;
  String curremcy;
  String name;
  String id;
  double qtt;
  String client;
  trans(this.name,this.qtt, this.id, this.time, this.Price,
      this.curremcy,this.client);
}
