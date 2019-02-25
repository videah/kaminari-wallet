import 'package:flutter/material.dart';
import 'package:kaminari_wallet/utils/screen_size.dart';

class SuccessAnimation extends StatelessWidget {
  final Color color;
  final Animation<double> buttonController;
  final Animation circleZoomOut;
  final Animation<Alignment> circleBottomToCenter;
  final GestureTapCallback onComplete;

  SuccessAnimation(
      {Key key, this.buttonController, this.onComplete, this.color})
      : circleZoomOut = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(parent: buttonController, curve: Curves.easeOut),
        )..addListener(
            () {
              if (buttonController.isCompleted) onComplete();
            },
          ),
        circleBottomToCenter =
            AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.center)
                .animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.0,
              0.500,
              curve: Curves.easeOut,
            ),
          ),
        ),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Align(
      alignment: circleBottomToCenter.value,
      child: Container(
        width: getLargestScreenSize(context) * circleZoomOut.value,
        height: getLargestScreenSize(context) * circleZoomOut.value,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            360 + -(circleZoomOut.value * 360),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
