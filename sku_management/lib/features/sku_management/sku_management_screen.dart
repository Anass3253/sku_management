import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sku_management/core/providers/items_provider.dart';
import 'package:sku_management/core/widgets/app_txt_field.dart';

class SkuManagementScreen extends ConsumerStatefulWidget {
  const SkuManagementScreen({super.key});

  @override
  ConsumerState<SkuManagementScreen> createState() =>
      _SkuManagementScreenState();
}

class _SkuManagementScreenState extends ConsumerState<SkuManagementScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    ref.read(itemsProvider.notifier).fetchItems();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchItems() {
    final searchTerm = searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      ref.watch(itemsProvider.notifier).searchItems(searchTerm);
    } else {
      ref.watch(itemsProvider.notifier).fetchItems(); // Reset to all items
    }
  }

  void onLongPressItem(String skuCode) {
    try {
      ref.watch(itemsProvider.notifier).deactivateItem(skuCode);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item Deactivated'),
            content: Text('Item with SKU Code $skuCode has been deactivated.'),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);

    Widget loading = Center(child: CircularProgressIndicator());

    Widget itemBuilder(BuildContext context, int index) {
      if (items.hasError) {
        return Center(child: Text('Error: ${items.error}'));
      }
      if (items.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      final item = items.value![index];
      return InkWell(
        onLongPress: () {
          onLongPressItem(item.skuCode!);
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
                child: Column(
                  children: [
                    AppTextFormField(
                      label: 'Search Items',
                      validator: (value) {
                        return null;
                      },
                      controller: searchController,
                      suffixIcon: IconButton(
                        onPressed: searchItems,
                        icon: Icon(Icons.search, color: Colors.white, size: 30),
                      ),
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
    );
  }
}
