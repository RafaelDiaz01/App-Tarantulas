import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<Uint8List> generate({
    required String nombre,
    required String edad,
    required String sexo,
    required String estadoCivil,
    required String localidad,
    required String lugarOrigen,
    required String escolaridad,
    required String fuenteTrabajo,
    required String lenguaMaterna,
    required String grupoEtnico,
    required String tenenciaTierra,
    required String numeroHijos,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Reporte de Usuario', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 16),
            pw.Text('Nombre: $nombre'),
            pw.Text('Edad: $edad'),
            pw.Text('Sexo: $sexo'),
            pw.Text('Estado Civil: $estadoCivil'),
            pw.Text('Localidad: $localidad'),
            pw.Text('Lugar de Origen: $lugarOrigen'),
            pw.Text('Escolaridad: $escolaridad'),
            pw.Text('Fuente de Trabajo: $fuenteTrabajo'),
            pw.Text('Lengua Materna: $lenguaMaterna'),
            pw.Text('Grupo Étnico: $grupoEtnico'),
            pw.Text('Tenencia de Tierra: $tenenciaTierra'),
            pw.Text('Número de Hijos: $numeroHijos'),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}
