class Transaction {
  final String id; //final - zmienna zainicjowana w czasie wykonywania i przypisana tylko raz
  late String title; //late - wymusza ograniczenia zmiennej w czasie wykonywania zamiast w czasie kompilacji
  late double amount;
  late DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
