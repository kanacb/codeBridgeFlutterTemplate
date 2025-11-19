import 'package:flutter/services.dart';

import 'SignUpPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/Validators.dart';
import '../../Utils/Dialogs/BuildSvgIcon.dart';

class SignUpVerify extends StatefulWidget {
  const SignUpVerify({super.key, required this.name, required this.email, required this.code});
  final String name;
  final String email;
  final int code;

  @override
  State<SignUpVerify> createState() => _SignUpVerifyState();
}

class _SignUpVerifyState extends State<SignUpVerify> {
  late LabeledGlobalKey<FormState> key = LabeledGlobalKey<FormState>("Verify");
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BuildSvgIcon(
          assetName: "assets/svg/signup-verify.svg",
          index: 1,
          currentIndex: 1,
        ),
      ),
      body: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 40.0, bottom: 2.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Verify your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please enter the 6-digit code sent to your email. Check your Junk/Spam folder if it doesn't arrive.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => _buildInputField(index)),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    // Add "resend code function" functionality
                  },
                  child: const Text(
                    "resend code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 120.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      onPressed: () {
                        final String enteredCode = _controllers.map((c) => c.text).join();
                        print(enteredCode);
                        if(int.parse(enteredCode) == widget.code){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpPassword(
                                    name: widget.name, email: widget.email);
                              },
                            ),
                          );
                        }
                        else {

                        }

                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "© 2024 CodeBridge Sdn Bhd. All rights reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),
              ],
            ),
          )),
    );
  }

  Widget _buildInputField(int index) {
    final isLastBox = index == _focusNodes.length - 1;

    return Container(
      width: 47,
      height: 61,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.5),
        border: Border.all(color: const Color(0xFFDEE2E6)),
      ),
      child: Center(
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                index > 0) {
              if (isLastBox) {
                if (_controllers[index].text.isNotEmpty) {
                  // Case 1: Last box has digit - clear it only
                  _controllers[index].clear();
                } else {
                  // Case 2: Last box empty - fast delete previous
                  _controllers[index - 1].clear();
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              } else {
                // Other boxes - fast delete always
                if (_controllers[index].text.isEmpty) {
                  _controllers[index - 1].clear();
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              }
            }
          },
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: "",
              contentPadding: EdgeInsets.zero,
            ),
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty && index < _focusNodes.length - 1) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }
            },
          ),
        ),
      ),
    );
  }
}
