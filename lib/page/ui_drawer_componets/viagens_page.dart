import 'package:flutter/material.dart';

class ViagensPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Escolha uma viagem", style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            tabs: [
              Tab(child: Text("Anteriores")),
              Tab(child: Text("Trabalho")),
              Tab(child: Text("Agendadas")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _anteriores(),
            _trabalho(),
            _agendadas(),
          ],
        ),
      ),
    );
  }

  Widget _anteriores() {
    return Center(
      child: Text(
        "Você ainda não realizou nenhuma viagem",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _trabalho() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            child: Image.asset("assets/login_image.png"),
          ),
          Text(
            "Bem-vindo(a) às viagens do Perfil Trabalho",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Text(
              "Configure as preferências da empresa para que os recebidos sejam enviados" +
                  "a um e-mail de trabalho, adicione outra forma de pagamento, " +
                  "simplifique as despesas e muito mais.",
              style:
                  TextStyle(fontSize: 13, height: 1.5, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  color: Colors.black,
                  child: Text(
                    "COMEÇAR",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agendadas() {
    return Center(
      child: Text(
        "Você não tem viagens agendadas",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
      ),
    );
  }
}
