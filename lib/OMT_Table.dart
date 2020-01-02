import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'OMTScreen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

final _firestore = Firestore.instance;

class OmtTable extends StatefulWidget {
  static const String id = 'OMT_Table';
  static String header;

  @override
  _OmtTableState createState() => _OmtTableState();
}

class _OmtTableState extends State<OmtTable> {
  List<trans> child = [];
  bool sort;
  void getrow() {
    for (var index = 0; index < OMTScreen.transaction.length; index++) {
      setState(() {
        child.add(trans(
          OMTScreen.transaction[index]['in'],
          OMTScreen.transaction[index]['out'],
          OMTScreen.transaction[index]['curency'].toString(),
          OMTScreen.transaction[index]['id'].toString(),
          OMTScreen.transaction[index]['time'].toDate(),
        ));
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
                      'IN',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'OUT',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),

                DataColumn(
                    label: Text(
                      'currency',
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
                          dd
                        ])}',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                      ),

                    ),
                    DataCell(
                      Text(
                        '${FlutterMoneyFormatter(amount: trans.IN).formattedNonSymbol}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text('${FlutterMoneyFormatter(amount: trans.OUT).formattedNonSymbol}',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold))),

                    DataCell(Text('${trans.currency}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold))),
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
                                                .document('${trans.ID}')
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
  double IN;
  double OUT;
  String currency;
  String ID;
   DateTime time;

  trans(this.IN,this.OUT, this.currency,this.ID,this.time);
}
