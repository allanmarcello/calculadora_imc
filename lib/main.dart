import 'package:flutter/material.dart';
import 'pessoa.dart';
import 'hex_color.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _result;
  double result_imc = 2;
  Color _color = HexColor('#000000');

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  var radioSelected = 1;

  Widget botao(BuildContext context) {
    var center = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: const Text('Homem'),
            leading: Radio(
              value: 1,
              onChanged: (int value) {
                radioSelected = value;
                resetFields();
              },
              groupValue: radioSelected,
            ),
          ),
          ListTile(
            title: const Text('Mulher'),
            leading: Radio(
              value: 2,
              onChanged: (int value) {
                radioSelected = value;
                resetFields();
              },
              groupValue: radioSelected,
            ),
          ),
        ],
      ),
    );

    return center;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso (kg)",
              error: "Insira seu peso!",
              controller: _weightController),
          buildTextFormField(
              label: "Altura (cm)",
              error: "Insira uma altura!",
              controller: _heightController),
          botao(context),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Widget buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              Pessoa p = Pessoa();
              p.peso = double.parse(_weightController.text);
              p.altura = double.parse(_heightController.text) / 100;
              result_imc = p.calcularIMC();
              _result = result_imc.toStringAsFixed(2);
              if (radioSelected == 1) {
                _color = HexColor("#4B0082");
                if (result_imc < 20.7) {
                  _result += "\nAbaixo do peso para Homem";
                  _color = HexColor("#9400D3");
                } else if (result_imc < 26.4) {
                  _result += "\nPeso Ideal para Homem";
                  _color = HexColor("#1E90FF");
                } else if (result_imc < 27.8) {
                  _result += "\nObsidade Grau 1 para Homem";
                  _color = HexColor("#FFFF00");
                } else if (result_imc < 31.1) {
                  _result += "\nObsidade Grau 2 para Homem";
                  _color = HexColor("#FF4500");
                } else {
                  _result += "\nObesidade Grau 3 para Homem";
                  _color = HexColor("#8B0000");
                }
              }
              if (radioSelected == 2) {
                _color = HexColor("#4B0082");
                if (result_imc < 19.1) {
                  _result += "\nAbaixo do peso para Mulher";
                  _color = HexColor("#9400D3");
                } else if (result_imc < 25.8) {
                  _result += "\nPeso Ideal para Mulher";
                  _color = HexColor("#1E90FF");
                } else if (result_imc < 27.3) {
                  _result += "\nObsidade Grau 1 para Mulher";
                  _color = HexColor("#FFFF00");
                } else if (result_imc < 32.3) {
                  _result += "\nObsidade Grau 2 para Mulher";
                  _color = HexColor("#FF4500");
                } else {
                  _result += "\nObesidade Grau 3 para Mulher";
                  _color = HexColor("#8B0000");
                }
              }
            });
          }
        },
        child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _color, fontWeight: FontWeight.bold, fontSize: 30.0),
      ),
    );
  }

  Widget buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}
