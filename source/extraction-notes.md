# Extraction Notes

## 2026-06-20 A Time of War PDF Extraction

- Extraction date: 2026-06-20
- PDF filename: `Battletech - CAT35005 - A Time of War.pdf`
- Source PDF path: `source/atow-pdf/Battletech - CAT35005 - A Time of War.pdf`
- Extracted text path: `source/atow-text/page-####.txt`
- Page count: 410 PDF pages
- Extraction command:

```powershell
$popplerBin = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\oschwartz10612.Poppler_Microsoft.Winget.Source_8wekyb3d8bbwe\poppler-25.07.0\Library\bin"
$pdfPath = "source\atow-pdf\Battletech - CAT35005 - A Time of War.pdf"
$outDir = "source\atow-text"
$pageCount = 410
for ($i = 1; $i -le $pageCount; $i++) {
  & "$popplerBin\pdftotext.exe" -f $i -l $i -layout $pdfPath (Join-Path $outDir ("page-{0:D4}.txt" -f $i))
}
```

- Tool/version notes:
  - Poppler installed with `winget install --id oschwartz10612.Poppler --accept-package-agreements --accept-source-agreements --silent`.
  - `pdfinfo.exe` version: 25.07.0.
  - `pdftotext.exe` version: 25.07.0.
  - `pdfinfo` reported title metadata and 410 pages.
  - The repository shell script expects `pdftotext` and `pdfinfo` command names. The installed Windows binaries were visible as `.exe` files from WSL, so extraction used the same Poppler page loop from PowerShell instead.
- Observed extraction issues:
  - Extraction produced 410 `page-####.txt` files.
  - No zero-byte page text files were observed.
  - Some pages produced very small text files; page-level quality still needs review during the chapter and section mapping issue.
  - No rule content was reviewed, summarized, quoted, or copied into committed files during this extraction.
- Page-number offset notes:
  - Numbered interior pages use a consistent offset: `PDF page = printed page + 2`.
  - Spot checks: PDF page 18 corresponds to printed page 16; PDF page 40 corresponds to printed page 38; PDF page 388 corresponds to printed page 386.
  - Front matter before printed page 1 and advertising/back-cover matter after the main book should be cited by PDF page unless later source review identifies a better convention.
  - Detailed chapter and section ranges are recorded in `source/atow-chapter-section-map.md`.
