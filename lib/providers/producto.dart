import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:recla/models/producto.dart';
import 'package:recla/services/producto.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoService _productoService = ProductoService();
  bool _isLoading = false;
  String? _errorMessage;
  bool? _isRegistered = false;
  List<ProductoFiltradoResponse> _productosFiltrados = [];
  List<ProductoConsultaCompleta> _productosVendedor = [];
  
  bool? get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool? get isRegistered => _isRegistered;
  List<ProductoFiltradoResponse> get productosFiltrados => _productosFiltrados;
  List<ProductoConsultaCompleta> get productosVendedor => _productosVendedor;


  //REGISTRO PRODUCTO
  Future<bool> registroPro(
    int idVendedor,String urlFoto, double precio, int cantidad, String descripcion, bool comprado, int tipo, String material,String nombre) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = ProductoRegistroRequest(
      //idProducto: idProducto,
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
    developer.log('{Filtrar productos - tipo: $tipo, material: "$material"}');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = ProductoFiltradoRequest(
      tipo: tipo,
      material: material,
    );

    try {
      final response = await _productoService.filtrarProductos(request);
      developer.log('Productos filtrados recibidos: $response');
      developer.log('Productos filtrados recibidos: ${response.length} items');
      _productosFiltrados = response;
      developer.log('Productos filtrados en provider: $_productosFiltrados');
      developer.log('Productos filtrados en provider: ${_productosFiltrados.length} items');
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Error al filtrar productos';
      developer.log('Error al filtrar productos: $e');
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
    developer.log('Buscando detalle para producto ID: $idProducto');
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


  // CONSULTA PRODUCTOS VENDEDOR
  Future<bool> obtenerProductosVendedor(int idVendedor) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      //print('📡 Provider: Llamando al servicio con idVendedor: $idVendedor');
      final response = await _productoService.obtenerProductosVendedor(idVendedor);

      //print('📥 Provider: Respuesta recibida del servicio: $response');
      //print('📊 Provider: Cantidad de productos: ${response.length}');

      _productosVendedor = response;
      //print('✅ Provider: Productos asignados a _productosVendedor: ${_productosVendedor.length}');
      _errorMessage = null;
      return true;
    } catch (e) {
      //print('❌ Provider: Error - $e');
      _errorMessage = 'Error al obtener productos del vendedor';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}