import 'package:flutter/material.dart';
import 'pages/habits.dart';
import 'pages/homepage.dart';
import 'pages/work.dart';
import 'package:provider/provider.dart';
import 'handlers.dart';
import 'styles.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderClass()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
      ],
      child: MyAppWrapper(),
    ),
  );
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProviderClass>();
      final timer = context.read<TimerProvider>();

      timer.attachProvider(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: NavigatedHomepage()
    );
  }

}


class NavigatedHomepage extends StatefulWidget {
  const NavigatedHomepage({super.key});

  @override
  State<NavigatedHomepage> createState() => _HomePageState();
}

class _HomePageState extends State<NavigatedHomepage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [workpage(), homepage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Work"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        
        ],
      ),
    );
  }
}
