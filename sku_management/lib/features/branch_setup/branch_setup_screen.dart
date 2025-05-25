import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sku_management/core/providers/branch_provider.dart';
import 'package:sku_management/core/widgets/app_txt_field.dart';

class BranchSetupScreen extends ConsumerStatefulWidget {
  const BranchSetupScreen({super.key});

  @override
  ConsumerState<BranchSetupScreen> createState() => _BranchSetupScreenState();
}

class _BranchSetupScreenState extends ConsumerState<BranchSetupScreen> {
  TextEditingController branchNameController = TextEditingController();
  TextEditingController branchAddressController = TextEditingController();
  TextEditingController branchPhoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    branchAddressController.dispose();
    branchNameController.dispose(); 
    branchPhoneNumberController.dispose();
    super.dispose();
  }


  void addBranch() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {

        await ref.read(branchProvider.notifier).addBranch(
              branchNameController.text,
              branchAddressController.text,
              branchPhoneNumberController.text,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Branch added successfully'), duration: Duration(seconds: 5),),
        );
        branchNameController.clear();
        branchAddressController.clear();
        branchPhoneNumberController.clear();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding branch: $e'),duration: Durations.extralong4,));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Branch Setup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Setup your branches here',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
                SizedBox(height: 60.h),
                AppTextFormField(
                  label: 'Branch Name',
                  controller: branchNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a branch name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  label: 'Branch Address',
                  controller: branchAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a branch address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  label: 'Branch Phone Number',
                  controller: branchPhoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a branch phone number';
                    }
                    return null;
                  },
                ),
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
                    onPressed: addBranch,
                    child: Text(
                      'Add Branch',
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
