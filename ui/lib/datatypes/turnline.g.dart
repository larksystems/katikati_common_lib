// This generated file is imported by "turnline.dart" residing in the same directory as this file
// and should not be imported or exported by any other file.
//
//   Source File  : Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_turnline.dart
//   Source SHA   : f7c56b411352eab9a26f64d51d895fe02e2e06e5633e0e6ac45d89223172cf7a
//   Generated by : danrubel
//
// Use "kktool codegen Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_turnline.dart" to regenerate this file.
// Adjust the imports as necessary as they are preserved when the code is regenerated.

import 'package:katikati_ui_lib/components/datatypes/doc_storage_util.dart';
import 'package:katikati_ui_lib/components/logger.dart';

class Turnline {
  String title;
  List<TurnlineStep> steps;

  static Turnline fromData(data, [Turnline modelObj]) {
    if (data == null) return null;
    return (modelObj ?? Turnline())
      ..title = data['title']?.toString()
      ..steps = List_fromData<TurnlineStep>(_log, 'steps', data);
  }

  Map<String, dynamic> toData() {
    return {
      if (title != null) 'title': title,
      if (steps != null) 'steps': steps,
    };
  }

  @override
  String toString() => 'Turnline: ${toData().toString()}';
}

class TurnlineStep {
  String title;
  String description;
  Set<String> tagIds;
  Set<String> standardMessagesIds;
  bool done;
  bool verified;
  Map<String, String> additionalInfo;

  static TurnlineStep fromData(data, [TurnlineStep modelObj]) {
    if (data == null) return null;
    return (modelObj ?? TurnlineStep())
      ..title = data['title']?.toString()
      ..description = data['description']?.toString()
      ..tagIds = Set_fromData<String>(_log, 'tagIds', data)
      ..standardMessagesIds = Set_fromData<String>(_log, 'standardMessagesIds', data)
      ..done = bool_fromData(_log, 'done', data)
      ..verified = bool_fromData(_log, 'verified', data)
      ..additionalInfo = Map_fromData<String>(_log, 'additionalInfo', data);
  }

  Map<String, dynamic> toData() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tagIds != null) 'tagIds': tagIds,
      if (standardMessagesIds != null) 'standardMessagesIds': standardMessagesIds,
      if (done != null) 'done': done,
      if (verified != null) 'verified': verified,
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
    };
  }

  @override
  String toString() => 'TurnlineStep: ${toData().toString()}';
}

final _log = Logger('turnline.g.dart');
