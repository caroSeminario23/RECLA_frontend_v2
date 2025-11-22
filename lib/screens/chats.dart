import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recla/providers/chats.dart';
import 'package:recla/providers/usuario.dart';

import 'package:recla/screens/beneficios.dart';
import 'package:recla/screens/chat_individual.dart';
import 'package:recla/screens/compra_productos.dart';
import 'package:recla/screens/login.dart';
import 'package:recla/screens/perfil_eco.dart';
import 'package:recla/screens/tabla_clasificacion.dart';
import 'package:recla/utils/servicios_externos.dart';
import 'package:recla/widgets/conversion_titulo.dart';
import 'package:recla/widgets/navbar.dart';


class ChatsPagina extends StatefulWidget {
  //final int idUsuarioActual; // El ID del usuario que ha iniciado sesión

  //const ChatsPagina({super.key, required this.idUsuarioActual});
  const ChatsPagina({super.key});

  @override
  State<ChatsPagina> createState() => _ChatsPaginaState();
}

class _ChatsPaginaState extends State<ChatsPagina> {
  int opcionSeleccionada = 3; // Chats es la opción 3
  late int idUsuarioActual; // Agrega esta variable
  
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
    // Carga las conversaciones cuando la pantalla se inicia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarConversaciones();
    });
  }

  Future<void> _cargarConversaciones() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final chatsProvider = Provider.of<ChatsProvider>(context, listen: false);
    // Usamos listen:false dentro de initState
    //Provider.of<ChatsProvider>(context, listen: false)
    //  .cargarConversaciones(widget.idUsuarioActual);

    idUsuarioActual = usuarioProvider.idUsuario ?? 1;

    await chatsProvider.cargarConversaciones(idUsuarioActual);
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

  void _irAlChat(int idReceptor, String nombreReceptor, String? avatarUrl, int idProducto) {
    // Navega a tu pantalla de Chat existente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Consumer<ChatsProvider>(
          builder: (context, chatsProvider, child) {
            //print("Navegando a ChatIndividualPagina con idUsuarioActual: $idUsuarioActual, idUsuarioReceptor: $idReceptor, idProducto: $idProducto");
            return ChatIndividualPagina(
              idUsuarioActual: idUsuarioActual,
              idUsuarioReceptor: idReceptor,
              nombreUsuario: nombreReceptor,
              idProducto: idProducto,
            );
          },
        ),
      ),
    ).then((_) {
      // Cuando volvemos de un chat, refrescamos la lista
      //print("Regresando del chat, refrescando conversaciones...");
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
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const Login()));
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ChatsProvider>(
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
                final avatarDeReserva = perfilPredeterminado;
                //print("PRODUCTO EN CONVERSACIÓN: ${convo.idProducto}");
                return ConversacionTitulo(
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
                      convo.idProducto ?? 0,
                    );
                  },
                );
              },
            ),
          );
        },
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