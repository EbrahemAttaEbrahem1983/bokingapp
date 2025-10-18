import 'package:flutter/material.dart';
import '../features/bookings/presentation/pages/bookings_page.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BokingApp',
      theme: ThemeData(useMaterial3: true),
      home: const BookingsPage(),
    );
  }
}
