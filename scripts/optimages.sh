shopt -s nullglob
for f in *.jpg *.jpeg; do
  tmp="${f}.tmp"
  if magick "$f" -strip -quality 82 "$tmp" &&
     [[ -s "$tmp" ]]; then
    mv -- "$tmp" "$f"
  else
    rm -f -- "$tmp"
    echo "Failed: $f" >&2
  fi
done

