import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Reducere',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorReducere(),
    );
  }
}

class CalculatorReducere extends StatefulWidget {
  const CalculatorReducere({super.key});

  @override
  State<CalculatorReducere> createState() => _CalculatorReducereState();
}

class _CalculatorReducereState extends State<CalculatorReducere> {
  final TextEditingController _pretController = TextEditingController();
  final TextEditingController _procentController = TextEditingController();

  String _rezultatReducere = '';
  String _rezultatFinal = '';
  String _tipReducere = 'Procent';
  final List<String> _tipuriReducere = ['Procent', 'Suma fixa'];

  void _calculeazaReducere() {
    double? pret = double.tryParse(_pretController.text);
    double? procent = double.tryParse(_procentController.text);

    if (pret == null || procent == null) {
      setState(() {
        _rezultatReducere = 'Introdu valori valide!';
        _rezultatFinal = '';
      });
      return;
    }

    if (pret <= 0 || procent < 0) {
      setState(() {
        _rezultatReducere = 'Valorile trebuie sa fie pozitive!';
        _rezultatFinal = '';
      });
      return;
    }

    double reducere;
    double pretFinal;

    if (_tipReducere == 'Procent') {
      if (procent > 100) {
        setState(() {
          _rezultatReducere = 'Procentul nu poate depasi 100%!';
          _rezultatFinal = '';
        });
        return;
      }
      reducere = pret * (procent / 100);
      pretFinal = pret - reducere;
    } else {
      reducere = procent;
      pretFinal = pret - reducere;
      if (pretFinal < 0) {
        setState(() {
          _rezultatReducere = 'Reducerea nu poate depasi pretul!';
          _rezultatFinal = '';
        });
        return;
      }
    }

    setState(() {
      _rezultatReducere = 'Reducere: ${reducere.toStringAsFixed(2)} lei';
      _rezultatFinal = 'Pret final: ${pretFinal.toStringAsFixed(2)} lei';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Reducere'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Introduceti datele:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _pretController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pret initial (lei)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _procentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tipReducere == 'Procent'
                    ? 'Procent reducere (%)'
                    : 'Suma reducere (lei)',
                border: const OutlineInputBorder(),
                prefixIcon: _tipReducere == 'Procent'
                    ? const Icon(Icons.percent)
                    : const Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 20),

            // DropdownButton
            Row(
              children: [
                const Text('Tip reducere: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _tipReducere,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _tipReducere = newValue!;
                      _rezultatReducere = '';
                      _rezultatFinal = '';
                    });
                  },
                  items: _tipuriReducere.map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // RadioButton (alternativă)
            const Text(
              'SAU alege din Radio Buttons:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Procent'),
                    value: 'Procent',
                    groupValue: _tipReducere,
                    onChanged: (String? value) {
                      setState(() {
                        _tipReducere = value!;
                        _rezultatReducere = '';
                        _rezultatFinal = '';
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Suma fixa'),
                    value: 'Suma fixa',
                    groupValue: _tipReducere,
                    onChanged: (String? value) {
                      setState(() {
                        _tipReducere = value!;
                        _rezultatReducere = '';
                        _rezultatFinal = '';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculeazaReducere,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('CALCULEAZA REDUCEREA'),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'REZULTATE:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _rezultatReducere,
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _rezultatFinal,
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}