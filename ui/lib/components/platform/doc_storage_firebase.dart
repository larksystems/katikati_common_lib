import 'dart:async';

import 'package:firebase/firestore.dart' as firestore;
import 'package:katikati_ui_lib/components/logger.dart';

import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart';

Logger log = Logger('doc_storage_firebase.dart');

/// Firebase specific document storage.
class FirebaseDocStorage implements DocStorage {
  final firestore.Firestore fs;
  final String collectionPathPrefix;

  FirebaseDocStorage(this.fs, {String collectionPathPrefix}) //
      : collectionPathPrefix = collectionPathPrefix ?? '';

  @override
  Stream<List<DocSnapshot>> onChange(String collectionRoot, List<DocQuery> queryList) {
    var collection = fs.collection('$collectionPathPrefix$collectionRoot');
    firestore.Query filteredCollection = collection;
    for (var query in queryList) {
      filteredCollection = filteredCollection.where(query.field, query.op, query.value);
    }

    log.serverLog('Registering snapshot listener against ${collection.path}');
    return filteredCollection.onSnapshot.transform<List<DocSnapshot>>(StreamTransformer.fromHandlers(
      handleData: (firestore.QuerySnapshot querySnapshot, EventSink<List<DocSnapshot>> sink) {
        // No need to process local writes to Firebase
        if (querySnapshot.metadata.hasPendingWrites) {
          log.verbose('Skipping processing of local changes');
          return;
        }
        var event = <DocSnapshot>[];
        for (var change in querySnapshot.docChanges()) {
          var doc = change.doc;
          DocChangeType changeType = change.oldIndex == -1
              ? DocChangeType.added
              : change.newIndex == -1
                  ? DocChangeType.removed
                  : DocChangeType.modified;
          event.add(DocSnapshot(doc.id, doc.data(), changeType));
        }
        log.serverLog('Received snapshot listener data from ${collection.path}: ${event.length} changes');
        sink.add(event);
      },
      handleDone: (sink) {
        log.serverLog('Finished shapshot listener against ${collection.path}');
      },
      handleError: (error, stacktrace, sink) {
        log.serverLog('Error for shapshot listener against ${collection.path}: $error\n$stacktrace');
      },
    ));
  }

  @override
  DocBatchUpdate batch() => _FirebaseBatchUpdate(this, fs.batch());
}

/// A batch update for documents in firestore.
class _FirebaseBatchUpdate implements DocBatchUpdate {
  final FirebaseDocStorage fsStorage;
  final firestore.WriteBatch _batch;

  _FirebaseBatchUpdate(this.fsStorage, this._batch);

  @override
  Future<Null> commit() => _batch.commit();

  @override
  void update(String documentPath, {Map<String, dynamic> data}) {
    _batch.update(fsStorage.fs.doc('${fsStorage.collectionPathPrefix}$documentPath'), data: data);
  }
}

/// A query for filtering document snapshots.
class FirebaseQuery extends DocQuery {
  static const LESS_THAN = "<";
  static const LESS_THAN_OR_EQUAL_TO = "<=";
  static const EQUAL_TO = "==";
  static const GREATER_THAN = ">";
  static const GREATER_THAN_OR_EQUAL_TO = ">=";
  static const NOT_EQUAL_TO = "!=";
  static const ARRAY_CONTAINS = "array-contains";
  static const ARRAY_CONTAINS_ANY = "array-contains-any";
  static const IN = "in";
  static const NOT_IN = "not-in";

  FirebaseQuery(String field, String op, String value) : super(field, op, value);
}
