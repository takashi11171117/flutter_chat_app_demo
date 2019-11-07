import 'package:flutter/material.dart';

class ChannelEditScreen extends StatefulWidget {
  @override
  ChannelEditScreenState createState() => ChannelEditScreenState();
}

class ChannelEditScreenState extends State<ChannelEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                print("Pressed save button");
              }
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              print("Pressed delete button");
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
        Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'channel name',
                  labelText: 'name',
                ),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'description',
                  labelText: 'description',
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:8.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}