import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'models/models.dart';

class Images extends StatefulWidget {
  final File pickedFile;

  const Images({Key key, this.pickedFile}) : super(key: key);
  @override
  _ImagesState createState() => _ImagesState(pickedFile);
}

class _ImagesState extends State<Images> {
  String _uploadedFileURL;
  final File pickerFile;

  bool loading;
  @override
  void initState() {
    super.initState();
    loading = false;
  }

  _ImagesState(this.pickerFile);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loading == false
          ? AppBar(
              title: Text("Images"),
            )
          : null,
      body: loading == false
          ? SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      pickerFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      var x = Random();
                      File result =
                          await FlutterImageCompress.compressAndGetFile(
                        pickerFile.path,
                        "/data/user/0/com.example.sih/cache/${x.nextInt(1000000)}.jpg",
                        quality: 30,
                      );
                      // print();
                      StorageReference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child(x.nextInt(1000000).toString());
                      StorageUploadTask uploadTask =
                          storageReference.putFile(File(result.path));
                      await uploadTask.onComplete;
                      print('File Uploaded');
                      storageReference.getDownloadURL().then((fileURL) async {
                        _uploadedFileURL = fileURL;

                        print(_uploadedFileURL);
                        print("Successfully");
                        print(GlobalUser.no);
                        await GlobalUser.key.child("images").update({
                          x.nextInt(1000000).toString():
                              _uploadedFileURL.toString()
                        })
                            // .set({"value": "af"});
                            // .child(GlobalUser.no)
                            //     .set({
                            //   "_uploadedFileURL": _uploadedFileURL.toString()
                            // })
                            .whenComplete(() {
                          imageUrl.add(_uploadedFileURL);
                          GlobalUser.photo = true;
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: Text("Upload"),
                    color: Colors.blue,
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
