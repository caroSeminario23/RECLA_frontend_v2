// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat.dart'; // Importa los modelos que acabamos de crear

class ChatService {

  final String _baseUrl = "http://127.0.0.1:5000/chat_routes";

  // Función para obtener el historial
  Future<List<ChatMensajeResponse>> getHistorial(ChatHistorialRequest request) async {
    final url = Uri.parse("$_baseUrl/chat_historial");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      print("getHistorial: Body (Recibido): ${response.body}");
      final List<dynamic> jsonList = jsonDecode(response.body);
      // Mapea la lista de JSON a la lista de Modelos
      return jsonList.map((json) => ChatMensajeResponse.fromJson(json)).toList();
    } else {
      // Si falla, lanza una excepción que el Provider atrapará
      throw Exception('Error al cargar el historial de chat');
    }
  }

  // Función para enviar un mensaje
  Future<bool> enviarMensaje(ChatEnviarRequest request) async {
    final url = Uri.parse("$_baseUrl/enviar_mensaje");
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      // 201 Creado (éxito)
      return true;
    } else {
      // Si falla, lanza una excepción
      throw Exception('Error al enviar el mensaje');
    }
  }
}