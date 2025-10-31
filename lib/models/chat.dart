// lib/models/chat.dart

// 1. Request para obtener el historial
class ChatHistorialRequest {
  int idUsuario1;
  int idUsuario2;

  ChatHistorialRequest({
    required this.idUsuario1,
    required this.idUsuario2,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_usuario_1': idUsuario1,
      'id_usuario_2': idUsuario2,
    };
  }
}

// 2. Response de CADA mensaje en el historial
// Esto es el equivalente a tu ProductoFiltradoResponse
class ChatMensajeResponse {
  int usuarioId;
  String mensaje;
  DateTime fechaHora;

  ChatMensajeResponse({
    required this.usuarioId,
    required this.mensaje,
    required this.fechaHora,
  });

  factory ChatMensajeResponse.fromJson(Map<String, dynamic> json) {
    return ChatMensajeResponse(
      usuarioId: json['id_usuario'] as int,
      mensaje: json['mensaje'] as String,
      fechaHora: DateTime.parse(json['fecha_hora'] as String),
    );
  }
}

// 3. Request para enviar un mensaje
class ChatEnviarRequest {
  int idUsuario1; // Quien envía
  int idUsuario2; // Quien recibe
  String mensaje;

  ChatEnviarRequest({
    required this.idUsuario1,
    required this.idUsuario2,
    required this.mensaje,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_usuario_1': idUsuario1,
      'id_usuario_2': idUsuario2,
      'mensaje': mensaje,
    };
  }
}