import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'page_manager.dart';
import 'services/service_locator.dart';
import 'package:provider/provider.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PageManager()..init(),
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<PageManager>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
            CurrentSongTitle(),
            Playlist(),
            AddRemoveSongButtons(),
            AudioProgressBar(),
            AudioControlButtons(),
          ],
        ),
      ),
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (_, pageManager, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(pageManager.currentSongTitle,
              style: const TextStyle(fontSize: 40)),
        );
      },
    );
  }
}

class Playlist extends StatelessWidget {
  const Playlist({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<PageManager>(
        builder: (context, pageManager, _) {
          return ListView.builder(
            itemCount: pageManager.playlist.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(pageManager.playlist[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class AddRemoveSongButtons extends StatelessWidget {
  const AddRemoveSongButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (context, pageManager, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: pageManager.add,
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: pageManager.remove,
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (_, pageManager, __) {
        return ListenableBuilder(
          listenable: pageManager.progressNotifier,
          builder: (context, _) {
            final value = pageManager.progressNotifier.value;
            return ProgressBar(
              progress: value.current,
              buffered: value.buffered,
              total: value.total,
              onSeek: pageManager.seek,
            );
          },
        );
      },
    );
  }
}

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          RepeatButton(),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (context, pageManager, child) {
        final value = pageManager.repeatButtonNotifier.value;
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (_, pageManager, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: pageManager.isFirstSong ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (_, pageManager, __) {
        // Force rebuild when playButtonNotifier changes
        return ListenableBuilder(
          listenable: pageManager.playButtonNotifier,
          builder: (context, _) {
            final value = pageManager.playButtonNotifier.value;

            switch (value) {
              case ButtonState.loading:
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 32.0,
                  height: 32.0,
                  child: const CircularProgressIndicator(),
                );
              case ButtonState.paused:
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 32.0,
                  onPressed: pageManager.play,
                );
              case ButtonState.playing:
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 32.0,
                  onPressed: pageManager.pause,
                );
            }
          },
        );
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (_, pageManager, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: pageManager.isLastSong ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(
      builder: (context, pageManager, _) {
        return IconButton(
          icon: pageManager.isShuffleModeEnabled
              ? const Icon(Icons.shuffle)
              : const Icon(Icons.shuffle, color: Colors.grey),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}
