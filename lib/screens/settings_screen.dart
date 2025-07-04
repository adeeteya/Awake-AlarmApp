import 'package:awake/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Scaffold(
      backgroundColor: (isDark) ? AppColors.darkBorder : Colors.white,
      body: Hero(
        tag: "InnerDecoratedBox",
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: (isDark) ? AppColors.darkBorder : Colors.white,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  (isDark)
                      ? [AppColors.darkScaffold1, AppColors.darkScaffold2]
                      : [
                        AppColors.lightContainer1,
                        AppColors.lightContainer2,
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
                                ? AppColors.darkBackgroundText
                                : AppColors.lightBackgroundText,
                      ),
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color:
                            (isDark)
                                ? AppColors.darkBackgroundText
                                : AppColors.lightBackgroundText,
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
