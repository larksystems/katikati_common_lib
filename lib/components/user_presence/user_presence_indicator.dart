import 'dart:html';
import 'package:katikati_ui_lib/components/tooltip/tooltip.dart';

mixin UserPresenceIndicator {
  DivElement _otherUserPresenceIndicator;
  Map<String, bool> _presentUsers = {};

  void hideOtherUserPresence(String userId) {
    var indicator = _otherUserPresenceIndicator.querySelector('[data-id="$userId"]');
    indicator?.remove();
    _presentUsers.remove(userId);

    if (_presentUsers.isEmpty) {
      _otherUserPresenceIndicator.children.clear();
      _presentUsers = {};
    }
  }

  void showOtherUserPresence(String userId, bool recent) {
    if (_presentUsers.containsKey(userId)) {
      var previousIndicator = _otherUserPresenceIndicator.querySelector('[data-id="$userId"]');
      previousIndicator.remove();
    }

    _otherUserPresenceIndicator.append(_generateOtherUserPresenceIndicator(userId, recent));
    _presentUsers[userId] = recent;
  }

  DivElement _generateOtherUserPresenceIndicator(String userId, bool recent) {
    var content = DivElement()
      ..classes.add('user-indicator')
      ..innerText = userId[0].toUpperCase()
      ..style.backgroundColor = _generateColourForId(userId, recent);
    var tooltip = Tooltip(content, userId, position: TooltipPosition.bottom)
      ..renderElement.dataset['id'] = userId;
    return tooltip.renderElement;
  }

  String _generateColourForId(String userId, bool recent) {
    var hue = userId.hashCode % 360;
    var light = recent ? 50 : 80;
    return 'hsl($hue, 60%, $light%)';
  }
}
