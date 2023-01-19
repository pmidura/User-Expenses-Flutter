import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget { //Stateful może zmieniać swój stan w czasie działania aplikacji
  final Function addTx;

  //const - zmienna inicjowana w czasie kompilacji i przypisywana w czasie wykonywania
  const NewTransaction(
    this.addTx,
    {Key? key}
  ) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState(); //Przesłonienie metody w celu zwrócenia nowo utworzonej instancji
}

class _NewTransactionState extends State<NewTransaction> {
  //final - zmienna zainicjowana w czasie wykonywania i przypisana tylko raz
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  late DateTime _selectedDate; //late - wymusza ograniczenia zmiennej w czasie wykonywania zamiast w czasie kompilacji
  bool _isDateSelected = false;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      locale: const Locale("pl", "PL"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null) {
        return;
      }
      setState(() {
        _isDateSelected = true;
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text ('N O W Y  W Y D A T E K'),
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
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Wartość (PLN)',
                      border: OutlineInputBorder(),
                    ),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))], //Wymusza wprowadzanie setnych części kwoty (groszy) po kropce i dwa miejsca po kropce
                    onSubmitted: (_) => _submitData(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded( //Widżet rozszerzający elementy potomne wiersza, kolumny, tak aby element potomny wypełniał dostępną przestrzeń
                  child: Text(
                    !_isDateSelected
                      ?'Nie Wybrano Daty!'
                      :'Data: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
                  ),
                ),
                TextButton( //FlatButton
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Wybierz Datę',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget> [
        Stack( //Widżet pozycjonujący elementy podrzędne względem krawędzi
          children: <Widget> [
            Align(
              alignment: Alignment.bottomLeft,
              child: MaterialButton(
                elevation: 8,
                color: Colors.grey[600],
                child: const Text(
                  'Anuluj',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                elevation: 8,
                color: Colors.grey[600],
                child: const Text(
                  'Dodaj',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: _submitData,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
