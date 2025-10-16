import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recla/models/certificado.dart';
import 'package:recla/utils/servicios_externos.dart';

class CertificadoService {
  final String baseUrl = '$servidorGamificacion/certificado_routes';

  // MOSTRAR CERTIFICADOS
  Future<List<CertificadoConEstado>> mostrarCertificados(int idUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_certificados_con_estado'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario}),
    );

    // Imprimir la respuesta
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => CertificadoConEstado.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener certificados: ${response.statusCode} - $message');
    }
  }
}