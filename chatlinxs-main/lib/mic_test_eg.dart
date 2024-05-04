import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:chatlinxs/models/audio_wave_form_data.dart';

class ClipperView extends StatefulWidget {
  const ClipperView({super.key});

  @override
  State<ClipperView> createState() => _ClipperViewState();
}

class _ClipperViewState extends State<ClipperView> {
  Stream<Uint8List>? stream;
  int? bits;
  Random rng = Random();
  AudioFormat audioFormat = AudioFormat.ENCODING_PCM_8BIT;

  @override
  void initState() {
    getStream();
    super.initState();
  }

  getStream() async {
    stream = MicStream.microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 1000 * (rng.nextInt(50) + 30),
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: audioFormat);
    bits = await MicStream.bitDepth;
    setState(() {});
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                height: 600,
                child: StreamBuilder<Uint8List>(
                  stream: stream,
                  builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData) {
                      return LayoutBuilder(
                          builder: (context, BoxConstraints constraints) {
                        // adjust the shape based on parent's orientation/shape
                        // the waveform should always be wider than taller
                        double height;
                        if (constraints.maxWidth < constraints.maxHeight) {
                          height = constraints.maxWidth;
                        } else {
                          height = constraints.maxHeight;
                        }
                        AudioWaveFormData waveFormData;
                        waveFormData = AudioWaveFormData(
                            bits: bits ?? 16,
                            data: snapshot.data?.map((e) => e).toList() ??
                                Uint8List(0));
                        return PolygonWaveform(
                          samples: waveFormData.data
                              .map((e) => e.toDouble())
                              .toList(),
                          height: 600,
                          absolute: true,
                          width: MediaQuery.of(context).size.width,
                        );
                        // return ClipPath(
                        //   clipper: WaveformClipper(waveFormData),
                        //   child: Container(
                        //     height: height,
                        //     decoration: const BoxDecoration(
                        //       gradient: LinearGradient(
                        //         begin: Alignment.centerLeft,
                        //         end: Alignment.centerRight,
                        //         stops: [0.1, 0.3, 0.9],
                        //         colors: [
                        //           Color(0xffFEAC5E),
                        //           Color(0xffC779D0),
                        //           Color(0xff4BC0C8),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                      });
                    } else if (snapshot.hasError) {
                      return Text("Error ${snapshot.error}",
                          style: const TextStyle(color: Colors.red));
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WaveformClipper extends CustomClipper<Path> {
  WaveformClipper(this.data);

  final AudioWaveFormData data;

  @override
  Path getClip(Size size) {
    return data.path(size);
  }

  @override
  bool shouldReclip(WaveformClipper oldClipper) {
    if (data != oldClipper.data) {
      return true;
    }
    return false;
  }
}

/// todo:
/// 1. AudioWaveFormWork(2), Contact Picker(1), Location Picker(1), Payment Picker(1) and Sending
/// 2. Contacts(10min)
/// 3. Share(10min), Settings(10min), Passcode(10min)
