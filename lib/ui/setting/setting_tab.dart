import 'package:flutter/material.dart';
import 'package:music_app_flutter/ui/custom/custom_list.dart';
import '../view_modles.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({super.key});

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  final _viewModles = MusicAppViewModles();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Setting Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _viewModles.themeMode,
            builder: (_, value, __) {
              return MyListTitle(
                  title: 'Dark Mode',
                  titleTextStyle: Theme.of(context).textTheme.titleLarge,
                  onTap: null,
                  trailing: Switch(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: _viewModles.themeMode.value == ThemeMode.dark,
                    onChanged: (value) {
                      _viewModles.updateThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light);
                    },
                  ));
            },
          ),
        ],
      ),
    );
  }
}
