import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/edit_profile_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class EditProfileButton extends StatelessWidget {
  User user;
  EditProfileButton({@required this.user});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => Navigator.push(
          context,
          SlideLeftRoute(
              page: EditProfilePage(
            user: user,
          ))),
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
      child: Text('Editar'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );
  }
}
