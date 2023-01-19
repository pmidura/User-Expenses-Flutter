import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget { //Stateless nie zmiena swojego stanu w czasie działania aplikacji
  //final - zmienna zainicjowana w czasie wykonywania i przypisana tylko raz
  final Transaction transaction;
  final Function deleteTx;

  //const - zmienna inicjowana w czasie kompilacji i przypisywana w czasie wykonywania
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card( //Panel z lekko zaokrąglonymi krawędziami i cieniem (elevation)
      elevation: 8,
      margin: const EdgeInsets.all(10),
      child: ListTile( //Pojedynczy wiersz o stałej wysokości
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5)
                ),
              ),
              child: Text(
                transaction.amount.toStringAsFixed(2) + ' PLN',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          transaction.title,
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          DateFormat('dd.MM.yyyy').format(transaction.date),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
