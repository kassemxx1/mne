import 'package:flutter/material.dart';
import 'OMTScreen.dart';
import 'Selling.dart';
import 'PhoneList.dart';
import 'Invoices.dart';
import 'Recharge_Screen.dart';
import 'Accessories_Screen.dart';
import 'ReportsScreen.dart';
import 'OMTScreen.dart';
import 'rechargeCategories.dart';
import 'clientsScreen.dart';
class MainScreen extends StatefulWidget {
  static const String id = 'Main_Screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;


    return Scaffold(
     appBar: AppBar(title: Text('Phone Store'),),
     body: Container(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
           color: Colors.amberAccent,
           child: orientation == Orientation.portrait ?
           Column(
             children:[ Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, PhonesList.id);
                     },
                     child: Container(
                       color: Colors.red,
                       child: Center(child: Text('Phones',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),

               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, RechargeCategories.id);

                     },
                     child: Container(
                       color: Colors.blueAccent,
                       child: Center(child: Text('Recharge',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),

               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, AccessoriesScreen.id);

                     },
                     child: Container(
                       color: Colors.green,
                       child: Center(child: Text('Accessories',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),
               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, OMTScreen.id);

                     },
                     child: Container(
                       color: Colors.pink,
                       child: Center(child: Text('OMT',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),
               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, Invoices.id);

                     },
                     child: Container(
                       color: Colors.pink,
                       child: Center(child: Text('Invoices',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),
               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, ReportsScreen.id);


                     },
                     child: Container(
                       color: Colors.pink,
                       child: Center(child: Text('Reports',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),
               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, ClientsScreen.id);


                     },
                     child: Container(
                       color: Colors.pink,
                       child: Center(child: Text('clients',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),
               ),
             ]
           ) : Row(children:[ Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, PhonesScreen.id);
                     },
                     child: Container(
                       color: Colors.red,
                       child: Center(child: Text('Phones',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),

               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, RechargeScreen.id);

                     },
                     child: Container(
                       color: Colors.blueAccent,
                       child: Center(child: Text('Recharge',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),

               ),
               Flexible(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: MaterialButton(
                     onPressed: (){
                       Navigator.pushNamed(context, AccessoriesScreen.id);

                     },
                     child: Container(
                       color: Colors.green,
                       child: Center(child: Text('Accessories',style: TextStyle(fontSize: 22,color: Colors.white),)),

                     ),
                   ),
                 ),

               ),
             Flexible(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: MaterialButton(
                   onPressed: (){
                     Navigator.pushNamed(context, OMTScreen.id);

                   },
                   child: Container(
                     color: Colors.pink,
                     child: Center(child: Text('OMT',style: TextStyle(fontSize: 22,color: Colors.white),)),

                   ),
                 ),
               ),
             ),
             Flexible(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: MaterialButton(
                   onPressed: (){
                     Navigator.pushNamed(context, Invoices.id);

                   },
                   child: Container(
                     color: Colors.pink,
                     child: Center(child: Text('Invoices',style: TextStyle(fontSize: 22,color: Colors.white),)),

                   ),
                 ),
               ),
             ),
             Flexible(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: MaterialButton(
                   onPressed: (){


                   },
                   child: Container(
                     color: Colors.pink,
                     child: Center(child: Text('Reports',style: TextStyle(fontSize: 22,color: Colors.white),)),

                   ),
                 ),
               ),
             ),
             Flexible(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: MaterialButton(
                   onPressed: (){
                     Navigator.pushNamed(context, ClientsScreen.id);


                   },
                   child: Container(
                     color: Colors.pink,
                     child: Center(child: Text('clients',style: TextStyle(fontSize: 22,color: Colors.white),)),

                   ),
                 ),
               ),
             ),
           ]
           )


           )


         ),
       ),

     );

  }
}
