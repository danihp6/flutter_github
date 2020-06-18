import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final StorageReference ref =
    FirebaseStorage.instance.ref();

Future<Map<String, dynamic>> uploadPublicationImage(File file) async {
  String name = file.path.split('/').last;
  final StorageReference refPublicationImages = ref.child('Publication images').child(name);
  final StorageUploadTask uploadTask = refPublicationImages.putFile(file);
  final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return {'image': downloadUrl, 'url': 'Publication images/' +name};
}

Future<Map<String, dynamic>> uploadAvatarImage(File file) async {
  String name = file.path.split('/').last;
  final StorageReference refPublicationImages = ref.child('Avatar images').child(name);
  final StorageUploadTask uploadTask = refPublicationImages.putFile(file);
  final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return {'image': downloadUrl, 'url': 'Avatar images/' +name};
}

Future<void> deleteImage(String path) {
  ref.child(path).delete();
}
