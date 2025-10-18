import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking.dart';
import '../providers/booking_providers.dart';
import '../widgets/booking_tile.dart';

class BookingsPage extends ConsumerWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: bookings.isEmpty
          ? const Center(child: Text('لا توجد حجوزات بعد'))
          : ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) {
                final b = bookings[i];
                return BookingTile(
                  b: b,
                  onEdit: () => _editDialog(context, ref, b),
                  onDelete: () => ref.read(bookingsProvider.notifier).remove(b.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('حجز'),
      ),
    );
  }

  Future<void> _addDialog(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    DateTime? when;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('إنشاء حجز'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم العميل')),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text(when == null ? 'اختر التاريخ/الوقت' : when.toString())),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                  if (date != null) {
                    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (time != null) {
                      setState(() {
                        when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    }
                  }
                },
                child: const Text('اختر'),
              ),
            ]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ')),
          ],
        );
      }),
    );
    if (ok == true && name.text.trim().isNotEmpty && when != null) {
      ref.read(bookingsProvider.notifier).add(name.text, when!);
    }
  }

  Future<void> _editDialog(BuildContext context, WidgetRef ref, Booking b) async {
    final name = TextEditingController(text: b.customer);
    DateTime when = b.when;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('تعديل الحجز'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم العميل')),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text(when.toString())),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: when,
                  );
                  if (date != null) {
                    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(when));
                    if (time != null) {
                      setState(() {
                        when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    }
                  }
                },
                child: const Text('اختر'),
              ),
            ]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ')),
          ],
        );
      }),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      ref.read(bookingsProvider.notifier).update(
            b.copyWith(customer: name.text.trim(), when: when),
          );
    }
  }
}
