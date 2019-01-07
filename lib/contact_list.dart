
import 'package:flutter/material.dart';
import 'Contact.dart';
import 'DataBase.dart';

Future<List<Contact>> getContactsFromDB() async {
  var dbHelper = DataBaseHelper();
  Future<List<Contact>> contacts = dbHelper.getContacts();
  return contacts;
}

class MyContactList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _MyContactStateList();
}

class _MyContactStateList extends State<MyContactList> {

  final controllerName = TextEditingController();
  final controllerPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact list'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
        future: getContactsFromDB(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {

              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {

                    return Row(
                      children: <Widget>[

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                      Text(
                      snapshot.data[index].phone,
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                            ],
                          ),
                        ),

                      ],
                    );

                    }
                );
              }

            }

            return Container(
              alignment: AlignmentDirectional.center,
              child: CircularProgressIndicator(),
            );

          },
        ),
      ),
    );
  }
}




