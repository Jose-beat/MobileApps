import 'package:therapp/src/models/Terapeuta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/pages/Login/LoginApp.dart';
import 'package:therapp/src/providers/authentApp.dart';

class RegistroPerfil extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final Terapeuta terapeuta;
  final String id;
  final String email;
  RegistroPerfil(
      {Key key,
      this.terapeuta,
      this.auth,
      this.loginCallback,
      this.id,
      this.email})
      : super(key: key);

  @override
  _RegistroPerfilState createState() => _RegistroPerfilState();
}

final terapeutaReference =
    FirebaseDatabase.instance.reference().child('terapeuta');

class _RegistroPerfilState extends State<RegistroPerfil> {

  final _formKey = GlobalKey<FormState>();
  List<Terapeuta> item;

  TextEditingController _nombreController;
  TextEditingController _apellidosController;
  TextEditingController _clinicaController;
  TextEditingController _especialidadController;
  TextEditingController _telefonoController;
  TextEditingController _emailController;
  TextEditingController _cedulaController;

  @override
  void initState() {
    super.initState();

    _nombreController =
        new TextEditingController(text: widget.terapeuta.nombre);
    _apellidosController =
        new TextEditingController(text: widget.terapeuta.apellidos);
    _clinicaController =
        new TextEditingController(text: widget.terapeuta.clinica);
    _especialidadController =
        new TextEditingController(text: widget.terapeuta.especialidad);
    _telefonoController =
        new TextEditingController(text: widget.terapeuta.telefono);
    _emailController = new TextEditingController(text: widget.email);
    _cedulaController =
        new TextEditingController(text: widget.terapeuta.cedula);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Productos DB'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: ListView(
          children: <Widget>[
            registro(),
            Container(
              height: 300.0,
            )
          ],
        )),
      ),
    );
  }

  Widget registro() {
    return Form(
      key: _formKey,
          child: Column(
        
        children: <Widget>[
          
          TextFormField(
            
            keyboardType: TextInputType.text,
            controller: _nombreController,
            
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration:
                InputDecoration(icon: Icon(Icons.person), labelText: 'Nombre'),
            validator: (value){
              value=_nombreController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
             
            },
          
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _apellidosController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration:
                InputDecoration(icon: Icon(Icons.code), labelText: 'Apellidos'),
            validator: (value){
              value=_apellidosController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _clinicaController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.description), labelText: 'Clinica Actual'),
            validator: (value){
              value=_clinicaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _cedulaController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.description), labelText: 'Cedula Profesional'),
            validator: (value){
              value=_cedulaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _especialidadController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.attach_money), labelText: 'Especialidad'),
            validator: (value){
             value=_cedulaController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _telefonoController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
                icon: Icon(Icons.satellite), labelText: 'Telefono'),
            validator: (value){
              value=_telefonoController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            style: TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
            decoration: InputDecoration(
              icon: Icon(Icons.satellite),
              labelText: 'Correo Electronico',
            ),
            validator: (value){
              value=_emailController.text;
              if(value.isEmpty){
                   return 'Please enter some text';
              }else{
                 
              }
            },
          ),
        
          FlatButton(
              onPressed: () {
                if(_formKey.currentState.validate()){
                  if (widget.terapeuta.id != null) {
                  terapeutaReference.child(widget.terapeuta.id).set({
                    'nombre': _nombreController.text,
                    'apellidos': _apellidosController.text,
                    'cedula': _cedulaController.text,
                    'clinica': _clinicaController.text,
                    'especialidad': _especialidadController.text,
                    'telefono': _telefonoController.text,
                    'email': _emailController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  terapeutaReference.push().set({
                    'nombre': _nombreController.text,
                    'apellidos': _apellidosController.text,
                    'cedula': _cedulaController.text,
                    'clinica': _clinicaController.text,
                    'especialidad': _especialidadController.text,
                    'telefono': _telefonoController.text,
                    'email': _emailController.text
                  }).then((_) {
                    Navigator.pop(context);
                  });
                }
                }
                
                print('jajaja no mames ${_emailController.text}');
              },
              child: Text('Registrar'))
        ],
      ),
    );
  }
}
