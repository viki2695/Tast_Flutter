import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
//import './random_list.dart';
import 'save_show.dart';
import 'package:firebase_database/firebase_database.dart';

class secondPage extends StatefulWidget {
  @override
  State createState() => new secondPageState();
  final mainReference = FirebaseDatabase.instance.reference();
}

class secondPageState extends State<secondPage> {
  
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime _value;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2015),
        lastDate: new DateTime(2020));

    if (picked != null && picked != _date) {
      print("Date selected ${_date.toString()}");
      setState(() {
        _date = picked;
        date = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  String date = "";
  String time = "";

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time
    );
    if (picked != null && picked != _time) {
      print("Time selected ${_time.toString()}");
      setState(() {
        _time = picked;
        time = picked.format(context);
      });
    }
  }

  List<String> title = new List();
  List<String> desc = new List();
  String result = "";
  String result1 = "";
  String dropdown3Value = '00';
  String dropdown2Value = '00';

  @override
  Widget build(BuildContext context) {
    var _textController_title = new TextEditingController();
    var _textController_desc = new TextEditingController();
    var _textController_date = new TextEditingController();

    return new Material(
        child: new Scaffold(
      appBar: new AppBar(
        title: new Text("Add New Task"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new MyHomePage()),
                  (Route route) => route == null);
            }),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.done),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new MyHomePage()),
                  (Route route) => route == null);
            },
          )
        ],
      ),
      body: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.only(top: 16.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'Set up Remainder',
                    style: new TextStyle(
                        fontSize: 35.0,
                        fontFamily: 'Roboto',
                        color: Colors.lightBlueAccent),
                  )
                ],
              ),
            ),
            new TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                labelText: 'Task title',
              ),
              onChanged: (String str) {
                setState(() {
                  result = str;
                });
              },
            ),
            new TextField(
              textAlign: TextAlign.start,
              decoration: new InputDecoration(
                labelText: 'Task Description',
              ),
              onChanged: (String str1) {
                setState(() {
                  result1 = str1;
                });
              },
            ),
            
            new ListTile(
              title: new Text("Date"),
              trailing: new FlatButton.icon(
                label: new Text("${_date.day}-${_date.month}-${_date.year}",
                    style: new TextStyle(
                      fontSize: 25.0
                    )
                  ),
                icon: new Icon(Icons.date_range),
                onPressed: (){_selectDate(context);
                  //date = "${_date.day}-${_date.month}-${_date.year}";
                },
              ),
            ),

            new ListTile(
              title: new Text("Time"),
              trailing: new FlatButton.icon(
                label: new Text("${_time.format(context)}",
                    style: new TextStyle(
                      fontSize: 25.0
                    )
                  ),
                icon: new Icon(Icons.access_time),
                onPressed: (){_selectTime(context);
                  //time = "${_time.format(context)}";
                },
              ),
            ),

            new RaisedButton(
              color: Colors.lightBlueAccent,
              child: new Text("Save and show"),
              onPressed: () {
                final mainReference =
                    FirebaseDatabase.instance.reference().child("task");
                mainReference
                    .push()
                    .set({'Title': result, 'Description': result1, 'Date': date, 'Time': time});
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new ShowList()),
                    (Route route) => route == null);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
