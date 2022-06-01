/// This is the interface file for user.g.dart
/// Import this file rather than importing user.g.dart directly

import 'package:katikati_ui_lib/datatypes/user.g.dart' as g;

export 'package:katikati_ui_lib/datatypes/user.g.dart';

// Add hand coded adjustments and modifications here rather than modifying the generated file.

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
      ..editTagsEnabled = this.editTagsEnabled ?? defaults.editTagsEnabled
      ..editStandardMessagesEnabled = this.editStandardMessagesEnabled ?? defaults.editStandardMessagesEnabled
      ..conversationalTurnsEnabled = this.conversationalTurnsEnabled ?? defaults.conversationalTurnsEnabled
      ..tagsPanelVisibility = this.tagsPanelVisibility ?? defaults.tagsPanelVisibility
      ..repliesPanelVisibility = this.repliesPanelVisibility ?? defaults.repliesPanelVisibility
      ..turnlinePanelVisibility = this.turnlinePanelVisibility ?? defaults.turnlinePanelVisibility
      ..suggestedRepliesGroupsEnabled = this.suggestedRepliesGroupsEnabled ?? defaults.suggestedRepliesGroupsEnabled
      ..sampleMessagesEnabled = this.sampleMessagesEnabled ?? defaults.sampleMessagesEnabled
      ..mandatoryIncludeTagIds = this.mandatoryIncludeTagIds ?? defaults.mandatoryIncludeTagIds
      ..mandatoryExcludeTagIds = this.mandatoryExcludeTagIds ?? defaults.mandatoryExcludeTagIds
      ..consoleLoggingLevel = this.consoleLoggingLevel ?? defaults.consoleLoggingLevel;

  static g.UserConfiguration get baseUserConfiguration => new g.UserConfiguration()
      ..repliesKeyboardShortcutsEnabled = false
      ..tagsKeyboardShortcutsEnabled = false
      ..sendMessagesEnabled = false
      ..sendCustomMessagesEnabled = false
      ..sendMultiMessageEnabled = false
      ..tagMessagesEnabled = false
      ..tagConversationsEnabled = false
      ..editTranslationsEnabled = false
      ..editNotesEnabled = false
      ..editTagsEnabled = false
      ..editStandardMessagesEnabled = false
      ..conversationalTurnsEnabled = false
      ..tagsPanelVisibility = false
      ..repliesPanelVisibility = false
      ..turnlinePanelVisibility = false
      ..suggestedRepliesGroupsEnabled = false
      ..sampleMessagesEnabled = false
      ..mandatoryIncludeTagIds = {}
      ..mandatoryExcludeTagIds = {}
      ..consoleLoggingLevel = 'verbose';

  static g.UserConfiguration get emptyUserConfiguration => new g.UserConfiguration();
}
