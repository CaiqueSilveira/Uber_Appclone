import 'package:flutter/material.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_bloc.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_provider.dart';

class PhoneConfirmePage extends StatefulWidget {
  final String phone;

  PhoneConfirmePage({Key key, @required this.phone}) : super(key: key);
  @override
  _PhoneConfirmePageState createState() => _PhoneConfirmePageState();
}

class _PhoneConfirmePageState extends State<PhoneConfirmePage> {
  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      child: Builder(
        builder: (context) {
          final bloc = LoginProvider.of(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.only(top: 5, left: 20),
                    child: Text(
                      "Confirme suas informações",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _nameInput('Nome', bloc),
                  _emailInput('E-mail', bloc),
                  _phoneInput(bloc, widget.phone.toString()),
                  _swithc(bloc),
                  ],
                ),
              ),
            ),
            floatingActionButton: _floatingButton(bloc),
          );
        },
      ),
    );
  }

  Widget _nameInput(String label, LoginBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.name,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
          child: TextField(
            onChanged: bloc.inputName,
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: label,
            ),
            textAlign: TextAlign.left,
          ),
        );
      }
    );
  }

  Widget _emailInput(String label, LoginBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
          child: TextField(
            onChanged: bloc.inputEmail,
            maxLines: 1,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: label,
            ),
            textAlign: TextAlign.left,
          ),
        );
      }
    );
  }

  Widget _phoneInput(LoginBloc bloc, String value) {
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

  Widget _swithc(LoginBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.type,
      builder: (context, snap) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
          child: Row(
            children: <Widget>[
              Text("Passageiro"),
              Switch(
                  activeColor: Colors.black,
                  value: snap.data,
                  onChanged: bloc.inputType),
              Text("Motorista"),
            ],
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
        bloc.onClickConfirmeUserByPhone(context);
      },
      child: Icon(
        Icons.arrow_forward,
        size: 18,
      ),
    );
  }
}

