import 'package:flutter/material.dart';
import 'PhoneList.dart';
import 'phonecat.dart';

class phonecategories extends StatefulWidget {
  static const String id='phone_categories';
  @override
  _phonecategoriesState createState() => _phonecategoriesState();
}

class _phonecategoriesState extends State<phonecategories> {
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
                        child: Center(child: Text('New',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context, phonecat.id);
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      child: Container(
                        color: Colors.white,
                        child: Center(child: Text('Used',style: TextStyle(color: Colors.black,fontSize: 30),)),
                      ),
                      onPressed: (){
                        setState(() {
                          PhonesList.subcat='used';
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
