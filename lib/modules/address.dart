// ignore_for_file: must_be_immutable
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';

import '../layout/cubit/cubit.dart';
import '../shared/components/textform.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({Key? key}) : super(key: key);

  var cityController = TextEditingController();
  var nameController = TextEditingController();
  var regionController = TextEditingController();
  var streetController = TextEditingController();
  var paymentController = DropdownEditingController<String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              defaultFormField(
                controller: nameController,
                type: TextInputType.text,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
                label: 'Name',
                prefix: Icons.person,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextDropdownFormField(
                options: const ['cash', 'online'],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                  ),
                  prefixIcon: Icon(
                    Icons.monetization_on,
                    color: Colors.grey,
                  ),
                  labelText: 'Payment',
                ),
                dropdownHeight: 115.0,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Select payment method';
                  }
                  return null;
                },
                controller: paymentController,
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultFormField(
                controller: cityController,
                type: TextInputType.text,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter your City';
                  }
                  return null;
                },
                label: 'City',
                prefix: Icons.location_city,
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultFormField(
                controller: regionController,
                type: TextInputType.text,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter your region';
                  }
                  return null;
                },
                label: 'Region',
                prefix: Icons.location_city,
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultFormField(
                controller: streetController,
                type: TextInputType.text,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter your street';
                  }
                  return null;
                },
                label: 'Address',
                prefix: Icons.house,
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultButton(
                function: () {
                  ShopCubit.get(context).addUserAddress(
                    name: 'samehhussien',
                    city: 'samehhussien',
                    region: 'samehhussien',
                    street: 'samehhussien',
                    latitude: '30.0616863',
                    longitude: '31.3260088',
                  );
                },
                text: 'Add Order',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
