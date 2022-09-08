import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/pages/login/login_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';


import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final LoginController _con = LoginController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: -80,
                left: -100,
                child: _circleLogin()
            ),
            Positioned(
                child: _textLogin(),
              top: 60,
              left: 12,
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  //_lottieAnimation(),
                  _imageBanner(),
                  _textFieldEmail(),
                  _textFieldPassword(),
                  _buttonLogin(),
                  _textDontHaveAccount(),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

// String --->  _name  <--- ; la raya abajo significa que la clase
// es privada  ; caso contrario es publica

  Widget _lottieAnimation() {
    return Container(
      margin: EdgeInsets.only(
          top: 150,
          bottom: MediaQuery.of(context).size.height * 0.07
      ),
      child: Lottie.asset(
        'assets/json/delivery.json',
        width: 350,
        height: 200,
        fit: BoxFit.fill
      ),
    );
    
    
  }
  
  Widget _textLogin() {
    return const Text(
      'LOGIN',
      style: TextStyle(
        color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'NimbusSans'
    ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes cuenta?',
          style: TextStyle(
            color: MyColors.primarycolor,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primarycolor,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
          onPressed: _con.login,
          child: const Text('INGRESAR'),
        style: ElevatedButton.styleFrom(
          primary: MyColors.primarycolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: const EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Electrónico',
                border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: MyColors.primarycolorDark
          ),
          prefixIcon: Icon(
              Icons.email,
          color: MyColors.primarycolor,)
        ),
      ),
    );
  }

  Widget _circleLogin() {
    return Container(
      width: 200,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primarycolor
      ),
    );
  }

  Widget _imageBanner() {
    return Container(
      margin: EdgeInsets.only(
          top: 150,
          bottom: MediaQuery.of(context).size.height * 0.05
      ),
      child: Image.asset(
        'assets/img/logo_hotel_herradura.png',
        width: 320,
        height: 270,
        // width: 350,
        // height: 200,
      ),
    );
  }

}
