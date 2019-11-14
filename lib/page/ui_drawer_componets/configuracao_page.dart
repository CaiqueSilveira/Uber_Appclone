import 'package:flutter/material.dart';

class ConfiguracaoPage extends StatefulWidget {
  @override
  _ConfiguracaoPageState createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações da conta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _header(),
            Divider(),
            _topics("Favoritos"),
            _flatButton("Adicionar casa", Icons.home),
            _flatButton("Adicionar trabalho", Icons.work),
            _link(),
            Divider(),
            _linkButton("Privacidade", "Controle as informações que você compartilha com a gente"),
            _linkButton("Segurança", "Controle a segurança da sua conta com a verificação em duas etapas"),
            _linkButton("Sair", ""),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 10.0),
          child: Container(
            height: 80,
            width: 80,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Igor Vasconcelos"),
              Text("+55 79 99478-8473"),
              Text("igor.vasconcelos@souunit.com.br"),
            ],
          ),
        )
      ],
    );
  }

  Widget _link() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20, 20.0),
      child: Text(
        "Mais locais salvos",
        style: TextStyle(fontSize: 15, height: 1.5, color: Colors.blue),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _linkButton(String title, String subtitle){
     return FlatButton(
      child: Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 12),),
        ),
      ),
      onPressed: () {},
    );

  }

  Widget _flatButton(String label, IconData icon) {
    return FlatButton(
      child: Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(label),
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _topics(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),
      ),
    );
  }
}
