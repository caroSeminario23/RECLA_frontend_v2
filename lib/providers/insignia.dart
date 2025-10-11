import 'package:flutter/material.dart';

import 'package:recla/models/insignia.dart';
import 'package:recla/services/insignia.dart';

class InsigniaProvider extends ChangeNotifier {

  // Servicio de insignias
  final InsigniaService _insigniaService = InsigniaService();

  List<InsigniaConEstado> _insigniasConEstado = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<InsigniaConEstado> get insignias => _insigniasConEstado;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener las insignias
  Future<bool> obtenerInsignias(int idUsuario, int tipoPuntos) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final insigniasConEstado = await _insigniaService.mostrarInsignias(idUsuario, tipoPuntos);
      _insigniasConEstado = insigniasConEstado;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar insignias con estado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}