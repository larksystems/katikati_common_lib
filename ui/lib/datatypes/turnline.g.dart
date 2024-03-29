// This generated file is imported by "turnline.dart" residing in the same directory as this file
// and should not be imported or exported by any other file.
//
//   Source File  : Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_turnline.dart
//   Source SHA   : b6400e55035ae40099f01cf737e2dc9e8d023b03bf05d3edab9a0c62b237db81
//   Generated by : mariana
//
// Use "kktool codegen Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_turnline.dart" to regenerate this file.
// Adjust the imports as necessary as they are preserved when the code is regenerated.

import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart';
import 'package:katikati_ui_lib/components/logger.dart';

class Turnline {
  String title;
  List<TurnlineStep> steps;

  Map<String, dynamic> otherData;

  static Turnline fromData(data, [Turnline modelObj]) {
    if (data == null) return null;
    (modelObj ??= Turnline())
      ..title = data['title']?.toString()
      ..steps = List_fromData<TurnlineStep>(_log, 'steps', data, TurnlineStep.fromData)
      ..otherData = {};
    for (var key in data.keys) {
      if ({'title', 'steps',}.contains(key)) continue;
      modelObj.otherData[key] = data[key];
    }
    return modelObj;
  }

  Map<String, dynamic> toData({bool validate: true}) {
    return {
      if (title != null) 'title': title,
      if (steps != null) 'steps': steps.map((elem) => elem.toData(validate: validate)).toList(),
      if (otherData != null) ...otherData,
    };
  }

  @override
  String toString() => 'Turnline(${toData(validate: false)})';
}

class TurnlineStep {
  String title;
  String description;
  String tagGroupName;
  String standardMessagesGroupId;
  bool done;
  bool verified;
  Map<String, dynamic> additionalInfo;

  Map<String, dynamic> otherData;

  static TurnlineStep fromData(data, [TurnlineStep modelObj]) {
    if (data == null) return null;
    (modelObj ??= TurnlineStep())
      ..title = data['title']?.toString()
      ..description = data['description']?.toString()
      ..tagGroupName = data['tagGroupName']?.toString()
      ..standardMessagesGroupId = data['standardMessagesGroupId']?.toString()
      ..done = bool_fromData(_log, 'done', data)
      ..verified = bool_fromData(_log, 'verified', data)
      ..additionalInfo = Map_fromData<dynamic>(_log, 'additionalInfo', data)
      ..otherData = {};
    for (var key in data.keys) {
      if ({'title', 'description', 'tagGroupName', 'standardMessagesGroupId', 'done', 'verified', 'additionalInfo',}.contains(key)) continue;
      modelObj.otherData[key] = data[key];
    }
    return modelObj;
  }

  Map<String, dynamic> toData({bool validate: true}) {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tagGroupName != null) 'tagGroupName': tagGroupName,
      if (standardMessagesGroupId != null) 'standardMessagesGroupId': standardMessagesGroupId,
      if (done != null) 'done': done,
      if (verified != null) 'verified': verified,
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
      if (otherData != null) ...otherData,
    };
  }

  @override
  String toString() => 'TurnlineStep(${toData(validate: false)})';
}

final _log = Logger('turnline.g.dart');
