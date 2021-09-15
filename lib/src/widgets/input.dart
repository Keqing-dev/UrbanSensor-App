import 'package:flutter/material.dart';
import 'package:urbansensor/src/utils/shadow.dart';

class Input extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final TextInputType? keyboardType;

  const Input({Key? key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    this.keyboardType,})
      : super(key: key);

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
          style: Theme
              .of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: shadow(),
          ),
          child: TextField(
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? !_passwordVisible : false,
            style: Theme
                .of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: widget.placeholder,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(_passwordVisible
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
                  : null,
            ),
          ),
        )
      ],
    );
  }
}
