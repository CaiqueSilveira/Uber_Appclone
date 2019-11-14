import 'package:flutter/material.dart';
import 'package:uber_appclone/page/ui_profile/edit_text.dart';

class EditProfilePage extends StatefulWidget {
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
            _avatar(),
            Divider(),
            _editField("Nome", "Ageu"),
            _editField("Sobrenome", "Paulo"),
            _editField("Telefone", "+55 79 99902-8593"),
            _editField("E-mail", "ageu.paulo@souunit.com.br"),
            _editField("Senha", "********"),
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

  Widget _avatar() {
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
