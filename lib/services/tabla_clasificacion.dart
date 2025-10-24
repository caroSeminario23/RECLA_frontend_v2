import 'dart:convert';
import 'package:recla/models/tabla_clasificacion.dart';
import 'package:http/http.dart' as http;

import 'package:recla/utils/servicios_externos.dart';

class TablaClasificacionService {
  final String baseUrl = '$servidorUsuarios/tabla_clasificacion_routes';

  // MOSTRAR TABLA DE CLASIFICACIÓN
  Future<List<TablaClasificacion>> mostrarTablaClasificacion() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_tabla_clasificacion'),
      headers: {'Content-Type': 'application/json'},
    );

    // Imprimir la respuesta
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => TablaClasificacion.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener tabla de clasificación: ${response.statusCode} - $message');
    }
  }
}