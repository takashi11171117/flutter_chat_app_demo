import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'channel_edit_screen.dart';

class ChannelListScreen extends StatefulWidget {
  @override
  ChannelListScreenState createState() => ChannelListScreenState();
}

class ChannelListScreenState extends State<ChannelListScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Channel List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('channel').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if (!snapshot.hasData) return const Text('Loading...');
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) => buildListItem(context, snapshot.data.documents[index]),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            print("Pressed new button");
            Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: "/new"),
                  builder: (BuildContext context) => ChannelEditScreen()
              ),
            );
          }
      ),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot document){
    return Card(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.android),
              title: Text(document['name']),
              subtitle: Text(document['description']),
            ),
            ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        child: const Text("Edit"),
                        onPressed: ()
                        {
                          print("Pressed edit button");
                        }
                    ),
                  ],
                )
            ),
          ]
      ),
    );
  }
}