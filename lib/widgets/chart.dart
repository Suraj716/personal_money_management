import 'package:flutter/material.dart';
import 'package:flutter_personal_management_app/widgets/chart_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_personal_management_app/models/transation.dart';

class Chart extends StatelessWidget {
  final List<Transation> recentTransations;

  Chart(this.recentTransations);  
  List<Map<String, Object>> get groupedTransationValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalsum = 0.0;
      for (var i = 0; i < recentTransations.length; i++) {
        if (recentTransations[i].date.day == weekDay.day &&
            recentTransations[i].date.month == weekDay.month &&
            recentTransations[i].date.year == weekDay.year) {
          totalsum+= recentTransations[i].amount;
        }
      }
      // print(DateFormat.E().format(weekDay));
      // print(totalsum);
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalsum,
      };
      //}).reversed.toList();
    });
  }

  double get totalSpending {
    return groupedTransationValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
     // height: MediaQuery.of(context).size.height * 0.4,
      return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransationValues.map((data) {
              //return Text('${data['day']}:${data['amount']}');
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  (data['day'] as String),
                  (data['amount'] as double),
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending,
                ),
              );
            }).toList(),
          ),
        ),
    );
  }
}
