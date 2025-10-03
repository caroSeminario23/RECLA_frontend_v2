import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/models/producto.dart';
import 'package:recla/providers/producto.dart';
import 'package:recla/widgets/boton_precio.dart';
import 'package:recla/widgets/botones_tipo.dart';
import 'package:recla/widgets/botones_tipo_material.dart';

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

  Future<void> _registrarProducto() async {
    if (!_formKey.currentState!.validate()) return;

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
      
      final resultado = await productoProvider.registroPro(
        0, // idProducto - se genera automáticamente
        1, // idVendedor - obtener del usuario logueado
        _urlFotoController.text,
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
              // Título: ESPECIFICACIONES
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'SOBRE  EL PRODUCTO',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
              ),
              const SizedBox(height: 8),

              // Área de imagen
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary,
                  width: 3.0),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: _urlFotoController.text.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.network(
                          _urlFotoController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported, size: 50),
                                  Text('Error al cargar imagen'),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Por ahora, mostrar diálogo para URL
                            _mostrarDialogoURL();
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Cargar imagen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(  context).colorScheme.primary,
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
              //const SizedBox(height: 12),

              // Botones de tipo
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
                        hintText: 'En monedas canjeables',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El precio es obligatorio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingresa un precio válido';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {}); // Para actualizar el BotonPrecio
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo: Cantidad
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ej: 5',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La cantidad es obligatoria';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingresa una cantidad válida';
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

  void _mostrarDialogoURL() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('URL de la imagen'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://ejemplo.com/imagen.jpg',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _urlFotoController.text = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}