import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// signup page
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var emailController= TextEditingController();
  var passController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body:
       Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                    controller: passController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async{
                 try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text,
    password: passController.text,
  );
  print("User created.");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("User created successfully!")),

  );
  Navigator.pushNamed(context,'/signin');
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
     ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("The password provided is too weak.!")),
  );
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
     ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("The account already exists for that email.!")),
  );
  
  }
} catch (e) {
  print(e);
}
                },
                child: Text("SignUp"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Login page

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
    var emailController= TextEditingController();
  var passController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async{
                try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailController.text,
    password: passController.text
  );

  print("User logged in.");
  Navigator.pushNamed(context, "/products");
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
                },
                child: Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}