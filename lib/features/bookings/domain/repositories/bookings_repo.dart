import '../../../bookings/data/models/booking.dart';

abstract class BookingsRepo {
  List<Booking> getAll();
  void add(Booking booking);
  void update(Booking booking);
  void remove(String id);
}
