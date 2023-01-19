import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class TransactionShow extends StatelessWidget { //Stateless nie zmiena swojego stanu w czasie działania aplikacji
  //final - zmienna zainicjowana w czasie wykonywania i przypisana tylko raz
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionShow(
    this.transactions,
    this.deleteTx,
    {Key? key}
  ) : super(key: key);

  final TextEditingController _newDateCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Center(
                    child: Text('P O D G L Ą D  W Y D A T K U'),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                  transactions[index].title,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                  transactions[index].amount.toStringAsFixed(2) + ' PLN',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                  DateFormat('dd.MM.yyyy').format(transactions[index].date),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Stack( //Widżet pozycjonujący elementy podrzędne względem krawędzi
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(ctx).push(DialogRoute(
                                context: ctx,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Center(
                                      child: Text ('E D Y T U J  W Y D A T E K'),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Tytuł',
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  controller: TextEditingController()..text = transactions[index].title, //.. - notacja kaskadowa (pozwala na wykonywanie sekwencji operacji na tym samym obiekcie
                                                  onChanged: (String newTitle) {
                                                    transactions[index].title = newTitle;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Wartość (PLN)',
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  controller: TextEditingController()..text = transactions[index].amount.toString(), //.. - notacja kaskadowa (pozwala na wykonywanie sekwencji operacji na tym samym obiekcie)
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))], //Wymusza wprowadzanie setnych części kwoty (groszy) po kropce i dwa miejsca po kropce
                                                  onChanged: (String newAmount) {
                                                    transactions[index].amount = double.parse(newAmount);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Data',
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  controller: _newDateCtr..text = DateFormat('dd.MM.yyyy').format(transactions[index].date), //.. - notacja kaskadowa (pozwala na wykonywanie sekwencji operacji na tym samym obiekcie
                                                  onTap: () {
                                                    FocusScope.of(ctx).unfocus(); //Ukryj kursor
                                                    FocusScope.of(context).requestFocus(FocusNode()); //Ukryj klawiaturę
                                                    showDatePicker(
                                                      context: context,
                                                      locale: const Locale("pl", "PL"),
                                                      initialDate: transactions[index].date,
                                                      firstDate: DateTime(2010),
                                                      lastDate: DateTime.now(),
                                                    ).then((newDate) {
                                                      if (newDate != null) {
                                                        _newDateCtr.text = DateFormat('dd.MM.yyyy').format(newDate);
                                                        transactions[index].date = newDate;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ));
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deleteTx(transactions[index].id);
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          child: TransactionItem(
            key: ValueKey(transactions[index].id),
            transaction: transactions[index],
            deleteTx: deleteTx,
          ),
        );
      },
    );
  }
}
