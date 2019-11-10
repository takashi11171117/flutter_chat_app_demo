import 'package:flutter/material.dart';
import '../components/login_dialog.dart';
import '../../bloc/channel_bloc_provider.dart';
import '../../bloc/channel_bloc.dart';
import '../../model/channel.dart';

class ChannelListScreenStateful extends StatefulWidget {
  @override
  _ChannelListScreenStatefulState createState() => _ChannelListScreenStatefulState();
}

class _ChannelListScreenStatefulState extends State<ChannelListScreenStateful> {
  ChannelBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChannelBloc();
  }

  @override
  Widget build(BuildContext context) {
    return ChannelBlocProvider(
      bloc: _bloc,
      child: ChannelListScreen(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class ChannelListScreen extends StatelessWidget {
  Widget build(context) {
    final bloc = ChannelBlocProvider.of(context);
    bloc.fetchChannels();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Channel List"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              print("login");
              loginDialog(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: bloc.channels,
            builder: (context, snapshot){
              if (!snapshot.hasData) return const Text('Loading...');
              return ListView.builder(
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) => buildListItem(context, snapshot.data[index]),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // print("Pressed new button");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       settings: const RouteSettings(name: "/new"),
            //       builder: (context) => ChannelEditScreen(null)
            //   ),
            // );
          }
      ),
    );
  }

  Widget buildListItem(BuildContext context, Channel document){
    return Card(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.android),
              title: Text(document.name),
              subtitle: Text(document.description),
            ),
            ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                        child: const Text("Edit"),
                        onPressed: ()
                        {
                          print("Pressed edit button");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       settings: const RouteSettings(name: "/edit"),
                          //       builder: (BuildContext context) => ChannelEditScreen(document)
                          //   ),
                          // );
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
