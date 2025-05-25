import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sku_management/core/models/item_model.dart';
import 'package:sku_management/core/providers/items_provider.dart';
import 'package:sku_management/features/barcode_integration/widgets/scanner_screen.dart';
import 'package:sku_management/features/item_details/item_details_screen.dart';

class BarcodeScreen extends ConsumerStatefulWidget {
  const BarcodeScreen({super.key});

  @override
  ConsumerState<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends ConsumerState<BarcodeScreen> {
  bool isScanningQr = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2));
    ref.read(itemsProvider.notifier).fetchItems();
    super.initState();
  }

  void onLongPressItem(ItemModel item) {
    try {
      ref.read(itemsProvider.notifier).generateCodes(item);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Barcode and QR Code Generated'),
            content: Text(
              'Tap on the item to view the generated codes for ${item.itemName}',
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void startScan() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ScannerScreen(
              isScanningQr: isScanningQr,
              onDetect: (String code) {
                print('Scanned code: $code');
                ref.watch(itemsProvider.notifier).searchItems(code);
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);
    Widget loading = const Center(child: CircularProgressIndicator());
    Widget itemBuilder(BuildContext context, int index) {
      if (items.hasError) {
        return Center(child: Text('Error: ${items.error}'));
      }
      if (items.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      final item = items.value![index];
      return InkWell(
        onLongPress: () => onLongPressItem(item),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailsScreen(item: item),
            ),
          );
        },
        child: ListTile(
          title: Text(item.itemName, style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'SKU Code: ${item.skuCode ?? "N/A"}',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            item.category,
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body:
          items.isLoading
              ? loading
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hold to generate barcode and qrcode!',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            'Or Scan from Here!',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner_outlined),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                isScanningQr = true;
                              });
                              startScan();
                            },
                          ),
                          SizedBox(width: 10.w),
                          IconButton(
                            icon: const Icon(Icons.barcode_reader),
                            color: Colors.white,
                            onPressed: () async {
                              setState(() {
                                isScanningQr = false;
                              });
                              startScan();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Column(
                        children: [
                          SizedBox(
                            height: 500.h,
                            child:
                                items.value!.isNotEmpty
                                    ? ListView.builder(
                                      itemBuilder: itemBuilder,
                                      itemCount: items.value?.length,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                    )
                                    : Center(
                                      child: Text(
                                        'No items found',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
