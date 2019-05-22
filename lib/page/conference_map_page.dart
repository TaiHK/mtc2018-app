import "package:flutter_web/material.dart";
import "package:mtc2018_app/colors.dart";
import "package:mtc2018_app/localize.dart";
import "package:mtc2018_app/model/exhibition.dart";
import "package:mtc2018_app/repository/repository.dart";

class ConferenceMapPage extends StatefulWidget {
  final Repository repository;

  const ConferenceMapPage({Key key, this.repository}) : super(key: key);

  @override
  _ConferenceMapPageState createState() => _ConferenceMapPageState();
}

class _ConferenceMapPageState extends State<ConferenceMapPage> {
  List<Exhibition> _exhibitionList = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final exhibitionList = await widget.repository.getExhibitionList();
    setState(() {
      _exhibitionList = exhibitionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_exhibitionList.length == 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Map"),
            centerTitle: false,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    }

    var boothAExhibitions = _exhibitionList.where((e) => e.place == "BoothA");
    var boothBExhibitions = _exhibitionList.where((e) => e.place == "BoothB");

    var boothIndex = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text("Map"),
          centerTitle: false,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
            child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(color: Colors.white),
                      flexibleSpace: SafeArea(
                          child: TabBar(
                        tabs: [
                          Tab(text: "ALL"),
                          Tab(text: "BOOTH A"),
                          Tab(text: "BOOTH B")
                        ],
                        labelColor: kMtcSecondaryRed,
                        indicatorColor: kMtcSecondaryRed,
                        unselectedLabelColor: Colors.white,
                        indicatorWeight: 4.0,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                  body: TabBarView(
                    children: [
                      Container(
                          color: Colors.white,
                          child:
                              ListView(padding: EdgeInsets.all(8.0), children: [
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 32.0),
                              child: Image.asset("images/tab_all.png"),
                            )
                          ])),
                      Container(
                          color: Colors.white,
                          child:
                              ListView(padding: EdgeInsets.all(8.0), children: [
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 32.0),
                              child: Image.asset("images/booth_a.png"),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: kMtcAboutSectionBackgroundGrey,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Container(
                                padding: EdgeInsets.all(24.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        boothAExhibitions.map((exhibition) {
                                      boothIndex += 1;
                                      return _buildExhibitionInfo(
                                          context, boothIndex, exhibition);
                                    }).toList()),
                              ),
                            ),
                            Container(height: 60.0)
                          ])),
                      Container(
                          color: Colors.white,
                          child:
                              ListView(padding: EdgeInsets.all(8.0), children: [
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 32.0),
                              child: Image.asset("images/booth_b.png"),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: kMtcAboutSectionBackgroundGrey,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Container(
                                  padding: EdgeInsets.all(24.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          boothBExhibitions.map((exhibition) {
                                        boothIndex += 1;
                                        return _buildExhibitionInfo(
                                            context, boothIndex, exhibition);
                                      }).toList()),
                                )),
                            Container(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 16.0),
                                child: Text(
                                    MtcLocalizations.of(context)
                                        .askTheSpeakerTitle,
                                    style: TextStyle(
                                        color: kMtcPrimaryGrey,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                            Container(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 60.0),
                                child: Text(
                                    MtcLocalizations.of(context)
                                        .askTheSpeakerDescription,
                                    style: TextStyle(
                                        color: kMtcPrimaryGrey,
                                        fontSize: 14.0))),
                          ])),
                    ],
                  ),
                ))));
  }

  Widget _buildExhibitionInfo(
      BuildContext context, int index, Exhibition exhibition) {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(right: 12.0),
                child: Text("$index. ",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: kMtcPrimaryGrey,
                        fontWeight: FontWeight.bold))),
            Flexible(
                child: Text(
                    exhibition.localizedTitle(getCurrentLanguageCode(context)),
                    style: TextStyle(color: kMtcPrimaryGrey, fontSize: 14.0)))
          ],
        ));
  }
}
