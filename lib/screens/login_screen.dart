import 'package:api_flutter/cubits/cubit/login_cubit.dart';
import 'package:api_flutter/screens/my_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubitt = LoginCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 37 / 844,
              ),
              width: MediaQuery.of(context).size.width * 332 / 390,
              height: MediaQuery.of(context).size.height * 46 / 844,
              child: TextFormField(
                controller: emailController,
                enableInteractiveSelection: false,
                autofocus: false,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Username',
                  alignLabelWithHint: false,
                  hintStyle: const TextStyle(
                    color: Color(0xFF89875B),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF89875B),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 17 / 844,
                  ),
                  width: MediaQuery.of(context).size.width * 332 / 390,
                  height: MediaQuery.of(context).size.height * 46 / 844,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    autofocus: false,
                    textAlign: TextAlign.left,
                    controller: passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      alignLabelWithHint: false,
                      hintStyle: const TextStyle(
                        color: Color(0xFF89875B),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      filled: true,
                      fillColor: const Color(0xFFD9D9D9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF89875B),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 6 / 844,
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      'Don\'t have an account? Register Now',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if(state is LoginSuccessState){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const MyHomePage(),));
                }else if(state is LoginLoadingState){
                  const Center(
                  child: CircularProgressIndicator()
                  );
                } 
                // }else{
                //     print('errror to load data');
                //   }
              },
              builder: (context, state) {
                return state is LoginLoadingState ? const Center(child: CircularProgressIndicator(),) : MaterialButton(
                  onPressed: () {
                    cubitt.loginUser(
                        emailController.text, passwordController.text);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 15 / 844,
                    ),
                    width: MediaQuery.of(context).size.width * 149 / 390,
                    height: MediaQuery.of(context).size.height * 51 / 844,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF96945E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
