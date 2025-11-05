// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/chat.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  // --- ESTADO ---
  bool _isLoading = false;
  String? _errorMessage;
  List<ChatMensajeResponse> _mensajes = [];

  // --- GETTERS ---
  bool get isLoading => _isLoading; // Tu ejemplo usa bool? pero bool es mejor
  String? get errorMessage => _errorMessage;
  List<ChatMensajeResponse> get mensajes => _mensajes;

  // --- OBTENER HISTORIAL DE CHAT ---
  Future<List<ChatMensajeResponse>> getHistorial(int idUsuario1, int idUsuario2) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = ChatHistorialRequest(
      idUsuario1: idUsuario1,
      idUsuario2: idUsuario2,
    );

    try {
      final response = await _chatService.getHistorial(request);
      _mensajes = response;
      // Opcional: ordenar por fecha
      _mensajes.sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
      
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Error al cargar el historial: $e';
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- ENVIAR MENSAJE ---
  Future<bool> enviarMensaje(int idUsuarioEnvia, int idUsuarioRecibe, String mensaje) async {
    _errorMessage = null;
    final request = ChatEnviarRequest(
      idUsuario1: idUsuarioEnvia,
      idUsuario2: idUsuarioRecibe,
      mensaje: mensaje,
    );

    try {
      final response = await _chatService.enviarMensaje(request);
      
      // Si el envío fue exitoso, refrescamos la lista de mensajes
      if (response) {
        await getHistorial(idUsuarioEnvia, idUsuarioRecibe);
      }
      
      _errorMessage = null;
      return response; // Devuelve true
    } catch (e) {
      _errorMessage = 'Error al enviar el mensaje: $e';
      notifyListeners(); // Notifica solo si hay error
      return false;
    }
  }
}