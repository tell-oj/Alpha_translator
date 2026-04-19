import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AlphaTranslatorApp());
}

class AlphaTranslatorApp extends StatelessWidget {
  const AlphaTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Translator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1A237E),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AlphaTranslator(),
    );
  }
}

class AlphaTranslator extends StatefulWidget {
  const AlphaTranslator({super.key});

  @override
  State<AlphaTranslator> createState() => _AlphaTranslatorState();
}

class _AlphaTranslatorState extends State<AlphaTranslator> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";
  String _inputLang = "Français";
  String _outputLang = "Morse";

  final List<String> _languages = ["Français", "International", "Morse"];

  final Map<String, String> _alphaMap = {
    'A': 'Alpha', 'B': 'Bravo', 'C': 'Charlie', 'D': 'Delta', 'E': 'Echo',
    'F': 'Foxtrot', 'G': 'Golf', 'H': 'Hotel', 'I': 'India', 'J': 'Juliet',
    'K': 'Kilo', 'L': 'Lima', 'M': 'Mike', 'N': 'November', 'O': 'Oscar',
    'P': 'Papa', 'Q': 'Quebec', 'R': 'Romeo', 'S': 'Sierra', 'T': 'Tango',
    'U': 'Uniform', 'V': 'Victor', 'W': 'Whiskey', 'X': 'X-ray', 'Y': 'Yankee',
    'Z': 'Zulu', '0': 'Zero', '1': 'One', '2': 'Two', '3': 'Three', '4': 'Four',
    '5': 'Five', '6': 'Six', '7': 'Seven', '8': 'Eight', '9': 'Nine', ' ': '/',
  };

  final Map<String, String> _morseMap = {
    'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.',
    'G': '--.', 'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
    'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
    'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
    'Y': '-.--', 'Z': '--..', '1': '.----', '2': '..---', '3': '...--',
    '4': '....-', '5': '.....', '6': '-....', '7': '--...', '8': '---..',
    '9': '----.', '0': '-----', ' ': '/',
  };

  void _translate(String text) {
    if (text.isEmpty) {
      setState(() => _result = "");
      return;
    }
    String cleanInput = text.trim().toUpperCase();
    String midText = "";

    // DECODAGE
    if (_inputLang == "Français") {
      midText = cleanInput;
    }
    else if (_inputLang == "International") {
      var rev = _alphaMap.map((k, v) => MapEntry(v.toUpperCase(), k));
      midText = cleanInput.split(' ').map((w) {
        if (rev.containsKey(w)) return rev[w];
        if (w == "/" || w == "|" || w == "-") return " ";
        return "";
      }).join('');
    }
    else if (_inputLang == "Morse") {
      var rev = _morseMap.map((k, v) => MapEntry(v, k));
      midText = cleanInput.split(' ').map((w) {
        if (rev.containsKey(w)) return rev[w];
        if (w == "/" || w == "|" || w == "-") return " ";
        return "";
      }).join('');
    }

    // ENCODAGE
    setState(() {
      if (_outputLang == "Français") {
        _result = midText;
      } else if (_outputLang == "International") {
        _result = midText.split('').map((c) => _alphaMap[c] ?? c).join(' ');
      } else if (_outputLang == "Morse") {
        _result = midText.split('').map((c) => _morseMap[c] ?? '').join(' ');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ALPHA TRANSLATOR",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildLangSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInputArea(),
                  const SizedBox(height: 25),
                  _buildOutputArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangSelector() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _dropdown(_inputLang, true),
          // BOUTON DE SWAP REPARÉ
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF1A237E), size: 30),
            onPressed: () {
              setState(() {
                String temp = _inputLang;
                _inputLang = _outputLang;
                _outputLang = temp;
                _translate(_controller.text);
              });
            },
          ),
          _dropdown(_outputLang, false),
        ],
      ),
    );
  }

  Widget _dropdown(String current, bool isInput) {
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() {
        if (isInput) _inputLang = v; else _outputLang = v;
        _translate(_controller.text);
      }),
      itemBuilder: (ctx) => _languages.map((l) => PopupMenuItem(value: l, child: Text(l))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
        child: Text(current, style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _controller,
        maxLines: 5,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          hintText: "Entrez votre message...",
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear_rounded, color: Colors.grey),
            onPressed: () { _controller.clear(); _translate(""); },
          ),
        ),
        onChanged: _translate,
      ),
    );
  }

  Widget _buildOutputArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_outputLang.toUpperCase(), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_all_rounded, color: Colors.white70),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _result));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copié !")));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white70),
                    onPressed: () {
                      if (_result.isNotEmpty) {
                        Share.share(_result);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          SelectableText(_result, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}