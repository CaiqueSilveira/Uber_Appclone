import 'package:flutter/material.dart';

class EditTextProfilePage extends StatefulWidget {
  final String label;
  final String controller;

  EditTextProfilePage(this.label, this.controller);
  @override
  _EditTextProfilePageState createState() => _EditTextProfilePageState();
}

class _EditTextProfilePageState extends State<EditTextProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          _formField(widget.label, widget.controller),
          _saveButton()
        ],
      ),
    );
  }
  
  Widget _formField(String label, String controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: InputDecoration(
          labelText: label,
        ),
        textAlign: TextAlign.left,
        initialValue: controller,
      ),
    );
  }

  Widget _saveButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: SizedBox(
          width: double.maxFinite,
          child: RaisedButton(
            color: Colors.black,
            child: Text(
              "SALVAR",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}