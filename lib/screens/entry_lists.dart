import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import '../components/custom_widgets.dart';
import '../screens/detailed_view.dart';
import '../screens/add_entry.dart';

class EntryLists extends StatefulWidget {
  
  static const routeName = '/';

  const EntryLists({Key? key}) : super(key: key);

  @override
  _EntryListsState createState() => _EntryListsState();
}

class _EntryListsState extends State<EntryLists> {

  LocationData? locationData;
  var locationService = Location();

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (locationData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
    return Scaffold(
      appBar: AppBar(title: customTitle()),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('wasteinfo').orderBy('date', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    return Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1)
                        ),
                        child: Semantics(
                          child: customListTile(post['date'], post['quantity'], context, DetailedView.routeName, index),
                          button: true,
                          label: 'Date of the entry and quantity',
                          onTapHint: 'Tapping will bring you to the detailed view of the item'),
                      );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: Semantics(
                      child: FloatingActionButton( 
                            child: const Icon(Icons.camera_alt_outlined, size: 40),
                            onPressed: () {
                                          Navigator.pushNamed(context, AddEntry.routeName, arguments: locationData);
                                        }),
                      button: true,
                      onTapHint: 'Opens the camera gallery to select a photo and opens submission page',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    }
  }
}

