import 'dart:io';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class DocumentService {
  static final PocketBase pb = PocketBase("http://127.0.0.1:8090"); // Update if needed

  /// 🔹 Fetch All Documents from PocketBase
  static Future<List<Map<String, dynamic>>> fetchDocuments() async {
    try {
      final records = await pb.collection('documents').getFullList();
      return records.map((record) => record.toJson()).toList();
    } catch (e) {
      print("❌ Error fetching documents: $e");
      return [];
    }
  }

  /// 🔹 Upload Document to PocketBase (Using Dio)
  static Future<bool> uploadDocument(String title, String description, File file) async {
    try {
      await pb.collection('documents').create(body: {
        "title": title,
        "description": description,
      }, files: [
        await http.MultipartFile.fromPath('file', file.path, filename: file.path.split('/').last),
      ]);

      print("✅ Document uploaded successfully!");
      return true;
    } catch (e) {
      print("❌ Document upload failed: $e");
      return false;
    }
  }

  /// 🔹 Get Document URL for Online Viewing
  static String getDocumentUrl(String documentId, String fileName) {
    const String baseUrl = "http://127.0.0.1:8090"; // Update if needed
    return "$baseUrl/api/files/documents/$documentId/$fileName";
  }
}
