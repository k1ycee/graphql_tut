import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mutations/widgets/button.dart';
import 'package:mutations/widgets/text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httplink =
        HttpLink(uri: "https://graphqlzero.almansi.me/api");

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httplink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GraphQLProvider(child: InitialPage(), client: client),
    );
  }
}

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String mutation = """
mutation makeAlbum(\$title: String!, \$userId: ID!){
  createAlbum(input:{
    title: \$title,
    userId: \$userId
  }){
    id,
    title,
    user{
      name
      username
    }
  }
}
""";

  TextEditingController titleController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(mutation),
        ),
        builder: (runMutation, result) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFields(
                controller: titleController,
                hint: "Title",
                underlineBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.greenAccent[700],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFields(
                controller: idController,
                hint: "Id",
                underlineBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.greenAccent[700],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthButton(
                  buttonColor: Colors.greenAccent[700],
                  name: Text(
                    "Post",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  tap: () {
                    runMutation(
                      {
                        "title": titleController.text,
                        "userId": int.parse(idController.text)
                      },
                    );
                  },
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.width / 3,
                ),
              ],
            ),
            Text(
              result.data == null ? "expecting" : result.data.data.toString(),
            )
          ],
        ),
      ),
    );
  }
}
