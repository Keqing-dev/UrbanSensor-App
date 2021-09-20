import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/utils/shadow.dart';
import 'package:urbansensor/src/utils/theme.dart';

class Input extends StatefulWidget {
  const Input({
    Key? key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    this.keyboardType,
    this.controller,
    this.feedback,
    this.validator,
    this.func,
  }) : super(key: key);

  final String label;
  final String placeholder;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? feedback;
  final FormFieldValidator<String>? validator;
  final Function? func;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.w500, color: CustomTheme.gray3),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Stack(
          children: [
            Container(
              height: widget.feedback != null ? 77 : 48,
              decoration: BoxDecoration(
                boxShadow: shadow(),
              ),
              child: TextFormField(
                onChanged: (value) {
                  if (widget.func != null) {
                    widget.func!(value);
                  }
                },
                validator: widget.validator,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.isPassword ? !_passwordVisible : false,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w500, color: CustomTheme.gray3),
                decoration: InputDecoration(
                  errorText: null,
                  errorStyle: null,
                  hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.w500, color: CustomTheme.gray3),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomTheme.lightBlue, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: widget.placeholder,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(_passwordVisible
                              ? UniconsLine.eye_slash
                              : UniconsLine.eye),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
            if (widget.feedback != null)
              Positioned(
                bottom: 0,
                child: widget.feedback!,
              )
          ],
        ),
        // if (widget.feedback != null) widget.feedback!,
      ],
    );
  }
}

class InputFeedback extends StatelessWidget {
  const InputFeedback({
    Key? key,
    this.iconSize = 16,
    this.icon,
    required this.label,
    this.color,
  }) : super(key: key);

  final double? iconSize;
  final IconData? icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Visibility(
          visible: icon != null,
          child: Icon(
            icon,
            size: iconSize,
            color: color ?? CustomTheme.red,
          ),
        ),
        const SizedBox(
          width: 4.0,
        ),
        Text(
          label,
          style: theme.textTheme.bodyText2!
              .copyWith(color: color ?? CustomTheme.red),
        )
      ],
    );
  }
}
