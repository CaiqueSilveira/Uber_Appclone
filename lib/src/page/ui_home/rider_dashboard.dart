import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_bloc.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_provider.dart';
import 'package:uber_appclone/src/models/destination.dart';
import 'package:uber_appclone/src/models/marker.dart';
import 'package:uber_appclone/src/models/request.dart';
import 'package:uber_appclone/src/models/user.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/ajuda_page.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/desconto_page.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/pagamento_page.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/viagens_page.dart';
import 'package:uber_appclone/src/services/request/status_request.dart';
import 'dart:async';
import 'dart:io';
import 'package:uber_appclone/src/services/userRepository/userRepository.dart';

class RiderDashboard extends StatefulWidget {
  final User user;

  RiderDashboard({Key key, @required this.user}) : super(key: key);
  @override
  _RiderDashboardState createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  UserRepository repository = UserRepository();
  TextEditingController _controllerDestino =
      TextEditingController(text: "R. Heitor Penteado, 800");
  List<String> itensMenu = ["Configurações", "Deslogar"];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-23.563999, -46.653256));
  Set<Marker> _marcadores = {};
  String _idRequisicao;
  Position _localPassageiro;
  Map<String, dynamic> _dadosRequisicao;
  StreamSubscription<DocumentSnapshot> _streamSubscriptionRequisicoes;

  //Controles para exibição na tela
  bool _exibirCaixaEnderecoDestino = true;
  String _textoBotao = "Chamar uber";
  Color _corBotao = Colors.black;
  Function _funcaoBotao;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (_idRequisicao != null && _idRequisicao.isNotEmpty) {
        //Atualiza local do passageiro
        repository.updateLocationData(
            _idRequisicao, position.latitude, position.longitude);
      } else {
        setState(() {
          _localPassageiro = position;
        });
        _statusUberNaoChamado();
      }
    });
  }

  _recuperaUltimaLocalizacaoConhecida() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);

        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _localPassageiro = position;
        _movimentarCamera(_posicaoCamera);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _exibirMarcadorPassageiro(Position local) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "assets/rider_marker.png")
        .then((BitmapDescriptor icone) {
      Marker marcadorPassageiro = Marker(
          markerId: MarkerId("marcador-passageiro"),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: "Meu local"),
          icon: icone);

      setState(() {
        _marcadores.add(marcadorPassageiro);
      });
    });
  }

  _chamarUber() async {
    String enderecoDestino = _controllerDestino.text;

    if (enderecoDestino.isNotEmpty) {
      List<Placemark> listaEnderecos =
          await Geolocator().placemarkFromAddress(enderecoDestino);

      if (listaEnderecos != null && listaEnderecos.length > 0) {
        Placemark endereco = listaEnderecos[0];
        Destination destino = Destination();
        destino.city = endereco.administrativeArea;
        destino.zip = endereco.postalCode;
        destino.neighborhood = endereco.subLocality;
        destino.street = endereco.thoroughfare;
        destino.number = endereco.subThoroughfare;

        destino.lat = endereco.position.latitude;
        destino.lng = endereco.position.longitude;

        String enderecoConfirmacao;
        enderecoConfirmacao = "\n Cidade: " + destino.city;
        enderecoConfirmacao +=
            "\n Rua: " + destino.street + ", " + destino.number;
        enderecoConfirmacao += "\n Bairro: " + destino.neighborhood;
        enderecoConfirmacao += "\n Cep: " + destino.zip;

        showDialog(
            context: context,
            builder: (contex) {
              return AlertDialog(
                title: Text("Confirmação do endereço"),
                content: Text(enderecoConfirmacao),
                contentPadding: EdgeInsets.all(16),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(contex),
                  ),
                  FlatButton(
                    child: Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      //salvar requisicao
                      _salvarRequisicao(destino);

                      Navigator.pop(contex);
                    },
                  )
                ],
              );
            });
      }
    }
  }

  _salvarRequisicao(Destination destino) async {
    User passageiro = await repository.getUserDatabase();
    passageiro.lat = _localPassageiro.latitude;
    passageiro.lng = _localPassageiro.longitude;

    Request requisicao = Request();
    requisicao.destination = destino;
    requisicao.rider = passageiro;
    requisicao.status = StatusRequest.AGUARDANDO;

    Firestore db = Firestore.instance;

    //salvar requisição
    db
        .collection("requisicoes")
        .document(requisicao.id)
        .setData(requisicao.toMap());

    //Salvar requisição ativa
    Map<String, dynamic> dadosRequisicaoAtiva = {};
    dadosRequisicaoAtiva["id_requisicao"] = requisicao.id;
    dadosRequisicaoAtiva["id_usuario"] = passageiro.id;
    dadosRequisicaoAtiva["status"] = StatusRequest.AGUARDANDO;

    db
        .collection("requisicao_ativa")
        .document(passageiro.id)
        .setData(dadosRequisicaoAtiva);

    //Adicionar listener requisicao
    if (_streamSubscriptionRequisicoes == null) {
      _adicionarListenerRequisicao(requisicao.id);
    }
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao) {
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _statusUberNaoChamado() {
    _exibirCaixaEnderecoDestino = true;

    _alterarBotaoPrincipal("Chamar uber", Color(0xff000000), () {
      _chamarUber();
    });

    if (_localPassageiro != null) {
      Position position = Position(
          latitude: _localPassageiro.latitude,
          longitude: _localPassageiro.longitude);
      _exibirMarcadorPassageiro(position);
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);
      _movimentarCamera(cameraPosition);
    }
  }

  _statusAguardando() {
    _exibirCaixaEnderecoDestino = false;

    _alterarBotaoPrincipal("Cancelar", Colors.red, () {
      _cancelarUber();
    });

    double passageiroLat = _dadosRequisicao["rider"]["lat"];
    double passageiroLon = _dadosRequisicao["rider"]["lng"];
    Position position =
        Position(latitude: passageiroLat, longitude: passageiroLon);
    _exibirMarcadorPassageiro(position);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);
    _movimentarCamera(cameraPosition);
  }

  _statusACaminho() {
    _exibirCaixaEnderecoDestino = false;

    _alterarBotaoPrincipal("Motorista a caminho", Colors.grey, () {});

    double latitudeDestino = _dadosRequisicao["rider"]["lat"];
    double longitudeDestino = _dadosRequisicao["rider"]["lng"];

    double latitudeOrigem = _dadosRequisicao["driver"]["lat"];
    double longitudeOrigem = _dadosRequisicao["driver"]["lng"];

    MapMarker marcadorOrigem = MapMarker(
        LatLng(latitudeOrigem, longitudeOrigem),
        "assets/driver_marker.png",
        "Local motorista");

    MapMarker marcadorDestino = MapMarker(
        LatLng(latitudeDestino, longitudeDestino),
        "assets/rider_marker.png",
        "Local destino");

    _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
  }

  _statusEmViagem() {
    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Em viagem", Colors.grey, null);

    double latitudeDestino = _dadosRequisicao["destination"]["lat"];
    double longitudeDestino = _dadosRequisicao["destination"]["lng"];

    double latitudeOrigem = _dadosRequisicao["driver"]["lat"];
    double longitudeOrigem = _dadosRequisicao["driver"]["lng"];

    MapMarker marcadorOrigem = MapMarker(
        LatLng(latitudeOrigem, longitudeOrigem),
        "assets/rider_marker.png",
        "Local motorista");

    MapMarker marcadorDestino = MapMarker(
        LatLng(latitudeDestino, longitudeDestino),
        "assets/rider_marker.png",
        "Local destino");

    _exibirCentralizarDoisMarcadores(marcadorOrigem, marcadorDestino);
  }

  _exibirCentralizarDoisMarcadores(
      MapMarker marcadorOrigem, MapMarker marcadorDestino) {
    double latitudeOrigem = marcadorOrigem.place.latitude;
    double longitudeOrigem = marcadorOrigem.place.longitude;

    double latitudeDestino = marcadorDestino.place.latitude;
    double longitudeDestino = marcadorDestino.place.longitude;

    //Exibir dois marcadores
    _exibirDoisMarcadores(marcadorOrigem, marcadorDestino);

    //'southwest.latitude <= northeast.latitude': is not true
    var nLat, nLon, sLat, sLon;

    if (latitudeOrigem <= latitudeDestino) {
      sLat = latitudeOrigem;
      nLat = latitudeDestino;
    } else {
      sLat = latitudeDestino;
      nLat = latitudeOrigem;
    }

    if (longitudeOrigem <= longitudeDestino) {
      sLon = longitudeOrigem;
      nLon = longitudeDestino;
    } else {
      sLon = longitudeDestino;
      nLon = longitudeOrigem;
    }
    //-23.560925, -46.650623
    _movimentarCameraBounds(LatLngBounds(
        northeast: LatLng(nLat, nLon), //nordeste
        southwest: LatLng(sLat, sLon) //sudoeste
        ));
  }

  _statusFinalizada() async {
    //Calcula valor da corrida
    double latitudeDestino = _dadosRequisicao["destination"]["lat"];
    double longitudeDestino = _dadosRequisicao["destination"]["lng"];

    print("Finalizando a corrida");
    print("LatLng destino: " +
        latitudeDestino.toString() +
        " " +
        longitudeDestino.toString());

    double latitudeOrigem = _dadosRequisicao["origem"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["origem"]["longitude"];

    print("LatLng origem: " +
        latitudeOrigem.toString() +
        " " +
        longitudeOrigem.toString());

    double distanciaEmMetros = await Geolocator().distanceBetween(
        latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino);

    //Converte para KM
    double distanciaKm = distanciaEmMetros / 1000;

    //8 é o valor cobrado por KM
    double valorViagem = distanciaKm * 8;

    //Formatar valor viagem
    var f = new NumberFormat("#,##0.00", "pt_BR");
    var valorViagemFormatado = f.format(valorViagem);

    _alterarBotaoPrincipal(
        "Total - R\$ ${valorViagemFormatado}", Colors.green, () {});

    _marcadores = {};
    Position position =
        Position(latitude: latitudeDestino, longitude: longitudeDestino);
    _exibirMarcador(position, "assets/driver_marker.png", "Destino");

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 19);

    _movimentarCamera(cameraPosition);
  }

  _statusConfirmada() {
    if (_streamSubscriptionRequisicoes != null)
      _streamSubscriptionRequisicoes.cancel();

    _exibirCaixaEnderecoDestino = true;
    _alterarBotaoPrincipal("Chamar uber", Color(0xff1ebbd8), () {
      _chamarUber();
    });

    //adicionar listener para requisicao ativa
    _recuperaRequisicaoAtiva();

    //_recuperaUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();

    _dadosRequisicao = {};
  }

  _exibirMarcador(Position local, String icone, String infoWindow) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio), icone)
        .then((BitmapDescriptor bitmapDescriptor) {
      Marker marcador = Marker(
          markerId: MarkerId(icone),
          position: LatLng(local.latitude, local.longitude),
          infoWindow: InfoWindow(title: infoWindow),
          icon: bitmapDescriptor);

      setState(() {
        _marcadores.add(marcador);
      });
    });
  }

  _movimentarCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  _exibirDoisMarcadores(MapMarker marcadorOrigem, MapMarker marcadorDestino) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    LatLng latLngOrigem = marcadorOrigem.place;
    LatLng latLngDestino = marcadorDestino.place;

    Set<Marker> _listaMarcadores = {};
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            marcadorOrigem.pathImage)
        .then((BitmapDescriptor icone) {
      Marker mOrigem = Marker(
          markerId: MarkerId(marcadorOrigem.pathImage),
          position: LatLng(latLngOrigem.latitude, latLngOrigem.longitude),
          infoWindow: InfoWindow(title: marcadorOrigem.title),
          icon: icone);
      _listaMarcadores.add(mOrigem);
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            marcadorDestino.pathImage)
        .then((BitmapDescriptor icone) {
      Marker mDestino = Marker(
          markerId: MarkerId(marcadorDestino.pathImage),
          position: LatLng(latLngDestino.latitude, latLngDestino.longitude),
          infoWindow: InfoWindow(title: marcadorDestino.title),
          icon: icone);
      _listaMarcadores.add(mDestino);
    });

    setState(() {
      _marcadores = _listaMarcadores;
    });
  }

  _cancelarUber() async {
    FirebaseUser firebaseUser = await repository.currentUser();

    Firestore db = Firestore.instance;
    db
        .collection("requisicoes")
        .document(_idRequisicao)
        .updateData({"status": StatusRequest.CANCELADA}).then((_) {
      db.collection("requisicao_ativa").document(firebaseUser.uid).delete();
    });
  }

  _recuperaRequisicaoAtiva() async {
    FirebaseUser firebaseUser = await repository.currentUser();

    Firestore db = Firestore.instance;
    DocumentSnapshot documentSnapshot = await db
        .collection("requisicao_ativa")
        .document(firebaseUser.uid)
        .get();

    if (documentSnapshot.data != null) {
      Map<String, dynamic> dados = documentSnapshot.data;
      _idRequisicao = dados["id_requisicao"];
      print(_idRequisicao);
      _adicionarListenerRequisicao(_idRequisicao);
    } else {
      _statusUberNaoChamado();
    }
  }

  _adicionarListenerRequisicao(String idRequisicao) async {
    Firestore db = Firestore.instance;
    _streamSubscriptionRequisicoes = await db
        .collection("requisicoes")
        .document(idRequisicao)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data != null) {
        Map<String, dynamic> dados = snapshot.data;
        _dadosRequisicao = dados;
        String status = dados["status"];
        _idRequisicao = dados["id"];

        switch (status) {
          case StatusRequest.AGUARDANDO:
            _statusAguardando();
            break;
          case StatusRequest.A_CAMINHO:
            _statusACaminho();
            break;
          case StatusRequest.VIAGEM:
            _statusEmViagem();
            break;
          case StatusRequest.FINALIZADA:
            _statusFinalizada();
            break;
          case StatusRequest.CONFIRMADA:
            _statusConfirmada();
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //adicionar listener para requisicao ativa
    _recuperaRequisicaoAtiva();

    //_recuperaUltimaLocalizacaoConhecida();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileProvider(
      child: Builder(builder: (context) {
        final bloc = ProfileProvider.of(context);
        return new Scaffold(
          drawer: _drawer(bloc),
          body: Container(
            child: Stack(
              children: <Widget>[     
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _posicaoCamera,
                  onMapCreated: _onMapCreated,
                  //myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _marcadores,
                  //-23,559200, -46,658878
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    iconTheme: IconThemeData(
                      color: Colors.black,
                    ),
                    elevation: 0,
                  ),
                ),
                Visibility(
                  visible: _exibirCaixaEnderecoDestino,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 95,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.white),
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    width: 10,
                                    height: 10,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Meu local",
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, top: 0)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 55,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.white),
                            child: TextField(
                              controller: _controllerDestino,
                              decoration: InputDecoration(
                                  icon: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    width: 10,
                                    height: 10,
                                    child: Icon(
                                      Icons.local_taxi,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Digite o destino",
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, top: 5)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Padding(
                    padding: Platform.isIOS
                        ? EdgeInsets.fromLTRB(20, 10, 20, 25)
                        : EdgeInsets.all(10),
                    child: Container(
                      child: RaisedButton(
                          child: Text(
                            _textoBotao,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: _corBotao,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          onPressed: _funcaoBotao),
                    ),
                  ),
                )
              ],
            ),
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
          _listTile("Suas viagens", ViagensPage()),
          _listTile("Ajuda", AjudaPage()),
          _listTile("Pagamento", PagamentoPage()),
          _listTile("Viagens com desconto", DescontoPage()),
          _settingPage("Configurações", bloc),
        ],
      ),
    );
  }

  Widget _listTile(String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));
      },
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

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionRequisicoes.cancel();
  }
}
