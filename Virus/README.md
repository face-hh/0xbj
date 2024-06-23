This is the source code for the virus.

Note that the following files are missing from `src/`:
- family_guy.mp4
- fart-with-reverb.mp3
- gtav.mp4
- satisfying.mp4
- sigma.mp4
- skibidi.jpg
- subscribe.png

# How to run
## Run
`$ python main.py <action>`

## Build
`$ python -m nuitka --standalone main.py --include-data-dir=src/=src --include-data-dir=src/vlc=src/vlc/ --enable-plugin=tk-inter`
`$ cp src/vlc main.dist/src/vlc`
`$ cd main.dist`
`$ .\main.exe <action>`