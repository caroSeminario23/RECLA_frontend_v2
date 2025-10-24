import 'package:flutter/material.dart';

import 'package:recla/models/certificado.dart';
import 'package:recla/services/certificado.dart';

class CertificadoProvider extends ChangeNotifier {
   // Servicio de certificados
   final CertificadoService _certificadoService = CertificadoService();

  List<CertificadoConEstado> _certificadosConEstado = [];
  List<CertificadoDesbloqueado> _certificadosDesbloqueadosUsuario = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<CertificadoConEstado> get certificados => _certificadosConEstado;
  List<CertificadoDesbloqueado> get certificadosDesbloqueadosUsuario => _certificadosDesbloqueadosUsuario;
  
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



  // Método para obtener los certificados desbloqueados
  Future<bool> obtenerCertificadosDesbloqueados(int idUsuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final certificadosDesbloqueados = await _certificadoService.mostrarCertificadosDesbloqueados(idUsuario);
      _certificadosDesbloqueadosUsuario = certificadosDesbloqueados;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar certificados desbloqueados del usuario $idUsuario';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}