import 'package:flutter/material.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class InputSearch extends StatelessWidget {
  const InputSearch({Key? key, required this.func}) : super(key: key);
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: TextField(
          onChanged: (value) {
            func(value);
          },
          style: TextStyle(
            fontSize: 13,
            color: Palettes.gray2,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 25,
              color: Palettes.gray2,
            ),
            hintText: 'Buscar..',
            hintStyle: Theme.of(context).textTheme.caption!.copyWith(
                  color: Palettes.gray2,
                ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide.none,
            ),
            enabledBorder:const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide.none,
            ),
          ),
        ));
  }
}
