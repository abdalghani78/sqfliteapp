import 'package:flutter/material.dart';

Widget customFromField({
  required TextEditingController controller,
  required TextInputType type,
  required String Function(String?) validate,
  required String label,
  required Widget prefix,
  bool isPassword = false,
  void Function()? onSubmitted,
  void Function()? onTap,
  void Function(String)? onChanged,
  Widget? suffix,
}) {
  return TextFormField(
    onTap: onTap ,
    controller: controller,
    keyboardType: type,
    onChanged: onChanged,
    onFieldSubmitted: (_) => onSubmitted?.call(),
    validator: validate,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: prefix,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
