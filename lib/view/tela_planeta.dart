import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';

import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Function() onFinalizado;
  final Planeta planeta;

  const TelaPlaneta({
    super.key,
    required this.planeta,
    required this.onFinalizado,
    required String title,
    required this.isIncluir,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;
  @override
  void initState() {
    _planeta = widget.planeta;
    _nameController.text = _planeta.nome;
    _sizeController.text = _planeta.tamanho.toString();
    _distanceController.text = _planeta.distancia.toString();
    _nicknameController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _distanceController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      //dados validados com sucesso
      _formkey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados do planeta foram ${widget.isIncluir ? 'incluídos' : 'alterados'} com sucesso!')),
      );
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 3,
        title: Text('Cadastrar Planeta'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, informe o nome do Planeta (3 ou mais caracteres.)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                TextFormField(
                  controller: _sizeController,
                  decoration: InputDecoration(
                    labelText: 'Tamanho (em km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 2) {
                      return 'Por favor, informe o tamanho (2 ou mais caracteres.)';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, informe um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                TextFormField(
                  controller: _distanceController,
                  decoration: InputDecoration(
                    labelText: 'Distância (em milhões de km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, informe a distância em KM';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, informe um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: 'Apelido (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _planeta.apelido = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [              
                      ElevatedButton(
                  onPressed: ()=> Navigator.of(context).pop(), child:
                 Text('Cancelar'),
                ),
                                ElevatedButton(
                  onPressed: _submitForm, //submitForm,
                  child: Text('Confirmar'),
                ),],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
