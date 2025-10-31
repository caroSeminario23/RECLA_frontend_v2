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

  List<InsigniaDesbloqueada> _insigniasCompraDesbloqueadasUsuario = [];
  List<InsigniaDesbloqueada> _insigniasVentaDesbloqueadasUsuario = [];
  List<InsigniaDesbloqueada> _insigniasRecursosDesbloqueadasUsuario = [];

  bool _isLoading = false;
  String? _errorMessage;

  //List<InsigniaConEstado> get insignias => _insigniasConEstado;

  // Getters para cada tipo de insignias
  List<InsigniaConEstado> get insigniasCompra => _insigniasCompra;
  List<InsigniaConEstado> get insigniasVenta => _insigniasVenta;
  List<InsigniaConEstado> get insigniasRecursos => _insigniasRecursos;

  List<InsigniaDesbloqueada> get insigniasCompraDesbloqueadasUsuario => _insigniasCompraDesbloqueadasUsuario;
  List<InsigniaDesbloqueada> get insigniasVentaDesbloqueadasUsuario => _insigniasVentaDesbloqueadasUsuario;
  List<InsigniaDesbloqueada> get insigniasRecursosDesbloqueadasUsuario => _insigniasRecursosDesbloqueadasUsuario;

  
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


  // Método para obtener las insignias desbloqueadas por un usuario
  Future<bool> obtenerInsigniasDesbloqueadasUsuario(int idUsuario, int tipoPuntos) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final insigniasDesbloqueadas = await _insigniaService.mostrarInsigniasDesbloqueadas(idUsuario, tipoPuntos);

      // Guardar las insignias según su tipo
      switch(tipoPuntos) {
        case 1:
          _insigniasCompraDesbloqueadasUsuario = insigniasDesbloqueadas;
          break;
        case 2:
          _insigniasVentaDesbloqueadasUsuario = insigniasDesbloqueadas;
          break;
        case 3:
          _insigniasRecursosDesbloqueadasUsuario = insigniasDesbloqueadas;
          break;
      }

      //_insigniasConEstado = insigniasConEstado;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar insignias desbloqueadas por el usuario $idUsuario';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Desbloquear una insignia para un usuario
  Future<bool> desbloquearInsignia(int idUsuario, int idInsignia) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final exito = await _insigniaService.desbloquearInsignia(idUsuario, idInsignia);

      if (exito) {
        // Actualizar el estado de la insignia en la lista correspondiente
        for (var insignia in _insigniasCompra) {
          if (insignia.idInsignia == idInsignia) {
            insignia.desbloqueada = true;
            break;
          }
        }
        for (var insignia in _insigniasVenta) {
          if (insignia.idInsignia == idInsignia) {
            insignia.desbloqueada = true;
            break;
          }
        }
        for (var insignia in _insigniasRecursos) {
          if (insignia.idInsignia == idInsignia) {
            insignia.desbloqueada = true;
            break;
          }
        }

        notifyListeners();
      }

      return exito;
    } catch (e) {
      _errorMessage = 'Error al desbloquear la insignia $idInsignia para el usuario $idUsuario';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}