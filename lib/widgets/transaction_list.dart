import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_show.dart';

class TransactionList extends StatelessWidget { //Stateless nie zmiena swojego stanu w czasie działania aplikacji
  //final - zmienna zainicjowana w czasie wykonywania i przypisana tylko raz
  final List<Transaction> transactions;
  final Function deleteTx;

  //const - zmienna inicjowana w czasie kompilacji i przypisywana w czasie wykonywania
  const TransactionList(
    this.transactions,
    this.deleteTx,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
      ?LayoutBuilder(builder: (ctx, constraints) {
        return Column(
          children: const <Widget>[
            Text(
              'Nie dodano żadnych wydatków!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        );
      })
      :TransactionShow(transactions, deleteTx);
  }
}
