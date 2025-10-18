import 'package:flutter/material.dart';
import '../../../bookings/data/models/booking.dart';

class BookingTile extends StatelessWidget {
  final Booking b;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const BookingTile({super.key, required this.b, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(b.customer),
      subtitle: Text(b.when.toString()),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
        IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
      ]),
    );
  }
}
