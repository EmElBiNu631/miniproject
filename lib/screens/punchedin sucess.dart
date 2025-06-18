import 'package:flutter/material.dart';
import 'package:miniproject/screens/profile.dart';
import 'package:provider/provider.dart';

import '../viewmodel/ProfilepageModel.dart';

class PunchInSuccessView extends StatefulWidget {
  final String time;

   PunchInSuccessView({super.key, required this.time});

  @override
  State<PunchInSuccessView> createState() => _PunchInSuccessViewState();
}

class _PunchInSuccessViewState extends State<PunchInSuccessView> {
  @override
  void initState() {
    super.initState();

    // Wait 2 seconds, then navigate to Profilepage using existing ViewModel
    Future.delayed(const Duration(seconds: 2), () {
      final existingVm = Provider.of<ProfilepageViewModel>(context, listen: false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: existingVm,
            child: const Profilepage(),
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFF98E66D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, size: 40, color: Colors.white),
              ),
               SizedBox(height: 24),
              Text(
                'Punched In Successfully at\n${widget.time}',
                textAlign: TextAlign.center,
                style:  TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
