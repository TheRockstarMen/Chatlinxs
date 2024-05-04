import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/getit.dart';
import 'package:chatlinxs/models/size_config.dart';
import 'package:chatlinxs/provider/audio_provider.dart';
import 'package:chatlinxs/models/audio_wave_form_data.dart';

class AudioMessage extends StatefulWidget {
  final Uint8List? samples;
  final bool isIncomingMessage;

  const AudioMessage({super.key, this.samples, required this.isIncomingMessage});

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  AudioProvider provider = getIt<AudioProvider>();
  int? bits;
  Random rng = Random();
  AudioFormat audioFormat = AudioFormat.ENCODING_PCM_8BIT;
  late bool fromFriend;

  @override
  void initState() {
    getStream();
    fromFriend = widget.isIncomingMessage;
    super.initState();
  }

  getStream() async {
    Stream<Uint8List>? stream = MicStream.microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 1000 * (rng.nextInt(50) + 30),
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: audioFormat);
    provider.addStream(stream); //corregido
    var subscription = stream.listen((event) {
      provider.addSample(event);
    });
    provider.setStreamSubscription(subscription);

    bits = await MicStream.bitDepth;
    setState(() {});
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            fromFriend ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
              constraints:
                  BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.8),
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(fromFriend ? 0 : 40),
                    topLeft: const Radius.circular(40),
                    topRight: const Radius.circular(40),
                    bottomRight: Radius.circular(fromFriend ? 40 : 0)),
                color: fromFriend ? const Color(0xFF313131) : null,
                gradient: fromFriend
                    ? null
                    : LinearGradient(colors: [
                        greenGradient.lightShade,
                        greenGradient.darkShade,
                      ]),
              ),
              child: Center(
                child: StreamBuilder<Uint8List>(
                  stream: provider.audioStream,
                  builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                    if (snapshot.hasData) {
                      AudioWaveFormData waveFormData;
                      waveFormData = AudioWaveFormData(
                          bits: bits ?? 16,
                          data: snapshot.data?.map((e) => e).toList() ??
                              Uint8List(0));
                      return RectangleWaveform(
                        samples:
                            waveFormData.data.map((e) => e.toDouble()).toList(),
                        height: 50,
                        absolute: true,
                        width: MediaQuery.of(context).size.width,
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error ${snapshot.error}",
                          style: const TextStyle(color: Colors.red));
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              )),
        ],
      ),
    );
  }
}

/// todo:
/// 1. AudioWaveFormWork(2), Contact Picker(1), Location Picker(1), Payment Picker(1) and Sending
/// 2. Contacts(10min)
/// 3. Share(10min), Settings(10min), Passcode(10min)
