import 'package:flutter/material.dart';

class ShowDialog{

  show(context) async {

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
      title: const Text('Oops!'),
      content: const Text('Something went wrong'),
      actions: <Widget>[
        TextButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
            //return;
          },
        )
      ],
    ),
    );
  }


}