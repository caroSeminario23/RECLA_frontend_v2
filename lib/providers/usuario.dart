import 'package:flutter/material.dart';
import 'package:recla/models/usuario.dart';
import 'package:recla/services/usuario.dart';

class UsuarioProvider extends ChangeNotifier {

  // INICIO DE SESIÓN
  final UsuarioService _usuarioService = UsuarioService();

  int? _idUsuario;
  String? _username;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isRegistered = false;

  int? get idUsuario => _idUsuario;
  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isRegistered => _isRegistered;

  Future<bool> login(String email, String contrasena) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = UsuarioLoginRequest(email: email, contrasena: contrasena);

    try {
      final response = await _usuarioService.loginEcoaprendiz(request);
      _idUsuario = response.idUsuario;
      _username = response.username;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _idUsuario = null;
    _username = null;
    notifyListeners();
  }

  Future<bool> registro(String email, String contrasena, String fecNacimiento, String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = UsuarioRegistro(
      email: email,
      contrasena: contrasena,
      fecNacimiento: fecNacimiento,
      username: username,
    );

    try {
      final response = await _usuarioService.registroEcoaprendiz(request);
      _isRegistered = response;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar el usuario';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}