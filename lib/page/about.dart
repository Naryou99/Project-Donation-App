import 'package:agile02/page/login.dart';
import 'package:agile02/page/pay.dart';
import 'package:agile02/providers/data_provider.dart';
import 'package:agile02/temp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:universal_html/html.dart' as html;
import 'package:universal_io/io.dart';

import '../providers/provUtama.dart';

class About extends StatefulWidget {
  final String username;

  About({Key? key, required this.username}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    // Cek dan simpan username pengguna ke SharedPreferences saat halaman ini diinisialisasi
    saveLastVisitedUsername(widget.username);
  }

  void saveLastVisitedUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(
        'lastVisitedUsername'); // Hapus lastVisitedUsername saat halaman ini dimuat
    prefs.setString('lastVisitedUsername', username);
  }

  @override
  Widget build(BuildContext context) {
    final dataprovider = Provider.of<ProvUtama>(context);

    dynamic userData;

    for (var dat in dataprovider.daftarakun) {
      if (dat["username"] == widget.username) {
        userData = dat;
      }
    }

    // openUrl(String urltujuan) async {
    //   Uri _urlUri = Uri.parse(urltujuan);
    //   if (kIsWeb) {
    //     html.window.open(urltujuan, "Sosial Media");
    //   } else if (Platform.isAndroid) {
    //     if (await canLaunch(_urlUri.toString())) {
    //       launch(_urlUri.toString(), forceSafariVC: false);
    //     }
    //   } else {
    //     print("Platform not supported");
    //   }
    // }

    return Template(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xff0C5513),
                  radius: 63,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(userData['img'] ?? ''),
                    radius: 60,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  userData['nama'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "@${userData['username'] ?? ''}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 7,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       onPressed: () async {
                //         openUrl(userData['youtube'] ?? 'https://www.youtube.com/@VALORANTEsportsIndonesia');
                //       },
                //       child: Image.asset("assets/youtube.png"),
                //     ),
                //     TextButton(
                //       onPressed: () async {
                //         openUrl(userData['twitch'] ?? 'https://www.twitch.tv/tarik');
                //       },
                //       child: Image.asset("assets/twitch.png"),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xff0C5513)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            color: Color(0xff0C5513),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "About me!",
                            style: TextStyle(
                              color: Color(0xff0C5513),
                              fontSize: 23,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(userData['desc'] ?? ''),
                    ],
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xff0C5513)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xff22A62F)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (dataprovider.islogin == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Perlu login untuk melanjutkan"),
                                duration: Duration(milliseconds: 1000),
                              ));
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => Login()));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Payment(
                                    usernamePenerima: userData['username'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text("Support Aku Disini!"),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isFollowing) ...[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "atau",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (dataprovider.islogin == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Diharuskan untuk login"),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Login()));
                      } else {
                        setState(() {
                          isFollowing = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil mengikuti Creator"),
                            duration: Duration(milliseconds: 800),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff92F090),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xff0C5513),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people,
                            color: Color(0xff0C5513),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Follow Aku",
                            style: TextStyle(
                              color: Color(0xff0C5513),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
