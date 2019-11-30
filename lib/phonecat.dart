import 'package:flutter/material.dart';
import 'PhoneList.dart';

class phonecat extends StatefulWidget {
  static const String id='phone_cat';
  @override
  _phonecatState createState() => _phonecatState();
}

class _phonecatState extends State<phonecat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Categories',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,


                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      child: Container(
                        color: Colors.white,
                        child: Center(child: Text('Apple',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          PhonesList.subcat='Apple';
                        });
                        Navigator.pushNamed(context, PhonesList.id);
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      child: Container(
                        color: Colors.white,
                        child: Center(child: Text('Samsung',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          PhonesList.subcat='Samsung';
                        });
                        Navigator.pushNamed(context, PhonesList.id);

                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      child: Container(
                        color: Colors.white,
                        child: Center(child: Text('huawei',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          PhonesList.subcat='huawei';
                        });
                        Navigator.pushNamed(context, PhonesList.id);

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
