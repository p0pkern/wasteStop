import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import '../components/custom_widgets.dart';
import '../models/entries.dart';
import 'dart:io';

class AddEntry extends StatefulWidget {

  const AddEntry({Key? key}) : super(key: key);

  static const routeName = 'add';

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {

  final Entries entries = Entries();
  final formKey = GlobalKey<FormState>();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? image;
  String? uploadUrl;
  final picker = ImagePicker();
  void getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    final date = DateTime.now().toString();

    try {
      await firebase_storage.FirebaseStorage.instance
      .ref('img' + date)
      .putFile(image!);
      uploadUrl = await firebase_storage.FirebaseStorage.instance
      .ref('img' + date)
      .getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print('failed to upload');
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    final locationData = ModalRoute.of(context)?.settings.arguments as LocationData;

    if(image == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(title: customTitle()),
        body: Column(
          children: [
            Semantics(child: imagePreview(image!),
            image: true,
            label: 'Image of waste items chosen from gallery'),
            Semantics(
              child: quantityForm(entries, formKey, context),
              focusable: true,
              label: 'Enter a number for quantity of wasted products',
              ),
            const Spacer(flex: 1),
            const Spacer(flex: 1),
            Semantics(
              child: submitAll(entries, formKey, context, locationData, uploadUrl!),
              button: true,
              enabled: true,
              onTapHint: 'Submit image and quantity data to server storage'
              ),
          ],),
        resizeToAvoidBottomInset: false,
        );
      }
    }
  }

Widget imagePreview(File image){
    return (
    Image.file(image, height: 300)
  );
}

Widget quantityForm(Entries entries, GlobalKey<FormState> formKey, BuildContext context){
  return(
    Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Number of Waste Items',
                                      border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSaved: (value){
            entries.quantity = int.parse(value!);
          },
          validator: (value) {
            if(value == null || value.isEmpty) {
              return 'Please enter a number';
            } else {
              return null;
            }
          },
        ),
      ),
    )
  );
}

Widget submitAll(Entries entries, 
                GlobalKey<FormState> formKey, 
                BuildContext context,
                LocationData locationData,
                String uploadUrl) {
  return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: double.infinity, height: 100),
      child: ElevatedButton(
          child: const Icon(Icons.cloud_upload,
                      size: 70),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              entries.date = DateTime.now();
              entries.latitude = locationData.latitude;
              entries.longitude = locationData.longitude;
              entries.imageUrl = uploadUrl;
              addEntriesToFirebase(entries);
              Navigator.pop(context);
            }
          },
      ),
    );
}

void addEntriesToFirebase(Entries entries) async{
  FirebaseFirestore.instance
      .collection('wasteinfo')
      .add({'date': entries.date, 
            'imgUrl': entries.imageUrl,
            'quantity': entries.quantity,
            'latitude': entries.latitude,
            'longitude': entries.longitude});
}


