#!/usr/bin/env bash
# SWG product-review board -> public GitHub Pages.  Run as yourself:
#   ! bash /home/jon/tcg/swg-deploy/deploy.sh
# Verbose + resilient: prints each step and the final URL.

SRC="/home/jon/AI_SECON_BRAIN/02_CLIENTS/SWG/MOCKUPS"
DIR="/home/jon/tcg/swg-deploy"
OWNER="jbmadl971-ctrl"

echo ">> 1. building bundle in $DIR"
cd "$DIR" || { echo "!! cannot cd $DIR"; exit 1; }
rm -rf photo-review-photos .git
mkdir -p photo-review-photos
cp "$SRC/swg-photo-review.html" index.html || { echo "!! board html not found"; exit 1; }
cp "$SRC"/photo-review-photos/IMG_*.jpg photo-review-photos/ || { echo "!! photos not found"; exit 1; }
echo "   bundle: index.html + $(ls photo-review-photos | wc -l) photos"

echo ">> 2. git init + commit"
git init -q -b main
git config user.name "Jon Madl"
git config user.email "jbmadl971@gmail.com"
git add -A
git commit -q -m "Style With Guljana - product review board" && echo "   committed" || { echo "!! commit failed"; exit 1; }

echo ">> 3. gh auth check"
gh auth status >/dev/null 2>&1 || { echo "!! gh not authenticated — run: gh auth login"; exit 1; }

REPO="review-$(head -c4 /dev/urandom | od -An -tx1 | tr -d ' \n')"
echo ">> 4. creating PUBLIC repo $OWNER/$REPO and pushing"
if ! gh repo create "$REPO" --public --source=. --remote=origin --push 2>&1; then
  echo "!! gh repo create failed (see error above)"; exit 1
fi

echo ">> 5. enabling GitHub Pages (main / root)"
gh api -X POST "repos/$OWNER/$REPO/pages" -f 'source[branch]=main' -f 'source[path]=/' 2>&1 \
  | grep -iv "already exists" || true

URL="https://$OWNER.github.io/$REPO/"
echo "$URL" > /tmp/swg_pages_url.txt
echo ""
echo "=================================================================="
echo "  DEPLOYED.  Pages builds in ~1-2 min, then live at:"
echo "  $URL"
echo "=================================================================="
