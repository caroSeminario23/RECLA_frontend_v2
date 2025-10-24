import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:recla/models/insignia.dart';
import 'package:recla/utils/servicios_externos.dart';

class InsigniaService {
  final String baseUrl = '$servidorGamificacion/insignia_routes';

  // MOSTRAR INSIGNIAS
  Future<List<InsigniaConEstado>> mostrarInsignias(int idUsuario, int tipoPuntos) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_insignias_con_estado'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario, 'tipo_ptos': tipoPuntos}),
    );

    // Imprimir la respuesta
    //print('Respuesta para tipoPuntos $tipoPuntos: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => InsigniaConEstado.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener insignias: ${response.statusCode} - $message');
    }
  }


  // MOSTRAR INSIGNIAS DESBLOQUEADAS POR UN USUARIO
  Future<List<InsigniaDesbloqueada>> mostrarInsigniasDesbloqueadas(int idUsuario, int tipoPuntos) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_insignias_con_estado_usuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario, 'tipo_ptos': tipoPuntos}),
    );

    // Imprimir la respuesta
    //print('Respuesta para tipoPuntos $tipoPuntos: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => InsigniaDesbloqueada.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener insignias: ${response.statusCode} - $message');
    }
  }
}