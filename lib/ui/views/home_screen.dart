import 'package:citations/data/models/citation.dart';
import 'package:flutter/material.dart';

abstract class IHomeViewModel extends ChangeNotifier {
  Future<List<Citation>> get citations;
}

class HomeScreen extends StatelessWidget {
  final IHomeViewModel _viewModel;
  const HomeScreen(this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _viewModel.citations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Une erreur est survenue"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("aucune citation disponible"));
          }

          List<Citation> citations = snapshot.data!;

          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: citations.length,
                itemBuilder: (context, index) {
                  Citation currentCitation = citations[index];
                  return Container(
                    color: Colors.grey,

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
                      Container(color: Colors.amber, height: 20, width: 200),
                      Row(
                        children: [
                          Spacer(),
                          FloatingActionButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.airline_seat_legroom_normal_sharp,
                            ),
                          ),
                          SizedBox(width: 12),
                          FloatingActionButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.airline_seat_legroom_normal_sharp,
                            ),
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
