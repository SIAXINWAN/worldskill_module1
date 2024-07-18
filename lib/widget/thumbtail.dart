import 'package:flutter/material.dart';
import 'package:worldskill_module1/widget/dot.dart';

class ThumbTail extends StatefulWidget {
  final List<String>images;
  final int index;
  const ThumbTail({super.key,required this.images,required this.index});

  @override
  State<ThumbTail> createState() => _ThumbTailState();
}

class _ThumbTailState extends State<ThumbTail> {
  late int current_index;

  @override
  void initState() {
    super.initState();
    current_index = widget.index;
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: current_index);

    List<Widget>image = <Widget>[
      for(int i =0;i<3;i++)
      Image.asset(widget.images[i],
      fit:BoxFit.fill)
    ];
    
    return Expanded(child: Stack(
      children: [
        PageView(
          children: image,
          scrollDirection: Axis.horizontal,
          controller: controller,
          onPageChanged: (num){
            setState(() {
              current_index = num;
            });
          },
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0;i<image.length;i++)
              Dot(color:current_index ==i?Colors.red:Colors.white),
            ],
          ))
      ],
    ));
  }
}