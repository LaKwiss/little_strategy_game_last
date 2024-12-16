import 'package:flutter/material.dart';

enum Type { success, error, info, custom }

class Toast extends StatelessWidget {
  const Toast({
    super.key,
    required this.message,
    required this.type,
  });

  final String message;
  final Type type;

  @override
  Widget build(BuildContext context) {
    final ToastStyle style = _getStyleForType(type);

    return Center(
      child: SizedBox(
        width: 350,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: style.gradient,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.white24,
              width: 2.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ClipOval(
                        child: Container(
                          height: 35,
                          width: 35,
                          color: style.iconBackgroundColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        style.icon,
                        color: style.iconColor,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.title,
                      style: TextStyle(
                        color: style.titleColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      message,
                      style: TextStyle(
                        color: style.messageColor,
                        fontSize: 14.0,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ToastStyle _getStyleForType(Type type) {
    switch (type) {
      case Type.success:
        return ToastStyle(
          title: "Success",
          gradient: const LinearGradient(
            colors: [
              Color(0x0028a745),
              Color(0x5528a745),
            ],
          ),
          icon: Icons.check_circle,
          iconBackgroundColor: const Color(0xFF28a745),
          iconColor: Colors.black87,
          titleColor: Colors.white,
          messageColor: Colors.white70,
        );

      case Type.error:
        return ToastStyle(
          title: "Error",
          gradient: const LinearGradient(
            colors: [
              Color(0x00dc3545),
              Color(0x55dc3545),
            ],
          ),
          icon: Icons.error,
          iconBackgroundColor: const Color(0xFFdc3545),
          iconColor: Colors.black87,
          titleColor: Colors.white,
          messageColor: Colors.white70,
        );

      case Type.info:
        return ToastStyle(
          title: "Information",
          gradient: const LinearGradient(
            colors: [
              Color(0x00ffc107),
              Color(0x55ffc107),
            ],
          ),
          icon: Icons.info,
          iconBackgroundColor: const Color(0xFFffc107),
          iconColor: Colors.black87,
          titleColor: Colors.white,
          messageColor: Colors.white70,
        );

      case Type.custom:
        return ToastStyle(
          title: "Custom Message",
          gradient: const LinearGradient(
            colors: [
              Color(0x006c757d),
              Color(0x556c757d),
            ],
          ),
          icon: Icons.tune,
          iconBackgroundColor: const Color(0xFF6c757d),
          iconColor: Colors.black87,
          titleColor: Colors.white,
          messageColor: Colors.white70,
        );
    }
  }
}

class ToastStyle {
  const ToastStyle({
    required this.title,
    required this.gradient,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
  });

  final String title;
  final Gradient gradient;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;
}
