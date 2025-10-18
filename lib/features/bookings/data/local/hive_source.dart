import 'package:hive_flutter/hive_flutter.dart';

class HiveBookingsSource {
  final Box<String> box; // نخزّن JSON كسلسلة مؤقتًا (سريع وسهل البدء)
  HiveBookingsSource(this.box);
}
