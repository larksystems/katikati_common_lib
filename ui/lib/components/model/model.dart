import 'dart:async';

import 'package:uuid/uuid.dart' as uuid;

import 'model.g.dart' as g;
import 'package:katikati_ui_lib/datatypes/conversation_list_shard.dart' as g;
import 'package:katikati_ui_lib/datatypes/doc_storage_util.dart';

export 'package:katikati_ui_lib/datatypes/doc_storage_util.dart' show DocBatchUpdate, DocChangeType, DocSnapshot, DocStorage;

export 'package:katikati_ui_lib/datatypes/conversation_list_shard.dart';
export 'package:katikati_ui_lib/datatypes/project.dart';
export 'package:katikati_ui_lib/datatypes/suggested_reply.dart';
export 'package:katikati_ui_lib/datatypes/tag.dart';
export 'package:katikati_ui_lib/datatypes/turnline.dart';
export 'package:katikati_ui_lib/datatypes/user.dart';

export 'model.g.dart';

extension ConversationListShardUtil on g.ConversationListShard {
  String get conversationListRoot => docId != null
    ? "/${g.ConversationListShard.collectionName}/$docId/conversations"
    : "/nook_conversations";

  String get displayName => name ?? docId;
}

extension ConversationUtil on g.Conversation {
  String get shortDeidentifiedPhoneNumber {
    try {
      return docId.split('uuid-')[1].split('-')[0];
    } catch (e) {
      return docId;
    }
  }

  /// Return the most recent inbound message, or `null`
  g.Message get mostRecentMessageInbound {
    for (int index = messages.length - 1; index >= 0; --index) {
      var message = messages[index];
      if (message.direction == g.MessageDirection.In) {
        return message;
      }
    }
    return null;
  }

  /// Return the most recent inbound message's tags or `[]`
  List<String> get lastInboundMessageTags {
    for (int index = messages.length - 1; index >= 0; --index) {
      var message = messages[index];
      if (message.direction == g.MessageDirection.In) {
        return message.tagIds ?? [];
      }
    }
    return [];
  }

  static int mostRecentInboundFirst(g.Conversation c1, g.Conversation c2) {
    var d1 = c1.mostRecentMessageInbound?.datetime;
    var d2 = c2.mostRecentMessageInbound?.datetime;

    if (c1.docId == c2.docId) {
      return 0;
    }
    if (d1 == d2) {
      return mostRecentMessageFirst(c1, c2);
    }
    if (d1 == null) {
      return 1;
    }
    if (d2 == null) {
      return -1;
    }

    return d2.compareTo(d1);
  }

  static int mostRecentMessageFirst(g.Conversation c1, g.Conversation c2) {
    var d1 = c1.messages.isNotEmpty ? c1.messages.last.datetime : null;
    var d2 = c2.messages.isNotEmpty ? c2.messages.last.datetime : null;

    if (c1.docId == c2.docId) {
      return 0;
    }
    if (d1 == d2) {
      return c1.docId.compareTo(c2.docId);
    }
    if (d1 == null) {
      return 1;
    }
    if (d2 == null) {
      return -1;
    }

    return d2.compareTo(d1);
  }

  static int alphabeticalById(g.Conversation c1, g.Conversation c2) {
    return c1.docId.compareTo(c2.docId);
  }

  /// Remove the suggested messages for this Conversation.
  /// Callers should catch and handle IOException.
  Future<void> removeSuggestedMessages(g.DocPubSubUpdate pubSubClient) async {
    if (suggestedMessages.isEmpty) return;
    suggestedMessages.clear();
    return pubSubClient.publishAddOpinion('nook_conversation/delete_suggested_messages', {
      "conversation_id": docId,
    });
  }
}

extension MessageUtil on g.Message {
  /// Add [tagId] to tagIds in this Message.
  /// Callers should catch and handle IOException.
  Future<void> addTagId(g.DocPubSubUpdate pubSubClient, g.Conversation conversation, String tagId, {bool wasSuggested = false}) async {
    if (tagIds.contains(tagId)) return;
    if (this.id.startsWith('pending-')) {
      throw AssertionError('Cannot add tag to a pending message - please try again in a few seconds');
    }
    tagIds.add(tagId);
    return pubSubClient.publishAddOpinion('nook_messages/add_tags', {
      "conversation_id": conversation.docId,
      "message_id": this.id,
      "tags": [tagId],
      "was_suggested": wasSuggested,
    });
  }

  /// Remove [tagId] from tagIds in this Message.
  /// Callers should catch and handle IOException.
  Future<void> removeTagId(g.DocPubSubUpdate pubSubClient, g.Conversation conversation, String tagId, {bool wasSuggested = false}) async {
    if (!tagIds.contains(tagId) && !suggestedTagIds.contains(tagId)) return;
    if (this.id.startsWith('pending-')) {
      throw AssertionError('Cannot remove a tag from a pending message - please try again in a few seconds');
    }
    tagIds.remove(tagId);
    suggestedTagIds.remove(tagId);
    return pubSubClient.publishAddOpinion('nook_messages/remove_tags', {
      "conversation_id": conversation.docId,
      "message_id": this.id,
      "tags": [tagId],
      "was_suggested": wasSuggested,
    });
  }

  Future<void> setTranslation(g.DocPubSubUpdate pubSubClient, g.Conversation conversation, String newTranslation) async {
    if (translation == newTranslation) return;
    if (this.id.startsWith('pending-')) {
      throw AssertionError('Cannot add translation of a pending message - please try again in a few seconds');
    }
    translation = newTranslation;
    return pubSubClient.publishAddOpinion('nook_messages/set_translation', {
      "conversation_id": conversation.docId,
      "message_id": this.id,
      "text": text,
      "translation": translation,
    });
  }

  /// Return the index of this message within the given conversations list of messages.
  int _messageIndex(g.Conversation conversation) {
    // TODO Consider switching to a message-id independent of conversation
    var index = conversation.messages.indexOf(this);
    if (index < 0) throw Exception("Cannot find message in conversation");
    return index;
  }
}

class User {
  String userName;
  String userEmail;
}

class DataMap {
  String docId;
  Map data;

  static DataMap fromSnapshot(DocSnapshot doc, [DataMap modelObj]) =>
      fromData(doc.data, modelObj)..docId = doc.id;

  static DataMap fromData(data, [DataMap modelObj]) {
    if (data == null) return null;
    return (modelObj ?? DataMap())
      ..data = data;
  }

  static DataMap required(Map data, String fieldName, String className) {
    var value = fromData(data[fieldName]);
    if (value == null && !data.containsKey(fieldName))
      throw g.ValueException("$className.$fieldName is missing");
    return value;
  }

  static DataMap notNull(Map data, String fieldName, String className) {
    var value = required(data, fieldName, className);
    if (value == null)
      throw g.ValueException("$className.$fieldName must not be null");
    return value;
  }

  static StreamSubscription listen(DocStorage docStorage, DataMapListener listener, String collectionRoot, {g.OnErrorListener onError}) =>
      g.listenForUpdates<DataMap>(docStorage, listener, collectionRoot, DataMap.fromSnapshot, onError);

  Map<String, dynamic> toData() {
    return data;
  }

  @override
  String toString() => '[$docId]: ${toData().toString()}';
}

typedef DataMapListener = void Function(
  List<DataMap> added,
  List<DataMap> modified,
  List<DataMap> removed,
);


final uuid.Uuid uuidGenerator = new uuid.Uuid();

String generateRandomId() => uuidGenerator.v4().substring(0, 8);

String generateTagId() => 'tag-${generateRandomId()}';
String generateTagGroupId() => 'tag-group-${generateRandomId()}';
String generateStandardMessageId() => 'standard-message-${generateRandomId()}';
String generateStandardMessageGroupId() => 'standard-message-group-${generateRandomId()}';
String generateStandardMessageCategoryId() => 'standard-message-category-${generateRandomId()}';
String generatePendingMessageId(g.Conversation conversation) => 'pending-nook-message-${conversation.docId}-${conversation.messages.length}';
