import 'package:flutter/material.dart';

class PagamentoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagamento"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _header(),
            _button(),
            Divider(),
            _topics("Formas de pagamento"),
            _flatButton("Dinheiro", "assets/money_logo.png"),
            _link("Adicionar formas de pagamento"),
            Divider(),
            _topics("Promoções"),
            _flatButton("Recompensas", "assets/reward_logo.png"),
            _link("Adicionar código promocional"),
            Divider(),
            _topics("Vouchers"),
            _flatButton("Vouchers", "assets/voucher_logo.png"),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10.0, 20.0, 10.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset("assets/uber_logo.jpeg"),
                  ),
                ),
                Text(
                  "Uber Cash",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
            child: Text("R\$0,00",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0, 0.0, 0),
            child: Row(
              children: <Widget>[
                Text(
                  "Planeje com antecedência.",
                  style: TextStyle(color: Colors.black38),
                ),
                Text(
                  "Planeje com antecedência.",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topics(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _link(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20, 20.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, height: 1.5, color: Colors.blue),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _flatButton(String label, String img) {
    return FlatButton(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(img),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _button() {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
        child: SizedBox(
          width: double.maxFinite,
          child: RaisedButton(
            color: Colors.black,
            child: Text(
              "ADICIONAR SALDO",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
