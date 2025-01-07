
import 'dart:async';
import 'dart:io';
import 'package:faceunity_ui_flutter/faceunity_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nertc_core/nertc_core.dart';
import 'package:nertc_faceunity_plugin/nertc_faceunity_plugin.dart';
import 'package:faceunity_plugin/faceunity_plugin.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  final int uid;
  final _nertcFaceunityPlugin = NertcFaceunityPlugin();

  VideoCall({Key? key, required this.channelName, required this.uid});

  @override
  _VideoCallState createState() {
    return _VideoCallState();
  }
}

class _VideoCallState extends State<VideoCall>
  with
  NERtcChannelEventCallback,
  NERtcVideoRendererEventListener {

  NERtcEngine _engine = NERtcEngine.instance;
  bool _engineInited = false;
  int _remoteUid = 0; // 远端用户ID，本sample暂时只演示 1对1 的情况

  @override
  void initState() {
    super.initState();

    _initEngine();
  }

  @override 
  void dispose() {
    super.dispose();

    _deinitEngine();
  }

  void _initEngine() async {
    var options = const NERtcOptions(logLevel: NERtcLogLevel.info);
    _engine.create(appKey: '云信appkey', channelEventCallback: this, options: options)
      .then((value) => _engine.enableLocalVideo(true))
      .then((value) => widget._nertcFaceunityPlugin.enableFuBeauty(true))
      .then((value) =>_engine.joinChannel('', widget.channelName, widget.uid))
      .then((value) {
        _engineInited = true;
        setState(() {});
    });
  }

  void _deinitEngine() async {
    _engine.leaveChannel();
    _engine.release();
    _engineInited = false;
  }

  @override
  void onJoinChannel(int result, int channelId, int elapsed, int uid) {
    print(
      'onJoinChannel: result=$result, channelId=$channelId, elapsed=$elapsed, uid=$uid',
    );
  }

  @override void onUserJoined(int uid, NERtcUserJoinExtraInfo? joinExtraInfo) {
    print('onUserJoined: ${joinExtraInfo}');
    if (_remoteUid == 0) {
      _remoteUid = uid;
    }
  }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    print('objective: onUserVideoStart: uid=$uid, maxProfile=$maxProfile');

    _engine.subscribeRemoteVideoStream(uid, NERtcRemoteVideoStreamType.high, true);
    setState(() {});
  }

  @override
  void onFirstFrameRendered(int uid) {
    // TODO: implement onFirstFrameRendered
  }

  @override 
  void onFrameResolutionChanged(int uid, int width, int height, int rotation) { 
    print('objective: onFrameResolutionChanged: uid=$uid, width=$width, height=$height');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(widget.channelName)),
      body: Stack (
        children: [
          if (_engineInited)
            buildVideoViews(context),
          if (_engineInited)
            FaceunityUI(),
        ],
      ),
    );
  }

  Widget buildVideoViews(BuildContext context) {
    return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行2个
            childAspectRatio: 9.0 / 16.0, // 宽高比
            crossAxisSpacing: 2.0, // 列间距
            mainAxisSpacing: 2.0, // 行间距
          ),
          itemCount: _remoteUid == 0 ? 1 : 2,
          itemBuilder: (BuildContext context, int index) {
            return buildVideoView(context, index);
          },
    );
  }

  Widget buildVideoView(BuildContext context, int index) {
    return Container(
      child: Stack(
        children: [
          NERtcVideoView.withInternalRenderer(
            uid: index == 0 ? null : _remoteUid,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                //'video ${index == 0 ? widget.uid : _remoteUid}',
                'video',
                style: TextStyle(color: Colors.red, fontSize: 10),
              )
            ],
          )
        ],
      ),
    );
  }
}