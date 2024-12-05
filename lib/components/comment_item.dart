import 'package:flutter/material.dart';
import 'package:gowheel_flutterflow_ui/url.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

import '../models/comment_model.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: comment.userImage != null
                ? NetworkImage(URL.imageUrl + comment.userImage!)
                : AssetImage('images/default_avartar.png') as ImageProvider,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName ?? 'Anonymous User',
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF213A58),
                        fontSize: 15,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < comment.point ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF213A58),
                    fontSize: 16,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  timeago.format(comment.createdOn, locale: 'en'),
                  style: GoogleFonts.urbanist(
                    color: Colors.grey,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
