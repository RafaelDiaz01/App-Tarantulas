import 'package:flutter/material.dart';
import 'package:app_tarantulas/models/usuario_model.dart';

class ResultadosScreen extends StatelessWidget {
  final Usuario usuario;

  const ResultadosScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final respuestas = usuario.respuestas ?? {};
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final comentarioFinalEntry = respuestas.entries.firstWhere(
      (e) => e.key.toLowerCase().contains('comentario'),
      orElse: () => const MapEntry('', ''),
    );
    final respuestasSinComentario = Map.of(respuestas)
      ..remove(comentarioFinalEntry.key);

    return Scaffold(
appBar: AppBar(
  title: Text(
    'Resultados',
    style: theme.textTheme.titleMedium,
  ),
  elevation: 4,
  shadowColor: theme.colorScheme.primary.withOpacity(0.5),
  actions: [
    IconButton(
      tooltip: 'Exportar PDF',
      icon: Icon(Icons.picture_as_pdf, color: theme.colorScheme.onPrimary),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exportar PDF... (pendiente)')),
        );
      },
    ),
    IconButton(
      tooltip: 'Regresar al inicio',
      icon: Icon(Icons.home, color: theme.colorScheme.onPrimary),
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
    ),
  ],
),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            _buildUsuarioHeader(theme),
            const SizedBox(height: 24),
            Divider(color: theme.colorScheme.onSurface.withOpacity(0.25), thickness: 1.2),
            const SizedBox(height: 20),
            ..._buildRespuestaCards(respuestasSinComentario, theme, isDark),
            if (comentarioFinalEntry.key.isNotEmpty) ...[
              const SizedBox(height: 30),
              Divider(color: theme.colorScheme.primary.withOpacity(0.3), thickness: 1.5),
              const SizedBox(height: 20),
              _animatedCard(
                respuestasSinComentario.length,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comentario Final',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
                            : theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.15),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        comentarioFinalEntry.value,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUsuarioHeader(ThemeData theme) {
    final colorPrimary = theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: colorPrimary.withOpacity(0.2),
          child: Icon(Icons.person, size: 36, color: colorPrimary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Encuestado',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _infoRow('Nombre', usuario.nombre, theme.textTheme.bodyLarge),
              _infoRow('Edad', usuario.edad.toString(), theme.textTheme.bodyLarge),
              _infoRow('Localidad', usuario.localidad, theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String valor, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: style?.copyWith(fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: valor,
              style: style?.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRespuestaCards(
      Map<String, String> respuestas, ThemeData theme, bool isDark) {
    final colorPrimary = theme.colorScheme.primary;

    return respuestas.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final pregunta = entry.value.key;
      final respuesta = entry.value.value;

      final card = Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surfaceVariant.withOpacity(0.4)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: colorPrimary.withOpacity(0.12),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pregunta,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 22, color: colorPrimary.withOpacity(0.8)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    respuesta,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      return _animatedCard(index, card);
    }).toList();
  }

  Widget _animatedCard(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + index * 100),
      curve: Curves.easeOut,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
    );
  }
}
