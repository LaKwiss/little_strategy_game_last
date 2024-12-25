import 'dart:ui';

import 'package:flutter/material.dart';

ScrollBehavior scrollBehavior = MaterialScrollBehavior().copyWith(
  dragDevices: {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  },
  overscroll: false,
  physics: const BouncingScrollPhysics(),
);
