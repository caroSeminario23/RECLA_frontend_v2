import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recla/models/recurso_educativo.dart';
import 'package:recla/utils/servicios_externos.dart';

class RecursoEducativoService {
  final String baseUrl = '$servidorGamificacion/recurso_educativo_routes';

  // MOSTRAR PORTADAS DE RECURSOS EDUCATIVOS
  Future<List<RecursoEducativoPortada>> presentarPortadasRecEducativos(int idUsuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/portadas_recursos_educativos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => RecursoEducativoPortada.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al presentar las portadas de recursos educativos: ${response.statusCode} - $message');
    }
  }

  // PRESENTAR CONTENIDO DE UN RECURSO EDUCATIVO
  Future<RecursoEducativoContenido> presentarContenidoRecEducativo(int idRecEducativo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detalle_recurso_educativo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_rec_edu': idRecEducativo}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final Map<String, dynamic> data = jsonResp['data'];

      return RecursoEducativoContenido.fromJson(data);
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al presentar el contenido de un recurso educativo: ${response.statusCode} - $message');
    }
  }


  // CARGAR CUESTIONARIO DE RECURSO EDUCATIVO
  Future<List<RecursoEducativoCuestionario>> cargarCuestionarioRecEducativo(int idRecEducativo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cargar_cuestionario_recurso_educativo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_rec_edu': idRecEducativo}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => RecursoEducativoCuestionario.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al cargar el cuestionario del recurso educativo $idRecEducativo: ${response.statusCode} - $message');
    }
  }


  // GUARDAR LAS RESPUESTAS DE UN CUESTIONARIO DE RECURSO EDUCATIVO
  Future<List<RecursoEducativoRespuesta>> guardarRptsCuestionarioRecEducativo(int idUsuario, int idRecEducativo, Map<int, String> respuestas) async {
    final response = await http.post(
      Uri.parse('$baseUrl/guardar_respuestas_cuestionario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario, 'id_rec_edu': idRecEducativo, 'respuestas': respuestas}),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => RecursoEducativoRespuesta.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al enviar respuestas del recurso educativo $idRecEducativo: ${response.statusCode} - $message');
    }
  }
}