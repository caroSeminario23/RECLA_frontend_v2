// lib/providers/conversaciones_provider.dart

import 'package:flutter/material.dart';
import '../models/chat.dart'; // Importa el modelo que acabamos de añadir
import '../services/chat.dart';

class ConversacionesProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  // --- ESTADO ---
  bool _isLoading = false;
  String? _errorMessage;
  List<ConversacionResumenResponse> _conversaciones = [];

  // --- GETTERS ---
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ConversacionResumenResponse> get conversaciones => _conversaciones;

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
}