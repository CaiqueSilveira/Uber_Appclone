import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_appclone/page/ui_drawer_componets/ajuda_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/configuracao_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/desconto_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/pagamento_page.dart';
import 'package:uber_appclone/page/ui_drawer_componets/viagens_page.dart';
import 'dart:async';

import 'package:uber_appclone/page/ui_profile/edit_profile.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-10.969126147329, -37.05891251564),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-10.969126147329, -37.05891251564),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('GO!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
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
