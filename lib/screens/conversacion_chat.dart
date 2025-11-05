
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/conversaciones.dart';
import 'package:recla/widgets/conversacion.dart';

// IMPORTA TU PANTALLA DE CHAT EXISTENTE
import 'package:recla/screens/chat.dart'; // Ajusta esta ruta si es necesario

class ConversacionesScreen extends StatefulWidget {
  final int idUsuarioActual; // El ID del usuario que ha iniciado sesión

  const ConversacionesScreen({super.key, required this.idUsuarioActual});

  @override
  State<ConversacionesScreen> createState() => _ConversacionesScreenState();
}

class _ConversacionesScreenState extends State<ConversacionesScreen> {
  
  @override
  void initState() {
    super.initState();
    // Carga las conversaciones cuando la pantalla se inicia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarConversaciones();
    });
  }

  Future<void> _cargarConversaciones() async {
    // Usamos listen:false dentro de initState
    Provider.of<ConversacionesProvider>(context, listen: false)
          .cargarConversaciones(widget.idUsuarioActual);
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final localDt = dt.toLocal(); // Asegurarse de que esté en hora local
    final date = DateTime(localDt.year, localDt.month, localDt.day);

    if (date == today) {
      return DateFormat.Hm().format(localDt); // 'HH:mm'
    } else {
      return DateFormat.Md('es').format(localDt); // 'd/M' (ej. 4/11)
    }
  }

  void _irAlChat(int idReceptor, String nombreReceptor, String? avatarUrl) {
    // Navega a tu pantalla de Chat existente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          idUsuarioActual: widget.idUsuarioActual,
          idUsuarioReceptor: idReceptor,
          nombreUsuario: nombreReceptor,
        ),
      ),
    ).then((_) {
      // Cuando volvemos de un chat, refrescamos la lista
      print("Regresando del chat, refrescando conversaciones...");
      _cargarConversaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Chats'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
      ),
      body: Consumer<ConversacionesProvider>(
        builder: (context, provider, child) {
          
          if (provider.isLoading && provider.conversaciones.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.conversaciones.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Error: ${provider.errorMessage}"),
              ),
            );
          }

          if (provider.conversaciones.isEmpty) {
            return const Center(
              child: Text(
                'Aún no tienes conversaciones.\nInicia un chat desde un producto.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Usamos RefreshIndicator para "deslizar para actualizar"
          return RefreshIndicator(
            onRefresh: _cargarConversaciones,
            child: ListView.builder(
              itemCount: provider.conversaciones.length,
              itemBuilder: (context, index) {
                final convo = provider.conversaciones[index];
                
                // Genera un avatar de reserva si no hay URL
                final avatarDeReserva = 'https://ui-avatars.com/api/?name=${convo.nombreReceptor.split(' ').first}&background=C8E6C9&color=2E7D32';

                return ConversacionTile(
                  nombre: convo.nombreReceptor,
                  ultimoMensaje: convo.ultimoMensaje,
                  hora: _formatTime(convo.fechaUltimoMensaje),
                  avatarUrl: (convo.avatarUrl != null && convo.avatarUrl!.isNotEmpty) 
                             ? convo.avatarUrl 
                             : avatarDeReserva,
                  onTap: () {
                    _irAlChat(
                      convo.idUsuarioReceptor,
                      convo.nombreReceptor,
                      convo.avatarUrl,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}