import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_provider/bloc_provider.dart';
import '../model/channel.dart';
import 'package:flamingo/flamingo.dart';

class ChannelBloc implements Bloc {
  final _channelsController = BehaviorSubject<List<Channel>>.seeded(null);

  final _loadFirstPageController = PublishSubject<void>();
  final _loadMoreController = PublishSubject<void>();
  final _limit = 6;
  var _isLoading = false;
  Timestamp _lastTimestamp;
  List<Channel> allChannels = [];

  ChannelBloc() {
    _loadFirstPageController.stream.listen((_) async {
      if (!_isLoading) {
        _isLoading = true;
        final snapshot =  await firestoreInstance().collection(Document.path<Channel>()).orderBy('createdAt', descending: true).limit(_limit).getDocuments();
        allChannels = snapshot.documents.map((item) => Channel(snapshot: item)).toList();
        _channelsController.sink.add(allChannels);
        _lastTimestamp = allChannels.last.createdAt;
        _isLoading = false;
      }
    });

    _loadMoreController.stream.throttleTime(Duration(milliseconds: 500)).listen((_) async {
      if (!_isLoading) {
        _isLoading = true;
        final snapshot =  await firestoreInstance().collection(Document.path<Channel>()).where("createdAt", isLessThan: _lastTimestamp).orderBy("createdAt", descending: true).limit(_limit).getDocuments();
        final channels = snapshot.documents.map((item) => Channel(snapshot: item)).toList();
        allChannels = <Channel>[
          ...allChannels,
          ...channels,
        ];
        _channelsController.sink.add(allChannels);
        _lastTimestamp = allChannels.last.createdAt;
        _isLoading = false;
      }
    });
  }

  Observable<List<Channel>> get channels => _channelsController.stream;

  Sink<void> get loadMore => _loadMoreController.sink;
  Sink<void> get loadFirstPage => _loadFirstPageController.sink;

  Future<void> refresh() async {
    _loadFirstPageController.add(null);
  }

  @override
  void dispose() async {
    await _channelsController.close();
    await _loadFirstPageController.close();
    await _loadMoreController.close();
  }
}