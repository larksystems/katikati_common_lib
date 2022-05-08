/// This is the interface file for suggested_reply.g.dart
/// Import this file rather than importing suggested_reply.g.dart directly

export 'package:katikati_ui_lib/datatypes/suggested_reply.g.dart';

// Add hand coded adjustments and modifications here rather than modifying the generated file.
import 'package:katikati_ui_lib/datatypes/suggested_reply.g.dart' as g;

extension SuggestedReplyUtils on g.SuggestedReply {
  g.SuggestedReply clone() {
    return g.SuggestedReply.fromData(this.toData())..docId = this.docId;
  }  

  bool equals(g.SuggestedReply other) {
    if (docId != other.docId
      || text != other.text
      || translation != other.translation
      || shortcut != other.shortcut
      || categoryId != other.categoryId
      || categoryName != other.categoryName
      || categoryIndex != other.categoryIndex
      || groupId != other.groupId
      || groupName != other.groupName
      || groupIndexInCategory != other.groupIndexInCategory
      || indexInGroup != other.indexInGroup
      ) {
      return false;
    }

    return true;
  }
}
