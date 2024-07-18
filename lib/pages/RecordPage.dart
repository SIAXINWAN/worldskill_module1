import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart' as ja;

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late ja.AudioPlayer _audioPlayer;
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isRecorded = false;
  String? _filePath;
  double _currentPosition = 0;
  double _totalDuration = 0;
  final List<String> audioList = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = ja.AudioPlayer(); // initializing the prefixed AudioPlayer
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';

    const config = RecordConfig(
        encoder: AudioEncoder.aacLc, sampleRate: 44100, bitRate: 128000);

    await _recorder.start(config, path: _filePath!);
    setState(() {
      _isRecording = true;
      _isRecorded = false;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _isRecorded = true;
    });
  }

  Future<void> _playRecording() async {
    if (_filePath != null) {
      await _audioPlayer.setFilePath(_filePath!);
      _totalDuration = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
      _audioPlayer.play();

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });
      });
    }
  }

  void _submitRecording() {
    if (_filePath != null) {
      audioList.add(_filePath!);
      setState(() {
        _filePath = null;
        _isRecorded = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Submit Successfully"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Record')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: const Color.fromARGB(255, 232, 226, 226)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            iconAlignment: IconAlignment.start,
                            onPressed:
                                _isRecording ? _stopRecording : _startRecording,
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(
                                    color:
                                        Colors.black), // Optional border color
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 170, 238, 172),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: const Text(
                              'Voice Record',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // ElevatedButton(
                      //     onPressed: _isRecording ? _stopRecording : null,
                      //     style: ElevatedButton.styleFrom(
                      //         shape: const RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.zero,
                      //           side: BorderSide(
                      //               color:
                      //                   Colors.black), // Optional border color
                      //         ),
                      //         backgroundColor:
                      //             const Color.fromARGB(255, 170, 238, 172),
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 30, vertical: 15)),
                      //     child: const Text('Stop')),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: !_isRecorded ? null : _playRecording,
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(
                                    color:
                                        Colors.black), // Optional border color
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 170, 238, 172),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: const Text('Voice Play')),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Slider(
                          value: _currentPosition,
                          max: _totalDuration,
                          onChanged: (value) {
                            setState(() {
                              _currentPosition = value;
                            });
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          })
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: _isRecorded ? _submitRecording : null,
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(
                                  color: Colors.black), // Optional border color
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 170, 238, 172),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: Text('Submit',
                              style: TextStyle(color: Colors.black))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Audios List",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: audioList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('audio ${index + 1}'),
                              trailing: IconButton(
                                onPressed: () async {
                                  await _audioPlayer.setFilePath(audioList[index]);
                              _audioPlayer.play();
                                },
                                icon: Icon(Icons.play_arrow),
                              ),
                            );
                          }))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
