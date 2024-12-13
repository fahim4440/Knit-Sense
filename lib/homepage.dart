import 'package:flutter/material.dart';
import 'api_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  final TextEditingController gsmController = TextEditingController();
  final TextEditingController cottonController = TextEditingController();
  final TextEditingController polyesterController = TextEditingController();
  final TextEditingController elastaneController = TextEditingController();

  Map<String, dynamic> result = {};
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  final ApiService apiService = ApiService(baseUrl: 'https://fleece-ai.onrender.com');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void predict() async {
    setState(() {
      isLoading = true;
      result = {};
    });

    try {
      final predictions = await apiService.predictYarn(
        gsm: double.parse(gsmController.text),
        cotton: double.parse(cottonController.text),
        polyester: double.parse(polyesterController.text),
        elastane: double.parse(elastaneController.text),
      );

      setState(() {
        result = predictions;
        _controller.forward(); // Trigger fade-in animation for the result
      });
    } catch (e) {
      setState(() {
        result = {"error": e.toString()};
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatYarnCount(double value) {
    return value.toInt().toString(); // Convert to integer
  }

  String formatYarnSL(double value) {
    return value.toStringAsFixed(2); // Format to 2 decimal places
  }

  Widget buildInputField({required String label, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Knit Sense"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SelectableText(
              "Predict Fleece Knit Specs",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            SelectableText(
              "Enter the fabric details.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            buildInputField(label: "GSM", controller: gsmController),
            const SizedBox(height: 10),
            buildInputField(label: "Cotton (%)", controller: cottonController),
            const SizedBox(height: 10),
            buildInputField(label: "Polyester (%)", controller: polyesterController),
            const SizedBox(height: 10),
            buildInputField(label: "Elastane (%)", controller: elastaneController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: predict,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blueAccent,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Predict"),
              ),
            ),
            const SizedBox(height: 20),
            if (result.isNotEmpty)
              FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: result.containsKey("error")
                      ? Text(
                    "Error: ${result["error"]}",
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Knit Yarn Count: ${formatYarnCount(result['regression']['knit_yarn_count'])}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Knit Yarn SL: ${formatYarnSL(result['regression']['knit_sl'])}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Binder Yarn Count: ${formatYarnCount(result['regression']['binder_yarn_count'])}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Binder Yarn SL: ${formatYarnSL(result['regression']['binder_sl'])}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Loop Yarn Count: ${formatYarnCount(result['regression']['loop_yarn_count'])}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Loop Yarn SL: ${formatYarnSL(result['regression']['loop_sl'])}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            // FadeTransition(
            //   opacity: _opacityAnimation,
            //   child: result.isNotEmpty
            //       ? Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[200],
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: Colors.grey[300]!),
            //     ),
            //     child: SelectableText(
            //       result,
            //       style: const TextStyle(fontSize: 16, color: Colors.black),
            //     ),
            //   )
            //       : const SizedBox.shrink(),
            // ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'api_service.dart';
//
// class Homepage extends StatefulWidget {
//   const Homepage({super.key});
//
//   @override
//   HomepageState createState() => HomepageState();
// }
//
// class HomepageState extends State<Homepage> {
//   final TextEditingController gsmController = TextEditingController();
//   final TextEditingController cottonController = TextEditingController();
//   final TextEditingController polyesterController = TextEditingController();
//   final TextEditingController elastaneController = TextEditingController();
//
//   String result = '';
//   bool isLoading = false;
//
//   final ApiService apiService = ApiService(baseUrl: 'https://fleece-ai.onrender.com');
//
//   void predict() async {
//     setState(() {
//       isLoading = true;
//       result = '';
//     });
//
//     try {
//       final predictions = await apiService.predictYarn(
//         gsm: double.parse(gsmController.text),
//         cotton: double.parse(cottonController.text),
//         polyester: double.parse(polyesterController.text),
//         elastane: double.parse(elastaneController.text),
//       );
//
//       setState(() {
//         result = predictions.toString();
//       });
//     } catch (e) {
//       setState(() {
//         result = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Knit Sense"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SelectableText(
//               "Fleece Knit Predictor",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueAccent,
//               ),
//             ),
//             const SizedBox(height: 10),
//             SelectableText(
//               "Enter the fabric details to predict knit specs.",
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: gsmController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "GSM",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: cottonController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Cotton (%)",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: polyesterController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Polyester (%)",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: elastaneController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Elastane (%)",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: predict,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(
//                   color: Colors.white,
//                 )
//                     : const SelectableText("Predict"),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (result.isNotEmpty)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: SelectableText(
//                   result,
//                   style: const TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
