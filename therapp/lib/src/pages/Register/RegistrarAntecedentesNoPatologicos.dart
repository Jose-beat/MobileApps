import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:therapp/src/models/AntecedentesNoPatologicos.dart';
import 'package:therapp/src/models/AntecedntesPatologicos.dart';

class ResAntecedentesNoPatologicos extends StatefulWidget {
  final AntecedentesNoPatologicos antecedentesNoPatologicos;
 
  ResAntecedentesNoPatologicos({Key key,  this.antecedentesNoPatologicos}) : super(key: key);

  @override
  _ResAntecedentesNoPatologicosState createState() => _ResAntecedentesNoPatologicosState();
}
final antecedentesNoPatologicosReference = FirebaseDatabase.instance.reference().child('antecedentes_no_patologicos');
class _ResAntecedentesNoPatologicosState extends State<ResAntecedentesNoPatologicos> {
  List<AntecedentesNoPatologicos>items;
  
  TextEditingController _enfermedadController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _enfermedadController = new TextEditingController(text: widget.antecedentesNoPatologicos.enfermedad);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),

      body: ListView(
      children: <Widget>[
        Container(
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _enfermedadController,
                    style: TextStyle(fontSize: 17.0, color: Colors.pink),
                    decoration: InputDecoration(icon: Icon(Icons.archive),
                    labelText: 'Enfermedad'
                    ),
                  ),
                  FlatButton(onPressed: (){
                    if(widget.antecedentesNoPatologicos.id!=null){
                      antecedentesNoPatologicosReference.child(widget.antecedentesNoPatologicos.id).set({
                        'motivos_consulta':_enfermedadController.text,
                        'paciente':widget.antecedentesNoPatologicos.idpaciente
                      }).then((_){
                        Navigator.pop(context);
                      });
                    }else{
                      antecedentesNoPatologicosReference.push().set({
                        'motivos_consulta':_enfermedadController.text,
                        'paciente':widget.antecedentesNoPatologicos.idpaciente
                      }).then((_){
                        Navigator.pop(context);
                      });
                    }
                  }, child: Text('Añadir Antecedente patologico'))

                ],
              ),
            ),
          ),
        )
      ],     
         
    
    )
    );
    
    
  }
}