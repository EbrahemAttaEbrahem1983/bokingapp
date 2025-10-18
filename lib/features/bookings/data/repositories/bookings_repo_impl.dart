import 'dart:convert';
import '../../data/models/booking.dart';
import '../local/hive_source.dart';
import '../../../bookings/domain/repositories/bookings_repo.dart';

class BookingsRepoImpl implements BookingsRepo {
  final HiveBookingsSource source;
  BookingsRepoImpl(this.source);

  @override
  List<Booking> getAll() =>
      source.box.values.map((s) => _fromJson(jsonDecode(s))).toList();

  @override
  void add(Booking booking) =>
      source.box.add(jsonEncode(_toJson(booking)));

  @override
  void update(Booking booking) {
    final values = source.box.values.toList(growable: false);
    final idx = values.indexWhere((s) => _fromJson(jsonDecode(s)).id == booking.id);
    if (idx != -1) {
      source.box.putAt(idx, jsonEncode(_toJson(booking)));
    }
  }

  @override
  void remove(String id) {
    final values = source.box.values.toList(growable: false);
    final idx = values.indexWhere((s) => _fromJson(jsonDecode(s)).id == id);
    if (idx != -1) source.box.deleteAt(idx);
  }

  Map<String, dynamic> _toJson(Booking b) => {
    'id': b.id,
    'customer': b.customer,
    'when': b.when.toIso8601String(),
    'notes': b.notes,
  };

  Booking _fromJson(Map<String, dynamic> m) =>
      Booking(
        id: m['id'] as String,
        customer: m['customer'] as String,
        when: DateTime.parse(m['when'] as String),
        notes: (m['notes'] as String?) ?? '',
      );
}
