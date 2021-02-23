import 'dart:html';

enum Brand { katikati, avf, ifrc }

const basePath = "packages/katikati_ui_lib/components/brand_asset/logos";

ImageElement logo(Brand brand, {int height, int width, String className}) {
  var assetPath = "$basePath/missing.svg";
  switch (brand) {
    case Brand.katikati:
      assetPath = "$basePath/katikati.svg";
      break;
    case Brand.avf:
      assetPath = "$basePath/avf.svg";
      break;
    case Brand.ifrc:
      assetPath = "$basePath/ifrc.svg";
      break;
  }
  var image = ImageElement(src: assetPath, height: height, width: width);
  if (className != null) {
    image.className = className;
  }
  return image;
}
