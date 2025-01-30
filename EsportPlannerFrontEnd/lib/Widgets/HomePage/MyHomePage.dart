import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Stelle sicher, dass du das benötigte Paket importierst
import '../Objects/user_model.dart';
import '/Data/Loader.dart';
import '/Widgets/Objects/TeamInfo.dart';
import '/Loging/LoginScreen.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //variables
  int _counter = 0;
  String id = '';
  List<TeamInfo> _teamInfos = [];
  ScrollController _sscrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchTeamInfosLoL();
  }

//Get the upcoming matches from the backend
  Future<void> fetchTeamInfosLoL() async {
    List<TeamInfo> teamInfos = [];
    final id = Provider.of<UserModel>(context, listen: false).id;
    teamInfos = await loader.fetchTeamInfosLoL(id);
    print("++++++" + id); // ID des Benutzers übergeben

    setState(() {
      _teamInfos = teamInfos;
    });
    _scrollToTop();
  }

 void _scrollToTop() {
    _sscrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

//Build the Homepage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
              color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: buildTeamInfoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchTeamInfosLoL,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () {
                Navigator.pushNamed(context, '/statistik');
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.pushNamed(context, '/calender');
              },
            ),
          ],
        ),
      ),
    );
  }

Widget buildTeamInfoList() {
  if (_teamInfos.isEmpty) {
    return Center(
      child: CircularProgressIndicator(),
    );
  } else {
    return ListView.builder(
      controller: _sscrollController,
      itemCount: _teamInfos.length,
      itemBuilder: (context, index) {
        final teamInfo = _teamInfos[index];
        return Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the entire card
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30), // Space for the image
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0), // Padding around the text
                          child: Text(
                            '${teamInfo.name}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Space between the row and the rest of the content
                      Padding(
                        padding: const EdgeInsets.all(16.0), // Padding around the entire row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                if (teamInfo.opponent1url != 'Unknown')
                                  Image.network(
                                    teamInfo.opponent1url,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  Container(
                                    height: 80,
                                    width: 80,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '?',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 4),
                                if (teamInfo.opponent1 != 'Unknown')
                                  Text(
                                    teamInfo.opponent_short1,
                                    style: TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                            SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding around the "vs" text
                              child: Text(
                                'vs',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              children: [
                                if (teamInfo.opponent2url != 'Unknown')
                                  Image.network(
                                    teamInfo.opponent2url,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  Container(
                                    height: 80,
                                    width: 80,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '?',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 4),
                                if (teamInfo.opponent2 != 'Unknown')
                                  Text(
                                    teamInfo.opponent_short2,
                                    style: TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 16.0),
                          SizedBox(width: 4.0),
                          Text('${teamInfo.date}'),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 16.0),
                          SizedBox(width: 4.0),
                          Text('${teamInfo.time}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (teamInfo.videoGame == 'LoL')
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/lol_logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (teamInfo.videoGame == 'Valorant')
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/valo_logo.webp',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

}
