import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:recla/models/usuario.dart';

class UsuarioService {
  final String baseUrl = "http://127.0.0.1:5000/usuario_routes";

  // INICIO DE SESIÓN
  Future<UsuarioLoginResponse> loginEcoaprendiz(UsuarioLoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login_ecoaprendiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final dynamic data = jsonResp['data'];

      if (data == null) {
        throw Exception('Respuesta inválida del servidor: falta campo "data"');
      }
      return UsuarioLoginResponse.fromJson(data);

    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al iniciar sesión: ${response.statusCode} - $message');
    }
  }

  // REGISTRO
  Future<bool> registroEcoaprendiz(UsuarioRegistro request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro_ecoaprendiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al registrar usuario: ${response.statusCode} - $message');
    }
  }

  // VALIDACIÓN DE EMAIL
  Future<bool> validarEmail(EmailValidacion request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verificar_email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al validar email: ${response.statusCode} - $message');
    }
  }

  // VALIDACIÓN DE USERNAME
  Future<bool> validarUsername(UsernameValidacion request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verificar_username'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al validar username: ${response.statusCode} - $message');
    }
  }
  
}

