import 'package:construction_app/utils/approutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonWidgets {
  SnackBar snackBarinfo(String content, {Color color = Colors.red}) {
    return SnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  TextFormField commonTextfield(
      {TextEditingController? textController,
      String? hintText,
      TextInputType keyboardtype = TextInputType.text,
      Color bordercolor = Colors.grey,
      int maxLines = 1,
      bool readOnly = false,
      Color errorBorderColor = const Color(0xFFFF4D4F),
      String? Function(String?)? validator,
      Widget? prefixIcon,
      Widget? suffixIcon,
      bool? obsureText = false,
      Function(String)? onchanged}) {
    return TextFormField(
      keyboardType: keyboardtype,
      readOnly: readOnly,
      controller: textController,
      maxLines: maxLines,
      obscureText: obsureText!,
      validator: validator,
      onChanged: onchanged,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0, // Top and Bottom padding
          horizontal: 20.0, // Left and Right padding
        ).r,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0).r, // Radius as specified
          borderSide: BorderSide(
            color: bordercolor, // Grey border color
            width: 1.0.w, // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0).r,
          borderSide: BorderSide(
            color: bordercolor, // Grey color on focus
            width: 1.0.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0).r,
          borderSide: BorderSide(
            color: bordercolor, // Grey color when not focused
            width: 1.0.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: errorBorderColor,
            width: 1.w,
          ),
        ),
      ),
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    );
  }

  AppBar commonappbar(
    String title,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      forceMaterialTransparency: true,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 10.r),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  GestureDetector commonButton({String? title, Function()? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(10).r,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10).r,
        ),
        child: Center(
          child: Text(
            title ?? '',
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Future<dynamic> successAlertBox(BuildContext context, String title) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(20.r),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Animation - 1749205098384.gif',
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
            ],
          ),
          actions: [
            CommonWidgets().commonButton(
              title: 'Done',
              ontap: () {
                Get.offAllNamed(Approutes.adminDashboardPage);
              },
            ),
          ],
        );
      },
    );
  }

  void showFeedbackDialogue(BuildContext context,
      TextEditingController descriptionController, Function()? ontap,
      {int? lines = 4, String? title = 'Description'}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12).r,
          ),
          content: Container(
            width: 338.w,
            height: 220.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12).r,
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    title ?? 'Description',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  CommonWidgets().commonTextfield(
                    maxLines: lines ?? 4,
                    hintText: 'Write here...',
                    keyboardtype: TextInputType.text,
                    textController: descriptionController,
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 100, bottom: 10).r,
                    child: CommonWidgets().commonButton(
                      title: 'Submit',
                      ontap: ontap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
