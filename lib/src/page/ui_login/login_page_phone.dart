import 'package:flutter/material.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_bloc.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_provider.dart';

class LoginPagePhone extends StatefulWidget {
  @override
  _LoginPagePhoneState createState() => _LoginPagePhoneState();
}

class _LoginPagePhoneState extends State<LoginPagePhone> {
  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      child: Builder(
        builder: (context) {
          final bloc = LoginProvider.of(context);
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 20, bottom: 30),
                    child: Text(
                      "Insira seu nº de celular",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  _phoneInput(bloc),
                ],
              ),
            ),
            floatingActionButton: _floatingButton(bloc),
          );
        },
      ),
    );
  }

  Widget _phoneInput(LoginBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.phone,
      builder: (context, snap) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0),
          child: Container(
            child: Row(
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
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                    child: TextField(
                      onChanged: bloc.inputPhone,
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '(xx) xxxxx-xxxx',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _floatingButton(LoginBloc bloc) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      mini: true,
      onPressed: () {
        bloc.onClickPhone(context);
      },
      child: Icon(
        Icons.arrow_forward,
        size: 18,
      ),
    );
  }
}
