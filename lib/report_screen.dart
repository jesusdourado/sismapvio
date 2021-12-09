import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SuspectGenre {
  m,
  f,
}

class ReportCrimeScreen extends StatefulWidget {
  ReportCrimeScreen({Key? key}) : super(key: key);

  @override
  State<ReportCrimeScreen> createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  late SuspectGenre genre;
  late String crime = 'Roubo';

  @override
  void initState() {
    genre = SuspectGenre.m;

    super.initState();
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        title: Center(
          child: Text(
            'Boletim enviado.',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Boletim de ocorrência'),
      ),
      body: Container(
        color: Colors.indigo,
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextField(
                        style: TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                          hintText: 'Nome completo',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        style: TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                          hintText: 'CPF válido',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white.withOpacity(
                              0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Sexo',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Radio(
                              value: SuspectGenre.m,
                              groupValue: genre,
                              onChanged: (value) {
                                setState(() {
                                  genre = SuspectGenre.m;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Masculino',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Radio(
                              value: SuspectGenre.f,
                              groupValue: genre,
                              onChanged: (value) {
                                setState(() {
                                  genre = SuspectGenre.f;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Feminino',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Qual o delito?',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        DropdownButton<String>(
                          value: crime,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              crime = newValue!;
                            });
                          },
                          items: <String>[
                            'Roubo',
                            'Furto',
                            'Latrocínio',
                            'Outro',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        style: TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                          hintText: 'Onde ocorreu?',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white.withOpacity(
                              0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 8),
                          child: Text(
                            'Quando ocorreu?',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: 12, minute: 00),
                            );
                          },
                          child: Text('Selecione'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 8),
                      child: Text(
                        'Descreva os suspeitos',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white.withOpacity(
                              0.8,
                            ),
                          ),
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).restorablePush(_dialogBuilder);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.lightBlue,
                    ),
                    child: Text(
                      'Enviar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
