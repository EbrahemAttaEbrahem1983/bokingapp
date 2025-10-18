import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../bookings/data/models/booking.dart';
import '../../../bookings/data/local/hive_source.dart';
import '../../../bookings/data/repositories/bookings_repo_impl.dart';
import '../../../bookings/domain/repositories/bookings_repo.dart';

// Box provider (تم فتحه في main)
final bookingsBoxProvider = Provider<Box<String>>(
  (ref) => Hive.box<String>('bookingsBox'),
);

// Repo provider
final bookingsRepoProvider = Provider<BookingsRepo>((ref) {
  final box = ref.watch(bookingsBoxProvider);
  return BookingsRepoImpl(HiveBookingsSource(box));
});

// الحالة = List<Booking> باستخدام Notifier API (Riverpod 3)
final bookingsProvider =
    NotifierProvider<BookingsNotifier, List<Booking>>(() => BookingsNotifier());

class BookingsNotifier extends Notifier<List<Booking>> {
  late final BookingsRepo _repo;

  @override
  List<Booking> build() {
    _repo = ref.read(bookingsRepoProvider);
    return _repo.getAll();
  }

  void add(String customer, DateTime when, {String notes = ''}) {
    final b = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customer: customer.trim(),
      when: when,
      notes: notes.trim(),
    );
    _repo.add(b);
    state = [...state, b];
  }

  void update(Booking b) {
    _repo.update(b);
    state = [for (final x in state) x.id == b.id ? b : x];
  }

  void remove(String id) {
    _repo.remove(id);
    state = state.where((x) => x.id != id).toList();
  }
}
