library smooth_star_rating;

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class SmoothStarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIconData;
  final IconData halfFilledIconData;
  final IconData
      defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  SmoothStarRating({
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData,
    this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 25,
    this.filledIconData,
    this.halfFilledIconData,
    this.allowHalfRating = true,
  }) {
    assert(this.rating != null);
  }

  Widget buildStar(BuildContext context, int index) {
    Widget icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_rate_rounded,
        color: Color(0xff4a4a4a).withOpacity(0.5),
        size: size,
      );
    } else if (index > rating - (allowHalfRating ? 0.5 : 1.0) &&
        index < rating) {
      icon = new Icon(
        halfFilledIconData != null ? halfFilledIconData : Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = ShaderMask(
        child: Icon(
          Icons.star_rate_rounded,
          size: size,
          color: Colors.white,
        ),
        shaderCallback: (Rect bounds) {
          final Rect rect = Rect.fromLTRB(0, 0, size, size);
          return LinearGradient(
            colors: <Color>[
              Color(0xfffda701),
              Color(0xfffdca10),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rect);
        },
      );
      // icon = new Icon(
      //   filledIconData != null ? filledIconData : Icons.star,
      //   color: color ?? Theme.of(context).primaryColor,
      //   size: size,
      // );
    }

    return new GestureDetector(
      onTap: () {
        if (this.onRatingChanged != null) onRatingChanged(index + 1.0);
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / size;
        var newRating = allowHalfRating ? i : i.round().toDouble();
        if (newRating > starCount) {
          newRating = starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (this.onRatingChanged != null) onRatingChanged(newRating);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Wrap(
          alignment: WrapAlignment.start,
          spacing: spacing,
          children: new List.generate(
              starCount, (index) => buildStar(context, index))),
    );
  }
}
