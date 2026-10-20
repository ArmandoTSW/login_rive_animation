
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscureText = true;

  StateMachineController? _controller;
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      _isChecking?.change(
        _emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus,
      );
      _isHandsUp?.change(_passwordFocusNode.hasFocus);
    });

    _passwordFocusNode.addListener(() {
      _isChecking?.change(
        _emailFocusNode.hasFocus && !_passwordFocusNode.hasFocus,
      );
      _isHandsUp?.change(_passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/OS0g0RdO.riv',
                    stateMachines: const ['Login Machine'],
                    onInit: (artboard) {
                      _controller =
                          StateMachineController.fromArtboard(
                        artboard,
                        'Login Machine',
                      );

                      if (_controller == null) return;

                      artboard.addController(_controller!);

                      _isChecking =
                          _controller!.findSMI('isChecking') as SMIBool?;

                      _isHandsUp =
                          _controller!.findSMI('isHandsUp') as SMIBool?;

                      _isChecking?.change(false);
                      _isHandsUp?.change(false);
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Email
                TextField(
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Password
                TextField(
                  focusNode: _passwordFocusNode,
                  obscureText: _isObscureText,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscureText = !_isObscureText;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
