import 'package:flutter/material.dart';
import 'package:recla/services/estatus.dart';

class EstatusProvider extends ChangeNotifier {

  // Servicio de estatus
  final EstatusService _estatusService = EstatusService();

  int? _racha;
  int? _ptosExperiencia;
  int? _ptosCompras;
  int? _ptosVentas;
  int? _ptosRecEducativos;
  bool _isLoading = false;
  String? _errorMessage;

  int? get racha => _racha;
  int? get ptosExperiencia => _ptosExperiencia;
  int? get ptosCompras => _ptosCompras;
  int? get ptosVentas => _ptosVentas;
  int? get ptosRecEducativos => _ptosRecEducativos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> cargarEstatusPerfil(int idUsuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final estatusPerfil = await _estatusService.mostrarEstatusPerfil(idUsuario);
      _racha = estatusPerfil.racha;
      _ptosExperiencia = estatusPerfil.ptosSistema;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar estatus de perfil';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cargarEstatusContadores(int idUsuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final estatusContadores = await _estatusService.mostrarEstatusContadores(idUsuario);
      _ptosCompras = estatusContadores.nCompras;
      _ptosVentas = estatusContadores.nVentas;
      _ptosRecEducativos = estatusContadores.nRecEducativos;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar estatus de contadores';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}