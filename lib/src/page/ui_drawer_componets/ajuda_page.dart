import 'package:flutter/material.dart';

class AjudaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajuda"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 30.0, 10.0, 20.0),
              child: Text(
                "Todos os tópicos",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _editField("Problemas com uma viagem específica e reembolsos"),
            _editField("Opções de conta e pagamento"),
            _editField("Mais"),
            _editField("O Guia da Uber"),
            _editField("Como se cadastrar"),
            _editField("Acessibilidade"),
            _editField("Emergencia"),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label) {
    return FlatButton(
      child: Text(
        label,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.left,
      ),
      onPressed: () {},
    );
  }
}
