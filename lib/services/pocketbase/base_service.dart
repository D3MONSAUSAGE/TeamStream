import 'package:pocketbase/pocketbase.dart';

class BaseService {
  static final PocketBase pb = PocketBase('http://127.0.0.1:8090'); // ✅ Update URL if needed

  /// 🔹 Fetch All Records from a Collection
  static Future<List<Map<String, dynamic>>> fetchAll(String collectionName) async {
    try {
      final records = await pb.collection(collectionName).getFullList();
      return records.map((record) => record.toJson()).toList();
    } catch (e) {
      print("❌ Error fetching $collectionName: $e");
      return [];
    }
  }

  /// 🔹 Fetch a Single Record by ID
  static Future<Map<String, dynamic>?> fetchById(String collectionName, String id) async {
    try {
      final record = await pb.collection(collectionName).getOne(id);
      return record.toJson();
    } catch (e) {
      print("❌ Error fetching $collectionName record $id: $e");
      return null;
    }
  }

  /// 🔹 Create a New Record
  static Future<void> create(String collectionName, Map<String, dynamic> data, {required List<dynamic> files}) async {
    try {
      await pb.collection(collectionName).create(body: data);
      print("✅ Successfully added to $collectionName!");
    } catch (e) {
      print("❌ Error creating record in $collectionName: $e");
    }
  }

  /// 🔹 Update an Existing Record
  static Future<void> update(String collectionName, String id, Map<String, dynamic> data) async {
    try {
      await pb.collection(collectionName).update(id, body: data);
      print("✅ Successfully updated $collectionName record!");
    } catch (e) {
      print("❌ Error updating $collectionName record: $e");
    }
  }

  /// 🔹 Delete a Record
  static Future<void> delete(String collectionName, String id) async {
    try {
      await pb.collection(collectionName).delete(id);
      print("✅ Successfully deleted from $collectionName!");
    } catch (e) {
      print("❌ Error deleting from $collectionName: $e");
    }
  }
}
