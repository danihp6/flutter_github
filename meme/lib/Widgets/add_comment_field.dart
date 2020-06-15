import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Models/Comment.dart';
import 'package:meme/Models/User.dart';

class AddCommentField extends StatefulWidget {
  User user;
  String publicationId;
  AddCommentField({@required this.user, @required this.publicationId});

  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  String comment = '';
  TextEditingController controller = new TextEditingController();
  FocusNode focus = new FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void sendComment() {

      newComment(
          widget.publicationId,
          new Comment(comment, <String>[], widget.user.getId(), DateTime.now(),
              widget.publicationId, <String>[], 0));
                    controller.clear();
      comment = '';
      focus.unfocus();
    }

    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(widget.user.getImage()),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                hintText: 'Escribe un comentario',
                border: InputBorder.none),

            onChanged: (text){ 
              setState(() {
                comment = text;
              });
              },
            controller: controller,
            focusNode: focus,
          ),
        ),
        if(comment.length>0)
        IconButton(
          icon: Icon(Icons.send),
          onPressed: sendComment,
        )
      ],
    );
  }
}
