import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:date_format/date_format.dart';
import 'package:mne/ReportsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
class MaintenaceTable extends StatefulWidget {
  static const String id = 'MaintenaceTable';
  @override
  _MaintenaceTableState createState() => _MaintenaceTableState();
}

class _MaintenaceTableState extends State<MaintenaceTable> {

  List<trans> child = [];
  bool sort;

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        child.sort((a, b) => a.Date.compareTo(a.Date));
      } else {
        child.sort((a, b) => b.Date.compareTo(a.Date));
      }
    }
  }

  void getrow() {
    for (var index = 0; index < ReportsScreen.Mtransaction.length; index++) {
      setState(() {
        child.add(trans(
          ReportsScreen.Mtransaction[index]['time'].toDate(),
          ReportsScreen.Mtransaction[index]['price'],
          ReportsScreen.Mtransaction[index]['description'],
          ReportsScreen.Mtransaction[index]['id'].toString(),

        ));
      });
    }
    print('kassem kassem ${child.length}');
  }
  @override
  void initState() {
    // TODO: implement initState
    getrow();
    sort = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text(
          'Maintenance report',
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
                      'Description',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'Amount',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                DataColumn(
                    label: Text(
                      'Delete',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),

              ],
              rows: child
                  .map((trans) => DataRow(

                  selected: true,
                  cells: [
                    DataCell(
                      Text(
                        '${formatDate(DateTime.parse(trans.Date.toString()), [
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
                        '${trans.description}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text('${FlutterMoneyFormatter(amount: trans.amount).output.nonSymbol}',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold))),
                    DataCell(
                      IconButton(icon: Icon(Icons.delete),onPressed: (){

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
                                            .collection('others')
                                            .document('${trans.id}')
                                            .delete();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      }),
                                ],
                              );
                            });


                      },)
                    ),

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
  DateTime Date;
  String description;
  double amount;
  String id;


  trans(this.Date,this.amount,this.description,this.id);
}