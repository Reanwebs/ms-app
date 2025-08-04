import 'dart:io';
import 'package:construction_app/controller/admin_controller/admin_controller.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddToolPage extends StatefulWidget {
  const AddToolPage({super.key});

  @override
  State<AddToolPage> createState() => _AddToolPageState();
}

class _AddToolPageState extends State<AddToolPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  File? _selectedImage;
  final AdminController adminController = Get.put(AdminController());
  String? _selectedType;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Add Tool'),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
            child: ListView(
              children: [
                // Tool Name
                CommonWidgets().commonTextfield(
                    textController: _nameController,
                    hintText: 'Tool Name',
                    validator: (value) =>
                        value == null || value.isEmpty ? "Required" : null),
                SizedBox(height: 15.h),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    hintText: 'Select Type',
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, // Top and Bottom padding
                      horizontal: 20.0, // Left and Right padding
                    ).r,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0).r, // Radius as specified
                      borderSide: BorderSide(
                        color: Colors.grey, // Grey border color
                        width: 1.0.w, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0).r,
                      borderSide: BorderSide(
                        color: Colors.grey, // Grey color on focus
                        width: 1.0.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0).r,
                      borderSide: BorderSide(
                        color: Colors.grey, // Grey color when not focused
                        width: 1.0.w,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.w,
                      ),
                    ),
                  ),
                  items: ['Tool', 'Material']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),

                SizedBox(height: 15.h),
                CommonWidgets().commonTextfield(
                  textController: _codeController,
                  hintText: 'Tool Unique Code',
                  validator: (value) =>
                      value == null || value.isEmpty ? "Required" : null,
                ),

                SizedBox(height: 15.h),
                CommonWidgets().commonTextfield(
                  textController: _countController,
                  hintText: 'Tool Count',
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Required";
                    if (int.tryParse(value) == null) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 15.h),

                // Optional Image
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12).r,
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              "Tap to select tool Image",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 30.h),
                Obx(
                  () => CommonWidgets().commonButton(
                    title: adminController.isloading.value
                        ? 'Adding Tool..'
                        : 'Submit',
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CommonWidgets()
                                .snackBarinfo('Please select an image'),
                          );
                          return;
                        }

                        var status = await adminController.addTool(
                            _nameController.text,
                            _codeController.text,
                            int.parse(_countController.text),
                            _selectedImage!,
                            _selectedType!);
                        if (status == true) {
                          CommonWidgets().successAlertBox(
                            context,
                            'Tool Added Successfully!',
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CommonWidgets()
                                .snackBarinfo('Failed to upload image'),
                          );
                        }
                      }
                    },
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
