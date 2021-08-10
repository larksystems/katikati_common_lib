/// This is the interface file for tag.g.dart
/// Import this file rather than importing tag.g.dart directly

import 'package:katikati_ui_lib/components/datatypes/tag.g.dart' as g;

export 'package:katikati_ui_lib/components/datatypes/tag.g.dart';

// Add hand coded adjustments and modifications here rather than modifying the generated file.

extension NotFoundTagType on g.TagType {
  static const NotFound = g.TagType('not found');

  static const values = <g.TagType>[
    g.TagType.normal,
    g.TagType.important,
    NotFoundTagType.NotFound,
  ];
}
