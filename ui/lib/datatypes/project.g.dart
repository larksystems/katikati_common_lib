// This generated file is imported by "project.dart" residing in the same directory as this file
// and should not be imported or exported by any other file.
//
//   Source File  : Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_project.dart
//   Source SHA   : 1d4c4ba14d77fef406412894f7340e3be34a8363abe9f10e9d42f9cd8faf24b1
//   Generated by : mariana
//
// Use "kktool codegen Lark/Katikati-Core/katikati_lib/lib/datatypes/nook_project.dart" to regenerate this file.
// Adjust the imports as necessary as they are preserved when the code is regenerated.

import 'dart:async';

import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart';
import 'package:katikati_ui_lib/components/logger.dart';

class Project {
  static const collectionName = 'projects';

  String docId;
  String projectName;
  String firstLanguage;
  String secondLanguage;
  int messageCharacterLimit;
  Map<String, String> allowedEmailDomainsMap;
  List<String> users;
  Map<String, dynamic> otherData;

  String get projectId => docId;

  static Project fromSnapshot(DocSnapshot doc, [Project modelObj]) => fromData(doc.data, modelObj)..docId = doc.id;

  static Project fromData(data, [Project modelObj]) {
    if (data == null) return null;
    Map<String, dynamic> otherData;
    data.forEach((key, value) {
      if (!_fieldNames.contains(key) && value != null) {
        (otherData ??= {})[key] = value;
      }
    });
    (modelObj ??= Project())
      ..projectName = data['projectName']?.toString()
      ..firstLanguage = data['firstLanguage']?.toString()
      ..secondLanguage = data['secondLanguage']?.toString()
      ..messageCharacterLimit = int_fromData(_log, 'messageCharacterLimit', data)
      ..allowedEmailDomainsMap = Map_fromData<String>(_log, 'allowedEmailDomainsMap', data)
      ..users = List_fromData<String>(_log, 'users', data)
      ..otherData = otherData;
    return modelObj;
  }

  static StreamSubscription listen(DocStorage docStorage, ProjectCollectionListener listener,
          {String collectionRoot = '/$collectionName', List<DocQuery> queryList, int limit, OnErrorListener onError}) =>
      listenForUpdates<Project>(_log, docStorage, listener, collectionRoot, Project.fromSnapshot, queryList: queryList, limit: limit, onError: onError);

  Map<String, dynamic> toData({bool validate: true}) {
    return {
      if (projectName != null) 'projectName': projectName,
      if (firstLanguage != null) 'firstLanguage': firstLanguage,
      if (secondLanguage != null) 'secondLanguage': secondLanguage,
      if (messageCharacterLimit != null) 'messageCharacterLimit': messageCharacterLimit,
      if (allowedEmailDomainsMap != null) 'allowedEmailDomainsMap': allowedEmailDomainsMap,
      if (users != null) 'users': users,
      if (otherData != null) ...otherData,
    };
  }

  @override
  String toString() => 'Project($docId, ${toData(validate: false)})';

  static const _fieldNames = {'docId', 'projectName', 'firstLanguage', 'secondLanguage', 'messageCharacterLimit', 'allowedEmailDomainsMap', 'users'};
}

typedef ProjectCollectionListener = void Function(
  List<Project> added,
  List<Project> modified,
  List<Project> removed,
);

final _log = Logger('project.g.dart');
