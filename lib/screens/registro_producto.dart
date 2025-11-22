import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/providers/usuario.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:recla/widgets/navbar.dart';

class RegistroProducto extends StatefulWidget {
  const RegistroProducto({super.key});

  @override
  State<RegistroProducto> createState() => _RegistroProductoState();
}

class _RegistroProductoState extends State<RegistroProducto> {
  int opcionSeleccionada = 0;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();

  // Estados para botones y carga
  int? _tipoSeleccionado;
  final List<String> _materialesSeleccionados = [];
  bool _isLoading = false;

  // Manejo de imágenes (web y móvil)
  File? _imagenMovil;
  Uint8List? _imagenWeb;

  void _onItemTapped(int index) {
    setState(() {
      opcionSeleccionada = index;
    });

    // NAVEGACIÓN BASADA EN LA OPCIÓN SELECCIONADA
    if (index == 4) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PerfilEcoPagina()));
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatsPagina()));
    }
  }
  
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
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      final productoProvider = Provider.of<ProductoProvider>(context, listen: false);

      final int idUsuario = usuarioProvider.idUsuario ?? 1;
      final precio = double.tryParse(_precioController.text) ?? 0.0;
      final cantidad = int.tryParse(_cantidadController.text) ?? 0;

      final String urlImagen = await productoProvider.cargarImagen(
        idUsuario, 
        _nombreController.text, 
        kIsWeb ? _imagenWeb : _imagenMovil);

      /*final rutaImagen = kIsWeb
          ? 'imagen_web' // en el futuro aquí podrías subir la imagen a Firebase o servidor
          : _imagenMovil?.path ?? '';
      */

      if (!mounted) return;

      if (urlImagen.isEmpty) {
        _mostrarSnackBar('Error al cargar la imagen', Colors.red);
        setState(() => _isLoading = false);
        return;
      }

      final resultado = await productoProvider.registroPro(
        idUsuario, // idVendedor (debería venir del usuario logueado)
        urlImagen,
        precio,
        cantidad,
        _descripcionController.text,
        false,
        _tipoSeleccionado!,
        _materialesSeleccionados.join(','),
        _nombreController.text,
      );

      // Verificar si el widget aún está montado antes de usar context
      if (!mounted) return;

      if (resultado) {
        _mostrarSnackBar('¡Producto registrado exitosamente!', Colors.green);
        _limpiarCampos();
        Navigator.of(context).pop();
      } else {
        _mostrarSnackBar('Error al registrar el producto', Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar('Error: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
          },
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
              //Precio
              TextFormField(
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
              const SizedBox(height: 16),
              //Cantidad
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

      bottomNavigationBar: SafeArea(
        top: false,
        child: NavBar(
          opcionSeleccionada: opcionSeleccionada,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
