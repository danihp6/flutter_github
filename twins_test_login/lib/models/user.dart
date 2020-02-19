import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String name;
  String mail;

  User({this.mail,this.name});

  factory User.fromFirestore(DocumentSnapshot doc){
    return User(
      name: doc.data['name'],
      mail:doc.data['mail']
    );
  }

  Map<String, dynamic> toJson() =>{
        'name':name,
        'mail':mail
  };

  @override
  String toString() {
    return 'name:$name mail:$mail';
  }
}