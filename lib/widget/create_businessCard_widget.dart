import 'package:business_card/model/businessCard.dart';
import 'package:flutter/material.dart';

class CreateBusinessCardWidget extends StatefulWidget {
  final BusinessCard? businessCard;
  final ValueChanged<BusinessCard> onSubmit;

  const CreateBusinessCardWidget({
    Key? key,
    this.businessCard,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateBusinessCardWidget> createState() => _CreateBusinessCardWidgetState();
}

class _CreateBusinessCardWidgetState extends State<CreateBusinessCardWidget> {
  late TextEditingController nameController;
  late TextEditingController companyNameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.businessCard?.name ?? '');
    companyNameController = TextEditingController(text: widget.businessCard?.companyName ?? '');
    emailController = TextEditingController(text: widget.businessCard?.email ?? '');
    mobileNumberController = TextEditingController(text: widget.businessCard?.mobileNumber?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.businessCard != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Business Card' : 'Add Business Card'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
              validator: (value) => value != null && value.isEmpty ? 'Name cannot be empty' : null,
            ),
            TextFormField(
              controller: companyNameController,
              decoration: const InputDecoration(hintText: 'Company Name'),
              validator: (value) =>
                  value != null && value.isEmpty ? 'Company Name cannot be empty' : null,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (value) => value != null && value.isEmpty ? 'Email cannot be empty' : null,
            ),
            TextFormField(
              controller: mobileNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Mobile Number'),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (int.tryParse(value) == null) {
                    return 'Invalid mobile number';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              widget.onSubmit(
                BusinessCard(
                  id: 0, 
                  name: nameController.text, 
                  companyName: companyNameController.text, 
                  email: emailController.text, 
                  mobileNumber: mobileNumberController.text
                  )
              );
              Navigator.pop(context);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}