import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:recla/providers/chats.dart';
import 'package:recla/providers/venta.dart';
import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chats.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/utils/servicios_externos.dart';
import 'package:recla/widgets/boton_comprado.dart';
import 'package:recla/widgets/burbuja_mensaje.dart';
import 'package:recla/widgets/campo_entrada_mensaje.dart';
import 'package:recla/widgets/encabezado_chat.dart';
import 'package:recla/widgets/navbar.dart'; 

class ChatIndividualPagina extends StatefulWidget {
  final int idUsuarioActual; // ID del usuario actual
  final int idUsuarioReceptor; // ID del contacto
  final String nombreUsuario; // Nombre del contacto
  final int idProducto; // ID del producto relacionado

  const ChatIndividualPagina({
    super.key,
    required this.idUsuarioActual,
    required this.idUsuarioReceptor,
    required this.nombreUsuario,
    required this.idProducto,
  });

  @override
  State<ChatIndividualPagina> createState() => _ChatIndividualPaginaState();
}

class _ChatIndividualPaginaState extends State<ChatIndividualPagina> {
  int opcionSeleccionada = 3;
  final TextEditingController _mensajeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  
  //final List<Map<String, dynamic>> _mensajes = []; // Lista de mensajes
  //bool _isLoading = false;

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
        MaterialPageRoute(builder: (_) => const TablaClasificacionPagina()));
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CompraProductosPagina()));
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const BeneficiosPagina()));
    }
  }

  @override
  void initState() {
    super.initState();
    //print("initState: Cargando chat para ${widget.nombreUsuario} (Actual: ${widget.idUsuarioActual}, Receptor: ${widget.idUsuarioReceptor})");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //print("initState: Widgets listos. Llamando a _cargarMensajes...");
      _cargarMensajes();
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        //print("Timer: Refrescando mensajes...");
        _cargarMensajes();
      });
    });

  }

  @override
  void dispose() {
    _timer?.cancel();
    _mensajeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarMensajes() async {
    //setState(() => _isLoading = true);
    //print("_cargarMensajes: Iniciando.");
    final chatProvider = Provider.of<ChatsProvider>(context, listen: false);
    // Mensajes de ejemplo con valores brutos
    //await Future.delayed(const Duration(milliseconds: 500));
    try {
      await chatProvider.getHistorial(
        widget.idUsuarioActual,
        widget.idUsuarioReceptor,
      );
      //print("_cargarMensajes: Llamada a getHistorial completada.");
    } catch (e) {
      //print("_cargarMensajes: Error atrapado en la PANTALLA: $e");
      // Manejar error si es necesario
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar mensajes: $e')),
        );
      }
    }
    _scrollToBottom();
  }


  Future<void> _enviarMensaje() async { // <-- Convertido a async
    final texto = _mensajeController.text.trim();
    if (texto.isEmpty) {
      //print("_enviarMensaje: Mensaje vacío, no se envía.");
      return;
    }
    //print("_enviarMensaje: Enviando mensaje: $texto");
    final chatProvider = Provider.of<ChatsProvider>(context, listen: false);
    _mensajeController.clear(); // Limpia el texto inmediatamente

    try {
      // Llama al provider para enviar el mensaje
      await chatProvider.enviarMensaje(
        widget.idUsuarioActual,
        widget.idUsuarioReceptor,
        texto,
      );
      //print("_enviarMensaje: Mensaje enviado y historial actualizado.");
      // El provider se encargará de recargar la lista
      await chatProvider.getHistorial(
        widget.idUsuarioActual,
        widget.idUsuarioReceptor,
      );
      _scrollToBottom(); // Haz scroll después de que se envíe
    } catch (e) {
      //print("_enviarMensaje: Error al enviar mensaje: $e");
      // Opcional: Mostrar error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar mensaje: $e')),
        );
      }
      // Opcional: Devolver el texto al campo si falla
      _mensajeController.text = texto;
    }
  }
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),     
          curve: Curves.easeOut,
        );
      }
    });
  }
  String _formatTime(DateTime dt) {
    final localDt = dt.toLocal(); // Convierte a hora local
    return "${localDt.hour}:${localDt.minute.toString().padLeft(2, '0')}";
  }
  //REGISTRAR VENTA
  Future<void> _registrarVenta(BuildContext context) async {
    // Definimos quién es el Comprador y quién es el Vendedor
    // NOTA: Esto asume que el usuario actual (widget.idUsuarioActual) es el Vendedor
    // y el Receptor (widget.idUsuarioReceptor) es el Comprador.
    // Si la lógica de tu aplicación es más compleja, ajústala aquí.
    
    final int idVendedor = widget.idUsuarioActual;
    final int idComprador = widget.idUsuarioReceptor;
    final int idProducto = widget.idProducto;
    
    // Obtenemos el provider de Venta. Usamos `read` para llamar a la función.
    final ventaProvider = context.read<VentaProvider>();

    try {
      // 1. Llama a la función de registro de venta
      final exito = await ventaProvider.registroVent(
        idVendedor,
        idComprador,
        idProducto,
      );

      // 2. Manejo de respuesta
      if (exito == true) {
        // Registro exitoso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ ¡Venta registrada exitosamente!')),
          );
          // Opcional: Navegar fuera del chat o inhabilitar el botón
          Navigator.of(context).pop(); // O pop hasta ChatsPagina
        }
      } else {
        // Fallo en el registro (debería ser manejado por el catch, pero es un buen fallback)
        throw Exception('El registro de venta falló.');
      }
    } catch (e) {
      // Manejo de errores (validación, fallo de conexión, error del servidor)
      if (mounted) {
        // Intentamos obtener el error del Provider, si no, mostramos la excepción.
        final mensajeError = ventaProvider.errorMessage ?? 'Error desconocido al registrar la venta.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $mensajeError')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ventaProvider =context.watch<VentaProvider>();
    final isVentaLoading = ventaProvider.isLoading == true; 
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          //color: Theme.of(context).colorScheme.surface,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: EncabezadoChat(
          nombreUsuario: widget.nombreUsuario,
          tipoUsuario: 'VENDEDOR',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Espaciado
          BotonComprado(
            onPressed: isVentaLoading
                ? null
                : () => _registrarVenta(context),
          ),
          /*
          BotonComprado(
            onPressed: () {
              print('Venta concretada');
            },
          ),*/
          const SizedBox(height: 16), // Espaciado entre el botón y los mensajes

          // Lista de mensajes
          Expanded(
            child: Consumer<ChatsProvider>(
              builder: (context, chatProvider, child) {

                if(chatProvider.isLoading && chatProvider.mensajes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if(chatProvider.errorMessage != null && chatProvider.mensajes.isEmpty) {    
                  return Center(child: Text(chatProvider.errorMessage!));
                } 
                final mensajes = chatProvider.mensajes;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemCount: mensajes.length,
                  itemBuilder: (context, index){
                    final mensaje = mensajes[index];
                    return BurbujaMensaje(
                      mensaje: mensaje.mensaje,
                      hora: _formatTime(mensaje.fechaHora),
                      idUsuario: mensaje.usuarioId,
                      idUsuarioActual: widget.idUsuarioActual,
                      avatarUrl: perfilPredeterminado,
                    );
                  }

                );

              }

            ),    
          ),
          

          // Campo de entrada
          CampoEntradaMensaje(
            controller: _mensajeController,
            onEnviar: _enviarMensaje,
          ),
        ],
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