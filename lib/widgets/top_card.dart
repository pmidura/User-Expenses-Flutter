import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TopCard extends StatelessWidget { //Stateless nie zmiena swojego stanu w czasie działania aplikacji
  //final - zmienna zainicjowana w czasie wykonywania i przypisana tylko raz
  final List<Transaction> recentTransactions;

  //const - zmienna inicjowana w czasie kompilacji i przypisywana w czasie wykonywania
  const TopCard(
    this.recentTransactions,
    {Key? key}
  ) : super(key: key);

  double get totalSpending {
    /*map - kolekcja kluczy/wartości z której pobierane są wartości za pomocą powiązanego klucza
    fold - redukuje kolekcję do pojedynczej wartości, iteracyjnie łącząc każdy element kolekcji z istniejącą wartością*/
    return recentTransactions.map((e) => e.amount).fold(0.0, (previousValue, amount) => previousValue + amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'S U M A  W Y D A T K Ó W',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
              Text(
                totalSpending.toStringAsFixed(2) + ' PLN',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 40,
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(4.0, 4.0), //offset(dx, dy) - przesunięcie względem osi odpowiednio x i y
              blurRadius: 15.0, //Właściwość kontrolująca "zamglenie" na krawędziach cienia
              spreadRadius: 1.0, //Właściwość kontrolująca BoxShadow przed nałożeniem rozmycia
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0), //offset(dx, dy) - przesunięcie względem osi odpowiednio x i y
              blurRadius: 15.0, //Właściwość kontrolująca "zamglenie" na krawędziach cienia
              spreadRadius: 1.0, //Właściwość kontrolująca BoxShadow przed nałożeniem rozmycia
            ),
          ],
        ),
      ),
    );
  }
}
