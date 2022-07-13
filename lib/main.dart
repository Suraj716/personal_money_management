import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_personal_management_app/widgets/chart.dart';
import 'package:flutter_personal_management_app/widgets/new_transation.dart';
import 'package:flutter_personal_management_app/widgets/transation_list.dart';
import './models/transation.dart';

void main() => runApp(MyApp());
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
//   );
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.purple,
        errorColor: Colors.black,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // late String titleInput;
  // late String amountInput;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transation> _userTransation = [
    /* Transation(
      id: 't1',
      title: 'New shoes',
      amount: 7000,
      date: DateTime.now(),
    ),
    Transation(
      id: 't2',
      title: 'Laptop',
      amount: 70000,
      date: DateTime.now(),
    ),*/
  ];

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  void didChageAppLifeCycle(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  bool _showChart = false;

  List<Transation> get _recentTransations {
    return _userTransation.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransation(String txtitle, double txamount, DateTime chosenDate) {
    final newTx = Transation(
        title: txtitle,
        amount: txamount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransation.add(newTx);
    });
  }

  void _startAddNewTransation(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (context) {
          return GestureDetector(
            onTap: () {},
            child: NewTransation(_addNewTransation),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransation(String id) {
    setState(() {
      //_userTransation.removeWhere((tx) {
      // return tx.id == id;
      //});
      _userTransation.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransations),
            )
          // : Container(
          //     height: (mediaQuery.size.height -
          //             appBar.preferredSize.height -
          //             MediaQuery.of(context).padding.top) *
          //         0.7,
          //     child: TransationList(_userTransation, _deleteTransation),
          //   ),
          : txListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransations),
      ),
      txListWidget
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // IconButton(
                //   onPressed: () => _startAddNewTransation(context),
                //   // icon: Icon(Icons.add),
                // ),
                GestureDetector(
                  onTap: () => _startAddNewTransation(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Expenses',
              style: TextStyle(fontFamily: 'Open Sans'),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => _startAddNewTransation(context),
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.add,
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = _buildAppBar();
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransationList(_userTransation, _deleteTransation),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /* Container(
              //or we can wrap card with container instead of text
              width: double.infinity,
              child: Card(
                elevation: 5,
                color: Colors.blue,
                child: Text('chart'),
                margin: EdgeInsets.all(20),
              ),
            ),*/
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPotraitContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPotraitContent(mediaQuery, appBar, txListWidget),
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     'Expenses',
            //     style: TextStyle(fontFamily: 'Open Sans'),
            //   ),
            //   actions: <Widget>[
            //     IconButton(
            //       onPressed: () => _startAddNewTransation(context),
            //       icon: Icon(
            //         Icons.add,
            //       ),
            //     ),
            //   ],
            //),
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransation(context),
                  ),
          );
  }
}
