import 'package:flutter/material.dart';

import 'package:recla/models/insignia.dart';
import 'package:recla/services/insignia.dart';

class InsigniaProvider extends ChangeNotifier {

  // Servicio de insignias
  final InsigniaService _insigniaService = InsigniaService();

  //List<InsigniaConEstado> _insigniasConEstado = [];

  // Tres listas separadas para cada tipo de insignias
  List<InsigniaConEstado> _insigniasCompra = [];
  List<InsigniaConEstado> _insigniasVenta = [];
  List<InsigniaConEstado> _insigniasRecursos = [];

  bool _isLoading = false;
  String? _errorMessage;

  //List<InsigniaConEstado> get insignias => _insigniasConEstado;

  // Getters para cada tipo de insignias
  List<InsigniaConEstado> get insigniasCompra => _insigniasCompra;
  List<InsigniaConEstado> get insigniasVenta => _insigniasVenta;
  List<InsigniaConEstado> get insigniasRecursos => _insigniasRecursos;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener las insignias
  Future<bool> obtenerInsignias(int idUsuario, int tipoPuntos) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final insigniasConEstado = await _insigniaService.mostrarInsignias(idUsuario, tipoPuntos);

      // Guardar las insignias según su tipo
      switch(tipoPuntos) {
        case 1:
          _insigniasCompra = insigniasConEstado;
          break;
        case 2:
          _insigniasVenta = insigniasConEstado;
          break;
        case 3:
          _insigniasRecursos = insigniasConEstado;
          break;
      }

      //_insigniasConEstado = insigniasConEstado;
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