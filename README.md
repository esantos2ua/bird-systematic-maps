# Bird systematic maps: data for binarization

Repository holding the data from two systematic maps on birds.
The goal is to binarize the coded responses in these maps for a lab study (COSSEE).

## The two maps

1. **Casallanovo, Santos & Cione (2026).** Bird and mammal diversity in agricultural landscapes and adjacent natural vegetation of the Brazilian Atlantic Forest: a systematic map. *Environmental Evidence*. https://doi.org/10.1186/s13750-026-00390-z
   - License: CC BY 4.0 (article) and CC0 (data).
   - Folder: `data/raw/casallanovo2026_mata_atlantica/`
   - Main coding sheet: *Additional file 5*, sheet "Data coding strategy" (one row per species × publication; includes mammals, filter `taxonomic_group == "birds"`).

2. **Adams, Fernández-Juricic, Bayne & St. Clair (2021).** Effects of artificial light on bird movement and distribution: a systematic map. *Environmental Evidence* 10: 37. https://doi.org/10.1186/s13750-021-00246-8
   - The main database is *Additional file 15* (Excel; the real header is on row 3). There is also an Access version (*Additional file 13*).
   - Folder: `data/raw/adams2021_luz_artificial/`

## How to use

1. Run the script from the repository root:

   ```
   Rscript scripts/01_baixar_dados.R
   ```

2. Check `data/raw/registro_downloads.csv` (download log) to see what was downloaded.
3. If a file fails, download it by hand from the article page and save it in the right folder.

## Known data gaps

- **Adams 2021, Additional file 3** (zip, 231 MB) is not in the Git repository because it exceeds GitHub's 100 MB file limit. Run the download script to get it.
- **Adams 2021, Additional file 14** has not been downloaded. It could not be found on the Springer CDN; download it by hand from the article page if needed.
- The Adams article page blocks automated reading, so the script uses direct CDN links for that map.

## Structure

```
data/raw/         original files, never edited
data/processed/   binarized data
scripts/          R code
```

Simple rule: never edit anything in `data/raw/`. All processing goes to `data/processed/`.
