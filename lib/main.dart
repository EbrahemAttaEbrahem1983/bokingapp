import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();                 // تهيئة Hive في Flutter
  await Hive.openBox<String>('bookingsBox'); // فتح صندوق التخزين
  runApp(const ProviderScope(child: App()));
}
