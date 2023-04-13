import 'package:flutter/cupertino.dart';

class WIDGETS {
  static Widget buildSwitch(String text, bool value, Function(bool) onChanged ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        CupertinoSwitch(value: value,onChanged: onChanged)
      ]);
  }
}
