class Booking {
  final String id;
  final String customer;   // اسم العميل
  final DateTime when;     // وقت/تاريخ الحجز
  final String notes;      // ملاحظات

  const Booking({
    required this.id,
    required this.customer,
    required this.when,
    this.notes = '',
  });

  Booking copyWith({String? customer, DateTime? when, String? notes}) =>
      Booking(
        id: id,
        customer: customer ?? this.customer,
        when: when ?? this.when,
        notes: notes ?? this.notes,
      );
}
