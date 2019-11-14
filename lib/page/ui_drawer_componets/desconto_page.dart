import 'package:flutter/material.dart';

class DescontoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Viagens com desconto"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(),
            _text(
                "Indique um amigo para experimentar a Uber e ganhe uma viagem com até R\$3 de desconto."),
            _link(),
            _image(),
            _text("Seu código promocional"),
            _formField(),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 50.0, 20.0),
      child: Text(
        "Quer viajar mais e pagar menos?",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _text(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _link() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20, 0),
      child: Text(
        "Como funciona os convites?",
        style: TextStyle(fontSize: 13, height: 1.5, color: Colors.blue),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _image() {
    return Padding(
      padding: const EdgeInsets.only(left: 140.0, bottom: 50.0),
      child: Container(
        width: 200,
        height: 200,
        child: Image.asset("assets/login_image.png"),
      ),
    );
  }

  Widget _formField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: InputDecoration(
          suffix: Text("Copiar", style: TextStyle(color: Colors.blue)),
        ),
        textAlign: TextAlign.left,
        initialValue: "anwjgxnmue",
      ),
    );
  }

  Widget _button() {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        child: SizedBox(
          width: double.maxFinite,
          child: RaisedButton(
            color: Colors.black,
            child: Text(
              "CONVIDE SEUS AMIGOS",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
