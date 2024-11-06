import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _input = '';
  String _result = '';
  String _history = '';

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'AC') {
        _input = '';
        _result = '';
        _history = '';
      } else if (text == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (text == '=') {
        _calculateResult();
      } else if (_isOperator(text)) {
        if (_input.isNotEmpty && _isOperator(_input[_input.length - 1])) {
          _input = _input.substring(0, _input.length - 1) + text;
        } else {
          _input += text;
        }
      } else {
        _input += text;
      }
    });
  }

  bool _isOperator(String text) {
    return text == '+' || text == '-' || text == 'X' || text == '/';
  }

  void _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_input.replaceAll('X', '*'));
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _history = _input;
        _result = result.toString();
        _input = '';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String text, Color color, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            foregroundColor: MaterialStateProperty.all<Color>(textColor),
          ),
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF2C2C2C),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      _history,
                      style:
                          const TextStyle(fontSize: 20.0, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      _result,
                      style:
                          const TextStyle(fontSize: 24.0, color: Colors.yellow),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      _input,
                      style:
                          const TextStyle(fontSize: 32.0, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('7', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('8', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('9', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('/', const Color(0xFF607274), Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('4', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('5', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('6', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('X', const Color(0xFF607274), Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('1', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('2', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('3', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('-', const Color(0xFF607274), Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('0', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('.', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('⌫', const Color(0xFF2C2C2C), Colors.white),
                _buildButton('+', const Color(0xFF607274), Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('AC', const Color(0xFF607274), Colors.white),
                _buildButton('=', Colors.yellow, Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
