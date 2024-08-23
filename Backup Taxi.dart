// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gif_view/gif_view.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:taxi/Bottom/Provider.dart';
// import 'package:taxi/History/Address.dart';
// import 'package:taxi/Map.dart';
// import 'package:taxi/const.dart';
// import '../HomePage/Rating.dart';
// import 'dart:async';
// import '../My Account/Profile.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//
// class DrawerPage extends StatefulWidget {
//   static const routeName = '/drawer';
//
//   const DrawerPage({super.key});
//
//   @override
//   _DrawerPageState createState() => _DrawerPageState();
// }
//
// class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
//   TextEditingController searchController = TextEditingController();
//   TextEditingController _DropController = TextEditingController();
//   TextEditingController _markerController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   DateTime timeBackPressed = DateTime.now();
//   bool warningShown = false;
//   String _searchType = 'pickup';
//   String _markerType = 'marker';
//   String _searchDropType = 'drop';
//   Set<Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   final PolylinePoints polylinePoints = PolylinePoints();
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late double _animationValue;
//
//   // Set<Marker> _markers = {};
//   Set<Marker> markers = {};
//   GoogleMapController? mapController;
//   GoogleMapController? mapLevelController;
//   GoogleMapController? mapMarkerController;
//   LatLng markerLocation = const LatLng(11.02713, 77.02425);
//   BitmapDescriptor? customIcon;
//   String _gender = '';
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _clearSearch();
//     });
//     _setMarkerIcon();
//     _getCurrentLocation();
//     searchController = TextEditingController();
//     _DropController = TextEditingController();
//     _markerController = TextEditingController();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 5), // Adjust duration as needed
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//     _animationController.addListener(() {
//       setState(() {
//         _animationValue = _animation.value; // Use _animation.value instead
//       });
//     });
//     _animationController.forward(from: 0);
//     _animationValue = 50.0;
//   }
//
//   @override
//   void dispose() {
//     _DropController.dispose();
//     searchController.dispose();
//     _markerController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _navigateAndSelectPayment(BuildContext context) async {
//     await cash();
//     setState(() {
//       _gender;
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   void _clearSearch() {
//     setState(() {
//       searchController.clear();
//       Provider.of<PlacesProvider>(context, listen: false)
//           .clearPlaceSuggestions();
//       _DropController.clear();
//       _markerController.clear();
//       emailController.clear();
//     });
//   }
//
//   Future<void> _setMarkerIcon() async {
//     final markers = await _createMarkers();
//     setState(() {
//       markers;
//       _getPolyline();
//     });
//   }
//
//   void _showBottomSheet() {
//     String selectedOption = '';
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(1),
//                         bottomRight: Radius.circular(1),
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const SizedBox(height: 10),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedOption = 'Auto';
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: selectedOption == 'Auto'
//                                       ? Colors.pink
//                                       : Colors.white,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               child: const ListTile(
//                                 leading: Image(
//                                   image: AssetImage('assets/images/auto.png'),
//                                   width: 40,
//                                   height: 40,
//                                 ),
//                                 title: Text(
//                                   'Auto',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 trailing: Text(
//                                   '₹250',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedOption = 'Mini';
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: selectedOption == 'Mini'
//                                       ? Colors.pink
//                                       : Colors.white,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               child: const ListTile(
//                                 leading: Image(
//                                   image:
//                                   AssetImage('assets/images/ic_mini.png'),
//                                   width: 40,
//                                   height: 40,
//                                 ),
//                                 title: Text(
//                                   'Mini',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 trailing: Text(
//                                   '₹150',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedOption = 'Sedan';
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: selectedOption == 'Sedan'
//                                       ? Colors.pink
//                                       : Colors.white,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               child: const ListTile(
//                                 leading: Image(
//                                   image:
//                                   AssetImage('assets/images/ic_prime.png'),
//                                   width: 40,
//                                   height: 40,
//                                 ),
//                                 title: Text(
//                                   'Sedan',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 trailing: Text(
//                                   '₹450',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedOption = 'Compact SUV';
//                               });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: selectedOption == 'Compact SUV'
//                                       ? Colors.pink
//                                       : Colors.white,
//                                   width: 2,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12.0),
//                               ),
//                               child: const ListTile(
//                                 leading: Image(
//                                   image: AssetImage('assets/images/ic_suv.png'),
//                                   width: 40,
//                                   height: 40,
//                                 ),
//                                 title: Text(
//                                   'Compact SUV',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 trailing: Text(
//                                   '₹450',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (selectedOption.isNotEmpty) ...[
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(10),
//                           bottomRight: Radius.circular(10),
//                           topLeft: Radius.circular(1),
//                           topRight: Radius.circular(1),
//                         ),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 10,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: TextButton(
//                                     onPressed: () =>
//                                         _navigateAndSelectPayment(context),
//                                     // Handle cash payment logic here
//                                     style: TextButton.styleFrom(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Cash₹',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold),
//                                         ), // Ensure _gender is not null
//                                         const Icon(
//                                           Icons.arrow_forward_ios,
//                                           size: 16,
//                                           // Use 'size' instead of 'style' for font size
//                                           color: Colors
//                                               .black, // Set color directly
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Padding(
//                             padding: const EdgeInsets.all(5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     height: 60,
//                                     margin:
//                                     const EdgeInsets.symmetric(vertical: 1),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       gradient: const LinearGradient(
//                                         colors: [Colors.pink, Colors.purple],
//                                         begin: Alignment.centerLeft,
//                                         end: Alignment.centerRight,
//                                       ),
//                                     ),
//                                     child: TextButton(
//                                       onPressed: () {
//                                         final placesProvider = context.read<
//                                             PlacesProvider>(); // Correctly accessing the provider
//                                         _selectRideOption(selectedOption);
//                                         setState(() {
//                                           placesProvider.clearPickupLocation();
//                                           placesProvider.clearDropLocation();
//                                           placesProvider.clearMarkerLocation();
//                                         });
//                                       },
//                                       style: TextButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                           BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         "Book Ride",
//                                         style: TextStyle(
//                                           fontSize: 17,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _selectRideOption(String option) async {
//     Navigator.pop(context);
//     await _playGif();
//     await location();
//   }
//
//   Future<void> _playGif() async {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 55),
//               child: Container(
//                 height: 315,
//                 width: 400,
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: GifView.asset(
//                   'assets/images/car5.gif',
//                   height: 400,
//                   frameRate: 30,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//     await Future.delayed(const Duration(seconds: 5));
//     Navigator.pop(context);
//   }
//   Future<void> location() async {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.7,
//           maxChildSize: 0.7,
//           minChildSize: 0.7,
//           expand: false,
//           builder: (BuildContext context, ScrollController scrollController) {
//             return Padding(
//               padding: const EdgeInsets.all(15),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         color: Colors.grey[350],
//                         child: const SizedBox(
//                           height: 80,
//                           width: 400,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(width: 80),
//                               Text(
//                                 'PIN',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.black,
//                                   fontFamily: 'Arial',
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                 '6598',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontFamily: 'Arial',
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                 '|',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontFamily: 'Arial',
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                 'On the way',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.black,
//                                   fontFamily: 'Arial',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         color: Colors.white,
//                         elevation: 0.7,
//                         child: const SizedBox(
//                           height: 50,
//                           width: 400,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(width: 10),
//                               Text(
//                                 'TN 50 S 8684 -',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                   fontFamily: 'Arial',
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                 'Suzuki Swift (white)',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.black,
//                                   fontFamily: 'Arial',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Image.asset(
//                               'assets/images/user.png',
//                               alignment: Alignment.center,
//                               width: 80,
//                               height: 80,
//                             ),
//                             const SizedBox(width: 10),
//                             const Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Jayaprakash',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   Text(
//                                     'Total Trip driver: 5',
//                                     style: TextStyle(fontSize: 13),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10),
//                                     child: SizedBox(
//                                       height: 30,
//                                       width: 30,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           // Handle WhatsApp action
//                                         },
//                                         child: const Icon(
//                                           FontAwesomeIcons.whatsapp,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 10),
//                             const Row(
//                               children: [
//                                 Icon(Icons.location_on),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'Gandhipuram',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 const SizedBox(width: 3),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 1, horizontal: 10),
//                                   child: CustomPaint(
//                                     size: const Size(10, 20),
//                                     painter:
//                                     DottedLinePainter(isHorizontal: false),
//                                   ),
//                                 ),
//                                 const Expanded(
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 1, horizontal: 10),
//                                     child: Divider(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             const Row(
//                               children: [
//                                 Icon(Icons.location_on),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'Singanallur',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const Divider(),
//                             const Align(
//                               alignment: Alignment.centerRight,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.cancel_outlined),
//                                   SizedBox(width: 5),
//                                   // Adds space between the icon and the text
//                                   Text(
//                                     'cancel',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Text(
//                                   'Trip Fare ₹50',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Paid by',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 Text(
//                                   '10 km',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Payment Method',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Cash',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//     // Delay for demonstration purposes (replace with actual logic)
//     await Future.delayed(const Duration(seconds: 5));
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: const Text(
//             "Your ride has been successfully booked!",
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//             ),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 50,
//                   padding: const EdgeInsets.all(1),
//                   margin: const EdgeInsets.symmetric(vertical: 1),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: const LinearGradient(
//                       colors: [Colors.pink, Colors.purple],
//                     ),
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       _clearSearch();
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (context) => RatePage()),
//                             (Route<dynamic> route) => false,
//                       ); // Handle add address action
//                     },
//                     child: const Text(
//                       "ok",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Future<void> cash() async {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: true,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.8,
//           maxChildSize: 0.8,
//           minChildSize: 0.8,
//           expand: false,
//           builder: (BuildContext context, ScrollController scrollController) {
//             return Padding(
//               padding: const EdgeInsets.all(15),
//               child: SingleChildScrollView(
//                 controller: scrollController,
//                 child: Column(
//                   children: [
//                     _buildHeader(),
//                     Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Total Fare',
//                             // textAlign: TextAlign.start,
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             '₹59',
//                             // textAlign: TextAlign.start,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomPaint(
//                             size: const Size(50, 2),
//                             painter: DottedPainter(
//                               Horizontal: true,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         SizedBox(width: 10),
//                         Text(
//                           'Cash On Pay',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                             fontFamily: 'Arial',
//                           ),
//                         ),
//                       ],
//                     ),
//                     _buildOthersCard(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.pop(context); // Use Navigator.pop to go back
//             },
//             child: Icon(Icons.arrow_back),
//           ),
//           SizedBox(width: 10),
//           Text(
//             'Payments',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.black,
//               fontFamily: 'Arial',
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildOthersCard() {
//     return Padding(
//       padding: const EdgeInsets.all(5),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         color: Colors.white,
//         elevation: 0.6,
//         child: Column(
//           children: [
//             ListTile(
//               title: Text(
//                 'Cash',
//                 style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.black,
//                     fontFamily: 'Arial',
//                     fontWeight: FontWeight.bold),
//               ),
//               trailing: Radio<String>(
//                 value: 'cash₹',
//                 groupValue: _gender,
//                 onChanged: (value) {
//                   setState(() {
//                     _gender = value!;
//                   });
//                   Navigator.pop(context, _gender);
//                 },
//                 activeColor: Colors.pink,
//               ),
//             ),
//             Container(
//               height: 50.0,
//               margin: EdgeInsets.symmetric(vertical: 5.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 color: Colors.grey[300],
//                 child: ListTile(
//                   contentPadding:
//                   EdgeInsets.symmetric(horizontal: 1, vertical: 1),
//                   // Adjust padding
//                   title: Align(
//                     alignment: Alignment.topLeft,
//                     // Align the text to the top left
//                     child: Text(
//                       'You can Pay via cash or UPI for your ride',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontFamily: 'Arial',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     final markerIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(24, 24)), // Try reducing the size
//       'assets/icon/red.png',
//     );
//     setState(() {
//       markerLocation = LatLng(position.latitude, position.longitude);
//       _createMarkers(); // Call to update markers with the new location
//       markers.add(
//         Marker(
//           markerId: MarkerId('markerLocation'),
//           position: markerLocation,
//           icon: markerIcon,
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         final difference = DateTime.now().difference(timeBackPressed);
//         final isExitWarning = difference >= Duration(seconds: 2);
//         timeBackPressed = DateTime.now();
//         emailController.clear();
//         if (isExitWarning) {
//           warningShown = false;
//         }
//         if (!warningShown) {
//           warningShown = true;
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Press back again to exit'),
//             ),
//           );
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: <Widget>[
//             Consumer<PlacesProvider>(
//               builder: (context, placesProvider, child) {
//                 return GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: markerLocation ?? LatLng(0, 0),
//                     zoom: 15,
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     mapController = controller;
//                     mapLevelController = controller;
//                     mapMarkerController = controller;
//                   },
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                   tiltGesturesEnabled: true,
//                   compassEnabled: true,
//                   scrollGesturesEnabled: true,
//                   zoomGesturesEnabled: true,
//                   markers: markers,
//                   polylines: polylines,
//                   // onCameraMove: (CameraPosition position) {
//                   //   markerLocation = position.target;
//                   // },
//                 );
//               },
//             ),
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 30,
//               left: 8,
//               child: Builder(
//                 builder: (context) => Container(
//                   decoration: BoxDecoration(
//                     color: Colors.pink.shade900,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.menu),
//                     color: Colors.white,
//                     onPressed: () {
//                       Scaffold.of(context).openDrawer();
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 16,
//               right: 16,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Padding(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 16, vertical: 1),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Pickup at...',
//                             // textAlign: TextAlign.start,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 1, vertical: 1),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           buildPickupContainer(
//                             context,
//                             'Pickup at...',
//                             Icons.location_on,
//                             context.read<PlacesProvider>().pickupAddress,
//                             'pickup',
//                           ),
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: CustomPaint(
//                             size: const Size(10, 2),
//                             painter: DottedPainter(
//                               Horizontal: true,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 1),
//                     Row(
//                       children: [
//                         const SizedBox(width: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 1, horizontal: 10),
//                           child: Column(
//                             children: [
//                               CustomPaint(
//                                 size: const Size(10, 35),
//                                 painter: DottedLinePainter(isHorizontal: false),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 16, vertical: 1),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Drop at...',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 1, vertical: 1),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           buildDropContainer(
//                             context,
//                             '',
//                             Icons.location_on,
//                             context.read<PlacesProvider>().dropAddress,
//                             'drop',
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               height: 40,
//                               padding: const EdgeInsets.all(1),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 gradient: const LinearGradient(
//                                   colors: [Colors.pink, Colors.purple],
//                                 ),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//                                   final placesProvider =
//                                   context.read<PlacesProvider>();
//                                   final pickupLocation =
//                                       placesProvider.pickupLocation;
//                                   final dropLocation =
//                                       placesProvider.dropLocation;
//                                   final markerLocation =
//                                       placesProvider.markerLocation;
//                                   if (pickupLocation == markerLocation) {
//                                     if (dropLocation == null) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                               'Please select a drop location'),
//                                         ),
//                                       );
//                                       return;
//                                     }
//                                     _showBottomSheet();
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             'Pickup location and marker location must be the same'),
//                                       ),
//                                     );
//                                   }
//                                   if (pickupLocation == null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             'Please select a pickup location'),
//                                       ),
//                                     );
//                                     return;
//                                   }
//                                   _showBottomSheet();
//                                   if (dropLocation == null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             'Please select a drop location'),
//                                       ),
//                                     );
//                                     return;
//                                   }
//                                   _showBottomSheet();
//                                   _clearSearch();
//                                 },
//                                 child: const Text(
//                                   'Continue',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         drawer: Drawer(
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Image.asset(
//                               'assets/images/user.png',
//                               width: 80,
//                               height: 80,
//                             ),
//                           ],
//                         ),
//                         const Positioned(
//                           top: 15,
//                           right: 10,
//                           left: 90,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Raju',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               SizedBox(height: 4.0),
//                               Text(
//                                 '82204852148',
//                                 style: TextStyle(fontSize: 13),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (context) => ProfilePage(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.account_circle, color: Colors.pink),
//                             SizedBox(width: 8.0),
//                             Text('My Account',
//                               style: const TextStyle(color: Colors.black,),),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon( Icons.info, color: Colors.pink,),
//                             SizedBox(width: 8.0),
//                             Text('About'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.contact_phone, color: Colors.pink),
//                             SizedBox(width: 8.0),
//                             Text('Contact Us'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.share, color: Colors.pink),
//                             SizedBox(width: 8.0),
//                             Text('Share'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.privacy_tip, color: Colors.pink),
//                             SizedBox(width: 8.0),
//                             Text('Privacy Policy'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                       child: GestureDetector(
//                         onTap: () {
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Icon(Icons.article_outlined, color: Colors.pink),
//                             SizedBox(width: 8.0),
//                             Text('Terms and Conditions'),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Divider(), // Divider line added here
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 right: 10,
//                 left: 10,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         'Version 1.1',
//                         textAlign: TextAlign.end,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildPickupContainer(BuildContext context, String label, IconData icon, String? address, String type) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _searchType = type;
//         });
//         _clearSearch();
//         _showPickupLocationSearch(context);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(icon, color: Colors.black, size: 24.0),
//             const SizedBox(height: 1),
//             Expanded(
//               child: Text(
//                 address ?? '91, Civil Aerodrome Post, Opp...',
//                 style: const TextStyle(color: Colors.black),
//                 overflow: TextOverflow.ellipsis,
//                 // Handle long text
//               ),
//             ),
//             if (address != null)
//               IconButton(
//                 icon: const Icon(Icons.clear, color: Colors.black),
//                 onPressed: () {
//                   _clearSearch();
//                   if (type == 'pickup') {
//                     context
//                         .read<PlacesProvider>()
//                         .setPickupLocation(null, null);
//                   } else {
//                     context
//                         .read<PlacesProvider>()
//                         .setPickupLocation(null, null);
//                   }
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//   void _showPickupLocationSearch(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(10),
//           height: 600,
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Choose rider pickup location',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                         fontFamily: 'Arial',
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         _clearSearch();
//                         Navigator.of(context).pop();
//                       },
//                       icon: const Icon(
//                         Icons.clear,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         offset: Offset(0, 4),
//                         blurRadius: 10.0,
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search the location...',
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 10),
//                       suffixIcon: searchController.text.isNotEmpty
//                           ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           _clearSearch();
//                         },
//                       )
//                           : const Icon(Icons.search),
//                     ),
//                     onChanged: (value) {
//                       if (value.isNotEmpty) {
//                         Provider.of<PlacesProvider>(context, listen: false)
//                             .getPlaceSuggestions(value);
//                       }
//                       if (value.isNotEmpty) {
//                         Provider.of<PlacesProvider>(context, listen: false)
//                             .getMarkerPlaceSuggestions(value);
//                       } else {
//                         Provider.of<PlacesProvider>(context, listen: false)
//                             .clearPlaceSuggestions();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               Flexible(
//                 child: Consumer<PlacesProvider>(
//                   builder: (context, placesProvider, child) {
//                     if (searchController.text.isNotEmpty &&
//                         placesProvider.placeSuggestions.isNotEmpty) {
//                       return ListView.builder(
//                         itemCount: placesProvider.placeSuggestions.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(placesProvider.placeSuggestions[index]
//                             ['description']),
//                             onTap: () async {
//                               final details =
//                               await placesProvider.getPlaceDetails(
//                                   placesProvider.placeSuggestions[index]
//                                   ['place_id']);
//                               final latLng = details['latLng']!.split(',');
//                               final location = LatLng(double.parse(latLng[0]),
//                                   double.parse(latLng[1]));
//                               if (_searchType == 'pickup') {
//                                 placesProvider.setPickupLocation(
//                                     location, details['address']);
//                               } else if (_markerType == 'marker') {
//                                 placesProvider.setMarkerLocation(
//                                     location, details['address']);
//                               } else {
//                                 placesProvider.setPickupLocation(
//                                     location, details['address']);
//                               }
//                               Navigator.pop(context);
//                               _getPolyline();
//                             },
//                           );
//                         },
//                       );
//                     } else if (searchController.text.isEmpty) {
//                       return SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () async {
//                                         Navigator.of(context).pushNamed(
//                                           MapScreen.routeName,
//                                           arguments: 'pickup',
//                                         );
//                                         _getPolyline();
//                                       },
//                                       child: Container(
//                                         height: 60,
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                                 color: Colors.grey),
//                                             borderRadius:
//                                             BorderRadius.circular(25),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.location_pin,
//                                                     color: Colors.pink),
//                                                 SizedBox(width: 8),
//                                                 Text(
//                                                   'Choose on map',
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.black,
//                                                     fontFamily: 'Arial',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                             const AddressPage(),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         height: 60,
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                                 color: Colors.grey),
//                                             borderRadius:
//                                             BorderRadius.circular(25),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.location_pin,
//                                                     color: Colors.pink),
//                                                 SizedBox(width: 8),
//                                                 Text(
//                                                   'Save Address',
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.black,
//                                                     fontFamily: 'Arial',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       return Container(); // Hide suggestions when there's no text or no suggestions
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   Widget buildDropContainer(BuildContext context, String label, IconData icon, String? address, String type) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _clearSearch();
//           _searchDropType = type;
//         });
//         _clearSearch();
//         _showDropLocationSearch(context, 'drop');
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//         child: Column(
//           children: [
//             const SizedBox(height: 1),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(icon, color: Colors.black, size: 24.0),
//                 const SizedBox(width: 1), // Changed from height to width
//                 Expanded(
//                   child: Text(
//                     address ?? label,
//                     style: const TextStyle(color: Colors.black),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (address != null)
//                   IconButton(
//                     icon: const Icon(Icons.clear, color: Colors.black),
//                     onPressed: () {
//                       _clearSearch();
//                       context
//                           .read<PlacesProvider>()
//                           .setDropLocation(null, null);
//                     },
//                   ),
//               ],
//             ),
//             Row(
//               children: [
//                 const SizedBox(width: 20),
//                 Expanded(
//                   child: CustomPaint(
//                     size: const Size(double.infinity, 2),
//                     painter: ThirdPainter(horizontal: true),
//                   ),
//                 ),
//               ],
//             ),
//             if (address != null)
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
//                 child: Consumer<PlacesProvider>(
//                   builder: (context, placesProvider, child) {
//                     final LatLng? pickupLocation =
//                         placesProvider.pickupLocation;
//                     final LatLng? dropLocation = placesProvider.dropLocation;
//                     if (pickupLocation != null && dropLocation != null) {
//                       return FutureBuilder<Map<String, String>>(
//                         future: placesProvider.getDirections(
//                             pickupLocation, dropLocation, markerLocation),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                           } else if (snapshot.connectionState ==
//                               ConnectionState.done) {
//                             if (snapshot.hasData) {
//                               final data = snapshot.data!;
//                               return Text(
//                                 'Distance: ${data['distance']}, Duration: ${data['duration']}',
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.pink),
//                               );
//                             } else if (snapshot.hasError) {
//                               return const Text('Error fetching data',
//                                   style: TextStyle(color: Colors.red));
//                             }
//                           }
//                           return const SizedBox.shrink();
//                         },
//                       );
//                     } else if (dropLocation != null && markerLocation != null) {
//                       return FutureBuilder<Map<String, String>>(
//                         future: placesProvider.getDirections(
//                             dropLocation, markerLocation, dropLocation),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                           } else if (snapshot.connectionState ==
//                               ConnectionState.done) {
//                             if (snapshot.hasData) {
//                               final data = snapshot.data!;
//                               return Text(
//                                 'Distance: ${data['distance']}, Duration: ${data['duration']}',
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.pink),
//                               );
//                             } else if (snapshot.hasError) {
//                               return const Text('Error fetching data',
//                                   style: TextStyle(color: Colors.red));
//                             }
//                           }
//                           return const SizedBox.shrink();
//                         },
//                       );
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//   void _showDropLocationSearch(BuildContext context, String type) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(10),
//           height: 600,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Choose rider drop location',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                         fontFamily: 'Arial',
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       icon: const Icon(
//                         Icons.clear,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         offset: Offset(0, 4),
//                         blurRadius: 10.0,
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _DropController,
//                     decoration: InputDecoration(
//                       hintText: 'Search the location...',
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 15.0, vertical: 15.0),
//                       suffixIcon: _DropController.text.isNotEmpty
//                           ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           _DropController.clear();
//                           Provider.of<PlacesProvider>(context,
//                               listen: false)
//                               .clearPlaceSuggestions();
//                         },
//                       )
//                           : const Icon(Icons.search),
//                     ),
//                     onChanged: (value) {
//                       final text = _DropController.text;
//                       if (text.isNotEmpty) {
//                         Provider.of<PlacesProvider>(context, listen: false)
//                             .getDropPlaceSuggestions(value);
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               Flexible(
//                 child: Consumer<PlacesProvider>(
//                   builder: (context, placesProvider, child) {
//                     if (_DropController.text.isNotEmpty &&
//                         placesProvider.dropSuggestions.isNotEmpty) {
//                       return ListView.builder(
//                         itemCount: placesProvider.dropSuggestions.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(placesProvider.dropSuggestions[index]
//                             ['description']),
//                             onTap: () async {
//                               final details =
//                               await placesProvider.getDropPlaceDetails(
//                                   placesProvider.dropSuggestions[index]
//                                   ['place_id']);
//                               final latLng = details['latLng']!.split(',');
//                               final location = LatLng(double.parse(latLng[0]),
//                                   double.parse(latLng[1]));
//                               if (_searchDropType == 'drop') {
//                                 placesProvider.setDropLocation(
//                                     location, details['address']);
//                               } else if (_markerType == 'marker') {
//                                 placesProvider.setMarkerLocation(
//                                     location, details['address']);
//                               } else {
//                                 placesProvider.setDropLocation(
//                                     location, details['address']);
//                               }
//                               Navigator.pop(context);
//                               _getPolyline();
//                             },
//                           );
//                         },
//                       );
//                     } else if (_DropController.text.isEmpty) {
//                       return SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 20),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       // onTap: () {
//                                       //   Navigator.of(context).pushReplacement(
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) => const MapScreen()),
//                                       //   ); // Handle add address action
//                                       // },
//                                       onTap: () async {
//                                         // print('drop Map$type');
//                                         Navigator.of(context).pushNamed(
//                                           MapScreen.routeName,
//                                           arguments: 'drop',
//                                         );
//                                         _getPolyline();
//                                       },
//                                       child: Container(
//                                         height: 60,
//                                         // Set the desired height here
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                                 color: Colors.grey),
//                                             borderRadius:
//                                             BorderRadius.circular(25),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.location_pin,
//                                                     color: Colors.pink),
//                                                 SizedBox(width: 8),
//                                                 Text(
//                                                   'Choose on map',
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.black,
//                                                     fontFamily: 'Arial',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                             const AddressPage(),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         height: 60,
//                                         // Set the desired height here
//                                         child: Card(
//                                           shape: RoundedRectangleBorder(
//                                             side: const BorderSide(
//                                                 color: Colors.grey),
//                                             borderRadius:
//                                             BorderRadius.circular(25),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Row(
//                                               children: [
//                                                 Icon(Icons.location_pin,
//                                                     color: Colors.pink),
//                                                 SizedBox(width: 8),
//                                                 Text(
//                                                   'Save Address',
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.black,
//                                                     fontFamily: 'Arial',
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     } else {
//                       return Container(); // Hide suggestions when there's no text or no suggestions
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   Future<void> _createMarkers() async {
//     final placesProvider = Provider.of<PlacesProvider>(context, listen: false);
//     final markers = <Marker>{};
//     if (placesProvider.pickupLocation != null) {
//       final pickupMarker = Marker(
//         markerId: const MarkerId('pickup'),
//         position: placesProvider.pickupLocation!,
//         infoWindow: InfoWindow(
//           title: 'Pickup Location',
//           snippet: placesProvider.pickupAddress ?? '',
//         ),
//         icon: await BitmapDescriptor.fromAssetImage(
//           const ImageConfiguration(size: Size(48, 48)),
//           'assets/icon/red.png',
//         ),
//       );
//       mapLevelController?.animateCamera(
//         CameraUpdate.newLatLngZoom(
//             placesProvider.pickupLocation!, 13), // Adjust padding as needed
//       );
//       markers.add(pickupMarker);
//     }
//     if (placesProvider.dropLocation != null) {
//       final dropMarker = Marker(
//         markerId: const MarkerId('drop'),
//         position: placesProvider.dropLocation!,
//         infoWindow: InfoWindow(
//           title: 'Drop Location',
//           snippet: placesProvider.dropAddress ?? '',
//         ),
//         icon: await BitmapDescriptor.fromAssetImage(
//           const ImageConfiguration(size: Size(48, 48)),
//           'assets/icon/green.png',
//         ),
//       );
//       mapMarkerController?.animateCamera(
//         CameraUpdate.newLatLngZoom(
//             placesProvider.dropLocation!, 13), // Adjust padding as needed
//       );
//       markers.add(dropMarker);
//     }
//     if (placesProvider.pickupLocation == null &&
//         placesProvider.dropLocation != null &&
//         markerLocation != null) {
//       final currentLocationMarker = Marker(
//         markerId: const MarkerId('currentLocation'),
//         position: markerLocation,
//         infoWindow: const InfoWindow(
//           title: 'Current Location',
//         ),
//         icon: await BitmapDescriptor.fromAssetImage(
//           const ImageConfiguration(size: Size(48, 48)),
//           'assets/icon/red.png',
//         ),
//       );
//       mapLevelController?.animateCamera(
//         CameraUpdate.newLatLngZoom(
//             placesProvider.markerLocation!, 13), // Adjust padding as needed
//       );
//       markers.add(currentLocationMarker);
//     }
//     setState(() {
//       this.markers.clear(); // Clear existing markers
//       this.markers.addAll(markers); // Add the new set of markers
//     });
//   }
//   void _addPolyLine() {
//     PolylineId id = const PolylineId("poly");
//     int pointCount = (_animationValue * polylineCoordinates.length).round();
//     List<LatLng> animatedPoints = polylineCoordinates.take(pointCount).toList();
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.black,
//       points: animatedPoints,
//       width: 2,
//     );
//     setState(() {
//       polylines.add(polyline);
//     });
//     _createMarkers();
//     _animationController.forward(from: 0); // Start from 0 for the animation
//   }
//   Future<void> _getPolyline() async {
//     final placesProvider = Provider.of<PlacesProvider>(context, listen: false);
//     final pickupLocation = placesProvider.pickupLocation ?? markerLocation;
//     if (placesProvider.dropLocation != null) {
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: googleApiKey,
//         request: PolylineRequest(
//           origin: PointLatLng(
//             pickupLocation.latitude,
//             pickupLocation.longitude,
//           ),
//           destination: PointLatLng(
//             placesProvider.dropLocation!.latitude,
//             placesProvider.dropLocation!.longitude,
//           ),
//           mode: TravelMode.driving,
//         ),
//       );
//       if (result.points.isNotEmpty) {
//         setState(() {
//           polylineCoordinates.clear();
//           result.points.forEach((PointLatLng point) {
//             polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//           });
//         });
//         _addPolyLine();
//       }
//     }
//   }
// }
//
// class DottedLinePainter extends CustomPainter {
//   final bool isHorizontal;
//
//   DottedLinePainter({this.isHorizontal = true});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     double dashWidth = 4, dashSpace = 4, startX = 0, startY = 0;
//     if (isHorizontal) {
//       while (startX < size.width) {
//         canvas.drawLine(
//             Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
//         startX += dashWidth + dashSpace;
//       }
//     } else {
//       while (startY < size.height) {
//         canvas.drawLine(
//             Offset(0, startY), Offset(0, startY + dashWidth), paint);
//         startY += dashWidth + dashSpace;
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class DottedPainter extends CustomPainter {
//   final bool Horizontal;
//
//   DottedPainter({this.Horizontal = true});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.pink
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     double dashWidth = 4, dashSpace = 4, startX = 0, startY = 0;
//     if (Horizontal) {
//       while (startX < size.width) {
//         canvas.drawLine(
//             Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
//         startX += dashWidth + dashSpace;
//       }
//     } else {
//       while (startY < size.height) {
//         canvas.drawLine(
//             Offset(0, startY), Offset(0, startY + dashWidth), paint);
//         startY += dashWidth + dashSpace;
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class ThirdPainter extends CustomPainter {
//   final bool horizontal;
//
//   ThirdPainter({this.horizontal = true});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.pink
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     double dashWidth = 4, dashSpace = 4, startX = 0, startY = 0;
//     if (horizontal) {
//       while (startX < size.width) {
//         canvas.drawLine(
//             Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
//         startX += dashWidth + dashSpace;
//       }
//     } else {
//       while (startY < size.height) {
//         canvas.drawLine(
//             Offset(0, startY), Offset(0, startY + dashWidth), paint);
//         startY += dashWidth + dashSpace;
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
