import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/widgets/encabezado.dart';
import 'package:intl/intl.dart';

class RegistroEco extends StatefulWidget {
  const RegistroEco({super.key});

  @override
  State<RegistroEco> createState() => _RegistroEcoState();
}

class _RegistroEcoState extends State<RegistroEco> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fecNacimientoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  DateTime? _fecNacimiento;

  Future<void> _handleRegistro() async {
    if (_formKey.currentState!.validate()) {
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);

      final email = _emailController.text.trim();
      final fecNacimiento = _fecNacimientoController.text;
      final username = _usernameController.text.trim();
      final contrasena = _contrasenaController.text;

      final success = await usuarioProvider.registro(
        email,
        fecNacimiento,
        username,
        contrasena
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registro exitoso. Ahora puedes iniciar sesión.'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
        Navigator.of(context).pop();
      } else if (usuarioProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(usuarioProvider.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year - 17); // 18 años atrás

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecNacimiento ?? lastDate,
      firstDate: DateTime(1975),
      lastDate: lastDate,
    );
    if (picked != null && picked != _fecNacimiento) {
      setState(() {
        _fecNacimiento = picked;
        _fecNacimientoController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ENCABEZADO
                const Encabezado(),

                const SizedBox(height: 40),

                // CORREO ELECTRÓNICO
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    final regex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!regex.hasMatch(value)) {
                      return 'Correo no válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // FECHA DE NACIMIENTO
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _fecNacimientoController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu fecha de nacimiento';
                        }
                        final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                        if (!regex.hasMatch(value)) {
                          return 'Formato no válido. Usa YYYY-MM-DD';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                /*TextFormField(
                  controller: _fecNacimientoController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu fecha de nacimiento';
                    }
                    final regex =
                        RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!regex.hasMatch(value)) {
                      return 'Formato no válido. Usa YYYY-MM-DD';
                    }
                    return null;
                  },
                ),*/
                const SizedBox(height: 12),

                // NOMBRE DE USUARIO
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un nombre de usuario';
                    }
                    if (value.length < 5 || value.length > 20) {
                      return 'El nombre de usuario debe tener entre 5 y 20 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // CONTRASEÑA
                TextFormField(
                  controller: _contrasenaController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    if (value.length != 6) {
                      return 'Debe tener exactamente 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // CONFIRMAR CONTRASEÑA
                TextFormField(
                  controller: _confirmarContrasenaController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma tu contraseña';
                    }
                    if (value != _contrasenaController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // BOTÓN REGISTRARSE
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: usuarioProvider.isLoading
                        ? null 
                        : _handleRegistro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.0,
                      ),
                      elevation: 0,
                      // padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: usuarioProvider.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Registrarse como Ecoaprendiz'),
                        /*? const CircularProgressIndicator()
                        : const Text(
                            'Registrarse como Ecoaprendiz',
                            style: TextStyle(fontSize: 16),
                          ),*/
                  ),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}