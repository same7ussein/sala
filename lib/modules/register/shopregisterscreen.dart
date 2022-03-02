import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/shop_app.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constant.dart';
import '../../shared/components/textform.dart';
import '../../shared/network/cache_helper/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {
  const ShopRegisterScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel!.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel!.data!.token,
              ).then((value) {
                token = state.loginModel!.data!.token;
                navigateAndFinish(
                  context,
                  ShopLayout(),
                );
              });
            } else {
              showToast(
                text: state.loginModel!.message!,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Register Now'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          onSubmitt: (value) {
                            ShopRegisterCubit.get(context).userRegister(
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                              name: nameController.text,
                            );
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            } else if (value.length < 8) {
                              return 'name must be more than 8 characters';
                            }
                            return null;
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          onSubmitt: (value) {
                            ShopRegisterCubit.get(context).userRegister(
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                              name: nameController.text,
                            );
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            } else if (!ShopRegisterCubit.get(context)
                                .legalEmail(emailController.text)) {
                              return 'enter valid email';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            onSubmitt: (value) {
                              ShopRegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                                name: nameController.text,
                              );
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              } else if (value.length < 9) {
                                return 'Password is too weak';
                              }
                              return null;
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: ShopRegisterCubit.get(context).suffix,
                            isPassword:
                                ShopRegisterCubit.get(context).isPassword,
                            suffixpressed: () {
                              ShopRegisterCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: confirmPasswordController,
                            type: TextInputType.visiblePassword,
                            onSubmitt: (value) {
                              ShopRegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                                name: nameController.text,
                              );
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'confirm password is wrong';
                              } else if (confirmPasswordController.text !=
                                  passwordController.text) {
                                return 'confirm password is wrong';
                              }
                              return null;
                            },
                            label: 'Confirm Password',
                            prefix: Icons.lock_outline,
                            suffix:
                                ShopRegisterCubit.get(context).confirmSuffix,
                            isPassword: ShopRegisterCubit.get(context)
                                .isConfirmPassword,
                            suffixpressed: () {
                              ShopRegisterCubit.get(context)
                                  .changeConfirmPasswordVisibility();
                            }),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          onSubmitt: (value) {
                            ShopRegisterCubit.get(context).userRegister(
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                              name: nameController.text,
                            );
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            } else if (value.length < 11) {
                              return 'Phone must be not less than 11 numbers';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                            text: 'register',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  name: nameController.text,
                                );
                              }
                            },
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
