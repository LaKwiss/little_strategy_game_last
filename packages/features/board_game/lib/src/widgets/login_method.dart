import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LoginMethodType {
  xbox,
  playstation,
  nintendo,
  steam,
  facebook,
  google,
  apple,
  lego
}

class LoginMethod extends StatelessWidget {
  const LoginMethod({required this.fn, required this.url, super.key});

  final Function fn;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: 96,
          height: 54,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: SvgPicture.asset(
              url,
            ),
          ),
        ),
      ),
    );
  }
}
