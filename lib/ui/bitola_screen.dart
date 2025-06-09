import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for filtering input

class BitolaScreen extends StatefulWidget {
  const BitolaScreen({super.key});

  @override
  State<BitolaScreen> createState() => _BitolaScreenState();
}

class _BitolaScreenState extends State<BitolaScreen> {
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _correnteController = TextEditingController();

  void _calcularBitola() async { // Make the function async to show dialog
    final double? distancia = double.tryParse(_distanciaController.text);
    final double? corrente = double.tryParse(_correnteController.text);

    String resultText;

    if (distancia != null && corrente != null) {
      final double bitola110 = (2 * corrente * distancia) / 294.64;
      final double bitola220 = (2 * corrente * distancia) / 510.4;

      resultText = '''
A bitola recomendada para Tensão de 127v é: ${bitola110.toStringAsFixed(2)}

A bitola recomendada para Tensão de 220v é: ${bitola220.toStringAsFixed(2)} 
''';
    } else {
      resultText = 'Por favor, insira valores válidos para distância e corrente.';
    }

    // Show the result in an AlertDialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Resultado"),
          content: Text(resultText),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _distanciaController.dispose();
    _correnteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de bitola(mm2)"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _distanciaController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Distância em metros',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _correnteController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Corrente em ampares',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularBitola,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
