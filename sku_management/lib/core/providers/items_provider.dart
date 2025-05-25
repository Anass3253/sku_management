import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_management/core/models/item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsProvider extends StateNotifier<AsyncValue<List<ItemModel>>> {
  ItemsProvider() : super(const AsyncValue.loading());
  final url = 'http://10.0.2.2:8000';
  Future<void> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('$url/item_management/'));
      final items =
          (json.decode(response.body) as List)
              .map((item) => ItemModel.fromJson(item))
              .toList();
      state = AsyncValue.data(items);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addItem(ItemModel item) async {
    var param = <String, dynamic>{};
    if (item.manualSku) {
      print('Manual SKU is true, ${item.manualSku}');
      param = {
        'item_name': item.itemName,
        'category': item.category,
        'sub_category': item.subCategory,
        'brand_name': item.brandName,
        'sku_code': item.skuCode,
        'isManual': item.manualSku,
      };
    } else {
      print('Manual SKU is false, ${item.manualSku}');
      param = {
        'item_name': item.itemName,
        'category': item.category,
        'sub_category': item.subCategory,
        'brand_name': item.brandName,
        'isManual': item.manualSku,
      };
    }

    await http.post(
      Uri.parse('$url/item_management/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(param),
    );
    item.codesGenerated = false; // Reset codesGenerated after adding
  }

  Future<void> searchItems(String searchTerm) async {
    final currentItems = state.value;
    if (currentItems == null) return;

    // If searchTerm is empty, show all items (or you can refetch from backend)
    if (searchTerm.trim().isEmpty) {
      state = AsyncValue.data(currentItems);
      return;
    }

    final lowerSearch = searchTerm.toLowerCase();
    final filtered =
        currentItems.where((item) {
          return (item.itemName.toLowerCase().contains(lowerSearch)) ||
              (item.skuCode?.toLowerCase().contains(lowerSearch) ?? false) ||
              (item.category.toLowerCase().contains(lowerSearch));
        }).toList();

    state = AsyncValue.data(filtered);
  }

  Future<void> deactivateItem(String skuCode) async {
    try {
      final response = await http.delete(
        Uri.parse('$url/item_deactivation/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sku_code': skuCode}),
      );
      if (response.statusCode == 202) {
        // Successfully deactivated
        await fetchItems(); // Refresh the list after deactivation
      } else {
        throw Exception('Failed to deactivate item');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> generateCodes(ItemModel item) async {
    final skuCode = item.skuCode;
    try {
      final response = await http.post(
        Uri.parse('$url/codes_generator/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sku_code': skuCode}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        item.codesGenerated = true; 
        item.qrCodeUri = Uri.parse(data['qr_code_url']);
        item.barcodeUri = Uri.parse(data['barcode_url']);
        // Update the item state
        // final barcodeUrl = data['barcode_url'];
        // final qrcodeUrl = data['qrcode_url'];

        // // You can handle the URLs as needed, e.g., display them or save them
        // print('Barcode URL: $barcodeUrl');
        // print('QR Code URL: $qrcodeUrl');
      } else {
        throw Exception('Failed to generate barcode');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final itemsProvider =
    StateNotifierProvider<ItemsProvider, AsyncValue<List<ItemModel>>>((ref) {
      return ItemsProvider();
    });
