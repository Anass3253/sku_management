import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sku_management/core/models/item_model.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.item});
  final ItemModel item;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Qr code for ${widget.item.itemName}',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: SizedBox(
                      height: 200.h,
                      width: 200.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child:
                            widget.item.codesGenerated
                                ? Image.network(
                                  widget.item.qrCodeUri.toString(),
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                                      child: Text(
                                        'No QR code for this product yet!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'barcode for ${widget.item.itemName}',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 200.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child:
                          widget.item.codesGenerated
                              ? Image.network(
                                widget.item.barcodeUri.toString(),
                                fit: BoxFit.cover,
                              )
                              : Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'No barcode for this product yet!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Item Details',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Item Name: ${widget.item.itemName}',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Category: ${widget.item.category}',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Sub Category: ${widget.item.subCategory}',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Brand Name: ${widget.item.brandName}',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'SKU Code: ${widget.item.skuCode ?? "N/A"}',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
