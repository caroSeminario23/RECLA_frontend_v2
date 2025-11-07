import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/chat.dart';
import 'package:recla/providers/conversaciones.dart';
import 'package:recla/screens/conversacion_chat.dart';
import 'package:recla/widgets/boton_comprado.dart';
import 'package:recla/widgets/burbuja_mensaje.dart';
import 'package:recla/widgets/campo_entrada.dart';
import 'package:recla/widgets/encabezado_chat.dart';
import 'dart:async'; // <-- AÑADIR ESTA LÍNEA

class Chat extends StatefulWidget {
  final int idUsuarioActual; // ID del usuario actual
  final int idUsuarioReceptor; // ID del contacto
  final String nombreUsuario; // Nombre del contacto

  const Chat({
    super.key,
    required this.idUsuarioActual,
    required this.idUsuarioReceptor,
    required this.nombreUsuario,
  });

  @override
  State<Chat> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  final TextEditingController _mensajeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  
  //final List<Map<String, dynamic>> _mensajes = []; // Lista de mensajes
  //bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print("initState: Cargando chat para ${widget.nombreUsuario} (Actual: ${widget.idUsuarioActual}, Receptor: ${widget.idUsuarioReceptor})");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("initState: Widgets listos. Llamando a _cargarMensajes...");
      _cargarMensajes();
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        print("Timer: Refrescando mensajes...");
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
    print("_cargarMensajes: Iniciando.");
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // Mensajes de ejemplo con valores brutos
    //await Future.delayed(const Duration(milliseconds: 500));
    try {
      await chatProvider.getHistorial(
        widget.idUsuarioActual,
        widget.idUsuarioReceptor,
      );
      print("_cargarMensajes: Llamada a getHistorial completada.");
    } catch (e) {
      print("_cargarMensajes: Error atrapado en la PANTALLA: $e");
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
      print("_enviarMensaje: Mensaje vacío, no se envía.");
      return;
    }
    print("_enviarMensaje: Enviando mensaje: $texto");
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _mensajeController.clear(); // Limpia el texto inmediatamente

    try {
      // Llama al provider para enviar el mensaje
      await chatProvider.enviarMensaje(
        widget.idUsuarioActual,
        widget.idUsuarioReceptor,
        texto,
      );
      print("_enviarMensaje: Mensaje enviado y historial actualizado.");
      // El provider se encargará de recargar la lista
      await chatProvider.getHistorial(
        widget.idUsuarioActual,
        widget.idUsuarioReceptor,
      );
      _scrollToBottom(); // Haz scroll después de que se envíe
    } catch (e) {
      print("_enviarMensaje: Error al enviar mensaje: $e");
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

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversacionesScreen(
                    idUsuarioActual: widget.idUsuarioActual, // Pasar el ID del usuario actual
                  ),
                ),
              );
            },
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
            child: Consumer<ChatProvider>(
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
                      avatarUrl: 'https://lyhgavhtpjtnozoabwqk.supabase.co/storage/v1/object/public/recla-images/perfil_aprendices/perfil_predeterminado.webp',
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
    );
  }
}
