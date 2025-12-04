import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class PrintService {
  // Generate PDF from document
  Future<File> generatePDF(Document document) async {
    final pdf = pw.Document();

    // Add page with document information
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  border: pw.Border.all(color: PdfColors.blue),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Land Archive Document',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Document ID: ${document.id}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 30),

              // Document Title
              pw.Text(
                document.title,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              
              pw.SizedBox(height: 20),

              // Document Information
              _buildInfoRow('Type:', document.type),
              _buildInfoRow('Status:', document.status),
              _buildInfoRow('Created:', document.createdAt.toString().split('.')[0]),
              if (document.updatedAt != null)
                _buildInfoRow('Updated:', document.updatedAt.toString().split('.')[0]),
              
              pw.SizedBox(height: 20),

              // Owner and Location Information
              pw.Container(
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Property Details',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    if (document.ownerName != null)
                      _buildInfoRow('Owner:', document.ownerName!),
                    if (document.location != null)
                      _buildInfoRow('Location:', document.location!),
                    if (document.area != null)
                      _buildInfoRow('Area:', '${document.area} sq meters'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Description
              pw.Text(
                'Description',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                document.description,
                style: const pw.TextStyle(fontSize: 12),
              ),

              pw.SizedBox(height: 20),

              // Tags
              if (document.tags.isNotEmpty) ...[
                pw.Text(
                  'Tags',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: document.tags.map((tag) {
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue100,
                        borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(15),
                        ),
                      ),
                      child: pw.Text(
                        tag,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    );
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
              ],

              // AI Analysis
              if (document.aiAnalysis != null) ...[
                pw.Text(
                  'AI Analysis',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                    border: pw.Border.all(color: PdfColors.green),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(5),
                    ),
                  ),
                  child: pw.Text(
                    document.aiAnalysis!,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              ],

              // Footer
              pw.Spacer(),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated by Land Archive App on ${DateTime.now().toString().split('.')[0]}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to file
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/document_${document.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }

  // Helper method to build info rows
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Print document directly
  Future<void> printDocument(Document document) async {
    final pdf = pw.Document();

    // Generate the same PDF content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Document: ${document.title}'),
          );
        },
      ),
    );

    // Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Share PDF
  Future<void> sharePDF(Document document) async {
    final pdfFile = await generatePDF(document);
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: 'document_${document.id}.pdf',
    );
  }

  // Generate multiple documents report
  Future<File> generateReport(List<Document> documents) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Land Archive Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Paragraph(
              text: 'Total Documents: ${documents.length}',
            ),
            pw.Paragraph(
              text: 'Generated: ${DateTime.now().toString().split('.')[0]}',
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Title', 'Type', 'Status', 'Created'],
                ...documents.map((doc) => [
                  doc.title,
                  doc.type,
                  doc.status,
                  doc.createdAt.toString().split(' ')[0],
                ]),
              ],
            ),
          ];
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }
}
