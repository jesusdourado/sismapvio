import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogOcorrencia extends StatelessWidget {
  const DialogOcorrencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('OcorrĂȘncia salva'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Sua ocorrĂȘncia foi salva em nossa base de dados.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
