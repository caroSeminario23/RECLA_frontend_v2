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
  //mesajes
  Future<List<ConversacionResumenResponse>> getConversaciones(int idUsuarioActual) async {
    
    // 1. Apunta a tu ruta POST. 
    // Asegúrate de que el nombre ('/ultimo_mensaje' o '/mis_conversaciones') es correcto.
    final url = Uri.parse("$_baseUrl/mis_conversaciones"); // <-- ¡VERIFICA ESTA RUTA!

    // 2. Prepara el body que tu backend espera
    final body = jsonEncode({
      'id_usuario': idUsuarioActual,
    });

    // 3. Ejecuta la petición POST
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      // 4. Tu backend devuelve {"data": [...]}, así que extraemos "data"
      final List<dynamic> jsonList = jsonResponse['data'];

      // 5. TRADUCCIÓN: Convertimos tu respuesta al modelo que la UI espera
      List<ConversacionResumenResponse> conversaciones = [];
      for (var item in jsonList) {
        
        // Determina quién es el receptor
        int idReceptor = (item['id_usuario_1'] == idUsuarioActual)
            ? item['id_usuario_2']
            : item['id_usuario_1'];

        // Extrae el último mensaje y la fecha
        final ultimoMsgJson = item['ultimo_mensaje'];
        final String ultimoMensaje = ultimoMsgJson['mensaje'];
        final DateTime fechaUltimoMensaje = DateTime.parse(ultimoMsgJson['fecha_hora']);

        // 6. ¡LA CLAVE! Como el backend no da nombre, creamos uno temporal.
        final String nombreTemporal = "Usuario $idReceptor";

        conversaciones.add(
          ConversacionResumenResponse(
            idUsuarioReceptor: idReceptor,
            nombreReceptor: nombreTemporal, // <-- Usamos el nombre temporal
            ultimoMensaje: ultimoMensaje,
            fechaUltimoMensaje: fechaUltimoMensaje,
            avatarUrl: null, // No tenemos avatar
          ),
        );
      }
      
      return conversaciones;

    } else {
      // Si falla, lanza una excepción
      final errorBody = jsonDecode(response.body);
      throw Exception('Error al cargar conversaciones: ${errorBody['message']}');
    }
  }
}