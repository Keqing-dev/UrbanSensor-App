import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/services/api_auth.dart';
import 'package:urbansensor/src/utils/theme.dart';
import 'package:urbansensor/src/widgets/button.dart';
import 'package:urbansensor/src/widgets/input.dart';
import 'package:validators/validators.dart' as validator;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiAuth _api = ApiAuth();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  Widget? _emailFeedback;
  Widget? _passwordFeedback;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            "assets/img/background_login.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 64.0, horizontal: 42.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "URBANSENSOR",
                          style: theme.textTheme.headline4!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 64.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Input(
                            controller: _emailController,
                            label: "Email",
                            placeholder: "example@example.com",
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            feedback: _emailFeedback,
                          ),
                          const SizedBox(height: 32.0),
                          Input(
                            controller: _passwordController,
                            label: "Contraseña",
                            placeholder: "••••••••",
                            isPassword: true,
                            validator: _validatePassword,
                            feedback: _passwordFeedback,
                          ),
                          const SizedBox(height: 32.0),
                          Button(
                            padding: isLoading
                                ? const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0)
                                : null,
                            content: isLoading
                                ? SizedBox(
                                    height: 48,
                                    width: 48,
                                    child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballClipRotateMultiple,
                                    ),
                                  )
                                : const Text("Ingresar"),
                            onPressed: isLoading
                                ? null
                                : () {
                                    _doLogin(_emailController.text,
                                        _passwordController.text, context);
                                  },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Button(
                      content: const Text("Crea tu Cuenta"),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                  context, "register");
                            },
                      type: ButtonType.outlined,
                      fillColor: const Color.fromRGBO(155, 81, 224, 1.0),
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/img/anid.png"),
                    ),
                    Text(
                      'FONDECYT 3200381',
                      style: theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w600, color: CustomTheme.gray3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !validator.isEmail(value)) {
      setState(() {
        _emailFeedback = InputFeedback(
          label: value!.isNotEmpty && !validator.isEmail(value)
              ? "Formato de Email Invalido"
              : "Campo Requerido",
          icon: UniconsLine.exclamation_triangle,
        );
      });
      return "";
    } else {
      setState(() {
        _emailFeedback = null;
      });
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _passwordFeedback = const InputFeedback(
          label: "Campo Requerido",
          icon: UniconsLine.exclamation_triangle,
        );
      });
      return "";
    } else {
      setState(() {
        _passwordFeedback = null;
      });
      return null;
    }
  }

  _doLogin(String email, String password, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      bool isLogged = await _api.login(
          _emailController.text, _passwordController.text, context);
      setState(() {
        isLoading = false;
      });
      if (isLogged) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (Route<dynamic> route) => false);
      } else {
        setState(() {
          _emailFeedback = const InputFeedback(
            label: "Datos Incorrectos",
            icon: UniconsLine.exclamation_triangle,
          );
          _passwordFeedback = const InputFeedback(
            label: "Datos Incorrectos",
            icon: UniconsLine.exclamation_triangle,
          );
        });
      }
    }
  }
}
