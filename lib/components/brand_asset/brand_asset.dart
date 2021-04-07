import 'dart:html';

const BASE_PATH = "packages/katikati_ui_lib/components/brand_asset/logos";

class BrandInfo {
  final String name;
  final String _assetPath;

  ImageElement logo({int height, int width, String className}) {
    var image = ImageElement(src: _assetPath, height: height, width: width);
    if (className != null) {
      image.className = className;
    }
    return image;
  }

  const BrandInfo(this.name, this._assetPath);
}

const KATIKATI = BrandInfo("katikati", "$BASE_PATH/katikati.svg");
const AVF = BrandInfo("avf", "$BASE_PATH/avf.svg");
const IFRC = BrandInfo("ifrc", "$BASE_PATH/ifrc.svg");
