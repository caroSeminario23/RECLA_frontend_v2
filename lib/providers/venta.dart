import 'package:flutter/material.dart';
import 'package:recla/models/venta.dart';
import 'package:recla/services/venta.dart';

class VentaProvider extends ChangeNotifier {
  final VentaService _ventaService = VentaService();
  bool _isLoading = false;
  String? _errorMessage;
  bool? _isRegistered = false;
  
  bool? get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get isRegistered => _isRegistered;

  //REGISTRO VENTA
  Future<bool> registroVent(int idVendedor, int idComprador, int idProducto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = VentaRegistroRequest(
      idVendedor: idVendedor,
      idComprador: idComprador,
      idProducto: idProducto,
    );

    try {
      final response = await _ventaService.registroVenta(request);
      _isRegistered = response;
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Error al registrar venta';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}