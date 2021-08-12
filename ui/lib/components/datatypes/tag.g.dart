// This generated file is imported by "tag.dart" residing in the same directory as this file
// and should not be imported or exported by any other file.
//
//   Source File  : Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_tag.dart
//   Source SHA   : 05e76194eab0645a8c45a1fcb64f2375163177cfbfe8f2bd27f616bf9512c9ac
//   Generated by : danrubel
//
// Use "kktool codegen Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_tag.dart" to regenerate this file.
// Adjust the imports as necessary as they are preserved when the code is regenerated.

import 'dart:async';

import 'package:katikati_ui_lib/components/datatypes/doc_storage_util.dart';
import 'package:katikati_ui_lib/components/logger.dart';

class Tag {
  String docId;
  String text;
  TagType type;
  String shortcut;
  bool filterable;
  List<String> groups;
  bool visible;
  bool isUnifier;
  String unifierTagId;
  List<String> unifiesTagIds;

  String get tagId => docId;

  static Tag fromSnapshot(DocSnapshot doc, [Tag modelObj]) => fromData(doc.data, modelObj)..docId = doc.id;

  static Tag fromData(data, [Tag modelObj]) {
    if (data == null) return null;
    return (modelObj ?? Tag())
      ..text = data['text']?.toString()
      ..type = TagType.fromData(_log, 'type', data)
      ..shortcut = data['shortcut']?.toString()
      ..filterable = bool_fromData(_log, 'filterable', data)
      ..groups = List_fromData<String>(_log, 'groups', data)
      ..visible = bool_fromData(_log, 'visible', data)
      ..isUnifier = bool_fromData(_log, 'isUnifier', data)
      ..unifierTagId = data['unifierTagId']?.toString()
      ..unifiesTagIds = List_fromData<String>(_log, 'unifiesTagIds', data);
  }

  static StreamSubscription listen(DocStorage docStorage, TagCollectionListener listener, String collectionRoot,
          {OnErrorListener onError, @Deprecated('use onError instead') OnErrorListener onErrorListener}) =>
      listenForUpdates<Tag>(_log, docStorage, listener, collectionRoot, Tag.fromSnapshot, onError: onError ?? onErrorListener);

  Map<String, dynamic> toData() {
    return {
      if (text != null) 'text': text,
      if (type != null) 'type': type.toData(),
      if (shortcut != null) 'shortcut': shortcut,
      if (filterable != null) 'filterable': filterable,
      if (groups != null) 'groups': groups,
      if (visible != null) 'visible': visible,
      if (isUnifier != null) 'isUnifier': isUnifier,
      if (unifierTagId != null) 'unifierTagId': unifierTagId,
      if (unifiesTagIds != null) 'unifiesTagIds': unifiesTagIds,
    };
  }

  @override
  String toString() => 'Tag [$docId]: ${toData().toString()}';
}

typedef TagCollectionListener = void Function(
  List<Tag> added,
  List<Tag> modified,
  List<Tag> removed,
);

class TagType {
  static const normal = TagType('normal');
  static const important = TagType('important');
  @deprecated
  static const Normal = normal;
  @deprecated
  static const Important = important;

  static const values = <TagType>[
    normal,
    important,
    Normal,
    Important,
  ];

  static TagType fromData(Logger log, String key, dynamic data) {
    if (data == null) return null;
    var value = data[key];
    if (value == null) return null;
    if (value is TagType) return value;
    if (value is String) {
      const prefix = 'TagType.';
      var valueName = value.startsWith(prefix) ? value.substring(prefix.length) : value;
      for (var value in values) {
        if (value.name == valueName) return value;
      }
      log.warning('Unknown TagType $value at "$key" in $data');
      return normal;
    }
    log.warning('Expected TagType at "$key", but found "$value" in $data');
    return normal;
  }

  final String name;
  const TagType(this.name);

  String toData() => 'TagType.$name';

  @override
  String toString() => toData();
}

final _log = Logger('tag.g.dart');
