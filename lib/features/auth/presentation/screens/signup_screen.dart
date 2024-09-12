import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snakbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/screens/login_screen.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SignUpScreen());
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> signUpFromKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if(state is AuthFailure){
                    showSnackBar(context: context, content: state.message);
                }else if(state is AuthSuccess){

                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                } else {
                  return Form(
                    key: signUpFromKey,
                    child: ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Sign Up.',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AuthField(
                          hint: 'Name',
                          myController: nameController,
                        ),
                        AuthField(
                          hint: 'Email',
                          myController: emailController,
                        ),
                        AuthField(
                          hint: 'Password',
                          myController: passwordController,
                          isPassword: true,
                        ),
                        AuthGradientButton(
                          onTap: () {
                            if (signUpFromKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthSignUp(
                                      name: nameController.text,
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    ),
                                  );
                            }
                          },
                          btnText: 'Sign Up',
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                              context, LoginScreen.route()),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Already Hava An Accout ? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppPallete.gradient2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
