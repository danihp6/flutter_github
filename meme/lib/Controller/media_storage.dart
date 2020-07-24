import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meme/Controller/gallery.dart';
import 'media_compressor.dart';

class MediaStorage {
  final StorageReference ref = FirebaseStorage.instance.ref();

  Future<Map<String, dynamic>> uploadMedia(MyMedia media, String userId) async {
    await mediaCompressor.compress(media);
    Uint8List bytes = media is ImageMedia
        ? media.image
        : await (media as VideoMedia).video.readAsBytes();
    String name = 'media_' + userId;
    final StorageReference refPublicationImages =
        ref.child(userId).child('media').child(name);
    final StorageUploadTask uploadTask = refPublicationImages.putData(bytes);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return {'media': downloadUrl, 'location': userId + '/media/' + name};
  }

  Future<Map<String, dynamic>> uploadAvatar(
      ImageMedia imageMedia, String userId) async {
    await mediaCompressor.compress(imageMedia);
    String name = 'avatar_' + userId;
    final StorageReference refPublicationImages = ref.child(userId).child(name);
    final StorageUploadTask uploadTask =
        refPublicationImages.putData(imageMedia.image);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return {'media': downloadUrl, 'location': userId + '/avatars/' + name};
  }

  Future<void> deleteFile(String path) async {
    if (path != null) await ref.child(path).delete();
  }

  Future<String> downloadFile(String path) async{
    if(path != null) return await ref.child(path).getDownloadURL();
  }
}

MediaStorage mediaStorage = MediaStorage();
