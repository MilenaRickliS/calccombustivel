import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Combustível',
      home: Home(), 
      debugShowCheckedModeBanner: false, 
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // Controladores para capturar entrada do usuário
  final TextEditingController _alcoolController = TextEditingController();
  final TextEditingController _gasolinaController = TextEditingController();

  String _infoText = "Informe os preços do álcool e da gasolina!"; 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  double _opacity = 0.0; 
  late AnimationController _controller; 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _resetFields() {
    _alcoolController.clear();
    _gasolinaController.clear();

    setState(() {
      _infoText = "Informe os preços do álcool e da gasolina!";
      _opacity = 0.0; // Reseta a opacidade
    });
  }

  void _calculate() {
    try {
      double alcool = double.parse(_alcoolController.text);
      double gasolina = double.parse(_gasolinaController.text);
      double vantagem = alcool / gasolina; // Calcula

      setState(() {
        if (vantagem < 0.7) {
          _infoText = "Abasteça com Álcool. (${vantagem.toStringAsPrecision(3)})";
        } else {
          _infoText = "Abasteça com Gasolina. (${vantagem.toStringAsPrecision(3)})";
        }
        _opacity = 1.0; // Torna o texto visível
      });
    } catch (e) {
      setState(() {
        _infoText = "Por favor, insira valores válidos!"; // Mensagem de erro para entradas inválidas
        _opacity = 1.0; // Torna o texto visível
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera o controlador de animação
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de Combustível"), 
        centerTitle: true, 
        backgroundColor: const Color.fromARGB(255, 236, 201, 0), 
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh), 
            onPressed: _resetFields, 
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 251, 199), 
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0), 
        child: Form(
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: <Widget>[
              Icon(
                Icons.local_gas_station,
                size: 120.0,
                color: const Color.fromARGB(255, 114, 23, 23),
              ), // Ícone decorativo
              TextFormField(
                keyboardType: TextInputType.number, 
                decoration: InputDecoration(
                  labelText: " Preço do álcool ", 
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 201, 147, 0)), 
                                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 201, 147, 0)),
                  ),
                  prefixText: "R\$ ", // Adiciona o símbolo R$ fixo
                  prefixStyle: TextStyle(color: const Color.fromARGB(255, 201, 147, 0)),
                ),
                textAlign: TextAlign.center, 
                style: TextStyle(color: const Color.fromARGB(255, 201, 147, 0), fontSize: 25.0), 
                controller: _alcoolController, 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Insira o valor do álcool!"; // Mensagem de erro
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0), 
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: " Preço da gasolina ",
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 201, 147, 0)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 201, 147, 0)),
                  ),
                  prefixText: "R\$ ", // Adiciona o símbolo R$ fixo
                  prefixStyle: TextStyle(color: const Color.fromARGB(255, 201, 147, 0)),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: const Color.fromARGB(255, 201, 147, 0)),
                controller: _gasolinaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Insira o valor da gasolina!";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) { // Valida o formulário antes do cálculo
                      _calculate();
                    }
                  },
                  child: Text(
                    "Calcular",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 201, 147, 0), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              AnimatedOpacity(
                opacity: _opacity, // Controla a opacidade
                duration: Duration(milliseconds: 300), // Duração da animação
                child: Text(
                  _infoText, 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: const Color.fromARGB(255, 62, 128, 0), fontSize: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}