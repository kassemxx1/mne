import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
final _firestore = Firestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;
class AccessoriesScreen extends StatefulWidget {
  static const String id='Accessories_Screen';
  @override
  _AccessoriesScreenState createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  var ListOfPhones = [];
  var ListOfItems=[];
  var ImageLink;
  var upload='Choose the Item Image';
  var nameOfItem='';
  var PriceOfItem='';



  Future<String> uploadPic() async {

    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child('images/');

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String location = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    print(location);
    setState(() {
      upload ='Uploade';
      ImageLink = location;
    });

    //returns the download url
    return location;

  }

  void getPhonesList() async {
    ListOfPhones.clear();
    final messages = await _firestore.collection('phones').where('categories',isEqualTo: 'accessories').getDocuments();
    for (var msg in messages.documents) {
      final name = msg['phonename'].toString();
      final price = msg['price'];
      final image = msg['image'].toString();
      setState(() {
        ListOfPhones.add({'phonename': name, 'price': price, 'image': image});
      });
    }
  }

  Future<int> getqtt(String name) async {
    var qtts = [0];

    final messages = await _firestore
        .collection('transaction')
        .where('name', isEqualTo: name)
        .getDocuments();
    for (var msg in messages.documents) {
      final qtt = msg['qtt'];
      qtts.add(qtt);
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhonesList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white24,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(icon:Icon(Icons.add,color: Colors.black,),

                    onPressed:(){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    MaterialButton(
                                      onPressed: (){
                                        setState(() {

                                          uploadPic();
                                        },);
                                      },
                                      child: Text(upload),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10,top: 10),
                                      child: TextField(
                                        keyboardType: TextInputType
                                            .emailAddress,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          setState(() {
                                            nameOfItem = value;
                                          });
                                        },
                                        decoration:
                                        KTextFieldImputDecoration
                                            .copyWith(
                                            hintText:
                                            'Enter the Name Of Item'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10,top: 10),
                                      child: TextField(
                                        keyboardType: TextInputType
                                            .emailAddress,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          setState(() {
                                            PriceOfItem =
                                                value;
                                          });
                                        },
                                        decoration:
                                        KTextFieldImputDecoration
                                            .copyWith(
                                            hintText:
                                            'Enter the Price Of Item in \$'),
                                      ),
                                    ),
                                    MaterialButton(
                                        child: Text('Add',style: TextStyle(fontSize: 30,color: Colors.blueAccent),),
                                        onPressed: (){
                                          _firestore.collection('phones').add({
                                            'phonename':nameOfItem,
                                            'price': PriceOfItem,
                                            'image': ImageLink,
                                            'INOUT': 'out',
                                            'categories':'accessories',
                                          });
                                          getPhonesList();


                                          Navigator.of(context).pop();
                                        }),



                                  ],
                                ),
                              ),
                            );
                          });


                    })
              ],
              title: Text(
                'Accessorie',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: ListOfPhones[index]['image'],
                                ),
                              ),
                            ),
                            Text(
                              ListOfPhones[index]['phonename'],
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '${ListOfPhones[index]['price'].toString()} \$',
                              style:
                              TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            FutureBuilder(
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> qttnumbr) {
                                  return Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Available:'),
                                        Text(
                                          '${qttnumbr.data}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                initialData: 1,
                                future:
                                getqtt(ListOfPhones[index]['phonename'])),
                            MaterialButton(
                              child: Text(
                                'Sell',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              onPressed: () {
                                var _n = -1;
                                var _price = 0.0;
                                var currency = '\$';
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(

                                        content: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    ListOfPhones[index]
                                                    ['image'],
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ListOfPhones[index]
                                                ['phonename'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              Text(
                                                '${ListOfPhones[index]['price'].toString()} \$',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                              FutureBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                      AsyncSnapshot<int>
                                                      qttnumbr) {
                                                    return Center(
                                                      child: Text(
                                                        'Available : ${qttnumbr.data}',
                                                      ),
                                                    );
                                                  },
                                                  initialData: 1,
                                                  future: getqtt(
                                                      ListOfPhones[index]
                                                      ['phonename'])),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40, right: 40,top: 10),
                                                child: TextField(
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textAlign: TextAlign.center,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _n = -(int.parse(value));
                                                    });
                                                  },
                                                  decoration:
                                                  KTextFieldImputDecoration
                                                      .copyWith(
                                                      hintText:
                                                      'Enter Your Qtt'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40, right: 40,top: 10),
                                                child: TextField(
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textAlign: TextAlign.center,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _price =
                                                      (double.parse(value));
                                                    });
                                                  },
                                                  decoration:
                                                  KTextFieldImputDecoration
                                                      .copyWith(
                                                      hintText:
                                                      'Enter Your Price'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CustomRadioButton(
                                                  buttonColor: Theme.of(context)
                                                      .canvasColor,
                                                  buttonLables: [
                                                    '\$',
                                                    'L.L',
                                                  ],
                                                  buttonValues: [
                                                    '\$',
                                                    'L.L',
                                                  ],
                                                  radioButtonValue: (value) {
                                                    setState(() {
                                                      currency = value;
                                                    });
                                                  },
                                                  selectedColor: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: MaterialButton(
                                                  child: Text('Sell',style: TextStyle(fontSize: 30,color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                                                  onPressed: () {
                                                    _firestore
                                                        .collection(
                                                        'transaction')
                                                        .add({
                                                      'name':
                                                      ListOfPhones[index]['phonename'],
                                                      'qtt': _n,
                                                      'price': _price,
                                                      'timestamp':
                                                      DateTime.now(),
                                                      'currency': currency,
                                                    });
                                                    setState(() {
                                                      getqtt(ListOfPhones[index]['phonename']);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: ListOfPhones.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  ///no.of items in the horizontal axis
                  crossAxisCount: 2,
                ))
          ],
        ),
      ),
    );
  }
}
