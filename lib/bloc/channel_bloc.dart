import 'package:rxdart/rxdart.dart';
import 'package:bloc_provider/bloc_provider.dart';
import '../model/channel.dart';
import 'package:flamingo/flamingo.dart';

class ChannelBloc implements Bloc {
  final _channelsController = BehaviorSubject<List<Channel>>.seeded(null);
  // final _actionController = PublishSubject<void>();

  Future fetchChannels() async {
    final snapshot =  await firestoreInstance().collection(Document.path<Channel>()).limit(10).getDocuments();
    final List<Channel> channels = snapshot.documents.map((item) => Channel(snapshot: item)).toList();
    _channelsController.sink.add(channels);
  }

  Observable<List<Channel>> get channels => _channelsController.stream;

  @override
  void dispose() async {
    // await _actionController.close();
    await _channelsController.close();
  }
}