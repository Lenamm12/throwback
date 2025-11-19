import 'package:flutter/material.dart';
import 'notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'notifiers/locale_notifier.dart';
import 'screens/page_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsService = await SettingsService.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier(settingsService)),
        ChangeNotifierProvider(create: (_) => LocaleNotifier(settingsService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
        builder: (context, theme, locale, child) {
      return MaterialApp(
        title: 'Throwback',
        theme: theme.currentTheme,
        locale: locale.locale,
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('de', ''), // German, no country code
          Locale('fr', ''), // French, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        home: const MainScreen(),
      );
    });
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    PageScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Meine Seite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Benachrichtigungen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            themeNotifier.isDarkMode ? Colors.white : Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
