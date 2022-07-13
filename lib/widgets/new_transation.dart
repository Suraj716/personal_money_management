import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_personal_management_app/widgets/adaptive_flat.dart';
import 'package:intl/intl.dart';

class NewTransation extends StatefulWidget {
  final Function addtx;

  NewTransation(this.addtx);

  @override
  State<NewTransation> createState() => _NewTransationState();
}

class _NewTransationState extends State<NewTransation> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  _NewTransationState() {
    debugPrint('Constructor NewTransaction State');
  }
  @override
  void initState() {
    debugPrint('InitState()');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransation oldWidget) {
    debugPrint('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    debugPrint('dispose');
    super.dispose();
  }

  var _selectedDate;
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredtitle = _titleController.text;
    final entredAmount = double.parse(_amountController.text);

    if (enteredtitle.isEmpty || entredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addtx(
      enteredtitle,
      entredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  10), //EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                // onChanged: (value) {
                //   titleInput = value;
                // },
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (value) => amountInput = value,
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        // ignore: unnecessary_null_comparison
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'PickedDate: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transation'),
                // onPressed: () {
                //   // print(titleInput);
                //   // print(amountInput);
                // },
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button!.color,
                // textColor: Theme.of(context).textTheme.button!.color,
                // textColor: Colors.white,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
