import 'package:awake/constants.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Scaffold(
      backgroundColor: (isDark) ? const Color(0xFF5D666D) : Colors.white,
      body: Hero(
        tag: "InnerDecoratedBox",
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: (isDark) ? const Color(0xFF5D666D) : Colors.white,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  (isDark)
                      ? [darkScaffoldGradient1Color, darkScaffoldGradient2Color]
                      : [
                        lightContainerGradient1Color,
                        lightContainerGradient2Color,
                      ],
            ),
          ),
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        foregroundColor:
                            (isDark)
                                ? const Color(0xFF8E98A1)
                                : const Color(0xFF646E82),
                      ),
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color:
                            (isDark)
                                ? const Color(0xFF8E98A1)
                                : const Color(0xFF646E82),
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.03,
                      ),
                    ),
                    IconButton(onPressed: null, icon: Offstage()),
                  ],
                ),
                // Add your settings options here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
