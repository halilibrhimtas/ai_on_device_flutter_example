import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediapipe_genai/mediapipe_genai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
//const String gpuUri = String.fromEnvironment('GEMMA_8B_GPU_URI');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    //bool isGpu = true;
    /*
    LlmInferenceOptions.cpu(
      modelPath: modelPath,
      maxTokens: 512,
      topK: 40,
      temperature: 0.8,
      randomSeed: 0,
      cacheDir: "logs",
    );
    */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_generateResponse();
      generateWithTflite();
    });
  }
  /*

  Future<void> _generateResponse() async {

    final byteData = await rootBundle.load("assets/models/test_model.bin");
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/test_model.bin');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());    

    final options = LlmInferenceOptions.gpu(
      modelPath: tempFile.path,
      maxTokens: 1000,
      topK: 40,
      temperature: 0.8,
      randomSeed: 101,
      sequenceBatchSize: 5,
    );
    // Create an inference engine
    LlmInferenceEngine engine = LlmInferenceEngine(options);


    final Stream<String> responseStream =
        engine.generateResponse('Hello, world!');
    await for (final String responseChunk in responseStream) {
      print('The LLM said: $responseChunk');
    }
  }
  */

  Future<void> generateWithTflite() async {
    final interpreter = await Interpreter.fromAsset('assets/models/modelc2f.tflite');
    final input = [[15]];
    final output = List<double>.filled(1, 0).reshape([1, 1]);

    interpreter.run(input, output);
    print("Tflite - generated value: $output");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
