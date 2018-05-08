import 'package:flutter/material.dart';
import './second_page.dart';
//import './random_list.dart';
import 'dart:async';
import 'save_show.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Test App',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

const List<String> tabNames = const <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _message = new Future<String>.value('');

  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  int _screen = 0;
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: tabNames.length,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('Navigation example',
                  style: new TextStyle(fontStyle: FontStyle.italic)),
            ),
            body: new TabBarView(
              children: new List<Widget>.generate(tabNames.length, (int index) {
                return new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new MaterialButton(
                        color: Colors.redAccent,
                        child: new Icon(Icons.arrow_forward_ios),
                        //child: const Text('Google'),
                        onPressed: () {
                          setState(() {
                            _message = _testSignInWithGoogle();
                          });
                        }),
                    new ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      children: <Widget>[
                        new Card(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new ListTile(
                                leading: const Icon(Icons.list),
                                title: new Text(
                                    'List of task as of for ${tabNames[index]}'),
                                subtitle: new Text(
                                    'Click View Details to see the list of tasks'),
                              ),
                              new ButtonTheme.bar(
                                // make buttons use the appropriate styles for cards
                                child: new ButtonBar(
                                  children: <Widget>[
                                    new FlatButton(
                                      child: new Text('View Details'),
                                      onPressed: () {
                                        Navigator
                                            .of(context)
                                            .pushAndRemoveUntil(
                                                new MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new ShowList()),
                                                (Route route) => route == null);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }),
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 1.0,
                child: new Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new secondPage()),
                      (Route route) => route == null);
                }),
            bottomNavigationBar: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                new AnimatedCrossFade(
                  firstChild: new Material(
                    color: Colors.blueAccent,
                    child: new TabBar(
                      isScrollable: true,
                      tabs: new List.generate(tabNames.length, (index) {
                        return new Tab(text: tabNames[index].toUpperCase());
                      }),
                    ),
                  ),
                  secondChild: new Container(),
                  crossFadeState: CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                )
              ],
            )));
  }
}
