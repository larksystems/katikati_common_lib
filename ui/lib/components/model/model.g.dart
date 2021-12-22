// This generated file is used by `model.dart`
// and should not be imported or exported by any other file.

import 'dart:async';

import 'package:katikati_ui_lib/components/logger.dart';
import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart' show DocBatchUpdate, DocChangeType, DocSnapshot, DocStorage;
import 'package:katikati_ui_lib/datatypes/turnline.dart';

Logger log = Logger('model.g.dart');

class Conversation {
  static const collectionName = 'nook_conversations';

  String docId;
  Map<String, String> demographicsInfo;
  Set<String> tagIds;
  Set<String> suggestedTagIds;
  Set<String> lastInboundTurnTagIds;
  List<Message> messages;
  List<SuggestedMessage> suggestedMessages;
  List<Turnline> turnlines;
  String notes;
  bool unread;

  static Conversation fromSnapshot(DocSnapshot doc, [Conversation modelObj]) =>
      fromData(doc.data, modelObj)..docId = doc.id;

  static Conversation fromData(data, [Conversation modelObj]) {
    if (data == null) return null;
    return (modelObj ?? Conversation())
      ..demographicsInfo = Map_fromData<String>(data['demographicsInfo'], String_fromData)
      ..tagIds = Set_fromData<String>(data['tags'], String_fromData)
      ..suggestedTagIds = Set_fromData<String>(data['suggested_tag_ids_set'], String_fromData) ?? {}
      ..lastInboundTurnTagIds = Set_fromData<String>(data['lastInboundTurnTags'], String_fromData) ?? {}
      ..messages = List_fromData<Message>(data['messages'], Message.fromData)
      ..suggestedMessages = List_fromData<SuggestedMessage>(data['suggested_messages'], SuggestedMessage.fromData) ?? []
      ..turnlines = List_fromData<Turnline>(data['turnlines'], Turnline.fromData) ?? []
      ..notes = String_fromData(data['notes'])
      ..unread = bool_fromData(data['unread']) ?? true;
  }

  static Conversation required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static Conversation notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  static StreamSubscription listen(DocStorage docStorage, ConversationCollectionListener listener,
          {String collectionRoot = '/$collectionName', OnErrorListener onErrorListener}) =>
      listenForUpdates<Conversation>(docStorage, listener, collectionRoot, Conversation.fromSnapshot, onErrorListener);

  Map<String, dynamic> toData() {
    return {
      if (demographicsInfo != null) 'demographicsInfo': demographicsInfo,
      if (tagIds != null) 'tags': tagIds.toList(),
      if (suggestedTagIds != null) 'suggested_tag_ids_set': suggestedTagIds.toList(),
      if (lastInboundTurnTagIds != null) 'lastInboundTurnTags': lastInboundTurnTagIds.toList(),
      if (messages != null) 'messages': messages.map((elem) => elem?.toData()).toList(),
      if (suggestedMessages != null) 'suggested_messages': suggestedMessages.map((elem) => elem?.toData()).toList(),
      if (turnlines != null) 'turnlines': turnlines.map((elem) => elem?.toData()).toList(),
      if (notes != null) 'notes': notes,
      if (unread != null) 'unread': unread,
    };
  }

  /// Add [newTagIds] to tagIds in this Conversation.
  /// Callers should catch and handle IOException.
  Future<void> addTagIds(DocPubSubUpdate pubSubClient, Iterable<String> newTagIds, {bool wasSuggested = false}) {
    var toBeAdded = Set<String>();
    for (var elem in newTagIds) {
      if (!tagIds.contains(elem)) {
        toBeAdded.add(elem);
      }
    }
    if (toBeAdded.isEmpty) return Future.value(null);
    tagIds.addAll(toBeAdded);
    return pubSubClient.publishAddOpinion('nook_conversations/add_tags', {
      'conversation_id': docId,
      'tags': toBeAdded.toList(),
      "was_suggested": wasSuggested,
    });
  }

  /// Set tagIds in this Conversation.
  /// Callers should catch and handle IOException.
  Future<void> setTagIds(DocPubSubUpdate pubSubClient, Set<String> newTagIds, {bool wasSuggested = false}) {
    if (tagIds.length == newTagIds.length && tagIds.difference(newTagIds).isEmpty) {
      return Future.value(null);
    }
    tagIds = newTagIds;
    return pubSubClient.publishAddOpinion('nook_conversations/set_tags', {
      'conversation_id': docId,
      'tags': tagIds.toList(),
      "was_suggested": wasSuggested,
    });
  }

  /// Remove [oldTagIds] from tagIds in this Conversation.
  /// Callers should catch and handle IOException.
  Future<void> removeTagIds(DocPubSubUpdate pubSubClient, Iterable<String> oldTagIds, {bool wasSuggested = false}) {
    var toBeRemoved = Set<String>();
    for (var elem in oldTagIds) {
      if (tagIds.remove(elem)) {
        toBeRemoved.add(elem);
      }
    }
    if (toBeRemoved.isEmpty) return Future.value(null);
    return pubSubClient.publishAddOpinion('nook_conversations/remove_tags', {
      'conversation_id': docId,
      'tags': toBeRemoved.toList(),
      "was_suggested": wasSuggested,
    });
  }

  /// Set notes in this Conversation.
  /// Callers should catch and handle IOException.
  Future<void> setNotes(DocPubSubUpdate pubSubClient, String newNotes) {
    if (notes == newNotes) {
      return Future.value(null);
    }
    notes = newNotes;
    return pubSubClient.publishAddOpinion('nook_conversations/set_notes', {
      'conversation_id': docId,
      'notes': notes,
    });
  }

  /// Set unread in this Conversation.
  /// Callers should catch and handle IOException.
  Future<void> setUnread(DocPubSubUpdate pubSubClient, bool newUnread) {
    if (unread == newUnread) {
      return Future.value(null);
    }
    unread = newUnread;
    return pubSubClient.publishAddOpinion('nook_conversations/set_unread', {
      'conversation_id': docId,
      'unread': unread,
    });
  }

  @override
  String toString() => 'Conversation [$docId]: ${toData().toString()}';
}
typedef ConversationCollectionListener = void Function(
  List<Conversation> added,
  List<Conversation> modified,
  List<Conversation> removed,
);

class Message {
  MessageDirection direction;
  DateTime datetime;
  MessageStatus status;
  List<String> tagIds;
  Set<String> suggestedTagIds;
  String text;
  String translation;
  String id;
  MessageChannel channel;

  static Message fromData(data, [Message modelObj]) {
    if (data == null) return null;
    return (modelObj ?? Message())
      ..direction = MessageDirection.fromData(data['direction']) ?? MessageDirection.Out
      ..datetime = DateTime_fromData(data['datetime'])
      ..status = MessageStatus.fromData(data['status'])
      ..tagIds = List_fromData<String>(data['tags'], String_fromData)
      ..suggestedTagIds = Set_fromData<String>(data['suggested_tag_ids_set'], String_fromData) ?? {}
      ..text = String_fromData(data['text'])
      ..translation = String_fromData(data['translation'])
      ..id = String_fromData(data['id'])
      ..channel = MessageChannel.fromData(data['channel']);
  }

  static Message required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static Message notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  Map<String, dynamic> toData() {
    return {
      if (direction != null) 'direction': direction.toData(),
      if (datetime != null) 'datetime': datetime.toIso8601String(),
      if (status != null) 'status': status.toData(),
      if (tagIds != null) 'tags': tagIds,
      if (suggestedTagIds != null) 'suggested_tag_ids_set': suggestedTagIds.toList(),
      if (text != null) 'text': text,
      if (translation != null) 'translation': translation,
      if (id != null) 'id': id,
      if (channel != null) 'channel': channel.toData(),
    };
  }

  @override
  String toString() => 'Message: ${toData().toString()}';
}

class MessageChannel {
  static const rapidpro_sms = MessageChannel('rapidpro_sms');
  static const twilio_sms = MessageChannel('twilio_sms');
  static const twilio_whatsapp = MessageChannel('twilio_whatsapp');

  static const values = <MessageChannel>[
    rapidpro_sms,
    twilio_sms,
    twilio_whatsapp,
  ];

  static MessageChannel fromString(String text, [MessageChannel defaultValue = MessageChannel.rapidpro_sms]) {
    if (text != null) {
      const prefix = 'MessageChannel.';
      var valueName = text.startsWith(prefix) ? text.substring(prefix.length) : text;
      for (var value in values) {
        if (value.name == valueName) return value;
      }
    }
    // Only warn if this is an unknown value
    if (text != null && text.isNotEmpty) log.warning('unknown MessageChannel $text');
    return defaultValue;
  }

  static MessageChannel fromData(data, [MessageChannel defaultValue = MessageChannel.rapidpro_sms]) {
    if (data is String || data == null) return fromString(data, defaultValue);
    log.warning('invalid MessageChannel: ${data.runtimeType}: $data');
    return defaultValue;
  }

  static MessageChannel required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static MessageChannel notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  final String name;
  const MessageChannel(this.name);

  String toData() => 'MessageChannel.$name';

  @override
  String toString() => toData();
}

class MessageDirection {
  static const In = MessageDirection('in');
  static const Out = MessageDirection('out');

  static const values = <MessageDirection>[
    In,
    Out,
  ];

  static MessageDirection fromString(String text, [MessageDirection defaultValue = MessageDirection.Out]) {
    if (text != null) {
      const prefix = 'MessageDirection.';
      var valueName = text.startsWith(prefix) ? text.substring(prefix.length) : text;
      for (var value in values) {
        if (value.name == valueName) return value;
      }
    }
    log.warning('unknown MessageDirection $text');
    return defaultValue;
  }

  static MessageDirection fromData(data, [MessageDirection defaultValue = MessageDirection.Out]) {
    if (data is String || data == null) return fromString(data, defaultValue);
    log.warning('invalid MessageDirection: ${data.runtimeType}: $data');
    return defaultValue;
  }

  static MessageDirection required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static MessageDirection notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  final String name;
  const MessageDirection(this.name);

  String toData() => 'MessageDirection.$name';

  @override
  String toString() => toData();
}

class MessageStatus {
  static const pending = MessageStatus('pending');
  static const confirmed = MessageStatus('confirmed');
  static const failed = MessageStatus('failed');
  static const unknown = MessageStatus('unknown');

  static const values = <MessageStatus>[
    pending,
    confirmed,
    failed,
    unknown,
  ];

  static MessageStatus fromString(String text, [MessageStatus defaultValue = MessageStatus.unknown]) {
    if (text != null) {
      const prefix = 'MessageStatus.';
      var valueName = text.startsWith(prefix) ? text.substring(prefix.length) : text;
      for (var value in values) {
        if (value.name == valueName) return value;
      }
    }
    // This is commented out because it generates too much noise in the logs
    // log.warning('unknown MessageStatus $text');
    return defaultValue;
  }

  static MessageStatus fromData(data, [MessageStatus defaultValue = MessageStatus.unknown]) {
    if (data is String || data == null) return fromString(data, defaultValue);
    log.warning('invalid MessageStatus: ${data.runtimeType}: $data');
    return defaultValue;
  }

  static MessageStatus required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static MessageStatus notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  final String name;
  const MessageStatus(this.name);

  String toData() => 'MessageStatus.$name';

  @override
  String toString() => toData();
}

class SuggestedMessage {
  String text;
  String translation;

  static SuggestedMessage fromData(data, [SuggestedMessage modelObj]) {
    if (data == null) return null;
    return (modelObj ?? SuggestedMessage())
      ..text = String_fromData(data['text'])
      ..translation = String_fromData(data['translation']);
  }

  static SuggestedMessage required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static SuggestedMessage notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  Map<String, dynamic> toData() {
    return {
      if (text != null) 'text': text,
      if (translation != null) 'translation': translation,
    };
  }

  @override
  String toString() => 'SuggestedMessage: ${toData().toString()}';
}

class SystemMessage {
  static const collectionName = 'systemMessages';

  String docId;
  String text;
  bool expired;

  String get msgId => docId;

  static SystemMessage fromSnapshot(DocSnapshot doc, [SystemMessage modelObj]) =>
      fromData(doc.data, modelObj)..docId = doc.id;

  static SystemMessage fromData(data, [SystemMessage modelObj]) {
    if (data == null) return null;
    return (modelObj ?? SystemMessage())
      ..text = String_fromData(data['text'])
      ..expired = bool_fromData(data['expired']) ?? false;
  }

  static SystemMessage required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw ValueException("$className.$fieldName is missing");
    return value;
  }

  static SystemMessage notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw ValueException("$className.$fieldName must not be null");
    return value;
  }

  static StreamSubscription listen(DocStorage docStorage, SystemMessageCollectionListener listener,
          {String collectionRoot = '/$collectionName', OnErrorListener onErrorListener}) =>
      listenForUpdates<SystemMessage>(docStorage, listener, collectionRoot, SystemMessage.fromSnapshot, onErrorListener);

  Map<String, dynamic> toData() {
    return {
      if (text != null) 'text': text,
      if (expired != null) 'expired': expired,
    };
  }

  @override
  String toString() => 'SystemMessage [$docId]: ${toData().toString()}';
}
typedef SystemMessageCollectionListener = void Function(
  List<SystemMessage> added,
  List<SystemMessage> modified,
  List<SystemMessage> removed,
);

typedef OnErrorListener = void Function(
  Object error,
  StackTrace stackTrace
);

// ======================================================================
// Core firebase/yaml utilities

bool bool_fromData(data) {
  if (data == null) return null;
  if (data is bool) return data;
  if (data is String) {
    var boolStr = data.toLowerCase();
    if (boolStr == 'true') return true;
    if (boolStr == 'false') return false;
  }
  log.warning('unknown bool value: ${data?.toString()}');
  return null;
}

bool bool_required(Map data, String fieldName, String className) {
  var value = bool_fromData(data[fieldName]);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

bool bool_notNull(Map data, String fieldName, String className) {
  var value = bool_required(data, fieldName, className);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

DateTime DateTime_fromData(data) {
  if (data == null) return null;
  var datetime = DateTime.tryParse(data);
  if (datetime != null) return datetime;
  log.warning('unknown DateTime value: ${data?.toString()}');
  return null;
}

DateTime DateTime_required(Map data, String fieldName, String className) {
  var value = DateTime_fromData(data[fieldName]);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

DateTime DateTime_notNull(Map data, String fieldName, String className) {
  var value = DateTime_required(data, fieldName, className);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

dynamic dynamic_fromData(data) => data;

dynamic dynamic_required(Map data, String fieldName, String className) {
  var value = data[fieldName];
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

dynamic dynamic_notNull(Map data, String fieldName, String className) {
  var value = dynamic_required(data, fieldName, className);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

int int_fromData(data) {
  if (data == null) return null;
  if (data is int) return data;
  if (data is String) {
    var result = int.tryParse(data);
    if (result is int) return result;
  }
  log.warning('unknown int value: ${data?.toString()}');
  return null;
}

int int_required(Map data, String fieldName, String className) {
  var value = int_fromData(data[fieldName]);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

int int_notNull(Map data, String fieldName, String className) {
  var value = int_required(data, fieldName, className);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

String String_fromData(data) => data?.toString();

String String_required(Map data, String fieldName, String className) {
  var value = String_fromData(data[fieldName]);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

String String_notNull(Map data, String fieldName, String className) {
  var value = String_required(data, fieldName, className);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

String String_notEmpty(Map data, String fieldName, String className) {
  var value = String_notNull(data, fieldName, className);
  if (value.isEmpty)
    throw ValueException("$className.$fieldName must not be empty");
  return value;
}

num num_fromData(data) {
  if (data == null) return null;
  if (data is num) return data;
  if (data is String) {
    var result = num.tryParse(data);
    if (result is num) return result;
  }
  log.warning('unknown num value: ${data?.toString()}');
  return null;
}

num num_required(Map data, String fieldName, String className) {
  var value = num_fromData(data[fieldName]);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

num num_notNull(Map data, String fieldName, String className) {
  var value = num_required(data, fieldName, className);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

List<T> List_fromData<T>(dynamic data, T Function(dynamic) createModel) =>
    (data as List)?.map<T>((elem) => createModel(elem))?.toList();

List<T> List_required<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = List_fromData(data[fieldName], createModel);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

List<T> List_notNull<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = List_required(data, fieldName, className, createModel);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

List<T> List_notEmpty<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = List_notNull(data, fieldName, className, createModel);
  if (value.isEmpty)
    throw ValueException("$className.$fieldName must not be empty");
  return value;
}

Map<String, T> Map_fromData<T>(dynamic data, T Function(dynamic) createModel) =>
    (data as Map)?.map<String, T>((key, value) => MapEntry(key.toString(), createModel(value)));

Map<String, T> Map_required<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = Map_fromData(data[fieldName], createModel);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

Map<String, T> Map_notNull<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = Map_required(data, fieldName, className, createModel);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

Map<String, T> Map_notEmpty<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = Map_notNull(data, fieldName, className, createModel);
  if (value.isEmpty)
    throw ValueException("$className.$fieldName must not be empty");
  return value;
}

Set<T> Set_fromData<T>(dynamic data, T Function(dynamic) createModel) =>
    (data as List)?.map<T>((elem) => createModel(elem))?.toSet();

Set<T> Set_required<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = Set_fromData(data[fieldName], createModel);
  if (value == null && !data.containsKey(fieldName))
    throw ValueException("$className.$fieldName is missing");
  return value;
}

Set<T> Set_notNull<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = Set_required(data, fieldName, className, createModel);
  if (value == null)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

Set<T> Set_notEmpty<T>(Map data, String fieldName, String className, T Function(dynamic) createModel) {
  var value = Set_notNull(data, fieldName, className, createModel);
  if (value.isEmpty)
    throw ValueException("$className.$fieldName must not be null");
  return value;
}

StreamSubscription<List<DocSnapshot>> listenForUpdates<T>(
    DocStorage docStorage,
    void Function(List<T> added, List<T> modified, List<T> removed) listener,
    String collectionRoot,
    T Function(DocSnapshot doc) createModel,
    [OnErrorListener onErrorListener]
    ) {
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
  }, onError: onErrorListener);
}

// ======================================================================
// Core pub/sub utilities

/// A pub/sub based mechanism for updating documents
abstract class DocPubSubUpdate {
  /// Publish the given opinion for the given namespace.
  Future<void> publishAddOpinion(String namespace, Map<String, dynamic> opinion);
}

class ValueException implements Exception {
  String message;

  ValueException(this.message);

  @override
  String toString() => 'ValueException: $message';
}
