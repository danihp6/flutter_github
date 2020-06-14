import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final StorageReference refPublicationImages = FirebaseStorage.instance.ref().child('Publication images');

Future<String> uploadImage(File file) async{
  String name = file.path.split('/').last;
  final StorageReference ref = refPublicationImages.child(name);
  final StorageUploadTask uploadTask = ref.putFile(file);
  final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  print(downloadUrl);
  return downloadUrl;
}