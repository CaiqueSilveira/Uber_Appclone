import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_bloc.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_provider.dart';
import 'package:uber_appclone/src/models/user.dart';
import 'package:uber_appclone/src/services/request/status_request.dart';
import 'package:uber_appclone/src/services/userRepository/userRepository.dart';

class PainelMotorista extends StatefulWidget {
  final User user;

  PainelMotorista({Key key, @required this.user}) : super(key: key);
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {
  List<String> itensMenu = ["Configurações", "Deslogar"];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  UserRepository repository = UserRepository();

  Stream<QuerySnapshot> _adicionarListenerRequisicoes() {
    final stream = db
        .collection("requisicoes")
        .where("status", isEqualTo: StatusRequest.AGUARDANDO)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });

    return stream;
  }

  _recuperaRequisicaoAtivaMotorista() async {
    //Recupera dados do usuario logado
    FirebaseUser firebaseUser = await repository.currentUser();

    //Recupera requisicao ativa
    DocumentSnapshot documentSnapshot = await db
        .collection("requisicao_ativa_motorista")
        .document(firebaseUser.uid)
        .get();

    var dadosRequisicao = documentSnapshot.data;

    if (dadosRequisicao == null) {
      _adicionarListenerRequisicoes();
    } else {
      String idRequisicao = dadosRequisicao["id_requisicao"];
      Navigator.pushReplacementNamed(context, "/corrida",
          arguments: idRequisicao);
    }
  }

  @override
  void initState() {
    super.initState();

    /*
    Recupera requisicao ativa para verificar se motorista está
    atendendo alguma requisição e envia ele para tela de corrida
    */
    _recuperaRequisicaoAtivaMotorista();
  }

  @override
  Widget build(BuildContext context) {
    var mensagemCarregando = Center(
      child: Column(
        children: <Widget>[CircularProgressIndicator()],
      ),
    );

    var mensagemNaoTemDados = Center(
      child: Text(
        "Você não tem nenhuma requisição :( ",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    return ProfileProvider(
      child: Builder(builder: (context) {
        final bloc = ProfileProvider.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text("Painel motorista"),
            centerTitle: true,
          ),
          drawer: _drawer(bloc),
          body: StreamBuilder<QuerySnapshot>(
            stream: _controller.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return mensagemCarregando;
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text("Erro ao carregar os dados!");
                  } else {
                    QuerySnapshot querySnapshot = snapshot.data;
                    if (querySnapshot.documents.length == 0) {
                      return mensagemNaoTemDados;
                    } else {
                      return ListView.separated(
                        itemCount: querySnapshot.documents.length,
                        separatorBuilder: (context, indice) => Divider(
                          height: 2,
                          color: Colors.grey,
                        ),
                        itemBuilder: (context, indice) {
                          List<DocumentSnapshot> requisicoes =
                              querySnapshot.documents.toList();
                          DocumentSnapshot item = requisicoes[indice];

                          String idRequisicao = item["id"];
                          String nomePassageiro = item["rider"]["name"];
                          String rua = item["destination"]["street"];
                          String numero = item["destination"]["number"];

                          return ListTile(
                            title: Text(nomePassageiro),
                            subtitle: Text("destino: $rua, $numero"),
                            onTap: () {
                              Navigator.pushNamed(context, "/corrida",
                                  arguments: idRequisicao);
                            },
                          );
                        },
                      );
                    }
                  }
                  break;
              }
            },
          ),
        );
      }),
    );
  }

  Widget _drawer(ProfileBloc bloc) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  child: FlatButton(
                    child: _header(widget.user.photoUrl),
                    onPressed: () {
                      bloc.onClickeEditProfile(context);
                    },
                  ),
                ),
                Container(
                  height: 12.0,
                ),
                Align(
                  child: Text(
                    widget.user.name,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Align(
                  child: Text(
                    widget.user.email,
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          _settingPage("Configurações", bloc),
        ],
      ),
    );
  }

  Widget _settingPage(String title, ProfileBloc bloc) {
    return ListTile(
      title: Text(title),
      onTap: () {
        bloc.onClickeSettingtProfile(context);
      },
    );
  }

  Widget _header(String photoUrl) {
    if (photoUrl != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.0, 5.0, 0, 5.0),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.white,
                width: 0.9,
              )),
        ),
      );
    } else {
      return Container(
        height: 60,
        width: 60,
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          child: Icon(Icons.person),
        ),
      );
    }
  }
}
