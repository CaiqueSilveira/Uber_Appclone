import 'package:flutter/material.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_bloc.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_provider.dart';
import 'package:uber_appclone/src/page/ui_login/login_page_phone.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      child: LoginContent(),
    );
  }
}

class LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final bloc = LoginProvider.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _logoApp(context),
            _phoneSignInButton(context),
            Row(children: <Widget>[
              Expanded(child: Divider()),
              Text(
                "  Ou entre com uma rede social  ",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Expanded(child: Divider()),
            ]),
            _signInButton("assets/google_logo.png", "Google", context, bloc),
          ],
        ),
      ),
    );
  }

  Widget _logoApp(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset("assets/login-img.png"),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "Viagens confiáveis em minutos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _phoneSignInButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/br.png"),
          ),
        ),
        Text(
          "+55",
          style: TextStyle(fontSize: 18),
        ),
        FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Text(
            "Insira seu nº de celular",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginPagePhone()
            ));
          },
        )
      ],
    );
  }

  Widget _signInButton(String asset, String title, BuildContext context, LoginBloc bloc) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image(image: AssetImage(asset), height: 20.0),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
      onPressed:(){
        bloc.onClickGoogle(context);
      },
    );
  }
}
