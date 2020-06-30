import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class MediaStorage{
  
final StorageReference ref =
    FirebaseStorage.instance.ref();

Future<Map<String, dynamic>> uploadMedia(File file,String userId) async {
  String name = 'media_'+userId + '_'+file.path.split('/').last;
  final StorageReference refPublicationImages = ref.child(userId).child('media').child(name);
  final StorageUploadTask uploadTask = refPublicationImages.putFile(file);
  final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return {'media': downloadUrl, 'location': 'media/' +name};
}

Future<Map<String, dynamic>> uploadAvatar(File file,String userId) async {
  String name = 'avatar_' + userId;
  final StorageReference refPublicationImages = ref.child(userId).child(name);
  final StorageUploadTask uploadTask = refPublicationImages.putFile(file);
  final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return {'media': downloadUrl, 'location': 'avatars/' +name};
}

Future<void> deleteFile(String path) {
  if(path!=null)ref.child(path).delete();
}


}

MediaStorage mediaStorage = MediaStorage();