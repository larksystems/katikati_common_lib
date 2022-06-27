// This generated file is imported by "conversation_list_shard.dart" residing in the same directory as this file
// and should not be imported or exported by any other file.
//
//   Source File  : Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_conversation_list_shard.dart
//   Source SHA   : 35411de5eb53c73af66839eba92e9a7e9a34cbd17a4a6fb3ce355e8ec9ac74a1
//   Generated by : danrubel
//
// Use "kktool codegen Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_conversation_list_shard.dart" to regenerate this file.
// Adjust the imports as necessary as they are preserved when the code is regenerated.

import 'dart:async';

import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart';
import 'package:katikati_ui_lib/components/logger.dart';

class ConversationListShard {
  static const collectionName = 'nook_conversation_shards';

  String docId;
  String name;
  int num_shards;

  // Alias
  int get numShards => num_shards;

  set numShards(int value) => num_shards = value;

  String get conversationListShardId => docId;

  static ConversationListShard fromSnapshot(DocSnapshot doc, [ConversationListShard modelObj]) => fromData(doc.data, modelObj)..docId = doc.id;

  static ConversationListShard fromData(data, [ConversationListShard modelObj]) {
    if (data == null) return null;
    (modelObj ??= ConversationListShard())
      ..name = data['name']?.toString()
      ..num_shards = int_fromData(_log, 'num_shards', data);
    return modelObj;
  }

  static StreamSubscription listen(DocStorage docStorage, ConversationListShardCollectionListener listener,
          {String collectionRoot = '/$collectionName', List<DocQuery> queryList, OnErrorListener onError, @Deprecated('use onError instead') OnErrorListener onErrorListener}) =>
      listenForUpdates<ConversationListShard>(_log, docStorage, listener, collectionRoot, ConversationListShard.fromSnapshot, queryList: queryList, onError: onError ?? onErrorListener);

  Map<String, dynamic> toData({bool validate: true}) {
    return {
      if (name != null) 'name': name,
      if (num_shards != null) 'num_shards': num_shards,
    };
  }

  @override
  String toString() => 'ConversationListShard($docId, ${toData(validate: false)})';
}

typedef ConversationListShardCollectionListener = void Function(
  List<ConversationListShard> added,
  List<ConversationListShard> modified,
  List<ConversationListShard> removed,
);

final _log = Logger('conversation_list_shard.g.dart');
