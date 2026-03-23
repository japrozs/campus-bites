class BudgetEntry {
  final int? id;
  final String name;
  final double amount;
  final String date;

  BudgetEntry({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
  });
  factory BudgetEntry.fromMap(Map<String, dynamic> map) {
    return BudgetEntry(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: map['date'],
    );
  }