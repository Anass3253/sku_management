class BranchModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String createdAt;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}