import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/validator.dart';
import '../viewmodel/signupviewmodels.dart';
import 'loginpage.dart';

class Signuppage extends StatefulWidget {
   Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(top: -80, left: -100, child: _circle(Colors.blue)),
        Positioned(bottom: -80, right: -100, child: _circle(Colors.greenAccent)),
      ],
    );
  }

  Widget _circle(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(200),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Center(
      child: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               Text('ZiyaAttend', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
               SizedBox(height: 8),
               Text('Create An Account', style: TextStyle(fontSize: 18, color: Colors.greenAccent)),
               SizedBox(height: 32),
              _buildTextField(nameController, 'Name', Validators.validateName),
              _buildTextField(emailController, 'Email', Validators.validateEmail, inputType: TextInputType.emailAddress),
              _buildTextField(mobileController, 'Mobile Number', Validators.validateMobile, inputType: TextInputType.phone),
              _buildTextField(passwordController, 'Password', Validators.validatePassword, obscure: true),
              _buildTextField(confirmPasswordController, 'Confirm Password', (value) => Validators.validateConfirmPassword(value, passwordController.text), obscure: true),
               SizedBox(height: 24),
              _buildSignupButton(context, viewModel),
               SizedBox(height: 16),
              _buildLoginRedirect(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      String? Function(String?) validator, {
        bool obscure = false,
        TextInputType inputType = TextInputType.text,
      }) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscure,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context, SignupViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            String? error = await viewModel.signUp(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              mobile: mobileController.text.trim(),
              password: passwordController.text.trim(),
              confirmPassword: confirmPasswordController.text.trim(),
            );
            if (error == null) {
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Signup successful')));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginPage()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child:  Text('Signup', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text("Already have an account? "),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  LoginPage())),
          child:  Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
