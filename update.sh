#!/usr/bin/env bash
# Push the latest board to the EXISTING Pages repo (same URL).
# Run:  ! bash /home/jon/tcg/swg-deploy/update.sh
SRC="/home/jon/AI_SECON_BRAIN/02_CLIENTS/SWG/MOCKUPS"
DIR="/home/jon/tcg/swg-deploy"
OWNER="jbmadl971-ctrl"
REPO="review-1450fe60"

cd "$DIR" || exit 1
echo ">> refreshing files"
rm -rf photo-review-photos; mkdir -p photo-review-photos
cp "$SRC/swg-photo-review.html" index.html
cp "$SRC"/photo-review-photos/IMG_*.jpg photo-review-photos/
echo "   index.html + $(ls photo-review-photos | wc -l) photos"

[ -d .git ] || git init -q -b main
git config user.name "Jon Madl"
git config user.email "jbmadl971@gmail.com"
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$OWNER/$REPO.git"
git add -A
git commit -q -m "Ashley review notes: front/back pairs, unique descriptions, colours, colourways"
echo ">> pushing to $OWNER/$REPO"
git push -f origin main

echo ""
echo "=================================================================="
echo "  UPDATED.  Same link, rebuilds in ~1-2 min:"
echo "  https://$OWNER.github.io/$REPO/"
echo "=================================================================="
