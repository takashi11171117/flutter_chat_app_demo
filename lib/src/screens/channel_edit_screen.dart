import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelEditScreen extends StatefulWidget {
  ChannelEditScreen(this.document);
  final DocumentSnapshot document;

  @override
  ChannelEditScreenState createState() => ChannelEditScreenState();
}

class FormData {
  String name;
  String description ;
  DateTime createdAt = DateTime.now();
}

class ChannelEditScreenState extends State<ChannelEditScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FormData data = FormData();

  @override
  Widget build(BuildContext context) {
    DocumentReference mainReference;
    mainReference = Firestore.instance.collection('channel').document();
    bool deleteFlg = false;
    if (widget.document != null) {
      if(data.name == null && data.description == null) {
        data.name = widget.document['name'];
        data.description = widget.document['description'];
        data.createdAt = widget.document['created_at'].toDate();
      }
      mainReference = Firestore.instance.collection('channel').
      document(widget.document.documentID);
      deleteFlg = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                print("Pressed save button");
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  mainReference.setData(
                      {
                        'name': data.name,
                        'description': data.description,
                        'created_at': data.createdAt
                      }
                  );
                  Navigator.pop(context);
                }
              }
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: !deleteFlg ? null : () {
              print("Pressed delete button");
              mainReference.delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
        Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              nameField(),
              descriptionField(),
              Padding(padding: const EdgeInsets.only(top:8.0)),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Channel Name',
        hintText: '5 channel',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        data.name = value;
      },
      initialValue: data.name,
    );
  }
  
  Widget descriptionField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'This is 5 channel.',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is required';
        }
        return null;
      },
      onSaved: (String value) {
        data.description = value;
      },
      initialValue: data.description,
    );
  }
}