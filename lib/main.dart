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
      providers: [ChangeNotifierProvider(
        create: (_) => ProviderClass(),),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ],
        child: MainApp()
      ),
    
  );

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
  int _selectedIndex = 0;

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Work"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Home"),
        
        ],
      ),
    );
  }
}
