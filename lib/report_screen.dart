import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:s_p/utils/http_class.dart';
import 'package:s_p/widgets/dialog_ocorrencia.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'location_screen.dart';

enum SuspectGenre {
  m,
  f,
}

class ReportCrimeScreen extends StatefulWidget {
  ReportCrimeScreen(this.center);

  final center;

  @override
  State<ReportCrimeScreen> createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  late String name = '';
  late String rg = '';
  late SuspectGenre genre = SuspectGenre.m;
  late String birth = 'Data de nascimento:';
  late String crime = 'Roubo';
  late String where = 'Onde ocorreu?';
  late String when = 'Quando ocorreu?';
  late String description = '';

  Future<bool> _sendOcorrencia(Map ocorrencia) async {
    // -> Ocorrencia
    // name: String
    // rg: String
    // sexo: String
    // data: String
    // descricao:  String
    // quando: String
    // onde: String
    // delito: int

    final response = await dio.Dio().post(
      WebRoutes.registerOcorrencia,
      data: ocorrencia,
    );

    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      return true;
    } else {
      return false;
    }
  }

  static List<String> crimes = ['Roubo', 'Furto', 'Latrocínio', 'Outro'];


  @override
  void initState() {
    genre = SuspectGenre.m;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
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
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
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
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'RG válido',
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
                            items: crimes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 8),
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                birth,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                                BottomPicker.date(
                                  title: 'Selecione uma data',
                                  dateOrder: DatePickerDateOrder.dmy,
                                  initialDateTime: DateTime.utc(1999),
                                  pickerTextStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  titleStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                  onChange: (index) {
                                    print(index);
                                  },
                                  onSubmit: (index) {
                                    birth = index.toString();
                                  },
                                  bottomPickerTheme: BOTTOM_PICKER_THEME.blue,
                                ).show(context);
                            },
                            child: Text('Selecione'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 8),
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                where,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LocationScreen(widget.center),
                                ),
                              ).then((address) {
                                setState(() {
                                  where = address;
                                });
                              });
                            },
                            child: Text('Selecione'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 8),
                            child: Text(
                              when,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: 12, minute: 00),
                              ).then((time) {
                                if (time == null) {
                                  print('cancelado');
                                } else {
                                  String minutes =
                                      time.minute.toString().length < 2
                                          ? '0${time.minute}'
                                          : '${time.minute}';
                                  String hours = time.hour.toString().length < 2
                                      ? '0${time.hour}'
                                      : '${time.hour}';
                                  setState(() {
                                    when = '$hours:$minutes';
                                  });
                                  print(when);
                                }
                              });
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
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () async {
                      final result = await _sendOcorrencia({
                        'name': name,
                        'rg': rg,
                        'sexo': genre == SuspectGenre.m ? 'masculino' : 'feminino',
                        'data': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        'descricao': description,
                        'quando': when,
                        'onde': where,
                        'delito': crimes.indexOf(crime) + 1,
                      });

                      if (result) {
                        await showDialog(
                          context: context,
                          builder: (context) => DialogOcorrencia(),
                        );

                        Navigator.pop(context);
                      } else {}
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
      ),
    );
  }
}
