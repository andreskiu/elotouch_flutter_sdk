import 'package:flutter/material.dart';

import 'package:elotouch_flutter_plugin/elotouch_flutter_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String textoAImprimir;
  bool methodOutput = false;

  void _print() async {
    final _isPrinterConnected = await ElotouchDevice.isPrinterConnected();

    if (_isPrinterConnected) {
      await ElotouchDevice.printEmptyLine();
      methodOutput = await ElotouchDevice.printText(
        text: "Test Working!",
        isBold: true,
        alignment: EloAlignment.center,
        fontSize: ElotouchFontSize.l,
      );

      methodOutput = await ElotouchDevice.printEmptyLine();

      await ElotouchDevice.printRow(
        cols: [
          TextColumn(text: "Account"),
          TextColumn(text: "1234567890", aligment: EloColumnAlignment.end),
        ],
      );
      methodOutput = await ElotouchDevice.printEmptyLine();
      try {
        await ElotouchDevice.printRow(
          cols: [
            TextColumn(text: "Account Medium"),
            TextColumn(text: "1234567890", aligment: EloColumnAlignment.end),
          ],
          size: ElotouchFontSize.m,
        );
      } catch (e) {
        await ElotouchDevice.printText(text: "TEXTO LARGO");
      }

      methodOutput = await ElotouchDevice.printEmptyLine();
      await ElotouchDevice.printRow(
        cols: [
          TextColumn(
            text: "Account Large",
            maxWidth: 8,
          ),
          TextColumn(
            text: "1234567890",
            aligment: EloColumnAlignment.end,
            maxWidth: 8,
          ),
        ],
        size: ElotouchFontSize.l,
      );

      methodOutput = await ElotouchDevice.printEmptyLine();
      try {
        await ElotouchDevice.printRow(
          cols: [
            TextColumn(text: "Account XLarge"),
            TextColumn(text: "1234567890", aligment: EloColumnAlignment.end),
          ],
          size: ElotouchFontSize.xl,
        );
      } catch (e) {
        await ElotouchDevice.printText(text: "Exception, text too large");
      }
      methodOutput = await ElotouchDevice.printEmptyLine();

      // this account will be cut due to the max width of that column
      await ElotouchDevice.printRow(
        cols: [
          TextColumn(text: "Account", maxWidth: 5),
          TextColumn(
            text: "1234567890",
            aligment: EloColumnAlignment.end,
            maxWidth: 27,
          ),
        ],
      );
      // this method wil not add one blank line. It will add 4 o 5...
      // if you put lines: 2, it will add probably 8 - 10 lines
      // this method is usefull to leave a blank space at the end of the print.
      await ElotouchDevice.feed(lines: 1);
    } else {
      methodOutput = false;
    }
    setState(() {
      // _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Press the floating button To print something"),
              Text("PRINTING SUCCESFUL?: " + methodOutput.toString()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _print,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
