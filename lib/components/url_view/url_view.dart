import 'dart:html';
import 'package:intl/intl.dart';

DateFormat afterDateFilterFormat = DateFormat('yyyy.MM.dd HH:mm');
enum TagFilterType { include, exclude, lastInboundTurn }

class UrlView {
  static const String queryConversationListKey = 'conversation-list';
  static const String queryConversationIdKey = 'conversation-id';
  static const String queryConversationIdFilterKey = 'conversation-id-filter';

  String getQueryTagFilterKey(TagFilterType type) {
    switch (type) {
      case TagFilterType.include:
        return 'filter'; // TODO(mariana): this should be updated to 'include-filter' but we keep it 'filter for backwards compatibility
      case TagFilterType.exclude:
        return 'exclude-filter';
      case TagFilterType.lastInboundTurn:
        return 'last-inbound-turn-filter';
    }
    throw 'Trying to read an unknown filter type: $type';
  }

  String getQueryAfterDateFilterKey(TagFilterType type) {
    switch (type) {
      case TagFilterType.include:
        return 'include-after-date';
      case TagFilterType.exclude:
        return 'exclude-after-date';
      default:
        throw 'Trying to read an unknown filter type: $type';
    }
  }

  Set<String> getPageUrlFilterTags(TagFilterType type) {
    var queryFilterKey = getQueryTagFilterKey(type);
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(queryFilterKey)) {
      List<String> filterTags = uri.queryParameters[queryFilterKey].split(' ');
      filterTags.removeWhere((tag) => tag == "");
      return filterTags.toSet();
    }
    return Set();
  }

  void setPageUrlFilterTags(TagFilterType type, Set<String> filterTags) {
    var queryFilterKey = getQueryTagFilterKey(type);
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (filterTags == null || filterTags.isEmpty) {
      queryParameters.remove(queryFilterKey);
    } else {
      queryParameters[queryFilterKey] = filterTags.join(' ');
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  String getPageUrlConversationList() {
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(queryConversationListKey)) {
      return uri.queryParameters[queryConversationListKey];
    }
    return null;
  }

  void setPageUrlConversationList(String conversationListId) {
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (conversationListId == null) {
      queryParameters.remove(queryConversationListKey);
    } else {
      queryParameters[queryConversationListKey] = conversationListId;
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  String getPageUrlConversationId() {
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(queryConversationIdKey)) {
      return uri.queryParameters[queryConversationIdKey];
    }
    return null;
  }

  void setPageUrlConversationId(String conversationId) {
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (conversationId == null) {
      queryParameters.remove(queryConversationIdKey);
    } else {
      queryParameters[queryConversationIdKey] = conversationId;
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  // TODO: More specific Function parameter
  DateTime getPageUrlFilterAfterDate(TagFilterType type, {onError: Function}) {
    var queryFilterKey = getQueryAfterDateFilterKey(type);
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(queryFilterKey)) {
      String afterDateFilter = uri.queryParameters[queryFilterKey];
      try {
        return afterDateFilterFormat.parse(afterDateFilter);
      } on FormatException catch (e) {
        if (onError != null) {
          onError(e);
        }
        return null;
      }
    }
    return null;
  }

  void setPageUrlFilterAfterDate(TagFilterType type, DateTime afterDateFilter) {
    var queryFilterKey = getQueryAfterDateFilterKey(type);
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (afterDateFilter == null) {
      queryParameters.remove(queryFilterKey);
    } else {
      queryParameters[queryFilterKey] = afterDateFilterFormat.format(afterDateFilter);
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  String getPageUrlFilterConversationId() {
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(queryConversationIdFilterKey)) {
      return uri.queryParameters[queryConversationIdFilterKey];
    }
    return null;
  }

  void setPageUrlFilterConversationId(String conversationIdFilter) {
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (conversationIdFilter == null) {
      queryParameters.remove(queryConversationIdFilterKey);
    } else {
      queryParameters[queryConversationIdFilterKey] = conversationIdFilter;
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }
}
