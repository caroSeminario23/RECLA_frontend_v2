import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recla/models/sticker.dart';
import 'package:recla/utils/servicios_externos.dart';

class StickerService {
  final String baseUrl = '$servidorGamificacion/sticker_routes';

  // MOSTRAR STICKERS
  Future<List<StickersConEstado>> mostrarStickers(int idUsuario, int categoria) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_stickers_con_estado'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_usuario': idUsuario, 'categoria': categoria}),
    );

    // Imprimir la respuesta
    //print('Respuesta para tipoPuntos $tipoPuntos: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];

      return data.map((json) => StickersConEstado.fromJson(json)).toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception('Error al obtener stickers: ${response.statusCode} - $message');
    }
  }
}