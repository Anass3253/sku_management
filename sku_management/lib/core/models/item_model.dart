class ItemModel {
  final String? id;
  final String itemName;
  final String category;
  final String subCategory;
  final String brandName;
  final String? skuCode;
  final String? createdAt;
  final bool manualSku;
  bool codesGenerated = false;
  Uri qrCodeUri = Uri.parse('');
  Uri barcodeUri = Uri.parse('');

  ItemModel({
    required this.itemName,
    required this.category,
    required this.subCategory,
    required this.brandName,
    required this.manualSku,
    this.id,
    this.skuCode,
    this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      itemName: json['item_name'],
      category: json['category'],
      subCategory: json['sub_category'],
      brandName: json['brand_name'],
      skuCode: json['sku_code'],
      createdAt: json['created_at'],
      manualSku: json['is_sku_manual'],
    );
  }
}