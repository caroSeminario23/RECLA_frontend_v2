import 'package:flutter/material.dart';
import 'package:recla/models/recurso_educativo.dart';
import 'package:recla/services/recurso_educativo.dart';

class RecursoEducativoProvider extends ChangeNotifier {

  // Servicio de recursos educativos
  final RecursoEducativoService _recursoEducativoService = RecursoEducativoService();

  /*List<RecursoEducativoPortada> _receduPortadas = [];
  List<RecursoEducativoContenido> _receduContenido = [];
  List<RecursoEducativoCuestionario> _receduCuestionario = [];
  List<RecursoEducativoRespuesta> _receduRespuestas = [];*/

  bool _isLoading = false;
  String? _errorMessage;

  /*List<RecursoEducativoPortada> get receduPortadas => _receduPortadas;
  List<RecursoEducativoContenido> get receduContenido => _receduContenido;
  List<RecursoEducativoCuestionario> get receduCuestionario => _receduCuestionario;
  List<RecursoEducativoRespuesta> get receduRespuestas => _receduRespuestas;*/

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener las portadas de los recursos educativos
  Future<List<RecursoEducativoPortada>> presentarPortadasRecEducativos(int idUsuario) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final receduPortadas = await _recursoEducativoService.presentarPortadasRecEducativos(idUsuario);
      //_receduPortadas = receduPortadas;
      _errorMessage = null;
      return receduPortadas;

    } catch (e) {
      _errorMessage = 'Error al cargar las portadas de recursos educativos';
      return [];

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Método para obtener el contenido de un recurso educativo
  Future<RecursoEducativoContenido?> presentarContenidoRecEducativo(int idRecEducativo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final receduContenido = await _recursoEducativoService.presentarContenidoRecEducativo(idRecEducativo);
      //_receduContenido = receduContenido;
      _errorMessage = null;
      return receduContenido;

    } catch (e) {
      _errorMessage = 'Error al cargar el contenido del recurso educativo $idRecEducativo';
      return null;

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Método para cargar el cuestionario de un recurso educativo
  Future<List<RecursoEducativoCuestionario>> cargarCuestionarioRecEducativo(int idRecEducativo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cuestionarioContenido = await _recursoEducativoService.cargarCuestionarioRecEducativo(idRecEducativo);
      //_receduCuestionario = cuestionarioContenido;
      _errorMessage = null;
      return cuestionarioContenido;

    } catch (e) {
      _errorMessage = 'Error al cargar el cuestionario del recurso educativo $idRecEducativo';
      return [];
      
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Método para cargar el cuestionario de un recurso educativo
  Future<List<RecursoEducativoRespuesta>> guardarRptsCuestionarioRecEducativo(int idUsuario, int idRecEducativo, Map<int, String> respuestas) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cuestionarioContenido = await _recursoEducativoService.guardarRptsCuestionarioRecEducativo(idUsuario, idRecEducativo, respuestas);
      //_receduRespuestas = cuestionarioContenido;
      _errorMessage = null;
      return cuestionarioContenido;

    } catch (e) {
      _errorMessage = 'Error al cargar el cuestionario del recurso educativo $idRecEducativo';
      return [];
      
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}