import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_bloc.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_provider.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/ajuda_page.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/desconto_page.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/pagamento_page.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/viagens_page.dart';
import 'package:geolocator/geolocator.dart';

class Painel extends StatefulWidget {
  final FirebaseUser currentUser;

  Painel({Key key, @required this.currentUser}) : super(key: key);
  @override
  State<Painel> createState() => PainelState();
}

class PainelState extends State<Painel> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-23.563999, -46.653256));
  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _addListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 19);

      _movCamera(_posicaoCamera);
    });
  }

  _ultimaLocalizacao() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);

        _movCamera(_posicaoCamera);
      }
    });
  }

  _movCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    _ultimaLocalizacao();
    _addListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileProvider(
      child: Builder(builder: (context) {
        final bloc = ProfileProvider.of(context);
        return new Scaffold(
          appBar: AppBar(
            title: Text("Uber"),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            elevation: 0,
            backgroundColor: Colors.black,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        child: FlatButton(
                          child: _header(widget.currentUser?.photoUrl),
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
                          widget.currentUser?.displayName,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Align(
                        child: Text(
                          widget.currentUser?.email,
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
          ),
          body: Container(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _posicaoCamera,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  //-23,559200, -46,658878
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
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
                                color: Colors.green,
                              ),
                            ),
                            hintText: "Meu local",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15, top: 16)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 55,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white),
                      child: TextField(
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
                            contentPadding: EdgeInsets.only(left: 15, top: 16)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: RaisedButton(
                        child: Text(
                          "Chamar Uber",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Color(0xff1ebbd8),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        onPressed: () {}),
                  ),
                )
              ],
            ),
          ),
        );
      }),
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
      return Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 0, 30.0),
        child: Container(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
        ),
      );
    }
  }
}