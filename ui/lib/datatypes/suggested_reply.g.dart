// This generated file is imported by "suggested_reply.dart" residing in the same directory as this file
// and should not be imported or exported by any other file.
//
//   Source File  : Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_suggested_reply.dart
//   Source SHA   : bf74bb838e913b39ce54677cfcd74c2ceff45816bf13b9f5faa3d91856d06611
//   Generated by : mariana
//
// Use "kktool codegen Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_suggested_reply.dart" to regenerate this file.
// Adjust the imports as necessary as they are preserved when the code is regenerated.

import 'dart:async';

import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart';
import 'package:katikati_ui_lib/components/logger.dart';

class SuggestedReply {
  static const collectionName = 'suggestedReplies';

  String docId;
  String text;
  String translation;
  String shortcut;
  int seq_no;
  String category_id;
  String category;
  int category_index;
  String group_id;
  String group_description;
  int group_index_in_category;
  int index_in_group;

  // Alias
  int get seqNumber => seq_no;
  String get categoryId => category_id;
  String get categoryName => category;
  int get categoryIndex => category_index;
  String get groupId => group_id;
  String get groupName => group_description;
  int get groupIndexInCategory => group_index_in_category;
  int get indexInGroup => index_in_group;

  set seqNumber(int value) => seq_no = value;
  set categoryId(String value) => category_id = value;
  set categoryName(String value) => category = value;
  set categoryIndex(int value) => category_index = value;
  set groupId(String value) => group_id = value;
  set groupName(String value) => group_description = value;
  set groupIndexInCategory(int value) => group_index_in_category = value;
  set indexInGroup(int value) => index_in_group = value;

  String get suggestedReplyId => docId;

  Map<String, dynamic> otherData;

  static SuggestedReply fromSnapshot(DocSnapshot doc, [SuggestedReply modelObj]) => fromData(doc.data, modelObj)..docId = doc.id;

  static SuggestedReply fromData(data, [SuggestedReply modelObj]) {
    if (data == null) return null;
    (modelObj ??= SuggestedReply())
      ..text = data['text']?.toString()
      ..translation = data['translation']?.toString()
      ..shortcut = data['shortcut']?.toString()
      ..seq_no = int_fromData(_log, 'seq_no', data)
      ..category_id = data['category_id']?.toString()
      ..category = data['category']?.toString()
      ..category_index = int_fromData(_log, 'category_index', data)
      ..group_id = data['group_id']?.toString()
      ..group_description = data['group_description']?.toString()
      ..group_index_in_category = int_fromData(_log, 'group_index_in_category', data)
      ..index_in_group = int_fromData(_log, 'index_in_group', data)
      ..otherData = {};
    for (var key in data.keys) {
      if ({'docId', 'text', 'translation', 'shortcut', 'seq_no', 'category_id', 'category', 'category_index', 'group_id', 'group_description', 'group_index_in_category', 'index_in_group',}.contains(key)) continue;
      modelObj.otherData[key] = data[key];
    }
    return modelObj;
  }

  static StreamSubscription listen(DocStorage docStorage, SuggestedReplyCollectionListener listener,
          {String collectionRoot = '/$collectionName', List<DocQuery> queryList, OnErrorListener onError, @Deprecated('use onError instead') OnErrorListener onErrorListener}) =>
      listenForUpdates<SuggestedReply>(_log, docStorage, listener, collectionRoot, SuggestedReply.fromSnapshot, queryList: queryList, onError: onError ?? onErrorListener);

  Map<String, dynamic> toData({bool validate: true}) {
    return {
      if (text != null) 'text': text,
      if (translation != null) 'translation': translation,
      if (shortcut != null) 'shortcut': shortcut,
      if (seq_no != null) 'seq_no': seq_no,
      if (category_id != null) 'category_id': category_id,
      if (category != null) 'category': category,
      if (category_index != null) 'category_index': category_index,
      if (group_id != null) 'group_id': group_id,
      if (group_description != null) 'group_description': group_description,
      if (group_index_in_category != null) 'group_index_in_category': group_index_in_category,
      if (index_in_group != null) 'index_in_group': index_in_group,
      if (otherData != null) ...otherData,
    };
  }

  @override
  String toString() => 'SuggestedReply($docId, ${toData(validate: false)})';
}

typedef SuggestedReplyCollectionListener = void Function(
  List<SuggestedReply> added,
  List<SuggestedReply> modified,
  List<SuggestedReply> removed,
);

final _log = Logger('suggested_reply.g.dart');
