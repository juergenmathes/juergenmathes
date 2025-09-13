#!/usr/bin/env bash
set -euo pipefail

# ---- Config ----
ART_DIR="artifacts"
PNG_OUT="${ART_DIR}/s3dpps_architecture.png"
GIF1_OUT_ORIG="${ART_DIR}/s3dpps_streamlit_orig.gif"
GIF2_OUT_ORIG="${ART_DIR}/s3dpps_3dpreds_orig.gif"
GIF1_OUT_360="${ART_DIR}/s3dpps_streamlit_360.gif"
GIF2_OUT_360="${ART_DIR}/s3dpps_3dpreds_360.gif"

URL_PNG="https://raw.githubusercontent.com/juergenmathes/s3dpps/main/readme_data/06_final_architecture.png"
URL_GIF1="https://raw.githubusercontent.com/juergenmathes/s3dpps/main/readme_data/05_streamlit_visu.gif"
URL_GIF2="https://raw.githubusercontent.com/juergenmathes/s3dpps/main/readme_data/05_final_training_last_step_best_example_visualization_3d.gif"

mkdir -p "${ART_DIR}"

echo "[1/5] Downloading assets..."
wget -q -O "${PNG_OUT}" "${URL_PNG}"
wget -q -O "${GIF1_OUT_ORIG}" "${URL_GIF1}"
wget -q -O "${GIF2_OUT_ORIG}" "${URL_GIF2}"

echo "[2/5] Generating palettes for high-quality resized GIFs..."
ffmpeg -y -i "${GIF1_OUT_ORIG}" -vf "fps=15,scale=-2:360:flags=lanczos,palettegen" "${ART_DIR}/palette1.png"
ffmpeg -y -i "${GIF2_OUT_ORIG}" -vf "fps=15,scale=-2:360:flags=lanczos,palettegen" "${ART_DIR}/palette2.png"

echo "[3/5] Resizing GIFs to ~360p with palettes..."
ffmpeg -y -i "${GIF1_OUT_ORIG}" -i "${ART_DIR}/palette1.png" \
  -lavfi "fps=15,scale=-2:360:flags=lanczos [x]; [x][1:v] paletteuse=dither=sierra2_4a" \
  "${GIF1_OUT_360}"

ffmpeg -y -i "${GIF2_OUT_ORIG}" -i "${ART_DIR}/palette2.png" \
  -lavfi "fps=15,scale=-2:360:flags=lanczos [x]; [x][1:v] paletteuse=dither=sierra2_4a" \
  "${GIF2_OUT_360}"

# Optional size trim (lossless-ish) with gifsicle if installed
if command -v gifsicle >/dev/null 2>&1; then
  echo "[4/5] Optimizing GIFs with gifsicle..."
  gifsicle -O3 "${GIF1_OUT_360}" -o "${GIF1_OUT_360}"
  gifsicle -O3 "${GIF2_OUT_360}" -o "${GIF2_OUT_360}"
fi

echo "[5/5] Done. Local artifacts:"
ls -lh "${ART_DIR}"/s3dpps_*.gif "${PNG_OUT}"

# ---- OPTIONAL: Upload to Artifactory ----
# Option A: jfrog CLI (recommended)
# jfrog rt u "artifacts/s3dpps_*" "my-generic-repo/path/to/s3dpps/" --flat=true

# Option B: curl (generic local example)
# ARTIFACTORY_BASE="https://artifactory.mycompany.com/artifactory"
# REPO_PATH="my-generic-repo/path/to/s3dpps"
# API_KEY="AKCp...."   # or use a token
# for f in "${PNG_OUT}" "${GIF1_OUT_360}" "${GIF2_OUT_360}"; do
#   bn="$(basename "$f")"
#   curl -H "X-JFrog-Art-Api: ${API_KEY}" -T "$f" "${ARTIFACTORY_BASE}/${REPO_PATH}/${bn}"
# done

echo "All set. Update your HTML to use:"
echo "  artifacts/s3dpps_architecture.png"
echo "  artifacts/s3dpps_streamlit_360.gif"
echo "  artifacts/s3dpreds_360.gif  (typo: actually artifacts/s3dpps_3dpreds_360.gif)"
