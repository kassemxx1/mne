import 'package:flutter/material.dart';
import 'MtcScreen.dart';
import 'alfaAcreen.dart';
import 'fanytelScreen.dart';
class RechargeCategories extends StatefulWidget {
  static const String id='Recharge_categories';
  @override
  _RechargeCategoriesState createState() => _RechargeCategoriesState();
}

class _RechargeCategoriesState extends State<RechargeCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recharge',style: TextStyle(color: Colors.black),
      ),backgroundColor: Colors.white,leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),),
      body:Container(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        child: Image.asset('assets/images/MTC.png'),

                      ),
                      onTap: (){
                        Navigator.pushNamed(context, MtcScreen.id);

                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        child: Image.asset('assets/images/ALFA.png'),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, AlfaScreen.id);

                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Container(
                        child: Image.asset('assets/images/fanytel.jpg'),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, FanytelScreen.id);

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
