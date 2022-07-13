import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transation.dart';
import './transaction_item.dart';

class TransationList extends StatelessWidget {
  final Function deleteTx;
  final List<Transation> transations;
  TransationList(this.transations, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    // return Container(
    // height: MediaQuery.of(context).size.height * 0.6,
    return transations.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transations added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        // : ListView.builder(
        //     itemBuilder: (ctx, index) {
        //       return TransactionItem(
        //           transations: transations[index], deleteTx: deleteTx);
        //     },
        //     itemCount: transations.length,
        //   );
        : ListView(
            children: transations
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transations: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
          );
  }
}
