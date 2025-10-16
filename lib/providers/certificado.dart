import 'package:flutter/material.dart';
import 'package:recla/models/certificado.dart';
import 'package:recla/services/certificado.dart';

class CertificadoProvider extends ChangeNotifier {
   // Servicio de certificados
   final CertificadoService _certificadoService = CertificadoService();

  List<CertificadoConEstado> _certificadosConEstado = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CertificadoConEstado> get certificados => _certificadosConEstado;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener los certificados
  Future<bool> obtenerCertificados(int idUsuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final certificadosConEstado = await _certificadoService.mostrarCertificados(idUsuario);
      _certificadosConEstado = certificadosConEstado;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar certificados con estado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}