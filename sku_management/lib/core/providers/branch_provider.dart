import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BranchProvider extends StateNotifier<void> {
  BranchProvider() : super(null);

  Future<void> addBranch(String name, String location, String number) async {
    final url = 'http://10.0.2.2:8000/add_branch/';
    await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "branch_name": name,
        "branch_location": location,
        "branch_phone": number,
      }),
    );
  }
}

final branchProvider = StateNotifierProvider<BranchProvider, void>((ref) {
  return BranchProvider();
});
