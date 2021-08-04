import 'package:uuid/uuid.dart' as uuid;

import 'model.g.dart' as g;
import 'package:katikati_ui_lib/components/datatypes/tag.dart' as g;
import 'package:katikati_ui_lib/components/datatypes/user.dart' as g;

export 'package:katikati_ui_lib/components/datatypes/doc_storage_util.dart' show DocBatchUpdate, DocChangeType, DocSnapshot, DocStorage;
export 'package:katikati_ui_lib/components/datatypes/suggested_reply.dart';
export 'package:katikati_ui_lib/components/datatypes/tag.dart';
export 'package:katikati_ui_lib/components/datatypes/user.dart';

export 'model.g.dart';

extension UserConfigurationUtil on g.UserConfiguration {
  g.UserConfiguration applyDefaults(g.UserConfiguration defaults) =>
    new g.UserConfiguration()
      ..docId = null
      ..tagsKeyboardShortcutsEnabled = this.tagsKeyboardShortcutsEnabled ?? defaults.tagsKeyboardShortcutsEnabled
      ..repliesKeyboardShortcutsEnabled = this.repliesKeyboardShortcutsEnabled ?? defaults.repliesKeyboardShortcutsEnabled
      ..sendMessagesEnabled = this.sendMessagesEnabled ?? defaults.sendMessagesEnabled
      ..sendCustomMessagesEnabled = this.sendCustomMessagesEnabled ?? defaults.sendCustomMessagesEnabled
      ..sendMultiMessageEnabled = this.sendMultiMessageEnabled ?? defaults.sendMultiMessageEnabled
      ..tagMessagesEnabled = this.tagMessagesEnabled ?? defaults.tagMessagesEnabled
      ..tagConversationsEnabled = this.tagConversationsEnabled ?? defaults.tagConversationsEnabled
      ..editTranslationsEnabled = this.editTranslationsEnabled ?? defaults.editTranslationsEnabled
      ..editNotesEnabled = this.editNotesEnabled ?? defaults.editNotesEnabled
      ..conversationalTurnsEnabled = this.conversationalTurnsEnabled ?? defaults.conversationalTurnsEnabled
      ..tagsPanelVisibility = this.tagsPanelVisibility ?? defaults.tagsPanelVisibility
      ..repliesPanelVisibility = this.repliesPanelVisibility ?? defaults.repliesPanelVisibility
      ..suggestedRepliesGroupsEnabled = this.suggestedRepliesGroupsEnabled ?? defaults.suggestedRepliesGroupsEnabled;
}

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

  static int mostRecentInboundFirst(g.Conversation c1, g.Conversation c2) {
    var m1 = c1.mostRecentMessageInbound;
    var m2 = c2.mostRecentMessageInbound;
    if (m1 == null) {
      if (m2 == null) {
        m1 = c1.messages.last;
        m2 = c2.messages.last;
      } else {
        return -1;
      }
    } else {
      if (m2 == null) {
        return 1;
      } else {
        // fall through
      }
    }
    var result = m2.datetime.compareTo(m1.datetime);
    return result != 0 ? result : c2.hashCode.compareTo(c1.hashCode);
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
    if (this.id == null) {
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
    if (this.id == null) {
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
    if (this.id == null) {
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


final uuid.Uuid uuidGenerator = new uuid.Uuid();

String generateTagId() => 'tag-${uuidGenerator.v4().substring(0, 8)}';
