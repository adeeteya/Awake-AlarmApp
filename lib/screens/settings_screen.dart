import 'package:awake/extensions/context_extensions.dart';
import 'package:awake/services/theme_cubit.dart';
import 'package:awake/theme/app_colors.dart';
import 'package:awake/widgets/theme_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBorder : Colors.white,
      body: Hero(
        tag: 'InnerDecoratedBox',
        child: Material(
          type: MaterialType.transparency,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    isDark
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
                              isDark
                                  ? AppColors.darkBackgroundText
                                  : AppColors.lightBackgroundText,
                        ),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkBackgroundText
                                  : AppColors.lightBackgroundText,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.03,
                        ),
                      ),
                      const IconButton(onPressed: null, icon: Offstage()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, mode) {
                      return ThemeListTile(
                        mode: mode,
                        onChanged:
                            (m) => context.read<ThemeCubit>().setTheme(m),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
