import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsla/Pages/inner/awarness.dart';
import 'package:vsla/Pages/inner/video_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class YoutubePlayerMy extends StatefulWidget {
  final String videoId;
  final List<String> ids;

  const YoutubePlayerMy({Key? key, required this.videoId, required this.ids})
      : super(key: key);
  @override
  _YoutubePlayerMyState createState() => _YoutubePlayerMyState();
}

class _YoutubePlayerMyState extends State<YoutubePlayerMy> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  final bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];
  var loading = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              print('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar(context, 'Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Image.asset(
              'assets/images/vsla.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          title: const Text(
            'Youtube Player Flutter',
            style: TextStyle(color: Colors.white),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.video_library),
          //     onPressed: () => Navigator.push(
          //       context,
          //       CupertinoPageRoute(
          //         builder: (context) => VideoList(),
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _space,
                  _text('Title', _videoMetaData.title),
                  _space,
                  _text('Channel', _videoMetaData.author),
                  _space,
                  _text('Video Id', _videoMetaData.videoId),
                  _space,
                  Row(
                    children: [
                      _text(
                        'Playback Quality',
                        _controller.value.playbackQuality ?? '',
                      ),
                      const Spacer(),
                      _text(
                        'Playback Rate',
                        '${_controller.value.playbackRate}x  ',
                      ),
                    ],
                  ),
                  _space,
                  // TextField(
                  //   enabled: _isPlayerReady,
                  //   controller: _idController,
                  //   decoration: InputDecoration(
                  //     border: InputBorder.none,
                  //     hintText: 'Enter youtube \<video id\> or \<link\>',
                  //     fillColor: Colors.blueAccent.withAlpha(20),
                  //     filled: true,
                  //     hintStyle: const TextStyle(
                  //       fontWeight: FontWeight.w300,
                  //       color: Colors.blueAccent,
                  //     ),
                  //     suffixIcon: IconButton(
                  //       icon: const Icon(Icons.clear),
                  //       onPressed: () => _idController.clear(),
                  //     ),
                  //   ),
                  // ),
                  _space,
                  // Row(
                  //   children: [
                  //     _loadCueButton(context, 'LOAD'),
                  //     const SizedBox(width: 10.0),
                  //     _loadCueButton(context, 'CUE'),
                  //   ],
                  // ),
                  _space,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     IconButton(
                  //       icon: const Icon(Icons.skip_previous),
                  //       onPressed: _isPlayerReady
                  //           ? () => _controller.load(_ids[
                  //               (_ids.indexOf(_controller.metadata.videoId) -
                  //                       1) %
                  //                   _ids.length])
                  //           : null,
                  //     ),
                  //     IconButton(
                  //       icon: Icon(
                  //         _controller.value.isPlaying
                  //             ? Icons.pause
                  //             : Icons.play_arrow,
                  //       ),
                  //       onPressed: _isPlayerReady
                  //           ? () {
                  //               _controller.value.isPlaying
                  //                   ? _controller.pause()
                  //                   : _controller.play();
                  //               setState(() {});
                  //             }
                  //           : null,
                  //     ),
                  //     IconButton(
                  //       icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                  //       onPressed: _isPlayerReady
                  //           ? () {
                  //               _muted
                  //                   ? _controller.unMute()
                  //                   : _controller.mute();
                  //               setState(() {
                  //                 _muted = !_muted;
                  //               });
                  //             }
                  //           : null,
                  //     ),
                  //     FullScreenButton(
                  //       controller: _controller,
                  //       color: Colors.blueAccent,
                  //     ),
                  //     IconButton(
                  //       icon: const Icon(Icons.skip_next),
                  //       onPressed: _isPlayerReady
                  //           ? () => _controller.load(_ids[
                  //               (_ids.indexOf(_controller.metadata.videoId) +
                  //                       1) %
                  //                   _ids.length])
                  //           : null,
                  //     ),
                  //   ],
                  // ),
                  _space,
                  Row(
                    children: <Widget>[
                      const Text(
                        "Volume",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          value: _volume,
                          min: 0.0,
                          max: 100.0,
                          divisions: 10,
                          label: '${(_volume).round()}',
                          onChanged: _isPlayerReady
                              ? (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _controller.setVolume(_volume.round());
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  _space,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: _getStateColor(_playerState),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _playerState.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadCueButton(BuildContext context, String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar(context, 'Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);
  // Future<void> fetchAwareness() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var accessToken = prefs.getStringList("_keyUser");
  //   final String authToken = accessToken![0];

  //   try {
  //     var response = await http.get(
  //       Uri.http("10.1.177.121:8111", "api/v1/awareness/by-group"),
  //       headers: <String, String>{
  //         'Authorization': 'Bearer $authToken',
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     var data = jsonDecode(response.body);
  //     print(data);
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         for (var aware in data) {
  //           // print(transaction.date);
  //           List<AwarenessData> awarenesses = [];
  //           var myAware = AwarenessData(
  //               title: aware['title'],
  //               description: aware['description'],
  //               imageUrl: aware['imageUrl'],
  //               videoUrl: aware['videoUrl']);
  //           awarenesses.add(myAware);
  //           print(myAware.videoUrl as YoutubePlayerController);
  //           _ids.add(myAware.videoUrl);
  //         }

  //         loading = false;
  //       });

  //       setState(() {
  //         loading = false;
  //       });
  //     } else if (response.statusCode != 201) {
  //       final responseBody = json.decode(response.body);
  //       final description =
  //           responseBody?['message']; // Extract 'description' field
  //       if (description == "Something went wron, please try again") {
  //         Fluttertoast.showToast(
  //             msg: "Something went wron, please try again", fontSize: 18);
  //       } else {
  //         var message = description ?? "Something went wrong, please try again";
  //         Fluttertoast.showToast(msg: message, fontSize: 18);
  //       }
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (e) {
  //     var message = e.toString();
  //     print(e.toString());
  //     'Please check your network connection';
  //     Fluttertoast.showToast(msg: message, fontSize: 18);
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }
}
