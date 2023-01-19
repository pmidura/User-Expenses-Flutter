import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'widgets/top_card.dart';
import 'widgets/transaction_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //Upewnienie się o posiadaniu instancji WidgetsBinding, która wymagana jest do wywoływania kodu natywnego
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]); //FullScreen (bez status bar itd.)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]); //Aplikacja działa tylko pionowo

  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //Stateless nie zmiena swojego stanu w czasie działania aplikacji
  //const - zmienna inicjowana w czasie kompilacji i przypisywana w czasie wykonywania
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Ukryj baner z napisem "DEBUG"
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, //Określa pochodzenie aplikacji
      ],
      supportedLocales: const [
        Locale('pl'), //Pochodzenie - Polska, język polski
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget { //Stateful może zmieniać swój stan w czasie działania aplikacji
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(); //Przesłonienie metody w celu zwrócenia nowo utworzonej instancji
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  bool _showFAB = false;

  List<Transaction> get _recentTransactions {
    if (_userTransactions.isEmpty) {
      setState(() => _showFAB = true); //setState - wywołujemy, aby natychmiast zobaczyć zmiany wynikające z nowego stanu
    }

    return _userTransactions;
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showDialog(
      barrierDismissible: false, //Zablokowanie możliwości wyłączenia okna poprzez kliknięcie poza jego obszar
      context: ctx,
      builder: (_) { //(_) - konstruktor bezparametrowy
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque, //Cały obszar okna jest obszarem "klikalnym"
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    Widget txListWidget) {
      return [
        SizedBox(
          height: (
            mediaQuery.size.height -
            mediaQuery.padding.top
          ) * 0.3,
          child: TopCard(_recentTransactions),
        ),
        txListWidget
      ];
    }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final txListWidget =
      SizedBox(
        height: (
          mediaQuery.size.height -
          mediaQuery.padding.top
        ) * 0.7,
        child: TransactionList(_userTransactions, _deleteTransaction),
      );

    return Scaffold( //Implementuje podstawową strukturę wyglądu aplikacji
      backgroundColor: Colors.grey[300],
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() => _showFAB = true);
          }
          else if (notification.direction == ScrollDirection.reverse) {
            setState(() => _showFAB = false);
          }

          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, //Rozciąga elementy podrzędne od góry do dołu dla rzędu i od lewej do prawej dla kolumny
            children: <Widget>[
              ..._buildPortraitContent( //... - operator rozsunięcia, umożliwiający dodawanie wielu elementów w kolekcjach
                mediaQuery,
                txListWidget
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _showFAB,
        child: FloatingActionButton(
          backgroundColor: Colors.grey[600],
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ),
    );
  }
}
