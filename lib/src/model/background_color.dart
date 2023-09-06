import 'dart:ui';
import 'package:onfido_sdk/src/serializer/color_serializer.dart';

class BackgroundColor {
  Color light;
  Color dark;

  BackgroundColor(this.light, this.dark);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dark'] = ColorSerializer.serialize(dark);
    data['light'] = ColorSerializer.serialize(light);
    return data;
  }
}
