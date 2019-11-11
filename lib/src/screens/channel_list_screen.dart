import 'package:flutter/material.dart';
import '../components/login_dialog.dart';
import '../../bloc/channel_bloc_provider.dart';
import '../../bloc/channel_bloc.dart';
import '../../model/channel.dart';
import '../../utils/date_util.dart';

class ChannelListScreenStateful extends StatefulWidget {
  @override
  _ChannelListScreenStatefulState createState() => _ChannelListScreenStatefulState();
}

class _ChannelListScreenStatefulState extends State<ChannelListScreenStateful> {
  ChannelBloc _bloc;
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const offsetVisibleThreshold = 50;

  @override
  void initState() {
    super.initState();
    _bloc = ChannelBloc();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return ChannelBlocProvider(
      bloc: _bloc,
      child: ChannelListScreen(_scaffoldKey, _scrollController),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset + offsetVisibleThreshold >=
      _scrollController.position.maxScrollExtent) {
      _bloc.loadMore.add(null);
    }
  }
}

class ChannelListScreen extends StatelessWidget {
  ChannelListScreen(this._scaffoldKey, this._scrollController);
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ScrollController _scrollController;

  Widget build(context) {
    final _bloc = ChannelBlocProvider.of(context);
    _bloc.loadFirstPage.add(null);

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
        child: RefreshIndicator(
          child: StreamBuilder(
            stream:  _bloc.channels,
            builder: (context, snapshot){
              if (!snapshot.hasData) return CircularProgressIndicator();
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: snapshot.data.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, index) => buildListItem(context, snapshot.data[index]),
              );
            },
          ),
          onRefresh: _bloc.refresh,
        )
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
              subtitle: Column(
                children: <Widget>[
                  Text(document.description),
                  Text(DateUtil.dateToString(document.createdAt.toDate(), 'yyyy/MM/dd')),
                ]
              ),
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
