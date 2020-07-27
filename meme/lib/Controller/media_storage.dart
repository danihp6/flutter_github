import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meme/Controller/gallery.dart';
import 'media_compressor.dart';

class MediaStorage {
  final StorageReference ref = FirebaseStorage.instance.ref();

  Future<String> uploadMedia(MyMedia media, String userId, String postId) async {
    await mediaCompressor.compress(media);
    Uint8List bytes = media is ImageMedia
        ? media.image
        : await (media as VideoMedia).video.readAsBytes();
    String name = postId;
    final StorageReference refPublicationImages =
        ref.child(userId).child('media').child(name);
    final StorageUploadTask uploadTask = refPublicationImages.putData(bytes);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

    Future<String> uploadPostListImage(MyMedia media, String userId, String postListId) async {
    await mediaCompressor.compress(media);
    Uint8List bytes = media is ImageMedia
        ? media.image
        : await (media as VideoMedia).video.readAsBytes();
    String name = postListId;
    final StorageReference refPublicationImages =
        ref.child(userId).child('postLists').child(name);
    final StorageUploadTask uploadTask = refPublicationImages.putData(bytes);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadAvatar(
      ImageMedia imageMedia, String userId) async {
    await mediaCompressor.compress(imageMedia);
    String name = 'avatar' + userId;
    final StorageReference refPublicationImages = ref.child(userId).child(name);
    final StorageUploadTask uploadTask =
        refPublicationImages.putData(imageMedia.image);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteMedia(String userId, String postId) async {
    await ref.child(userId).child('media').child(postId).delete();
  }

    Future<void> deletePostListImage(String userId, String postListId) async {
    await ref.child(userId).child('postLists').child(postListId).delete();
  }

    Future<void> deleteAvatar(String userId) async {
    await ref.child(userId).child('avatar' + userId).delete();
  }
}

MediaStorage mediaStorage = MediaStorage();
