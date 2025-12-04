import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class PdfService {
  // Singleton pattern
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  // Generate PDF for document
  Future<String> generatePdf(Document document) async {
    final pdf = pw.Document();
    
    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    // Add document info page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'أرشيف الوثائق',
                      style: pw.TextStyle(
                        font: arabicFontBold,
                        fontSize: 24,
                        color: PdfColors.white,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      document.title,
                      style: pw.TextStyle(
                        font: arabicFontBold,
                        fontSize: 20,
                        color: PdfColors.white,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              
              // Document details
              _buildInfoRow('نوع الوثيقة:', document.typeDisplayName, arabicFont, arabicFontBold),
              _buildInfoRow('الحالة:', document.statusDisplayName, arabicFont, arabicFontBold),
              _buildInfoRow('تاريخ الإنشاء:', _formatDate(document.createdAt), arabicFont, arabicFontBold),
              
              if (document.ownerName != null)
                _buildInfoRow('اسم المالك:', document.ownerName!, arabicFont, arabicFontBold),
              
              if (document.location != null)
                _buildInfoRow('الموقع:', document.location!, arabicFont, arabicFontBold),
              
              if (document.area != null)
                _buildInfoRow('المساحة:', '${document.area} متر مربع', arabicFont, arabicFontBold),
              
              pw.SizedBox(height: 20),
              
              // Description
              if (document.description.isNotEmpty) ...[
                pw.Text(
                  'الوصف:',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Text(
                    document.description,
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 14,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
              
              // Tags
              if (document.tags.isNotEmpty) ...[
                pw.Text(
                  'الوسوم:',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 16,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.SizedBox(height: 10),
                pw.Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: document.tags.map((tag) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.teal100,
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
                      ),
                      child: pw.Text(
                        tag,
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          );
        },
      ),
    );

    // Add images pages
    for (int i = 0; i < document.imagePaths.length; i++) {
      try {
        final imageFile = File(document.imagePaths[i]);
        if (await imageFile.exists()) {
          final imageBytes = await imageFile.readAsBytes();
          final image = pw.MemoryImage(imageBytes);

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Column(
                  children: [
                    pw.Text(
                      'صورة ${i + 1} من ${document.imagePaths.length}',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 14,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Expanded(
                      child: pw.Image(image, fit: pw.BoxFit.contain),
                    ),
                  ],
                );
              },
            ),
          );
        }
      } catch (e) {
        print('خطأ في إضافة الصورة $i: $e');
      }
    }

    // Save PDF
    final appDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${appDir.path}/pdfs');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    final fileName = '${document.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${pdfDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  // Helper method to build info row
  pw.Widget _buildInfoRow(String label, String value, pw.Font font, pw.Font fontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: font, fontSize: 14),
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Text(
            label,
            style: pw.TextStyle(font: fontBold, fontSize: 14),
            textDirection: pw.TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  // Format date
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  // Print PDF
  Future<void> printPdf(Document document) async {
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    // Add similar content as generatePdf
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              document.title,
              style: pw.TextStyle(font: arabicFontBold, fontSize: 24),
              textDirection: pw.TextDirection.rtl,
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Share PDF
  Future<void> sharePdf(String pdfPath) async {
    await Printing.sharePdf(
      bytes: await File(pdfPath).readAsBytes(),
      filename: 'document.pdf',
    );
  }
}
