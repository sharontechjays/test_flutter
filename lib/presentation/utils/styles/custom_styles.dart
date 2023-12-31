import 'package:flutter/material.dart';
import 'package:test_flutter/presentation/utils/styles/custom_colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton(
      {super.key,
      required this.positiveLabel,
      required this.positiveFunction,
      required this.secondaryColor});

  final String positiveLabel;
  final Color secondaryColor;
  final Function positiveFunction;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: BorderSide(width: 1, color: secondaryColor),
      ),
      child: Text(positiveLabel),
      onPressed: () {
        positiveFunction();
        Navigator.of(context).pop();
      },
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.negativeLabel,
    required this.negativeFunction,
  });

  final String negativeLabel;
  final Function negativeFunction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))),
        child: Text(negativeLabel),
        onPressed: () {
          negativeFunction();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class MyMaterialButton extends StatelessWidget {
  const MyMaterialButton({
    super.key,
    required this.onClickButton(BuildContext context),
  });

  final void Function(BuildContext context) onClickButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClickButton(context);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(
            colors: [
              AppColors.Primary_purple,
              AppColors.Secondary_purple,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: const Center(
            child: Text(
          'Get Started',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}

class AnimatedToggle extends StatelessWidget {
  final List<String> values;
  final ValueChanged<int> onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  const AnimatedToggle({
    Key? key,
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: values.length,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: TabBar(
          tabs: List.generate(
            values.length,
            (index) => Tab(
              child: Text(
                values[index],
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          onTap: (index) => onToggleCallback(index),
          indicatorColor: AppColors.Secondary_purple,
          labelColor: AppColors.Secondary_purple,
          unselectedLabelColor: Colors.black87,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.Secondary_purple,
          ),
        ),
      ),
    );
  }
}
