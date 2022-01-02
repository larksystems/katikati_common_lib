import 'dart:collection';
import 'dart:html';

/// Katikati URLs look like this
/// <domain-name>/<path-to-page>?<query-list>
class UrlView {
  static const _CONVERSATION_LIST_QUERY_KEY = 'conversation-list';
  static const _CONVERSATION_ID_QUERY_KEY = 'conversation-id';
  static const _CONVERSATION_ID_FILTER_QUERY_KEY = 'conversation-id-filter';

  TagFilterUrlView _tagFilterUrlView = TagFilterUrlView();
  TagFilterUrlView get tagsFilter => _tagFilterUrlView;

  String get conversationList {
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(_CONVERSATION_LIST_QUERY_KEY)) {
      return uri.queryParameters[_CONVERSATION_LIST_QUERY_KEY];
    }
    return null;
  }

  void set conversationList(String conversationListId) {
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (conversationListId == null) {
      queryParameters.remove(_CONVERSATION_LIST_QUERY_KEY);
    } else {
      queryParameters[_CONVERSATION_LIST_QUERY_KEY] = conversationListId;
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  String get conversationId {
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(_CONVERSATION_ID_QUERY_KEY)) {
      return uri.queryParameters[_CONVERSATION_ID_QUERY_KEY];
    }
    return null;
  }

  void set conversationId(String conversationId) {
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (conversationId == null) {
      queryParameters.remove(_CONVERSATION_ID_QUERY_KEY);
    } else {
      queryParameters[_CONVERSATION_ID_QUERY_KEY] = conversationId;
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  String get conversationIdFilter {
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(_CONVERSATION_ID_FILTER_QUERY_KEY)) {
      return uri.queryParameters[_CONVERSATION_ID_FILTER_QUERY_KEY];
    }
    return null;
  }

  void set conversationIdFilter(String conversationId) {
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (conversationId == null) {
      queryParameters.remove(_CONVERSATION_ID_FILTER_QUERY_KEY);
    } else {
      queryParameters[_CONVERSATION_ID_FILTER_QUERY_KEY] = conversationId;
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }
}

// NOTE: Must be kept in sync with the TagFilterUrlView.TAG_FILTER_QUERY_KEYS map.
enum TagFilterType {
  include,
  exclude,
  lastInboundTurn,
}

class TagFilterUrlView with MapMixin<TagFilterType, Set<String>> {
  // NOTE: Must be kept in sync with the TagFilterType enum definition.
  static const TAG_FILTER_QUERY_KEYS = {
    TagFilterType.include: 'include-filter',
    TagFilterType.exclude: 'exclude-filter',
    TagFilterType.lastInboundTurn: 'last-inbound-turn-filter',
  };

  @override
  Set<String> operator [](Object key) {
    if (key == null) return Set<String>();
    var queryFilterKey = TAG_FILTER_QUERY_KEYS[key];
    var uri = Uri.parse(window.location.href);
    if (uri.queryParameters.containsKey(queryFilterKey)) {
      List<String> filterTags = uri.queryParameters[queryFilterKey].split(' ');
      filterTags.removeWhere((tag) => tag == "");
      return filterTags.toSet();
    }
    return Set<String>();
  }

  @override
  void operator []=(TagFilterType key, Set<String> value) {
    if (key == null) return;
    var queryFilterKey = TAG_FILTER_QUERY_KEYS[key];
    var uri = Uri.parse(window.location.href);
    Map<String, String> queryParameters = new Map.from(uri.queryParameters);
    if (value == null || value.isEmpty) {
      queryParameters.remove(queryFilterKey);
    } else {
      queryParameters[queryFilterKey] = value.join(' ');
    }
    uri = uri.replace(queryParameters: queryParameters);
    window.history.pushState('', '', uri.toString());
  }

  @override
  Iterable<TagFilterType> get keys => TagFilterType.values;

  @override
  /// Operation unsupported - nothing will happen.
  void clear() {
    // Operation usupported
  }

  @override
  /// Operation unsupported - nothing will happen.
  Set<String> remove(Object key) {
    // Operation usupported
    return Set<String>();
  }
}
