import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Contact.dart';
import 'DataBase.dart';
import 'contact_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Contact contact = new Contact();
  String name, phone;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Create contact'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.view_list),
            tooltip: 'View list',
            onPressed: () => startContactList,
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Name"),
              validator: (val) => val.length == 0 ? 'Enter your name' : null,
              onSaved: (val) => this.name = val,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Phone"),
              validator: (val) => val.length == 0 ? 'Enter your phone' : null,
              onSaved: (val) => this.phone = val,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                child: Text('Submit'),
                  onPressed: submitContact
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  startContactList() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyContactList()));
  }

  submitContact() {

    if (this.formKey.currentState.validate())
      formKey.currentState.save();
    else
      return null;

    var contact = Contact();
    contact.name = name;
    contact.phone = phone;

    var dbHelper = DataBaseHelper();
    dbHelper.addNewContact(contact);
    Fluttertoast.showToast(
        msg: 'Contact created!',
        toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.lightBlue,
        textColor: Colors.white,
    );

  }

}
