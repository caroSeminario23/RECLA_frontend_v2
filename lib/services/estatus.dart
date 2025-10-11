import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:recla/models/estatus.dart';
import 'package:recla/utils/servicios_externos.dart';

class EstatusService {
  final String baseUrl = '$servidorUsuarios/estatus_routes';

  // MOSTRAR ESTATUS PERFIL
  Future<EstatusPerfil> mostrarEstatusPerfil(int idUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estatus_perfil'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final dynamic data = jsonResp['data'];

      if (data == null) {
        throw Exception('Respuesta inválida del servidor: falta campo "data"');
      }
      return EstatusPerfil.fromJson(data);
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener estatus de perfil: ${response.statusCode} - $message');
    }
  }


  // MOSTRAR ESTATUS CONTADORES
  Future<EstatusContadores> mostrarEstatusContadores(int idUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estatus_contadores'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final dynamic data = jsonResp['data'];

      if (data == null) {
        throw Exception('Respuesta inválida del servidor: falta campo "data"');
      }
      return EstatusContadores.fromJson(data);
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener estatus de contadores: ${response.statusCode} - $message');
    }
  }
}