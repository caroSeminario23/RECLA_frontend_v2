
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/widgets/boton_precio.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class RegistroProducto extends StatefulWidget {
  const RegistroProducto({super.key});

  @override
  State<RegistroProducto> createState() => _RegistroProductoState();
}

class _RegistroProductoState extends State<RegistroProducto> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();

  // Estados para botones y carga
  int? _tipoSeleccionado;
  List<String> _materialesSeleccionados = [];
  bool _isLoading = false;

  // Manejo de imágenes (web y móvil)
  File? _imagenMovil;
  Uint8List? _imagenWeb;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  // -------------------------------
  // FUNCIONES DE SELECCIÓN
  // -------------------------------

  void _onTipoSelected(int tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
    });
  }

  void _onMaterialSelected(String materialId) {
    setState(() {
      if (_materialesSeleccionados.contains(materialId)) {
        _materialesSeleccionados.remove(materialId);
      } else {
        _materialesSeleccionados.add(materialId);
      }
    });
  }

  // -------------------------------
  // MANEJO DE IMAGEN
  // -------------------------------

  void _mostrarDialogoSeleccionImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Seleccionar imagen',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _seleccionarImagen(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.photo_library, size: 28),
                        label: const Text('Galería'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _seleccionarImagen(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.photo_camera, size: 28),
                        label: const Text('Cámara'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _imagenWeb = bytes;
          });
        } else {
          setState(() {
            _imagenMovil = File(image.path);
          });
        }
      }
    } catch (e) {
      _mostrarSnackBar('Error al seleccionar imagen: $e', Colors.red);
    }
  }

  // -------------------------------
  // REGISTRO DEL PRODUCTO
  // -------------------------------

  Future<void> _registrarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    // Validar imagen
    if (!kIsWeb && _imagenMovil == null || (kIsWeb && _imagenWeb == null)) {
      _mostrarSnackBar('Agrega una imagen del producto', Colors.orange);
      return;
    }

    if (_tipoSeleccionado == null) {
      _mostrarSnackBar('Selecciona el tipo de producto', Colors.orange);
      return;
    }

    if (_materialesSeleccionados.isEmpty) {
      _mostrarSnackBar('Selecciona al menos un material', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final productoProvider = Provider.of<ProductoProvider>(context, listen: false);
      final precio = double.tryParse(_precioController.text) ?? 0.0;
      final cantidad = int.tryParse(_cantidadController.text) ?? 0;

      final rutaImagen = kIsWeb
          ? 'imagen_web' // en el futuro aquí podrías subir la imagen a Firebase o servidor
          : _imagenMovil?.path ?? '';

      final resultado = await productoProvider.registroPro(
        1, // idVendedor (debería venir del usuario logueado)
        rutaImagen,
        precio,
        cantidad,
        _descripcionController.text,
        false,
        _tipoSeleccionado!,
        _materialesSeleccionados.join(','),
        _nombreController.text,
      );

      if (resultado) {
        _mostrarSnackBar('¡Producto registrado exitosamente!', Colors.green);
        _limpiarCampos();
        Navigator.of(context).pop();
      } else {
        _mostrarSnackBar('Error al registrar el producto', Colors.red);
      }
    } catch (e) {
      _mostrarSnackBar('Error: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // -------------------------------
  // UTILIDADES
  // -------------------------------

  void _mostrarSnackBar(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
      ),
    );
  }

  void _limpiarCampos() {
    _formKey.currentState!.reset();
    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();
    _cantidadController.clear();
    _imagenMovil = null;
    _imagenWeb = null;
    _tipoSeleccionado = null;
    _materialesSeleccionados.clear();
  }

  String get _precioFormateado {
    final precio = double.tryParse(_precioController.text);
    if (precio == null) return '\$0';
    return '\$${precio.toStringAsFixed(2)}';
  }

  // -------------------------------
  // UI PRINCIPAL
  // -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('VENTA DE PRODUCTOS',
            style: Theme.of(context).textTheme.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(thickness: 1),
              Center(
                child: Text('SOBRE EL PRODUCTO',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 10),

              // Imagen del producto
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imagenWeb != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(_imagenWeb!, fit: BoxFit.cover))
                    : _imagenMovil != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_imagenMovil!, fit: BoxFit.cover),
                          )
                        : Center(
                            child: ElevatedButton.icon(
                              onPressed: _mostrarDialogoSeleccionImagen,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Cargar imagen'),
                            ),
                          ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (value.length < 3) return 'Debe tener al menos 3 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (value.length < 10) {
                    return 'Debe tener al menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Divider(thickness: 1),
              Center(
                child: Text('ESPECIFICACIONES',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 8),

              BotonesTipo(material: 1, producto: 1, onSelect: _onTipoSelected),
              const SizedBox(height: 8),
              BotonesTipoMaterial(
                plastico: 1,
                carton: 1,
                metal: 1,
                vidrio: 1,
                onSelect: _onMaterialSelected,
              ),
              const SizedBox(height: 16),

              Divider(thickness: 1),
              Center(
                child: Text('PRECIO DE VENTA',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final precio = double.tryParse(value ?? '');
                        if (precio == null || precio <= 0) {
                          return 'Precio inválido';
                        }
                        if (precio > 999.99) return 'Máximo permitido: 999.99';
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  BotonPrecio(precio: _precioFormateado),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final cantidad = int.tryParse(value ?? '');
                  if (cantidad == null || cantidad <= 0) {
                    return 'Cantidad inválida';
                  }
                  if (cantidad > 9999) return 'Máximo permitido: 9999';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _registrarProducto,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload),
                  label: Text(_isLoading ? 'Publicando...' : 'Publicar producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/widgets/boton_precio.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//para web
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class RegistroProducto extends StatefulWidget {
  const RegistroProducto({super.key});

  @override
  State<RegistroProducto> createState() => _RegistroProductoState();
}

class _RegistroProductoState extends State<RegistroProducto> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _urlFotoController = TextEditingController();

  // Estados para los botones
  int? _tipoSeleccionado;
  List<String> _materialesSeleccionados = [];
  bool _isLoading = false;
  File? _imagenSeleccionada;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _urlFotoController.dispose();
    super.dispose();
  }

  void _onTipoSelected(int tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
    });
  }

  void _onMaterialSelected(String materialId) {
    setState(() {
      if (_materialesSeleccionados.contains(materialId)) {
        _materialesSeleccionados.remove(materialId);
      } else {
        _materialesSeleccionados.add(materialId);
      }
    });
  }

  String get _precioFormateado {
    if (_precioController.text.isEmpty) return '\$0';
    try {
      final precio = double.parse(_precioController.text);
      return '\$${precio.toInt()}';
    } catch (e) {
      return '\$0';
    }
  }

  void _mostrarDialogoSeleccionImagen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Seleccionar imagen',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Opción Galería
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _seleccionarImagen(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.photo_library, size: 30),
                        label: const Text('Galería'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Opción Cámara
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _seleccionarImagen(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.photo_camera, size: 30),
                        label: const Text('Cámara'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024, // Limitar tamaño para mejor rendimiento
        maxHeight: 1024,
        imageQuality: 85, // Comprimir imagen
      );

      if (image != null) {
        setState(() {
          _imagenSeleccionada = File(image.path);
          //_urlFotoController.text = image.path; // Guardar ruta local (solo moviles)
          //Para que soporte web y moviles
          _urlFotoController.text = kIsWeb
            ? image.path // En web, esto es solo un identificador temporal
            : image.path; // En móviles, esto es la ruta local
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _registrarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    // Validar imagen
    if (_imagenSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega una imagen del producto')),
      );
      return;
    }

    if (_tipoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el tipo de producto')),
      );
      return;
    }

    if (_materialesSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un material')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final productoProvider = Provider.of<ProductoProvider>(context, listen: false);
      
      // Usar la ruta local de la imagen
      final rutaImagen = _imagenSeleccionada?.path ?? '';
      
      final resultado = await productoProvider.registroPro(
        1, // idVendedor - obtener del usuario logueado
        rutaImagen, // Usar ruta local de la imagen
        double.parse(_precioController.text),
        int.parse(_cantidadController.text),
        _descripcionController.text,
        false, // comprado
        _tipoSeleccionado!,
        _materialesSeleccionados.join(','),
        _nombreController.text,
      );

      if (resultado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Producto registrado exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar el producto'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'VENTA DE PRODUCTOS',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título: SOBRE EL PRODUCTO
              Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'SOBRE EL PRODUCTO',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
              ),
              const SizedBox(height: 8),

              // Área de imagen
              // Reemplazar todo el Container de imagen:
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: _imagenSeleccionada != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: kIsWeb
                            ? FutureBuilder<Uint8List>(
                                future: _imagenSeleccionada!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.error, size: 50, color: Colors.red),
                                            Text('Error al cargar imagen'),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                            : Image.file(
                                _imagenSeleccionada!,
                                fit: BoxFit.cover,
                              ),
                      )
                    : Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _mostrarDialogoSeleccionImagen();
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Cargar imagen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
              ),
              /*Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: _imagenSeleccionada != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imagenSeleccionada!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _mostrarDialogoSeleccionImagen(); // ← Cambio aquí
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Cargar imagen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
              ),*/
              const SizedBox(height: 16),

              // Campo: Nombre del producto
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  hintText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  if (value.length > 100) {
                    return 'El nombre no puede tener más de 100 caracteres';
                  }
                  if (value.trim().isEmpty) {
                    return 'El nombre no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Descripción del producto
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción del producto',
                  hintText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (value.length < 10) {
                    return 'La descripción debe tener al menos 10 caracteres';
                  }
                  if (value.length > 500) {
                    return 'La descripción no puede tener más de 500 caracteres';
                  }
                  if (value.trim().isEmpty) {
                    return 'La descripción no puede estar vacía';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
                thickness: 1,
              ),

              // Título: ESPECIFICACIONES
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'ESPECIFICACIONES',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
              ),

              // Botones de tipo - CON SELECCIÓN ÚNICA
              BotonesTipo(
                material: 1,
                producto: 1,
                onSelect: _onTipoSelected,
              ),
              const SizedBox(height: 8),

              // Botones de material
              BotonesTipoMaterial(
                plastico: 1,
                carton: 1,
                metal: 1,
                vidrio: 1,
                onSelect: _onMaterialSelected,
              ),
              const SizedBox(height: 16),

              Divider(
                color: Theme.of(context).colorScheme.outlineVariant,
                thickness: 1,
              ),

              // Título: PRECIO DE VENTA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'PRECIO DE VENTA',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
              ),
              const SizedBox(height: 8),

              // Campo: Precio + BotonPrecio
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Precio del producto',
                        hintText: 'En monedas canjeables (máx. 999.99)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El precio es obligatorio';
                        }
                        final precio = double.tryParse(value);
                        if (precio == null) {
                          return 'Ingresa un precio válido';
                        }
                        if (precio > 999.99) {
                          return 'El precio no puede ser mayor a 999.99';
                        }
                        if (precio <= 0) {
                          return 'El precio debe ser mayor a 0';
                        }
                        if (value.contains('.') && value.split('.')[1].length > 2) {
                          return 'El precio solo puede tener 2 decimales';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {}); // Para actualizar el BotonPrecio
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  BotonPrecio(precio: _precioFormateado),
                ],
              ),
              const SizedBox(height: 16),

              // Campo: Cantidad
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ej: 5 (máx. 9999)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La cantidad es obligatoria';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null) {
                    return 'Ingresa una cantidad válida';
                  }
                  if (cantidad <= 0) {
                    return 'La cantidad debe ser mayor a 0';
                  }
                  if (cantidad > 9999) {
                    return 'La cantidad no puede ser mayor a 9999';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón de registro
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _registrarProducto,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload),
                  label: Text(_isLoading ? 'Publicando...' : 'Publicar producto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/