
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
  int idProducto; // Producto relacionado (opcional)

  ChatEnviarRequest({
    required this.idUsuario1,
    required this.idUsuario2,
    required this.mensaje,
    required this.idProducto,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_usuario_1': idUsuario1,
      'id_usuario_2': idUsuario2,
      'mensaje': mensaje,
      'id_producto': idProducto,
    };
  }
}


// 4. Response para CADA fila de la lista de chats
class ConversacionResumenResponse {
  final int idUsuarioReceptor;
  final String nombreReceptor;
  final String ultimoMensaje;
  final DateTime fechaUltimoMensaje;
  final String? avatarUrl;
  final int? idProducto; 
  // final int mensajesNoLeidos; // Opcional, para un futuro

  ConversacionResumenResponse({
    required this.idUsuarioReceptor,
    required this.nombreReceptor,
    required this.ultimoMensaje,
    required this.fechaUltimoMensaje,
    this.avatarUrl,
    this.idProducto,
  });

  factory ConversacionResumenResponse.fromJson(Map<String, dynamic> json) {
    return ConversacionResumenResponse(
      idUsuarioReceptor: json['id_usuario_receptor'] as int,
      nombreReceptor: json['nombre_receptor'] as String,
      ultimoMensaje: json['ultimo_mensaje'] as String,
      fechaUltimoMensaje: DateTime.parse(json['fecha_ultimo_mensaje'] as String),
      avatarUrl: json['avatar_url'] as String?,
      idProducto: json['id_producto'] as int?,
    );
  }
}