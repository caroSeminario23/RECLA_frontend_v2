import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recla/models/producto.dart';

//REGISTRO PRODUCTO
class ProductoService {
  final String baseUrl = "http://127.0.0.1:5000/producto_routes";

  Future<bool> registroProducto(ProductoRegistroRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro_producto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception(
        'Error al registrar producto: ${response.statusCode} - $message',
      );
    }
  }



  //FILTRAR PRODUCTOS
  Future<List<ProductoFiltradoResponse>> filtrarProductos(ProductoFiltradoRequest request) async {
    print('Request JSON: ${request.toJson()}');
    final response = await http.post(
      Uri.parse('$baseUrl/filtrar_productos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];
      print('Response Data: $data');
      return data
          .map((item) => ProductoFiltradoResponse.fromJson(item))
          .toList();
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception(
        'Error al filtrar productos: ${response.statusCode} - $message',
      );
    }
  }


  // DETALLE PRODUCTO
  Future<ProductoDetalleResponse> detalleProducto(ProductoDetalleRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detalle_producto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson())
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final dynamic data = jsonResp['data'];

      if (data == null) {
        throw Exception('Respuesta inválida del servidor: falta campo "data"');
      }
      return ProductoDetalleResponse.fromJson(data);
    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception(
        'Error al obtener detalle del producto: ${response.statusCode} - $message',
      );
    }
  }





}
