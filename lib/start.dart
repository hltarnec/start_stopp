import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin{
  static Color bleuC = Color(0xFF74b9ff);
  static Color bleuF = Color(0xFF4da6ff);
  Symptome _selectedSymptome;
  List<Symptome> symptomesList = [
    new Symptome('Douleurs au ventre', <Drug>[new Drug('Vitamine C')]),
    new Symptome('Chute de tension', <Drug>[new Drug('Ketamine')]),
  ];
  List<Drug> _drugs = [];
  Widget _widget = Text(
        "Veuillez renseigner les symptômes du patient",
        style: TextStyle(
          fontSize: 22,
          color: bleuF,
        ),
        textAlign: TextAlign.center,
  );

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ListTile(
                  leading: Container(
                    width: 50.0,
                    height: 50.0,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/launcher/drug.png'),
                      backgroundColor: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: bleuF,
                      ),
                      shape: BoxShape.circle
                    ),
                  ),
                  title: Text(
                    'Start & Stopp App',
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.error_outline, color: Colors.red),
                title: Text(
                  'Scanner d\'Ordonnance',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new HomePage()
                    ),
                  );
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  'Sélecteur de Symptômes',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new StartPage()
                    ),
                  );
                },
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.help, color: bleuF),
                title: Text(
                  'Aide et commentaires',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Contacter le développeur"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Text(
                              "N'hésitez pas à me contacter pour toutes questions ou commentaires concernant l'utilisation ou le développement de l'application.\n",
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              "antoineconqui@gmail.com",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: bleuF)
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Ok",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      );
                    }
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: bleuC,
          centerTitle: true,
          title: Text(
            'Sélecteur de Symptômes',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'OpenSans',
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {},
            ),
          ],
        ),
        body: _buildBody(),
        // floatingActionButton: Container(
        //   height: 200,
        //   child: Stack(
        //     children: <Widget>[
        //       Align(
        //         alignment: Alignment.bottomRight,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: <Widget>[
        //             Container(
        //               height: 60,
        //               child: FloatingActionButton(
        //                 heroTag: 'olderThan65',
        //                 onPressed: (){
        //                   setState(() {
        //                     _olderThan65 = !_olderThan65; 
        //                   });
        //                 },
        //                 backgroundColor: (_olderThan65) ? bleuF : Colors.white,
        //                 foregroundColor: (_olderThan65) ? Colors.white : bleuF,
        //                 shape: CircleBorder(
        //                   side: BorderSide(
        //                     color: bleuF,
        //                     width: 2,
        //                   ),
        //                 ),
        //                 child: Text(
        //                   '+65',
        //                   style: TextStyle(
        //                     fontSize: 20,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ),
    );
  }

  Widget _buildBody(){
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: new DropdownButton<Symptome>(
              value: _selectedSymptome,
              items: symptomesList.map((Symptome symptome) {
                return new DropdownMenuItem<Symptome>(
                  value: symptome,
                  child: new Text(symptome.name),
                );
              }).toList(),
              onChanged: (Symptome symptome) {
                setState(() {
                  _selectedSymptome = symptome;
                  _drugs = symptome.drugsToGive;
                });
              },
              hint: Text('Choisissez un symptôme'),
            )
          ),
          _buildList(),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_drugs.length == 0)
      return Expanded(
        child:Container(
          child: Center(
            child: _widget,
          ),
        ),
      );
    return Expanded(
      child:Column(
        children: <Widget>[
          Center(
            child: Text(
              _selectedSymptome.name,
              style: TextStyle(
                fontSize: 36 
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: bleuF,
                ),
                padding: const EdgeInsets.all(1.0),
                itemCount: _drugs.length,
                itemBuilder: (context, i) {
                  return _buildRow(_drugs[i]);
              }),
            ),
          ),
        ]
      )
    );
  }

  Widget _buildRow(drug) {
      return ListTile(
        leading: Icon(
          Icons.check,
          color: Colors.green,
        ),
        title: Padding(
          padding: EdgeInsets.fromLTRB(40.0,0.0,0.0,0.0),
          child: Text(
            drug.name,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
        ),
      );
  }


  dialog(BuildContext context){
    
  }

  String eachfirstUpper(String string){
    List<String> list = [];
    string.split(' ').forEach((word) {
      list.add(word[0].toUpperCase()+word.substring(1).toLowerCase());
    });
    return list.join(' ');
  }
}

class Drug {
  String name;

  Drug(this.name);
  Drug.fromMap(map) : name = map['name'];
}

class Symptome {
  String name;
  List<Drug> drugsToGive;

  Symptome(this.name, this.drugsToGive);
  Symptome.fromMap(map) : name = map['name'], drugsToGive = map['drugsToGive'];
}