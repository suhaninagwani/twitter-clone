import 'package:flutter/material.dart';
import 'package:twitter_clone/components/my_button.dart';
import 'package:twitter_clone/components/my_textfield.dart';
//import 'package:twitter_clone/pages/home_page.dart';
import 'package:twitter_clone/services/auth/auth_service.dart';
import 'package:twitter_clone/components/my_loading_circle.dart';
import 'package:twitter_clone/services/database/database_service.dart';
/* Registration page 
-email
-confirm password
-name
-password
----------------------------------------

if successfull redirects to home page
else
if user already exists it redirects to login page
*/
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //access auth service
  final _auth = AuthService();
  final _db = DatabaseService();

//text controllers
  final TextEditingController nameController= TextEditingController();
  final TextEditingController emailController= TextEditingController();
  final TextEditingController pwController= TextEditingController();
  final TextEditingController cpwController= TextEditingController();

//register button tapped
void registerMethod() async{
  //PASSWORD MATCHES -> CREATE USER
  //show loading circle
    showLoadingCircle(context);
  if(pwController.text==cpwController.text){
    
    
    //attempt to register user
    try{
      //trying to register user with email and password
      await _auth.registerEmailAndPassword(
        emailController.text, 
        pwController.text,
        );

        //registration finished
        if (mounted) hideLoadingCircle(context);

        // once registered, create and save user profile in the database
        await _db.saveUserInfoInFirebase(
          name: nameController.text, 
          email: emailController.text
          );
        //dev notes:btw everytime you add a new package , its a good idea to kill the app and restart

    }

    //catch errors
    catch(e) {
      //loading finished
      if (mounted) hideLoadingCircle(context);
      //let user know the error
      if (mounted) {
        showDialog(context: context,
           builder: (context) => AlertDialog(
            title: Text(e.toString()),

           )
          );
        
      }

    }
    }
  
  else{
    //passwords don't match-> show error
    showDialog(context: context,
           builder: (context) =>const AlertDialog(
            title: Text("Passwords don't match"),
            
           ));
  }
  //passwords don't match-> show error

}
  @override
  
  //Build UI
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(height:50),
                //icon
                Icon(Icons.lock_open_rounded),
                //create an account
                Text("Let's create an account for you.",
                style: TextStyle( 
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16)),
              
                  SizedBox(height: 25,),
                //name
                MyTextField(
                  controller: nameController, 
                  hintText: "Enter your name", 
                  obscureText: false),
              
                  SizedBox(height:10),
                //email
                 MyTextField(
                  controller: emailController, 
                  hintText: "Enter your email", 
                  obscureText: false),
              
                  SizedBox(height:10),
                //password
                 MyTextField(
                  controller: pwController, 
                  hintText: "Enter your password", 
                  obscureText: true),
              
                  SizedBox(height:10),
                //confirm password
                 MyTextField(
                  controller: cpwController, 
                  hintText: "Confirm Password", 
                  obscureText: true),
              
                  SizedBox(height:50),
                MyButton(name:"Register", onTap: (){
                  registerMethod();
                },),
                const SizedBox(height: 50),
              //not a member?register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                    Text("Already a member?", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Login Now",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)
                    ),
                  ),
              ],),
                        ]),
            ),
        ),
      )
    ));
  }
}