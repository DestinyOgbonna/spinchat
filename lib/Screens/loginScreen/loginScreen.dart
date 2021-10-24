import 'package:flutter/material.dart';
import 'package:spinchat/Screens/loginScreen/loginScreenViewModel.dart';
import 'package:spinchat/utils/constants.dart';
import 'package:spinchat/utils/validations.dart';
import 'package:spinchat/widgets/custom_textfield.dart';
import 'package:spinchat/widgets/roundedButton.dart';
import 'package:stacked/stacked.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginScreenViewModel>.reactive(
      viewModelBuilder: () => LoginScreenViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: KMyWhite,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 150, 25, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('assets/rectangle.png'),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: model.resetForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomTextField(
                        onChange: (val) {},
                        hintText: 'Email',
                        controller: model.newEmailController,
                        validateFunction: Validations.validateEmail,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        onChange: (val) {},
                        obscureText: true,
                        validateFunction: Validations.validatePassword,
                        hintText: 'Password',
                        controller: model.newPasswordController
                      ),
                      SizedBox(height: 30),
                      CustomButton(
                        label: 'Login',
                        color: kMynaveyBlue,
                        onTap: () async {
                          await model.login();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
