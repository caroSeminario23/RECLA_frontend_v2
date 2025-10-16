import 'package:flutter/material.dart';
import 'package:recla/models/sticker.dart';
import 'package:recla/services/stickers.dart';

class StickerProvider extends ChangeNotifier {

  // Servicio de stickers
  final StickerService _stickerService = StickerService();

  List<StickersConEstado> _stickerEmociones = [];
  List<StickersConEstado> _stickerReacciones = [];
  List<StickersConEstado> _stickerActividades = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<StickersConEstado> get stickerEmociones => _stickerEmociones;
  List<StickersConEstado> get stickerReacciones => _stickerReacciones;
  List<StickersConEstado> get stickerActividades => _stickerActividades;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para obtener los stickers
  Future<bool> obtenerStickers(int idUsuario, int categoria) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final stickersConEstado = await _stickerService.mostrarStickers(idUsuario, categoria);

      // Guardar los stickers según su tipo
      switch(categoria) {
        case 1:
          _stickerEmociones = stickersConEstado;
          break;
        case 2:
          _stickerReacciones = stickersConEstado;
          break;
        case 3:
          _stickerActividades = stickersConEstado;
          break;
      }

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al cargar stickers con estado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}