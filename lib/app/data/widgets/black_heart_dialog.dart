import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'custom_button.dart';

class BlackHeartDialog extends StatelessWidget {
  final VoidCallback onPurchase;
  final VoidCallback onReset;
  final int price;

  const BlackHeartDialog({
    Key? key,
    required this.onPurchase,
    required this.onReset,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.purpleAccent.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonBlue.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'YOU HAVE DIED',
              style: TextStyle(
                color: AppColors.dangerRed,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: AppColors.dangerRed.withOpacity(0.7),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Black Heart Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purpleAccent.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.favorite,
                  color: AppColors.dangerRed,
                  size: 60,
                  shadows: [
                    Shadow(
                      color: AppColors.dangerRed.withOpacity(0.8),
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Message
            Text(
              'You have failed your mission, Hunter.',
              style: AppTextStyles.bodyWhite,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Your heart stops beating...',
              style: AppTextStyles.bodyWhite,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            
            // Options
            Text(
              'USE BLACK HEART TO REVIVE?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            
            // Purchase button
            CustomButton(
              text: 'REVIVE - ₹$price',
              onPressed: onPurchase,
              type: ButtonType.primary,
              fullWidth: true,
              height: 50,
              icon: Icons.favorite,
            ),
            SizedBox(height: 12),
            
            // Reset button
            CustomButton(
              text: 'RESTART FROM LEVEL 1',
              onPressed: onReset,
              type: ButtonType.danger,
              fullWidth: true,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}