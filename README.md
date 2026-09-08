# homebrew-readaloud

Homebrew tap for [readaloud](https://github.com/Nornchan/readaloud) — turns
a web article, HTML file, or PDF into a listenable audio file using a local
neural TTS engine (Kokoro-82M via onnxruntime). No API key, no network
after the model's one-time download.

## Install

```
brew install nornchan/readaloud/readaloud
```

Apple Silicon only — see the `arch` dependency note in
[`Formula/readaloud.rb`](Formula/readaloud.rb) for why (onnxruntime ships
no Intel-macOS build).

## Documentation

`readaloud --help`, or the main repo's
[README](https://github.com/Nornchan/readaloud#readme) and
[SPEC.md](https://github.com/Nornchan/readaloud/blob/main/SPEC.md) for the
full design and build history.

For Homebrew itself: `brew help`, `man brew`, or
[Homebrew's documentation](https://docs.brew.sh).
