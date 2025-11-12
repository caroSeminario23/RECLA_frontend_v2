import 'package:flutter/material.dart';
import 'package:recla/models/chats.dart';
import 'package:recla/services/chats.dart';

class ChatsProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  // --- ESTADO ---
  bool _isLoading = false;
  String? _errorMessage;
  List<ConversacionResumenResponse> _conversaciones = [];
  List<ChatMensajeResponse> _mensajes = [];

  // --- GETTERS ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ConversacionResumenResponse> get conversaciones => _conversaciones;
  List<ChatMensajeResponse> get mensajes => _mensajes;

  // --- OBTENER LISTA DE CONVERSACIONES ---
  Future<void> cargarConversaciones(int idUsuarioActual) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _chatService.getConversaciones(idUsuarioActual);
      _conversaciones = response;
      
      // Opcional: ordenar por la fecha del último mensaje (más reciente primero)
      _conversaciones.sort((a, b) => b.fechaUltimoMensaje.compareTo(a.fechaUltimoMensaje));
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar conversaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


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