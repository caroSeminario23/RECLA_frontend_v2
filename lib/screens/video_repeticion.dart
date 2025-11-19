import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'package:recla/screens/perfil_eco.dart';


class VideoYoutubeRepeticion extends StatefulWidget {
  final String videoId;
  
  const VideoYoutubeRepeticion({
    super.key,
    required this.videoId,
  });

  @override
  State<VideoYoutubeRepeticion> createState() => _VideoYoutubeRepeticionState();
}

class _VideoYoutubeRepeticionState extends State<VideoYoutubeRepeticion> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Solo inicializa el controlador si NO es web
    if (!kIsWeb) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          forceHD: true,
          enableCaption: false
        ),
      );
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onVideoFinished() {
    // Restaurar orientación a vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PerfilEcoPagina()),
    );
  }

  Future<void> _openYoutubeWeb() async {
    final url = 'https://www.youtube.com/watch?v=${widget.videoId}';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Después de 5 segundos, redirige a PerfilEcoPagina
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          _onVideoFinished();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Para WEB: Abre YouTube en navegador externo
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openYoutubeWeb();
      });
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenido a RECLA'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Abriendo video de bienvenida...'),
            ],
          ),
        ),
      );
    }

    // Para MÓVIL: Usa el reproductor integrado
    return Scaffold(
      appBar: null,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              //isFullScreen: orientation == Orientation.landscape,
              onReady: () {
                debugPrint('Video listo para reproducir');
                _controller.toggleFullScreenMode(); // Pantalla completa
              },
              onEnded: (metaData) {
                debugPrint('Video finalizado - Redirigiendo a Login');
                _onVideoFinished();
              },
            ),
          );
        },
      ),
    );
  }
}