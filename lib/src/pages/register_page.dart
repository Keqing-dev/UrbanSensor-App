import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/plan.dart';
import 'package:urbansensor/src/services/api_register.dart';
import 'package:urbansensor/src/utils/theme.dart';
import 'package:urbansensor/src/widgets/button.dart';
import 'package:urbansensor/src/widgets/input.dart';
import 'package:validators/validators.dart' as validator;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiRegister _api = ApiRegister();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _professionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Plan>? planList;
  String? groupValue;
  bool _isLoading = false;
  Widget? _nameFeedback;
  Widget? _lastNameFeedback;
  Widget? _professionFeedback;
  Widget? _planFeedback;
  Widget? _emailFeedback;
  Widget? _passwordFeedback;

  @override
  void initState() {
    _getPlans();
    super.initState();
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
                    Text(
                      'Formulario de Registro',
                      style: theme.textTheme.headline4,
                    ),
                    const SizedBox(height: 32.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Input(
                            controller: _nameController,
                            label: "Nombre",
                            placeholder: "Ej.: Juan",
                            validator: (value) => _validateField(
                              value,
                              () {
                                setState(() {
                                  _nameFeedback = const InputFeedback(
                                    label: "Campo Requerido",
                                    icon: UniconsLine.exclamation_triangle,
                                  );
                                });
                              },
                              () {
                                setState(() {
                                  _nameFeedback = null;
                                });
                              },
                            ),
                            feedback: _nameFeedback,
                          ),
                          const SizedBox(height: 32.0),
                          Input(
                            controller: _lastNameController,
                            label: "Apellido",
                            placeholder: "Ej.: Valdés",
                            validator: (value) => _validateField(
                              value,
                              () {
                                setState(() {
                                  _lastNameFeedback = const InputFeedback(
                                    label: "Campo Requerido",
                                    icon: UniconsLine.exclamation_triangle,
                                  );
                                });
                              },
                              () {
                                setState(() {
                                  _lastNameFeedback = null;
                                });
                              },
                            ),
                            feedback: _lastNameFeedback,
                          ),
                          const SizedBox(height: 32.0),
                          Input(
                            controller: _professionController,
                            label: "Profesión",
                            placeholder: "Ej.: Geólogo",
                            validator: (value) => _validateField(
                              value,
                              () {
                                setState(() {
                                  _professionFeedback = const InputFeedback(
                                    label: "Campo Requerido",
                                    icon: UniconsLine.exclamation_triangle,
                                  );
                                });
                              },
                              () {
                                setState(() {
                                  _professionFeedback = null;
                                });
                              },
                            ),
                            feedback: _professionFeedback,
                          ),
                          const SizedBox(height: 32.0),
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
                          planList != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipo de Plan:',
                                      style: theme.textTheme.bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: CustomTheme.gray3),
                                    ),
                                    ...planList!
                                        .map((plan) => RadioListTile<String?>(
                                              title: Text(plan.name!),
                                              value: plan.id,
                                              groupValue: groupValue,
                                              onChanged: _handleRadioChange,
                                              contentPadding:
                                                  const EdgeInsets.all(0.0),
                                            ))
                                        .toList(),
                                    if (_planFeedback != null) _planFeedback!
                                  ],
                                )
                              : SizedBox(
                                  height: 128,
                                  width: 128,
                                  child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballClipRotateMultiple),
                                ),
                          const SizedBox(height: 32.0),
                          Button(
                            padding: _isLoading
                                ? const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0)
                                : null,
                            content: _isLoading
                                ? SizedBox(
                                    height: 48,
                                    width: 48,
                                    child: LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballClipRotateMultiple,
                                    ),
                                  )
                                : const Text("Crear Cuenta"),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _register(context);
                                  },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Button(
                      content: const Text("Inicia Sesión"),
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(context, "login");
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

  _getPlans() async {
    List<Plan>? value = await _api.getPlans();
    setState(() {
      planList = value;
    });
  }

  void _handleRadioChange(String? value) {
    setState(() {
      groupValue = value;
    });
  }

  String? _validateField(
      String? value, VoidCallback callback, VoidCallback nullCallback) {
    if (value == null || value.isEmpty) {
      callback();
      return "";
    } else {
      nullCallback();
      return null;
    }
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

  _register(BuildContext context) async {
    var planIdList = planList!.map((element) => element.id).toList();
    if (_formKey.currentState!.validate() && planIdList.contains(groupValue)) {
      setState(() {
        _isLoading = true;
      });
      int code = await _api.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _lastNameController.text,
        _professionController.text,
        groupValue!,
      );
      setState(() {
        _isLoading = false;
      });

      if (code == 200) {
        _formKey.currentState!.reset();
        groupValue = null;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registrado exitosamente'),
        ));
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "login", (Route<dynamic> route) => false);
        });
      } else if (code == 400) {
        _emailFeedback = const InputFeedback(
          label: "Email Duplicado, intenta con otro o recupera tu cuenta",
          icon: UniconsLine.exclamation_triangle,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ha ocurrido un error, intenta nuevamente'),
        ));
      }
    } else {
      if (!planIdList.contains(groupValue)) {
        setState(() {
          _planFeedback = const InputFeedback(
            label: "Campo Requerido",
            icon: UniconsLine.exclamation_triangle,
          );
        });
      } else {
        setState(() {
          _planFeedback = null;
        });
      }
    }
  }
}
