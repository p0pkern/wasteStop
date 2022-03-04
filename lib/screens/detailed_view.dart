import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/custom_widgets.dart';

class DetailedView extends StatelessWidget {

  const DetailedView({Key? key}) : super(key: key);
  
  static const routeName = 'detail';

  final index = 0;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)?.settings.arguments as int;

    return (
      Scaffold(
      appBar: AppBar(title: customTitle()),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('wasteinfo').orderBy('date', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs.isNotEmpty) {
              return (
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    formattedDate(convertDate(snapshot.data!.docs[index]['date']), context),
                    formattedImage(snapshot.data!.docs[index]['imgUrl'], context),
                    formattedQuantity(snapshot.data!.docs[index]['quantity'].toString(), context),
                    const Spacer(flex: 1),
                    formattedLocation(snapshot.data!.docs[index]['latitude'].toString(),
                                      snapshot.data!.docs[index]['longitude'].toString(), 
                                      context),
                    const Spacer(flex: 1)
                  ],)
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        )
      )
    );
  }
}

Widget formattedImage(String url, BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: padding(context),
                                    vertical: 10.0),
      child: (
        Image(
          height: 300,
          image: NetworkImage(url))
      ),
    ),
  );
}

double padding(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.03;
}

Widget formattedDate(Widget date, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding(context),
                                  vertical: 20.0),
    child: date);
}

Widget formattedQuantity(String quantity, BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding(context),
                                  vertical: 20.0),
    child: (
      Text('Total Items: $quantity',
            style: const TextStyle(fontSize: 26) )
    ),
  );
}

Widget formattedLocation(String latitude, String longitude, BuildContext context){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding(context),
                                  vertical: 10.0),
    child: (
      Text('location ($latitude, $longitude)')
    ),
  );
}

