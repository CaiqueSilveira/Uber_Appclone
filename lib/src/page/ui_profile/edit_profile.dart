import 'package:flutter/material.dart';
import 'package:uber_appclone/src/models/user.dart';
import 'package:uber_appclone/src/page/ui_profile/edit_text.dart';

class EditProfilePage extends StatefulWidget {
  final User currentUser;

  EditProfilePage({Key key, @required this.currentUser}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar conta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _avatar(widget.currentUser.photoUrl),
            Divider(),
            _editField("Nome", widget.currentUser.name),
            _editField("Telefone", widget.currentUser.phone),
            _editField("E-mail", widget.currentUser.email),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, String controller) {
    return FlatButton(
      child: ListTile(
        subtitle: Text(label),
        title: Text(controller),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTextProfilePage(label, controller),
          ),
        );
      },
    );
  }

  Widget _avatar(String photoUrl) {
    if (photoUrl != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 0, 10.0),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.grey,
                width: 0.2,
              )),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 0, 30.0),
        child: Container(
          height: 80,
          width: 80,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
        ),
      );
    }
  }
}
