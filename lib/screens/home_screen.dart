import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController userPrompt = TextEditingController();

  String? apiResponse = "";
  
  List chats = [];

  void askGemini()async{
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyAivPvYu4oOOxeQK1dWHiejgfKqKaS2SP0',
    );

    final prompt = userPrompt.text;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    chats.add({"message" : userPrompt.text, "isUser" : true});
    chats.add({"message": response.text, "isUser": false});
    setState(() {
      apiResponse = response.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Column(
        children: [
          
          Expanded(child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
            return Align(
              alignment: chats[index]["isUser"] ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: chats[index]["isUser"] ? Colors.blue : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(14)
                ),
                child: Text(chats[index]["message"],style: TextStyle(color: chats[index]["isUser"] ? Colors.white : Colors.black),),
              ),
            );
          },)),
          
          
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: userPrompt,
              decoration: const InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
          ),
      
          const SizedBox(
            height: 10,
          ),
      
          ElevatedButton(onPressed: (){
            askGemini();
          }, child: const Text("Generate"))
        ],
      ),
    );
  }
}
