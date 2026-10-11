mkdir -p optimized
shopt -s nullglob

for f in *.mp4; do
  ffmpeg -i "$f" -c:v libx264 -crf 28 -preset medium \
    -c:a aac -b:a 128k "optimized/$f"
done
