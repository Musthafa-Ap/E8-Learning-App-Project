import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/pages/my_learning/services/my_learnings_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class CourseVideosPage extends StatefulWidget {
  const CourseVideosPage({super.key});

  @override
  State<CourseVideosPage> createState() => _CourseVideosPageState();
}

class _CourseVideosPageState extends State<CourseVideosPage> {
  List allSpeed = <double>[0.25, 0.5, 1, 1.5, 2, 2.5, 3];
  bool prev = false;
  bool forw = false;
  late MyLearningsProvider _myLearningsProvider;
  late VideoPlayerController _controller;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _myLearningsProvider =
        Provider.of<MyLearningsProvider>(context, listen: false);
    playVideo(init: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  playVideo({int index = 0, bool init = false}) {
    if (index < 0 ||
        index >= _myLearningsProvider.courseVideoList!.data!.length) return;
    if (!init) {
      _controller.pause();
    }
    setState(() {
      _currentIndex = index;
    });
    _controller = VideoPlayerController.network(_myLearningsProvider
        .courseVideoList!.data![_currentIndex].video
        .toString()
        .toString())
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) {
        _controller.play();
        _controller.setVolume(1);
        _controller.setLooping(false);
      });
  }

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final myLearningsProvider = Provider.of<MyLearningsProvider>(context);
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text("My Learnings"),
      ),
      body: myLearningsProvider.isCourseLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: size * .58,
                      child: _controller.value.isInitialized
                          ? Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                      });
                                    },
                                    child: _controller.value.isInitialized
                                        ? Stack(
                                            children: [
                                              SizedBox(
                                                height: size * .501,
                                                child: VideoPlayer(_controller),
                                              ),
                                              GestureDetector(
                                                onDoubleTap: () async {
                                                  setState(() {
                                                    prev = true;
                                                  });
                                                  await _controller.seekTo(
                                                      Duration(
                                                          seconds: _controller
                                                                  .value
                                                                  .position
                                                                  .inSeconds -
                                                              10));
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {
                                                      prev = false;
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                    color: Colors.transparent,
                                                    width: size * .25,
                                                    height: size * .501,
                                                    child: prev == true
                                                        ? const Center(
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.black,
                                                              radius: 20,
                                                              child: Icon(
                                                                Icons
                                                                    .fast_rewind,
                                                                color: Colors
                                                                    .white,
                                                                size: 30,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox()),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: GestureDetector(
                                                  onDoubleTap: () async {
                                                    setState(() {
                                                      forw = true;
                                                    });
                                                    await _controller.seekTo(
                                                        Duration(
                                                            seconds: _controller
                                                                    .value
                                                                    .position
                                                                    .inSeconds +
                                                                10));
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      setState(() {
                                                        forw = false;
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                      color: Colors.transparent,
                                                      width: size * .25,
                                                      height: size * .501,
                                                      child: forw == true
                                                          ? const Center(
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                radius: 20,
                                                                child: Icon(
                                                                  Icons
                                                                      .fast_forward,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox()),
                                                ),
                                              ),
                                              Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    LandscapePlayerPage(
                                                                        controller:
                                                                            _controller)));
                                                      },
                                                      icon: const Icon(
                                                          Icons.fullscreen))),
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0,
                                                child: _controller
                                                        .value.isPlaying
                                                    ? const SizedBox()
                                                    : Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _controller.value
                                                                    .isPlaying
                                                                ? _controller
                                                                    .pause()
                                                                : _controller
                                                                    .play();
                                                          },
                                                          child:
                                                              const CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .play_arrow,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 40,
                                                                    ),
                                                                  )),
                                                        ),
                                                      ),
                                              ),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child:
                                                      PopupMenuButton<double>(
                                                    initialValue: _controller
                                                        .value.playbackSpeed,
                                                    tooltip: 'Playback speed',
                                                    onSelected: _controller
                                                        .setPlaybackSpeed,
                                                    itemBuilder: (context) => allSpeed
                                                        .map<
                                                            PopupMenuEntry<
                                                                double>>((speed) =>
                                                            PopupMenuItem(
                                                                value: speed,
                                                                child: Text(
                                                                    "${speed}x")))
                                                        .toList(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white38,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 6,
                                                        horizontal: 10,
                                                      ),
                                                      child: Text(
                                                          "${_controller.value.playbackSpeed}x"),
                                                    ),
                                                  ))
                                            ],
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          )),
                                kHeight,
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable: _controller,
                                          builder: (context,
                                              VideoPlayerValue value, child) {
                                            return Text(
                                              _videoDuration(value.position),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            );
                                          }),
                                      Expanded(
                                        child: SizedBox(
                                          height: 8,
                                          child: VideoProgressIndicator(
                                              _controller,
                                              allowScrubbing: true,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 0)),
                                        ),
                                      ),
                                      Text(
                                        _videoDuration(
                                            _controller.value.duration),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                  kHeight,
                  Text(
                    myLearningsProvider
                            .courseVideoList?.data?[_currentIndex].topicName
                            .toString() ??
                        "Introduction to Cloud computing on AWS for Beginners[2022])",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  kHeight5,
                  ReadMoreText(
                    myLearningsProvider
                            .courseVideoList?.data?[_currentIndex].description
                            .toString() ??
                        "Introduction to Cloud computing on AWS for Beginners[2022])",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    trimLines: 2,
                    colorClickableText: Colors.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  // kHeight5,
                  const Divider(
                    color: Colors.white,
                  ),
                  kHeight5,
                  Expanded(
                      child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        myLearningsProvider.courseVideoList?.data?.length,
                    itemBuilder: (context, index) {
                      final datas =
                          myLearningsProvider.courseVideoList?.data?[index];
                      var x = datas?.videoDuration.toString();
                      var d = x?.split(':');
                      var duration = "${d?[1]}:${d?[2]}";
                      return InkWell(
                        onTap: () => playVideo(index: index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            datas!.thumbnail.toString()))),
                                height: size * .21,
                                width: size * .25,
                                child: Stack(
                                  children: [
                                    const Center(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 2,
                                      bottom: 2,
                                      child: Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        width: 38,
                                        child: Center(
                                          child: Text(
                                            duration,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              kWidth10,
                              Expanded(
                                child: Text(
                                  datas.topicName.toString(),
                                  style: const TextStyle(
                                      //overflow: TextOverflow.ellipsis,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ))
                ],
              ),
            ),
    );
  }
}

class LandscapePlayerPage extends StatefulWidget {
  final VideoPlayerController controller;
  const LandscapePlayerPage({super.key, required this.controller});

  @override
  State<LandscapePlayerPage> createState() => _LandscapePlayerPageState();
}

class _LandscapePlayerPageState extends State<LandscapePlayerPage> {
  List allSpeed = <double>[0.25, 0.5, 1, 1.5, 2, 2.5, 3];
  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  bool prev = false;
  bool forw = false;
  @override
  void initState() {
    super.initState();
    _landscapeMode();
  }

  @override
  void dispose() {
    super.dispose();
    _setAllOrientation();
  }

  Future _setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  Future _landscapeMode() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.value.isPlaying
              ? widget.controller.pause()
              : widget.controller.play();
        });
      },
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  VideoPlayer(widget.controller),
                  widget.controller.value.isPlaying
                      ? const SizedBox()
                      : const Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 45,
                            ),
                          )),
                  GestureDetector(
                    //highlightColor: Colors.white,
                    onDoubleTap: () async {
                      setState(() {
                        prev = true;
                      });
                      await widget.controller.seekTo(Duration(
                          seconds:
                              widget.controller.value.position.inSeconds - 10));

                      await Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          prev = false;
                        });
                      });
                    },

                    child: Container(
                      height: double.infinity,
                      width: size * .25,
                      color: Colors.transparent,
                      child: prev == true
                          ? const Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 25,
                                child: Icon(
                                  Icons.fast_rewind,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: () async {
                      setState(() {
                        forw = true;
                      });
                      await widget.controller.seekTo(Duration(
                          seconds:
                              widget.controller.value.position.inSeconds + 10));
                      await Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          forw = false;
                        });
                      });
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: double.infinity,
                        width: size * .25,
                        color: Colors.transparent,
                        child: forw == true
                            ? const Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 25,
                                  child: Icon(
                                    Icons.fast_forward,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                          alignment: Alignment.center,
                          onPressed: () async {
                            await _setAllOrientation();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.black,
                          ))),
                  Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<double>(
                        initialValue: widget.controller.value.playbackSpeed,
                        tooltip: 'Playback speed',
                        onSelected: widget.controller.setPlaybackSpeed,
                        itemBuilder: (context) => allSpeed
                            .map<PopupMenuEntry<double>>((speed) =>
                                PopupMenuItem(
                                    value: speed, child: Text("${speed}x")))
                            .toList(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10,
                          ),
                          child:
                              Text("${widget.controller.value.playbackSpeed}x"),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  ValueListenableBuilder(
                      valueListenable: widget.controller,
                      builder: (context, VideoPlayerValue value, child) {
                        return Text(
                          _videoDuration(value.position),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        );
                      }),
                  Expanded(
                    child: Container(
                      height: 8,
                      color: Colors.transparent,
                      width: double.infinity,
                      child: VideoProgressIndicator(widget.controller,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0)),
                    ),
                  ),
                  Text(
                    _videoDuration(widget.controller.value.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  )
                ],
              ),
            ),
            kHeight5
          ],
        ),
      ),
    ));
  }
}
