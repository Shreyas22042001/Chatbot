import 'package:flutter/material.dart';
import 'watson_assistant_v2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Watson Assistant Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _text;
  WatsonAssistantV2Credential credential = WatsonAssistantV2Credential(
    version: '2021-06-14',
    username: 'apikey',
    apikey: 'pdeWubIM4HumAWX5W_eCvqMhlstBGRjaBUlTMIWMJSxp',
    assistantID: '42a5c583-2e7a-4d7d-b346-96c4a9c09545',
    url:
        'https://api.eu-gb.assistant.watson.cloud.ibm.com/instances/321bed7c-2653-421d-aff9-1589deae4fc5/v2',
  );

  late WatsonAssistantApiV2 watsonAssistant;
  late WatsonAssistantResponse watsonAssistantResponse;
  WatsonAssistantContext watsonAssistantContext =
      WatsonAssistantContext(context: {});

  final myController = TextEditingController();

  //_MyHomePageState(this._text);

  void _callWatsonAssistant() async {
    watsonAssistantResponse = (await watsonAssistant.sendMessage(
        myController.text, watsonAssistantContext))!;
    setState(() {
      _text = watsonAssistantResponse.resultText;
    });
    watsonAssistantContext = watsonAssistantResponse.context;
    myController.clear();
  }

  @override
  void initState() {
    super.initState();
    watsonAssistant =
        WatsonAssistantApiV2(watsonAssistantCredential: credential);
    _callWatsonAssistant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watson_Assistant_V2'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.restore,
            ),
            onPressed: () {
              watsonAssistantContext.resetContext();
              setState(() {
                _text = "";
              });
            },
          )
        ],
      ),
      body: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Your Input to the chatbot',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                _text != null ? '$_text' : 'Watson Response Here',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _callWatsonAssistant,
        child: Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}
