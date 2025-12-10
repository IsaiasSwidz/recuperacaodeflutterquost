import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/preferences_screen.dart';
import 'presentation/screens/history_screen.dart';
import 'presentation/providers/monitoring_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MonitoringProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento e Alertas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/preferences': (context) => PreferencesScreen(),
        '/history': (context) => HistoryScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}