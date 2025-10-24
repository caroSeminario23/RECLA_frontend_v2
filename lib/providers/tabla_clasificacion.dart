import 'package:flutter/material.dart';

import 'package:recla/models/tabla_clasificacion.dart';
import 'package:recla/services/tabla_clasificacion.dart';

class TablaClasificacionProvider extends ChangeNotifier {
  // Servicio de tabla de clasificación
  final TablaClasificacionService _tablaClasificacionService = TablaClasificacionService();

  List<TablaClasificacion> _tablaClasificacion = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TablaClasificacion> get tablaClasificacion => _tablaClasificacion;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener la tabla de clasificación
  Future<bool> mostrarTablaClasificacion() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tablaClasificacion = await _tablaClasificacionService.mostrarTablaClasificacion();
      _tablaClasificacion = tablaClasificacion;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar la tabla de clasificación';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}