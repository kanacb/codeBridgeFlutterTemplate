import 'dart:io';

import 'package:flutter/material.dart';

import '../snackbars.dart';

Widget buildEmail(email) {
  return TextFormField(
    controller: email,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: 'Email',
      hintStyle: const TextStyle(color: Colors.black),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(500.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500.0),
          borderSide: const BorderSide(color: Colors.blue)),
      isDense: true,
      // Added this
      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
    ),
    cursorColor: Colors.white,
    style: const TextStyle(color: Colors.black),
    validator: (email) =>
        email != null && email.isEmpty ? 'Email required' : null,
  );
}

Widget buildPassword(password) {
  return TextFormField(
      controller: password,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500.0),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500.0),
            borderSide: const BorderSide(color: Colors.blue)),
        isDense: true,
        // Added this
        contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      ),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      validator: (password) =>
          password != null && password.isEmpty ? 'Password required' : null);
}

Widget buildButton(context, formKey, label, email, password, isKeyboard, fetchLogin,
    snackBar, nextScreen) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 172, 6, 6)),
      shadowColor: MaterialStateProperty.all<Color>(Colors.white70),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    ),
    onPressed: () async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      final data = {
        "email": email.value.text.trim(),
        "password": password.value.text.trim()
      };
      try {
        // return const Center(child: CircularProgressIndicator());
        BuildContext dialogContext = context;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              dialogContext = context;
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        if (isKeyboard) FocusScope.of(context).requestFocus(FocusNode());
        final response = await fetchLogin(data);
        Navigator.of(context, rootNavigator: true).pop();
        if (response.statusCode == 200 && response.status) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => nextScreen(),
              ));
        } else {
          // catch all errors
          snackBar = const SnackBar(
            content: Text("Invalid Login"),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        return;
      } on SocketException catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBarException(context, e, 'Server is probably not up and running');
      } on Exception catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBarException(context, e, "Oppssss, something is not right.");
      }
    },
    child: Text(
      label,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 0),
    ),
  );
}
