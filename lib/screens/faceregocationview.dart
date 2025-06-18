import 'package:flutter/material.dart';
import 'package:miniproject/screens/profile.dart';
import 'package:miniproject/screens/puchedout.dart';
import 'package:miniproject/screens/punchedin%20sucess.dart';
import 'package:miniproject/viewmodel/ProfilepageModel.dart';
import 'package:provider/provider.dart';

class FaceConfirmationView extends StatefulWidget {
  final bool isPunchingIn;
  final VoidCallback onConfirmed;

  const FaceConfirmationView({super.key, required this.isPunchingIn, required this.onConfirmed});

  @override
  State<FaceConfirmationView> createState() => _FaceConfirmationViewState();
}

class _FaceConfirmationViewState extends State<FaceConfirmationView> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfilepageViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 280,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFF71C6F7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                const Text(
                  "Center your face",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Point your face right at the box,\nthen take a photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cameraswitch, size: 28),
                        onPressed: () {
                          // TODO: implement camera switch
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: ElevatedButton(
                          onPressed: isProcessing
                              ? null
                              : () {
                            setState(() => isProcessing = true);

                            final now = TimeOfDay.now();
                            final formattedTime = now.format(context);

                            if (widget.isPunchingIn) {
                              vm.punchIn();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PunchInSuccessView(time: formattedTime),
                                ),
                              ).then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Profilepage()),
                                );
                              });
                            } else {
                              vm.punchOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PunchedOutSuccessView(time: formattedTime),
                                ),
                              ).then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Profilepage()),
                                );
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.all(24),
                            elevation: 6,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 36),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flash_on, size: 28),
                        onPressed: () {
                          // TODO: toggle flash
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
