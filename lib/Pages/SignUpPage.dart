import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/User.dart'; // Corrected the import for your User service

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Instantiate the UserService
  final Userservice _userService = Userservice();

  // Method to handle sign-up logic
  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String height = _heightController.text;
      String weight = _weightController.text;

      // Call the sign-up function from UserService
      bool isSignedUp = await _userService.signUp(
        email,
        password,
        firstName,
        lastName,
        height,
        weight,
      );

      // Show success or failure message based on the result
      if (isSignedUp) {
        // Save the user's data to SharedPreferences
        _saveUserData(firstName, lastName, height, weight);
        _showSuccessDialog(firstName, lastName);
      } else {
        _showErrorDialog();
      }
    } else {
      print('Validation failed');
    }
  }

  // Method to save user data to SharedPreferences
  void _saveUserData(String firstName, String lastName, String height, String weight) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName);
    prefs.setString('lastName', lastName);
    prefs.setString('height', height);
    prefs.setString('weight', weight);
  }

  // Method to show an error dialog if sign-up fails
  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign-up Failed'),
          content: Text('There was an issue with the sign-up. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to show a success dialog
  void _showSuccessDialog(String firstName, String lastName) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        // Delay the dismissal of the dialog
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Close the dialog after 2 seconds
        });

        return AlertDialog(
          title: Text('Account Created'),
          content: Text('Account successfully created for $firstName $lastName!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss if 'OK'
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bgg.jpg'), // Food-themed background
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Get Started\nwith Delicious Food!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Form Fields
                  _buildTextField(_firstNameController, "First Name"),
                  _buildTextField(_lastNameController, "Last Name"),
                  _buildTextField(_emailController, "Email", email: true),
                  _buildTextField(_heightController, "Height (in inches)", keyboardType: TextInputType.number),
                  _buildTextField(_weightController, "Weight (kg)", keyboardType: TextInputType.number),
                  _buildTextField(_passwordController, "Password", obscureText: true),
                  _buildTextField(_confirmPasswordController, "Confirm Password", obscureText: true, confirmPassword: true),
                  SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _signUp,
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Sign In Link
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType? keyboardType, bool obscureText = false, bool confirmPassword = false, bool email = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          }

          // Custom validation for email
          if (email) {
            String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            RegExp regExp = RegExp(pattern);
            if (!regExp.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }

          // Custom validation for confirm password
          if (confirmPassword) {
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
          }

          return null;
        },
      ),
    );
  }
}
