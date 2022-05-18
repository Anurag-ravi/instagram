import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/components/cacheimage.dart';
import 'package:instagram/models/postmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key,required this.post,required this.prefs}) : super(key: key);
  final PostModel post;
  final SharedPreferences prefs;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin{
  late TransformationController controller;
  late AnimationController animationController;
  late Animation<Matrix4> animation;

  bool isheartanimated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 200))
    ..addListener(() {controller.value = animation.value;});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    animationController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.5),
                  child: ClipOval(
                    child: Container(
                      // width: deviceWidth * 0.12,
                      height: deviceWidth * 0.12,
                      child: widget.post.authorDp != '' ? ChachedImage(url: widget.post.authorDp)
                      : Image.asset("assets/avatar.png"),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: deviceWidth * 0.02,
                      ),
                      Text(
                        widget.post.authorUsername,
                        style: TextStyle(
                          fontSize: deviceWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.post.location,
                            style: TextStyle(
                              fontSize: deviceWidth * 0.03,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceWidth * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    bottompopup(context);
                  },
                  icon: Icon(
                    Icons.more_vert,
                    size: deviceWidth * 0.07,
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.03,
              ),
            ],
          ),
          GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  clipBehavior: Clip.none,
                  transformationController: controller,
                  onInteractionEnd: (details) {
                    resetAnimation();
                  },
                  child: Container(
                    width: deviceWidth,
                    child: ChachedImage(url: widget.post.imageurl),
                    ),
                ),
                Opacity(
                  opacity: isheartanimated ? 1: 0,
                  child: HeartAnimationWidget(
                    isAnimating: isheartanimated,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.favorite,color: Colors.white,size: deviceWidth * 0.25,),
                    onEnd: () {
                      setState(() {
                        isheartanimated = false;
                      });
                    },
                    ),
                    
                )
              ],
            ),
            onDoubleTap: () {
              setState(() {
                widget.post.liked = true;
                isheartanimated = true;
              });
            },
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: deviceWidth * 0.01,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.post.liked = !widget.post.liked;
                  });
                },
                alignment: Alignment.topCenter,
                icon: SvgPicture.asset(
                    widget.post.liked ? 'assets/bottomicons/heart1.svg' : 'assets/bottomicons/heart0.svg',
                    height: deviceWidth * 0.07,
                    width: deviceWidth * 0.07,
                  ),
              ),
              IconButton(
                onPressed: () {},
                alignment: Alignment.topCenter,
                icon: SvgPicture.asset(
                  'assets/comment.svg',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
              IconButton(
                onPressed: () {},
                alignment: Alignment.topCenter,
                icon: SvgPicture.asset(
                  'assets/send.svg',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.45,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.post.saved = !widget.post.saved;
                  });
                  if (widget.post.saved){
                    final snackbar = SnackBar(
                      content: const Text('Saved to collection'),
                      action: SnackBarAction(
                        label: 'Undo',
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            widget.post.saved = false;
                          });
                        },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                alignment: Alignment.topCenter,
                icon: Image.asset(
                  widget.post.saved ? 'assets/savee.png' : 'assets/save.png',
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.07,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: deviceWidth * 0.04,
              ),
              widget.post.firstLikeDp == '' ? CircleAvatar(
                backgroundImage: const AssetImage("assets/avatar.png"),
                radius: deviceWidth * 0.03,
              ) : ClipOval(
                child: Container(
                  width: deviceWidth * 0.06,
                  height: deviceWidth * 0.06,
                  child: ChachedImage(url: widget.post.firstLikeDp)),
              ),
              SizedBox(
                width: deviceWidth * 0.01,
              ),
              Flexible(
                child: Text(
                  'Liked by ${widget.post.liked ? 'me, ' : ''}${widget.post.firstLike != '' ? widget.post.firstLike+', ':''}${widget.post.liked || widget.post.firstLike != '' ? 'and ' : ''}${widget.post.likeCount} others',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceWidth * 0.01,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: deviceWidth * 0.04,
              ),
              Flexible(
                child: Text(
                  '${widget.post.authorUsername} : ${widget.post.caption}',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: deviceWidth * 0.039,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceWidth * 0.018,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: deviceWidth * 0.04,
              ),
              Text(
                'View all ${widget.post.commentCount} comments',
                style: TextStyle(
                  fontSize: deviceWidth * 0.037,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceWidth * 0.02,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: deviceWidth * 0.04,
              ),
              Expanded(
                flex: 1,
                child: ClipOval(
                      child: Container(
                        width: deviceWidth*0.084,
                        height: deviceWidth*0.084,
                        child: widget.prefs.getString('dp')! == '' ? Image.asset('assets/avatar.png') : ChachedImage(url: widget.prefs.getString('dp')!),
                      ),
                    ),
              ),
              SizedBox(
                width: deviceWidth * 0.02,
              ),
              Expanded(
                flex: 8,
                child: Text(
                  'Add a comment',
                  style: TextStyle(
                    fontSize: deviceWidth * 0.034,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '❤',
                  style: TextStyle(
                    fontSize: deviceWidth * 0.035,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ' 🙌',
                  style: TextStyle(
                    fontSize: deviceWidth * 0.035,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.add_circle_outline,
                    size: deviceWidth * 0.04,
                  )),
            ],
          ),
          SizedBox(
            height: deviceWidth * 0.02,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: deviceWidth * 0.04,
              ),
              Text(
                widget.post.ago,
                style: TextStyle(
                  fontSize: deviceWidth * 0.031,
                  color: Colors.grey[500],
                ),
              ),
              Icon(
                Icons.circle,
                size: deviceWidth * 0.01,
                color: Colors.grey[500],
              ),
              Text(
                ' See translation',
                style: TextStyle(
                  fontSize: deviceWidth * 0.031,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity()
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    animationController.forward(from: 0);
  }
}

class HeartAnimationWidget extends StatefulWidget {
  const HeartAnimationWidget({ Key? key,required this.child,required this.isAnimating,this.duration = const Duration(milliseconds: 150),required this.onEnd }) : super(key: key);
  
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback onEnd;

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/2;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: halfDuration)
      );

      scale = Tween<double>(begin: 0.9,end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant HeartAnimationWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(widget.isAnimating != oldWidget.isAnimating){
      doAnimation();
    }
  }
  Future doAnimation() async {
    await controller.forward();
    await controller.reverse();

    if( widget.onEnd != null){
      widget.onEnd();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    controller.dispose();
  }
  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: scale,
    child: widget.child
    );

}

void bottompopup(context) {
  double devicewidth = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: devicewidth * 0.5,
          child: Flexible(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Container(
                      width: devicewidth * 0.15,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.report,
                        size: devicewidth * 0.07,
                        color: Colors.redAccent,
                      ),
                      SizedBox(
                        width: devicewidth * 0.025,
                      ),
                      Text(
                        'Report',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.link,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.025,
                      ),
                      Text(
                        'Copy Link',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: devicewidth * 0.05,
                      ),
                      Icon(
                        Icons.share,
                        size: devicewidth * 0.07,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: devicewidth * 0.025,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: devicewidth * 0.055,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
