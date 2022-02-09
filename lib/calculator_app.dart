// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petitparser/core.dart';
import 'package:petitparser/expression.dart';
import 'package:petitparser/parser.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String values = "";
double answer = 0.0;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            Text(
              '$answer',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              values,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: 'c',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        values = "";
                        answer = 0;
                      });
                    }
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '+/-',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        answer = answer * -1;
                      });
                    }
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '%',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        answer = answer / 100;
                      });
                    }
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.yellow,
                  label: '/',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        values = values + '/';
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '7',
                  ontap: () {
                    setState(() {
                      values = values + '7';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '8',
                  ontap: () {
                    setState(() {
                      values = values + '8';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '9',
                  ontap: () {
                    setState(() {
                      values = values + '9';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.yellow,
                  label: 'x',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        values = values + 'x';
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '4',
                  ontap: () {
                    setState(() {
                      values = values + '4';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '5',
                  ontap: () {
                    setState(() {
                      values = values + '5';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '6',
                  ontap: () {
                    setState(() {
                      values = values + '6';
                    });
                  },
                ),
                StreamBuilder<Object>(
                    stream: null,
                    builder: (context, snapshot) {
                      return KeyPadWidget(
                        backgroundColor: Colors.yellow,
                        label: '-',
                        ontap: () {
                          if (values.isNotEmpty) {
                            setState(() {
                              values = values + '-';
                            });
                          }
                        },
                      );
                    }),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '1',
                  ontap: () {
                    setState(() {
                      values = values + '1';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '2',
                  ontap: () {
                    setState(() {
                      values = values + '2';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '3',
                  ontap: () {
                    setState(() {
                      values = values + '3';
                    });
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.yellow,
                  label: '+',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        values = values + '+';
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: ' 0               ',
                  ontap: () {
                    if (values.isNotEmpty) {
                      setState(() {
                        values = values + '0';
                      });
                    }
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.white,
                  label: '.',
                  ontap: () {
                    if (values.isEmpty) {
                      setState(() {
                        values = values + '0.';
                      });
                    } else {
                      setState(() {
                        values = values + '.';
                      });
                    }
                  },
                ),
                KeyPadWidget(
                  backgroundColor: Colors.yellow,
                  label: '=',
                  ontap: () {
                    Parser buildParser() {
                      final builder = ExpressionBuilder();
                      builder.group()
                        ..primitive((pattern('+-').optional() &
                                digit().plus() &
                                (char('.') & digit().plus()).optional() &
                                (pattern('eE') &
                                        pattern('+-').optional() &
                                        digit().plus())
                                    .optional())
                            .flatten('number expected')
                            .trim()
                            .map(num.tryParse))
                        ..wrapper(char('(').trim(), char(')').trim(),
                            (left, value, right) => value);
                      builder
                          .group()
                          .prefix(char('-').trim(), (op, num a) => -a);
                      builder.group().right(
                          char('^').trim(), (num a, op, num b) => pow(a, b));
                      builder.group()
                        ..left(char('x').trim(), (num a, op, num b) => a * b)
                        ..left(char('/').trim(), (num a, op, num b) => a / b);
                      builder.group()
                        ..left(char('+').trim(), (num a, op, num b) => a + b)
                        ..left(char('-').trim(), (num a, op, num b) => a - b);
                      return builder.build().end();
                    }

                    final parser = buildParser();

                    final _result = parser.parse(values);

                    setState(() {
                      answer = double.parse('${_result.value}');
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class KeyPadWidget extends StatelessWidget {
  const KeyPadWidget(
      {Key? key,
      required this.label,
      required this.backgroundColor,
      required this.ontap})
      : super(key: key);

  final String label;
  final Color backgroundColor;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(5),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90))),
        onPressed: ontap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 30,
          ),
        ));
  }
}
