import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/Paciente.dart';
import 'package:therapp/src/models/Terapeuta.dart';
import 'package:therapp/src/pages/Register/RegistrarPaciente.dart';
import 'package:therapp/src/pages/Register/RegistroPerfil.dart';
import 'package:therapp/src/pages/View/Calendar.dart';
import 'package:therapp/src/pages/View/HomePage.dart';
import 'package:therapp/src/pages/View/VerConsultas.dart';
import 'package:therapp/src/pages/View/VerTerapeuta.dart';
import 'package:therapp/src/providers/authentApp.dart';


//ESTA CLASE SOLO SERA LA CARCASA DE CADA PAGINA PRINCIPAL 
class NavigationAppBar extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;
  final String userId;
  NavigationAppBar(
      {Key key,
      this.auth,
      this.loginCallback,
      this.logoutCallback,
      this.userId})
      : super(key: key);

  @override
  _NavigationAppBarState createState() => _NavigationAppBarState();
}
//METODO PARA LA BASE DE DATOS 
final terapeutaReference =
    FirebaseDatabase.instance.reference().child('terapeuta');



class _NavigationAppBarState extends State<NavigationAppBar> {

  //METODOS INICIALES
  Color colorTema = Colors.orange;
  Color colorSubTema = Colors.teal[300];
  StreamSubscription<Event> _onTerapeutaAddedSubscription;
  StreamSubscription<Event> _onTerapeutaChangedSubscription;
  List<Terapeuta> items;
  String imagenTerapeuta;

  //METODOS AL INICIAR LA APP 
  @override
  void initState() {
    super.initState();
    items = new List();
    _onTerapeutaAddedSubscription =
        terapeutaReference.onChildAdded.listen(_onTerapeutaAdded);
    _onTerapeutaChangedSubscription =
        terapeutaReference.onChildChanged.listen(_onTerapeutaUpdated);
  }


//DESTRUCCION DE VARIABLES VITALES
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onTerapeutaAddedSubscription.cancel();
    _onTerapeutaChangedSubscription.cancel();
  }
//METODOS PAR EL CONTROL DE BOTONES DEL MENU
  String titulo = 'Lista de pacientes';


  int _cIndex = 0;
//METODO PARA INCREMENTAR LA VARIABLES DE PAGINA 
  void _incrementTab(int index) {
    setState(() {
      _cIndex = index;
    });
  }
//METODO PARA CERRAR SESION
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
//METODO PARA DIBUJAR CADA PANTALLA INDICADA
  @override
  Widget build(BuildContext context) {
/*El arrelgo que contiene  acada una de las 
pantallas mostrar al usuario segun indique en los botones de navegacion*/
    List<Widget> _opciones = [
      /*Pagia principal*/
      HomePage(
        auth: widget.auth,
        loginCallback: widget.loginCallback,
        logoutCallback: widget.logoutCallback,
        userId: widget.userId,
      ),
      /*Pagina de calendario*/
      ConsultasActuales(
        idTerapeuta: widget.userId,
      ),

/*Pagina para crear el expediente de paciente */
      RegistrarPaciente(
        paciente: Paciente(null, '', '', '', 0, '', '', widget.userId, ''),
        userId: widget.userId,
        app: false,
      ),
      VerTerapeuta(
        activado: false,
        userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback,
      )
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //MOSTRAREMOS UN MENU DESPLEGABLE
          drawer: Drawer(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, position) {
                return _filter(context, position);
              },
            ),
          ),
          appBar: AppBar(
            elevation: 0.0,
            title: Text(titulo, style: TextStyle(color: Colors.white)),
            backgroundColor: colorTema,
            actionsIconTheme: IconThemeData(color: Colors.black),
            
          ),

          /*Aqui se muestra la pantalla indicada por el metodo elementAt seugn la lista*/
          body: Center(child: _opciones.elementAt(_cIndex)),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: colorSubTema,
            currentIndex: _cIndex,
            type: BottomNavigationBarType.fixed,
            /*-----------------------------------CONJUNTO DE ICONOS DE NAVEGACION ENTRE INTERFACES DE LA APP-----------------------*/

            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.assignment_ind,
                  size: 20.5,
                ),
                icon: Icon(
                  Icons.assignment_ind,
                  color: Colors.grey,
                  size: 20.5,
                ),
                title: Text(
                  'Expedientes',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.calendar_today,
                  size: 20.5,
                ),
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                  size: 20.5,
                ),
                title: Text(
                  'Calendario',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.person_add,
                    size: 20.5,
                  ),
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.grey,
                    size: 20.5,
                  ),
                  title: Text(
                    'Añadir Paciente',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
              BottomNavigationBarItem(
                  activeIcon: Icon(Icons.person, size: 20.5),
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 20.5,
                  ),
                  title: Text(
                    'Perfil',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  )),
            ],
            /*Ejecucion del metodo que incrementa la variable index que controla la posicion de las paginas en la pantalla principal */
            onTap: (index) {
              _incrementTab(index);
              titulos(index);
            },
          )),
    );
  }

  /*-------------------------METODO QUE INICIALIZA EL REGISTRO DE UN PACIENTE---------------------------*/

  void _createNewPaciente(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistrarPaciente(
                  paciente:
                      Paciente(null, '', '', '', 0, '', '', widget.userId, ''),
                  userId: widget.userId,
                )));
  }

/*---------------BOTON DE PERFIL--------------------------------*/

  void titulos(int posicion) {
    switch (posicion) {
      case 0:
        titulo = 'Lista de pacientes';
        break;
      case 1:
        titulo = 'Calendario de consultas';
        break;
      case 2:
        titulo = 'Registro de pacientes';
        break;
      case 3:
        titulo = 'perfil';
        break;
      case 4:
        titulo = 'Otra funcion';
        break;

      default:
    }
  }


/*-------------------------------------OPCIONES DESPLEGABLES----------------------------*/

/*-------------------------------------------------------BACKEND--------------------------------------- */

  void _onTerapeutaAdded(Event event) {
    setState(() {
      items.add(new Terapeuta.fromSnapshot(event.snapshot));
    });
  }

  void _onTerapeutaUpdated(Event event) {
    var oldTerapeutaValue =
        items.singleWhere((terapeuta) => terapeuta.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldTerapeutaValue)] =
          new Terapeuta.fromSnapshot(event.snapshot);
    });
  }

  void _deleteTerapeuta(
      BuildContext context, Terapeuta terapeuta, int position) async {
    await terapeutaReference.child(terapeuta.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
        widget.auth.deleteUser();
        return signOut;
      });
    });
  }

  void _navigateToTerapeuta(BuildContext context, Terapeuta terapeuta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistroPerfil(
                terapeuta: terapeuta,
                email: terapeuta.email,
                imagenPerfil: false,
              )),
    );
  }

/*-------------------------------------FRONTEND DEL MENU DESPLEGABLE-----------------------------*/

  Widget _filter(BuildContext context, int position) {
    print("Usuario Actual :${items[position].id}");
    print("USER ID: ${widget.userId}");

    if (items[position].id == widget.userId) {
      print('${items[position].id}');

      return Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: colorSubTema,
            ),
            onDetailsPressed: () {
              Navigator.pop(context);
            },
            accountName:
                Text("${items[position].nombre} ${items[position].apellidos}"),
            accountEmail: Text("${items[position].email}"),
            currentAccountPicture: ClipOval(
              child: FadeInImage(
                fit: BoxFit.cover,
                width: 150.0,
                height: 150.0,
                fadeInCurve: Curves.bounceIn,
                placeholder: AssetImage('assets/images/icon-app.jpeg'),
                image: items[position].imagen != null
                    ? NetworkImage(items[position].imagen + '?alt=media')
                    : AssetImage('assets/images/photo-null.jpeg'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil de usuario'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerTerapeuta(
                            activado: true,
                            userId: widget.userId,
                            auth: widget.auth,
                            logoutCallback: widget.logoutCallback,
                          )));
            },
          ),
          Divider(
            height: 280.0,
          ),
          ListTile(
              leading: Icon(
                Icons.keyboard_capslock,
                color: Colors.red,
              ),
              title: Text(
                'Cerrar Sesion',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: signOut),
          Divider(
            height: 7.0,
          ),
        ],
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }
}
