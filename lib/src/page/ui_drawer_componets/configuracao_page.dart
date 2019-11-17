import 'package:flutter/material.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_bloc.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_provider.dart';
import 'package:uber_appclone/src/models/user.dart';

class SettingPage extends StatefulWidget {
  final User user;

  SettingPage({Key key, @required this.user}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return LoginProvider(
          child: Builder(
        builder: (context) {
          final bloc = LoginProvider.of(context);
          return Scaffold(
            appBar: AppBar(
              title: Text("Configurações da conta"),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _header(widget.user),
                  Divider(),
                  _topics("Favoritos"),
                  _flatButton("Adicionar casa", Icons.home),
                  _flatButton("Adicionar trabalho", Icons.work),
                  _link(),
                  Divider(),
                  _linkButton("Privacidade", "Controle as informações que você compartilha com a gente"),
                  _linkButton("Segurança", "Controle a segurança da sua conta com a verificação em duas etapas"),
                  _sairButton("Sair", bloc),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _header(User user) {
    return Row(
      children: <Widget>[
        _circleAvatar(user.photoUrl),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user.name),
              Text(user.phone),
              Text(user.email),
            ],
          ),
        )
      ],
    );
  }

   Widget _circleAvatar(String photoUrl) {
    if (photoUrl != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 10.0),
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

  Widget _sairButton(String title, LoginBloc bloc){
     return FlatButton(
      child: Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
          title: Text(title),
        ),
      ),
      onPressed: (){
        bloc.onClickSignOut(context);
      },
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
