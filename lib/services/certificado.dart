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



  // MOSTRAR CERTIFICADOS DESBLOQUEADOS POR UN USUARIO
  Future<List<CertificadoDesbloqueado>> mostrarCertificadosDesbloqueados(int idUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_certificados_desbloqueados_usuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario}),
    );

    // Imprimir la respuesta
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => CertificadoDesbloqueado.fromJson(json)).toList();
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


  // DESBLOQUEAR CERTIFICADO (REVISAR)
  Future<bool> desbloquearCertificado(int idUsuario, int idCertificado) async {
    final response = await http.post(
      Uri.parse('$baseUrl/marcar_certificado_revisado'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_certificado': idCertificado, 'id_usuario': idUsuario}),
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
      throw Exception('Error al desbloquear certificado: ${response.statusCode} - $message');
    }
  }


  // ENVIAR CERTIFICADO (REVISAR)
  Future<bool> enviarCertificado(int idUsuario, int idCertificado, String username, String plantillaCertificadoUrl) async {
    final response = await http.post(
      Uri.parse('$baseUrl/enviar_certificado'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_certificado': idCertificado, 
        'id_usuario': idUsuario,
        'username': username,
        'plantilla_url': plantillaCertificadoUrl,
      }),
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
      throw Exception('Error al enviar certificado: ${response.statusCode} - $message');
    }
  }
}