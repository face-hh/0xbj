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
python -m nuitka --standalone main.py --include-data-dir=src/=src --include-data-files=src/*.py=src/ --enable-plugin=tk-inter