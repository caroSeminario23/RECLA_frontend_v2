import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recla/models/venta.dart';

//REGISTRO VENTA
class VentaService {
  final String baseUrl = "http://127.0.0.1:5000/venta_routes";
  Future<bool> registroVenta(VentaRegistroRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro_venta'),
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
      throw Exception(
        'Error al registrar venta: ${response.statusCode} - $message',
      );
    }
  }
}