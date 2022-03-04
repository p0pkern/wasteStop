import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget customTitle() {
  return (
    RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 26),
        children: <TextSpan>[
          TextSpan(
            text: 'waste',
            ),
          TextSpan(
            text: 'Stop',
            style: TextStyle(fontWeight: FontWeight.bold,
                             color: Colors.black)
            ),
          ]),
        )
  );
}

Widget customListTile(Timestamp date, int quantity, BuildContext context, String routeName, int index){
  return (
    ListTile(
      title: convertDate(date),
      trailing: Text(
        quantity.toString(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold)
        ),
        onTap: () {
          Navigator.pushNamed(context, routeName, arguments: index);
        },
    )
  );
}

Widget convertDate(Timestamp timestamp){
  DateTime date = timestamp.toDate();
  String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(date);
  return (
    Text(formattedDate,
         style: const TextStyle(fontSize: 22))
  );
}