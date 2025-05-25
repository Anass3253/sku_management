import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sku_management/core/models/item_model.dart';
import 'package:sku_management/core/providers/items_provider.dart';
import 'package:sku_management/core/widgets/app_txt_field.dart';

class SkuSetupScreen extends ConsumerStatefulWidget {
  const SkuSetupScreen({super.key});

  @override
  ConsumerState<SkuSetupScreen> createState() => _SkuSetupScreenState();
}

class _SkuSetupScreenState extends ConsumerState<SkuSetupScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController skuCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool manualSku = false;

  @override
  void dispose() {
    itemNameController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    brandNameController.dispose();
    super.dispose();
  }

  void clearFields() {
    itemNameController.clear();
    categoryController.clear();
    subCategoryController.clear();
    brandNameController.clear();
    skuCodeController.clear();
    manualSku = false;
  }

  void addSku() {
    if (_formKey.currentState!.validate()) {
      final item = ItemModel(
        itemName: itemNameController.text,
        category: categoryController.text,
        subCategory: subCategoryController.text,
        brandName: brandNameController.text,
        skuCode: manualSku ? skuCodeController.text : null,
        manualSku: manualSku,
      );
      try {
        ref.read(itemsProvider.notifier).addItem(item);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('SKU added successfully')));
        clearFields(); // Clear fields after successful submission
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding SKU: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget skuCodeField = Column(
      children: [
        const SizedBox(height: 20),
        AppTextFormField(
          label: 'SKU Code',
          controller: skuCodeController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a SKU code';
            }
            return null;
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'SKU Setup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Add your SKU details here',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
                SizedBox(height: 60.h),
                AppTextFormField(
                  label: 'Item Name',
                  controller: itemNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  label: 'Category',
                  controller: categoryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  label: 'Sub-Category',
                  controller: subCategoryController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a sub-category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  label: 'Brand Name',
                  controller: brandNameController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a brand name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Checkbox(
                      value: manualSku,
                      activeColor: Colors.blueGrey,
                      onChanged: (value) {
                        setState(() {
                          manualSku = value ?? false;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Enter SKU manually',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                if (manualSku) skuCodeField,
                SizedBox(height: 60.h),
                Container(
                  width: double.infinity.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: TextButton(
                    onPressed: addSku,
                    child: Text(
                      'Add SKU code',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
