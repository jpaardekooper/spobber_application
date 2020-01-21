// import 'package:flutter/material.dart';
// import 'album.dart';
// import 'package:photo_view/photo_view.dart';

// class GridDetails extends StatefulWidget {
//   final Album curAlbum;
//   final ImageProvider imageProvider;
//   final Widget loadingChild;
//   final Decoration backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
//   final dynamic initialScale;
//   final Alignment basePosition;

//   GridDetails(
//       {@required this.curAlbum,
//       this.imageProvider,
//       this.loadingChild,
//       this.backgroundDecoration,
//       this.minScale,
//       this.maxScale,
//       this.initialScale,
//       this.basePosition = Alignment.center});

//   @override
//   GridDetailsState createState() => GridDetailsState();
// }

// class GridDetailsState extends State<GridDetails> {
//   //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         constraints: BoxConstraints.expand(
//           height: MediaQuery.of(context).size.height,
//         ),
//         child: Stack(
//           children: <Widget>[
//             Hero(
//               tag: "image${widget.curAlbum.uri}",
//               child: PhotoView(
//                 imageProvider: widget.imageProvider,
//                 loadingChild: widget.loadingChild,
//                 backgroundDecoration: widget.backgroundDecoration,
//                 minScale: widget.minScale,
//                 maxScale: widget.maxScale,
//                 initialScale: widget.initialScale,
//                 basePosition: widget.basePosition,
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: OutlineButton(
//                   child: const Icon(
//                     Icons.close,
//                     color: Colors.white,
//                   ),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // class FullScreenWrapper extends StatelessWidget {
// //   const FullScreenWrapper(
// //       {this.imageProvider,
// //       this.loadingChild,
// //       this.backgroundDecoration,
// //       this.minScale,
// //       this.maxScale,
// //       this.initialScale,
// //       this.basePosition = Alignment.center});

// //   final ImageProvider imageProvider;
// //   final Widget loadingChild;
// //   final Decoration backgroundDecoration;
// //   final dynamic minScale;
// //   final dynamic maxScale;
// //   final dynamic initialScale;
// //   final Alignment basePosition;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("test"),
// //       ),
// //       body: Container(
// //         constraints: BoxConstraints.expand(
// //           height: MediaQuery.of(context).size.height,
// //         ),
// //         child: Stack(
// //           children: <Widget>[
// //             PhotoView(
// //               imageProvider: imageProvider,
// //               loadingChild: loadingChild,
// //               backgroundDecoration: backgroundDecoration,
// //               minScale: minScale,
// //               maxScale: maxScale,
// //               initialScale: initialScale,
// //               basePosition: basePosition,
// //             ),
// //             Align(
// //                 alignment: Alignment.bottomCenter,
// //                 child: Padding(
// //                     padding: EdgeInsets.all(20),
// //                     child: Text("Foto", style: TextStyle(color: Colors.white))))
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
