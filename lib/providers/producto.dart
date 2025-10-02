import 'package:flutter/material.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/services/producto.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _productoService = ProductoService();
  bool _isLoading = false;
  String? _errorMessage;
  bool? _isRegistered = false;
  List<ProductoFiltradoResponse> _productosFiltrados = [];
  
  bool? get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get isRegistered => _isRegistered;
  List<ProductoFiltradoResponse> get productosFiltrados => _productosFiltrados;

  //REGISTRO PRODUCTO
  Future<bool> registroPro(
    int idProducto, int idVendedor,String urlFoto, double precio, int cantidad, String descripcion, bool comprado, int tipo, String material,String nombre) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = ProductoRegistroRequest(
      idProducto: idProducto,
      idVendedor: idVendedor,
      urlFoto: urlFoto,
      precio: precio,
      cantidad: cantidad,
      descripcion: descripcion,
      comprado: comprado,
      tipo: tipo,
      material: material,
      nombre: nombre,
    );

    try {
      final response = await _productoService.registroProducto(request);
      _isRegistered = response;
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Error al registrar producto';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  //FILTRAR PRODUCTOS
  Future<List<ProductoFiltradoResponse>> filtrarP(List<int> tipo, String material) async {
    print('{tipo: $tipo, material: "$material"}');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = ProductoFiltradoRequest(
      tipo: tipo,
      material: material,
    );

    try {
      final response = await _productoService.filtrarProductos(request);
      print('Productos filtrados recibidos: $response');
      _productosFiltrados = response;
      print('Productos filtrados en provider: $_productosFiltrados');
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Error al filtrar productos';
      print('Error al filtrar productos: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  // DETALLE PRODUCTO
  Future<ProductoDetalleResponse?> detalleP(int idProducto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print('Buscando detalle para producto ID: $idProducto');
    final request = ProductoDetalleRequest(idProducto: idProducto);

    try {
      final response = await _productoService.detalleProducto(request);
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Error al obtener detalle del producto';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}