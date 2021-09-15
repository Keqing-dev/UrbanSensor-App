import 'package:flutter/material.dart';
import 'package:urbansensor/src/widgets/button.dart';
import 'package:urbansensor/src/widgets/input.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/img/background.png",
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 42.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "URBANSENSOR",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Prototipo Universidad Autónoma de Chile",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    SizedBox(height: 64.0),
                    Input(
                      label: "Email",
                      placeholder: "example@example.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 32.0),
                    Input(
                      label: "Contraseña",
                      placeholder: "••••••••",
                      isPassword: true,
                    ),
                    SizedBox(height: 32.0),
                    Button(
                      content: Text("Ingresar"),
                      onPressed: () {
                        // print("xd");
                        // auth.login("email", "password");
                      },
                    ),
                    SizedBox(height: 32.0),
                    Button(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/img/google.png"),
                          SizedBox(width: 24.0),
                          Text("Acceder con Google")
                        ],
                      ),
                      onPressed: () {},
                      fillColor: Colors.white,
                      textColor: Colors.black54,
                    ),
                    SizedBox(height: 32.0),
                    Button(
                      content: Text("Crea tu Cuenta"),
                      onPressed: () {},
                      type: ButtonType.text,
                      fillColor: const Color.fromRGBO(164, 156, 255, 1.0),
                    ),
                    SizedBox(height: 32.0),
                    Image.asset("assets/img/ua.png"),
                    SizedBox(height: 32.0),
                    Image.asset("assets/img/fondecyt.png"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
