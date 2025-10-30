import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:recla/models/producto.dart';
import 'package:recla/utils/servicios_externos.dart';

//REGISTRO PRODUCTO
class ProductoService {
  final String baseUrl = "$servidorCompraventa/producto_routes";

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
    developer.log('Request JSON: ${request.toJson()}');
    final response = await http.post(
      Uri.parse('$baseUrl/filtrar_productos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final List<dynamic> data = jsonResp['data'];
      developer.log('Response Data: $data');
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
      Uri.parse('$baseUrl/producto_detalle'),
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


  Future<List<ProductoConsultaCompleta>> obtenerProductosVendedor(int idVendedor) async {
    //print('🌐 Servicio: POST a $baseUrl/listar_productos_vendedor');
    //print('📤 Servicio: Body enviado: {id_vendedor: $idVendedor}');

    final response = await http.post(
      Uri.parse('$baseUrl/listar_productos_vendedor'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_vendedor': idVendedor}),
    );

    //print('📊 Servicio: Status code: ${response.statusCode}');
    //print('📋 Servicio: Response body completo: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);
      final dynamic data = jsonResp['data'];

      //print('🔍 Servicio: Campo "data" extraído: $data');
      //print('📈 Servicio: Tipo de "data": ${data.runtimeType}');

      if (data == null) {
        throw Exception('Respuesta inválida del servidor: falta campo "data"');
      }

      if (data is! List) {
        //print('⚠️ Servicio: "data" NO es una lista, es: ${data.runtimeType}');
        throw Exception('El campo "data" no es una lista');
      }

      //return data.map((json) => ProductoConsultaCompleta.fromJson(json)).toList();
      //print('✅ Servicio: Parseando ${data.length} productos');
      final result = data.map((json) => ProductoConsultaCompleta.fromJson(json)).toList();
      //print('✅ Servicio: Resultado final: ${result.length} productos');
      
      return result;

    } else {
      String message;
      try {
        final Map<String, dynamic> err = jsonDecode(response.body);
        message = err['message'] ?? response.body;
      } catch (_) {
        message = response.body;
      }
      throw Exception(
        'Error al obtener productos del vendedor: ${response.statusCode} - $message',
      );
    }
  }





}
