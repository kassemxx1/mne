import 'package:flutter/material.dart';
import 'package:mne/clientsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
class AllClients extends StatefulWidget {
  static const String id = 'AllClient_Screen';
  @override
  _AllClientsState createState() => _AllClientsState();
}

class _AllClientsState extends State<AllClients> {

  List<trans> child = [];
  void getrow() {
    for (var index = 0; index < ClientsScreen.ListOfPhones.length; index++) {
      setState(() {
        child.add(trans(
          ClientsScreen.ListOfPhones[index]['phonename'].toString(),


        ));
      });
    }

  }



  Future<double> getqtt(String name) async {
    var qtts = [0.0];

    final messages = await _firestore
        .collection('transaction')
        .where('cat', isEqualTo: 'client')
        .where('client', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['debt'];
      final den = msg['price'];
      qtts.add(qtt.toDouble());
      qtts.add(-den.toDouble());
    }


    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result.toDouble());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getrow();
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
          backgroundColor: Colors.black54,
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(

                columns: [

                  DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                  DataColumn(
                      label: Text(
                        'Price',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                ],
                rows: child
                    .map((trans) => DataRow(

                    selected: true,
                    cells: [

                      DataCell(
                        Text(
                          '${trans.name}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                      DataCell(
                          FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> qttnumbr) {
                                return Center(
                                  child: Text(
                                    '${qttnumbr.data.round()}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red),
                                  ),
                                );
                              },
                              initialData: 0.0,
                              future:
                              getqtt(trans.name))
                      ),
                    ]))
                    .toList(),
              ),
            ),
          ),
        ),
      )
    );
  }
}


class trans {
  String name;
  trans(this.name);
}