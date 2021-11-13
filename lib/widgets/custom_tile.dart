import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spinchat/utils/constants/color_constants.dart';
import 'package:spinchat/widgets/rounded_button.dart';

class CustomTile extends StatelessWidget {
  final String? username;
  final Function()? ontap;
  final bool? chatPage;
  final bool? isUserLoggedIn;
  final bool isWhite;
  final Widget? leading;
  const CustomTile({
    Key? key,
    this.username,
    this.ontap,
    @required this.chatPage,
    @required this.isUserLoggedIn,
    required this.isWhite,
    @required this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: leading ?? const CircleAvatar(),
        title: Text(
          username!,
          style: GoogleFonts.spinnaker(
            color: AppColors.naveyBlue,
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(isUserLoggedIn! ? 'online' : 'offline'),
        trailing: chatPage!
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isUserLoggedIn!
                            ? AppColors.myGreen
                            : AppColors.myLightGrey),
                  ),
                ],
              )
            : CustomButton(
                width: MediaQuery.of(context).size.width / 5,
                label: 'Message',
                onTap: ontap,
                color: isWhite ? AppColors.myGreen : AppColors.naveyBlue,
              ),
      ),
    );
  }
}
