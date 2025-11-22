import 'package:citations/data/models/citation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class IHomeViewModel extends ChangeNotifier {
  Future<List<Citation>> get citations;
  Future<bool> firstOpening();
}

class HomeScreen extends StatefulWidget {
  final IHomeViewModel _viewModel;
  const HomeScreen(this._viewModel, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showOverlay = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          widget._viewModel.citations,
          widget._viewModel.firstOpening(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Une erreur est survenue"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("aucune citation disponible"));
          }

          final List<Citation> citations = snapshot.data![0];
          bool isFirstOpening = snapshot.data![1];
          citations.shuffle();
          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: citations.length,
                itemBuilder: (context, index) {
                  Citation currentCitation = citations[index];
                  return Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentCitation.citation,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "${currentCitation.author} - ${currentCitation.source}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 18,
                    left: 18,
                    bottom: 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: Center(
                          child: Text(
                            "Citations",
                            style: GoogleFonts.acme(
                              fontSize: 30,
                              color: Color(0xff1a759f),
                            ),
                          ),
                        ),
                      ),
                      Row(children: [Spacer()]),
                    ],
                  ),
                ),
              ),
              if (isFirstOpening && _showOverlay)
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _showOverlay = false;
                    });
                  },

                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Bienvenu sur L'application Citations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "MomoSignature-Regular",
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),

                        Column(
                          children: [
                            Text(
                              "Défilez vers le haut pour voir d'autres citations",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "MomoSignature-Regular",
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 12),
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
