import 'dart:io';

import 'package:blog_app/home.dart';
//import 'package:firebase/firebase.dart'as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File? sampleImage;
  String? _myvalue;
  String? url;
  bool validateandSave(){
    final form=formkey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
  void uploadStatusImage() async {
    if (validateandSave()) {
      final Reference postImageRef =
      FirebaseStorage.instance.ref().child("Post Images"); // Updated type to Reference

      var timekey = DateTime.now();
      final UploadTask uploadTask =
      postImageRef.child(timekey.toString() + ".jpg").putFile(sampleImage!);
      var snapshot = await uploadTask;
      var ImageUrl = await snapshot.ref.getDownloadURL();
      // You can also use `await uploadTask` if you want to wait for the upload to finish
      url=ImageUrl.toString();
      print("Image Url ="+url!);
      goToHomePage();
      saveToDatabase();
    }
  }
  void goToHomePage(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context)=>const HomePage()));
  }
  void saveToDatabase(){
    var dbTimeKey=DateTime.now();
    var formatDate=DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');
    
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.ref();
    var data = {
      "image":url,
      "description":_myvalue,
      "Date":date,
      "time": time,
    };
    
    ref.child("Posts").push().set(data);
  }

  final formkey = GlobalKey<FormState>();
  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    var tempimage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = File(tempimage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload photo"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: sampleImage == null ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const Text("Select an Image",style: TextStyle(
               fontSize: 18
             ),),
            const SizedBox(
              height: 15,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                  onPressed: getImage,
                  icon: const Icon(
                    Icons.upload,
                    size: 60,
                  )
              ),
            )
          ],
        ) : enableUpload(),
      )
    );
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Form(
          key: formkey,
          child: Column(
            children: [
              Image.file(
                sampleImage!,
                height: 310.0,
                width: 600.0,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      return value!.isEmpty ? "Description is required" : null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _myvalue = value;
                      });
                    }),
              ),
              const SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 10.0
                ),
                  onPressed: uploadStatusImage,
                  child: const Text("Add a new post",style: TextStyle(
                    color: Colors.white
                  ),))
            ],
          )),
    );
  }
}
