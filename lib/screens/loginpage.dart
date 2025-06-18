import 'package:flutter/material.dart';
import 'package:miniproject/screens/homepage.dart';
import 'package:miniproject/viewmodel/loginviewmodels.dart';
import 'package:provider/provider.dart';
import '../../utils/validator.dart';
import '../../screens/forgetpassword.dart';
import '../../screens/signuppage.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void _login(LoginViewModel loginVM) async {
    if (_formKey.currentState!.validate()) {
      final result = await loginVM.login(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomepageView(),
          ),
        );
      } else {
        _showErrorDialog(result['error'] ?? 'Login failed');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            child:  Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildForm(loginVM),
        ],
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

  Widget _buildForm(LoginViewModel loginVM) {
    return Center(
      child: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               Text('ZiyaAttend', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
               SizedBox(height: 8),
               Text("Login", style: TextStyle(fontSize: 18, color: Colors.greenAccent)),
               SizedBox(height: 16),
              TextFormField(
                controller: emailcontroller,
                decoration: _inputDecoration("Email"),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
               SizedBox(height: 16),
              TextFormField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: _inputDecoration("Enter a Password"),
                validator: Validators.validatePassword,
              ),
               SizedBox(height: 24),
              _buildLoginButton(loginVM),
               SizedBox(height: 8),
              _buildBottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildLoginButton(LoginViewModel loginVM) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _login(loginVM),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: loginVM.isLoading
            ?  CircularProgressIndicator(color: Colors.white)
            :  Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  Forgetpassword())),
          child:  Text("Forgot Password?", style: TextStyle(color: Colors.black87)),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  Signuppage())),
          child:  Text(
            "Signup",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
