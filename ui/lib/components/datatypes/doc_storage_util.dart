import 'dart:async';

import 'package:katikati_ui_lib/components/logger.dart';

enum DocChangeType { added, modified, removed }

/// Document storage interface.
/// See [FirebaseDocStorage] for a firebase specific version of this.
abstract class DocStorage {
  /// Return a stream of document snapshots
  Stream<List<DocSnapshot>> onChange(String collectionRoot);

  /// Return a object for batching document updates.
  /// Call [DocBatchUpdate.commit] after the changes have been made.
  DocBatchUpdate batch();
}

/// A snapshot of a document's id and data at a particular moment in time.
class DocSnapshot {
  final String id;
  final Map<String, dynamic> data;
  final DocChangeType changeType;

  DocSnapshot(this.id, this.data, this.changeType);
}

/// A batch update, used to perform multiple writes as a single atomic unit.
/// None of the writes are committed (or visible locally) until
/// [DocBatchUpdate.commit()] is called.
abstract class DocBatchUpdate {
  /// Commits all of the writes in this write batch as a single atomic unit.
  /// Returns non-null [Future] that resolves once all of the writes in the
  /// batch have been successfully written to the backend as an atomic unit.
  /// Note that it won't resolve while you're offline.
  Future<Null> commit();

  /// Updates fields in the document referred to by this [DocumentReference].
  /// The update will fail if applied to a document that does not exist.
  void update(String documentPath, {Map<String, dynamic> data});
}

StreamSubscription<List<DocSnapshot>> listenForUpdates<T>(
  Logger log,
  DocStorage docStorage,
  void Function(List<T> added, List<T> modified, List<T> removed) listener,
  String collectionRoot,
  T Function(DocSnapshot doc) createModel, {
  OnErrorListener onError,
}) {
  log.verbose('Loading from $collectionRoot');
  log.verbose('Query root: $collectionRoot');
  return docStorage.onChange(collectionRoot).listen((List<DocSnapshot> snapshots) {
    var added = <T>[];
    var modified = <T>[];
    var removed = <T>[];
    log.verbose("Starting processing ${snapshots.length} changes.");
    for (var snapshot in snapshots) {
      log.verbose('Processing ${snapshot.id}');
      switch (snapshot.changeType) {
        case DocChangeType.added:
          added.add(createModel(snapshot));
          break;
        case DocChangeType.modified:
          modified.add(createModel(snapshot));
          break;
        case DocChangeType.removed:
          removed.add(createModel(snapshot));
          break;
      }
    }
    listener(added, modified, removed);
  }, onError: onError);
}

typedef OnErrorListener = void Function(Object error, StackTrace stackTrace);

// ======================================================================
// Data conversion methods

bool bool_fromData(Logger log, String key, dynamic data) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  if (value is bool) return value;
  if (value is String) {
    var boolStr = value.toLowerCase();
    if (boolStr == 'true') return true;
    if (boolStr == 'false') return false;
  }
  log.warning('Expected bool at "$key", but found "$value" in $data');
  return null;
}

DateTime DateTime_fromData(Logger log, String key, dynamic data) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  var datetime = DateTime.tryParse(value);
  if (datetime != null) return datetime;
  log.warning('Expected DateTime at "$key", but found "$value" in $data');
  return null;
}

int int_fromData(Logger log, String key, dynamic data) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    var result = int.tryParse(value);
    if (result is int) return result;
  }
  log.warning('Expected int at "$key", but found "$value" in $data');
  return null;
}

double double_fromData(Logger log, String key, dynamic data) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  if (value is double) return value;
  if (value is String) {
    var result = double.tryParse(value);
    if (result is double) return result;
  }
  log.warning('Expected double at "$key", but found "$value" in $data');
  return null;
}

List<T> List_fromData<T>(Logger log, String key, dynamic data, [T Function(dynamic) fromData]) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  if (value is List<T>) return value;
  if (value is Iterable) {
    if (fromData != null) return value.map((elem) => fromData(elem)).toList();
    return List<T>.from(value);
  }
  log.warning('Expected List or Set at "$key", but found $value in $data');
  return null;
}

Map<String, T> Map_fromData<T>(Logger log, String key, dynamic data) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  if (value is Map<String, T>) return value;
  if (value is Map) return Map<String, T>.from(value);
  log.warning('Expected Map at "$key", but found $value in $data');
  return null;
}

Set<T> Set_fromData<T>(Logger log, String key, dynamic data) {
  if (data == null) return null;
  var value = data[key];
  if (value == null) return null;
  if (value is Set<T>) return value;
  if (value is Iterable) return Set<T>.from(value);
  log.warning('Expected Set or List at "$key", but found $value in $data');
  return null;
}
