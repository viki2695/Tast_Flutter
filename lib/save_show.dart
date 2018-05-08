import 'package:flutter/material.dart';
import './second_page.dart';
import 'main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';

class ShowList extends StatefulWidget {
  @override
  createState() => new ShowListState();
}

class ShowListState extends State<ShowList> {
  final reference = FirebaseDatabase.instance.reference().child('task');
  final DataSnapshot snapshot;
  List<String> _todoName = new List();
  List<String> _todoDesc = new List();
  List<String> _todoDate = new List();
  List<String> _todoTime = new List();

  StreamSubscription _subscriptionTodo;

  @override
  void initState() {
    FirebaseTodos.getTodo().then(_updateTodo);

    //FirebaseTodos.getTodoStream("-LAmYPWvipzJg8XZc7KC", _updateTodo).then((StreamSubscription s) => _subscriptionTodo = s);
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  @override
  build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Task To do"),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new MyHomePage()),
                    (Route route) => route == null);
              }),
        ),
        body: new ListView.builder(
          itemCount: _todoName.length,
          itemBuilder: (BuildContext context, int index) {
            return new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(_todoName[index]),
                  subtitle: new Text(_todoDesc[index]),
                  trailing: new Text("${_todoDate[index]} - ${_todoTime[index]}")
                ),
                new Divider(height: 2.0,),
              ],
            );
          },
        )
      );
  }

  _updateTodo(Todo value) {
    var len = value.title.length;

    setState(() {
      for( int j = 0; j < len; j++) {
      _todoName.add(value.title[j]);
      _todoDesc.add(value.desc[j]);
      _todoDate.add(value.date[j]);
      _todoTime.add(value.time[j]);
      }
      print(_todoName); 
    });
  }
}

class Todo {
  final String key;
  List<String> title = new List();
  List<String> desc = new List();
  List<String> date = new List();
  List<String> time = new List();

  Todo.fromJson(this.key, Map data) {
    for (var task in data.keys) {
      //print('$task was written by ${data[task]}');
      title.add(data[task]['Title']);
      desc.add(data[task]['Description']);
      date.add(data[task]['Date']);
      time.add(data[task]['Time']);
    }
  }
}

class FirebaseTodos {
  static Future<StreamSubscription<Event>> getTodoStream(
      String todoKey, void onData(Todo todo)) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child(todoKey)
        .onValue
        .listen((Event event) {
      var todo = new Todo.fromJson(event.snapshot.key, event.snapshot.value);
      onData(todo);
    });

    return subscription;
  }

  static Future<Todo> getTodo() async {
    Completer<Todo> completer = new Completer<Todo>();

    FirebaseDatabase.instance
        .reference()
        .child("task")
        .once()
        .then((DataSnapshot snapshot) {
      var todo;
      todo = new Todo.fromJson(snapshot.key, snapshot.value);
      completer.complete(todo);
    });

    return completer.future;
  }
}
