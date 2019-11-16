import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_appclone/page/ui_drawer_componets/ajuda_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/configuracao_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/desconto_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/pagamento_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/viagens_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_appclone/page/ui_profile/edit_profile.dart';

class Painel extends StatefulWidget {
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
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            'CS',
                            style: TextStyle(color: Colors.black),
                          )),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ));
                      },
                    ),
                  ),
                  Container(
                    height: 12.0,
                  ),
                  Align(
                    child: Text(
                      "Caíque Silveira",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Align(
                    child: Text(
                      "caiquesilveira@gmail.com",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
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
            _listTile("Configurações", ConfiguracaoPage()),
          ],
        ),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          //-23,559200, -46,658878
        ),
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
}
