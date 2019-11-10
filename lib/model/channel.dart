import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flamingo/flamingo.dart';

class Channel extends Document<Channel> {
  Channel({String id, DocumentSnapshot snapshot, Map<String, dynamic> values,
  }): super(id: id, snapshot: snapshot, values: values);

  String name;
  String description;

  /// For save data
  @override
  Map<String, dynamic> toData() {
    final data = <String, dynamic>{};
    writeNotNull(data, 'name', name);
    return data;
  }

  /// For load data
  @override
  void fromData(Map<String, dynamic> data) {
    name = valueFromKey<String>(data, 'name');
    description = valueFromKey<String>(data, 'description');
  }

  void log() {
    print('$id $name');
  }
}