import 'package:flutter/material.dart';
import 'package:teamstream/widgets/menu_drawer.dart';
import 'package:teamstream/services/pocketbase/document_service.dart';
import 'package:teamstream/pages/document_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  DocumentsPageState createState() => DocumentsPageState();
}

class DocumentsPageState extends State<DocumentsPage> {
  List<Map<String, dynamic>> documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  /// 🔹 Fetch documents from PocketBase
  void loadDocuments() async {
    List<Map<String, dynamic>> fetchedDocuments =
        await DocumentService.fetchDocuments();
    setState(() {
      documents = fetchedDocuments;
      isLoading = false;
    });
  }

  /// 🔹 Open document in Google Docs Viewer
  void viewDocument(String documentId, String fileName) {
    String fileUrl = DocumentService.getDocumentUrl(documentId, fileName);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerPage(fileUrl: fileUrl),
      ),
    );
  }

  /// 🔹 Direct Download
  void downloadDocument(String documentId, String fileName) async {
    String fileUrl = DocumentService.getDocumentUrl(documentId, fileName);
    Uri uri = Uri.parse(fileUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Could not download document: $fileName")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Company Documents")),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Company Policies & Documents",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : documents.isEmpty
                      ? const Center(child: Text("No documents available."))
                      : ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final document = documents[index];
                            return _buildDocumentCard(
                              context,
                              document['title'],
                              document['description'] ?? "No description",
                              Icons.article,
                              document['id'],
                              document['file'],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String documentId,
    String fileName,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.green),
              tooltip: "View Document",
              onPressed: () => viewDocument(documentId, fileName),
            ),
            IconButton(
              icon: const Icon(Icons.download, color: Colors.blue),
              tooltip: "Download Document",
              onPressed: () => downloadDocument(documentId, fileName),
            ),
          ],
        ),
      ),
    );
  }
}
