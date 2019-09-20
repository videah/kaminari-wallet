import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

import 'package:kaminari_wallet/main.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(KaminariApp());
}