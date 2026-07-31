# prep-public.ps1
#
# Run BEFORE making this repo public.
#
# The repo holds third-party model/texture/sound packs that are fine as a
# private archive but are not ours to redistribute. Going public without
# running this converts a private backup into public redistribution of paid
# content.
#
#   powershell -File scripts/prep-public.ps1            # dry run
#   powershell -File scripts/prep-public.ps1 -Apply     # remove
#
# Plugin jars are already absent from this repo, so nobody can obtain the
# plugins here either way. This script is only about bundled ASSETS.
#
# NOTE: -Apply removes files from the working tree and index, but they remain
# in git history. Because they were committed at import, going public also
# requires a history rewrite (git filter-repo) or a fresh init.

param([switch]$Apply)

$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
Push-Location $repo
try {
  # Licensed third-party asset TREES. Whole directories, not blanket globs -
  # a repo-wide *.png sweep also catches our own server icons and logos.
  $trees = @(
    'smp/plugins/ModelEngine/blueprints',      # Gamita et al. .bbmodel packs
    'smp/plugins/ModelEngine/resource pack',
    'smp/plugins/Nexo/pack',                   # bundled textures/models
    'smp/plugins/CustomNameplates/ResourcePack',
    'smp/plugins/MythicMobs/packs',            # gamitamodels resourcepacks
    'smp/plugins/AdvancedPets/skinPacks',
    'smp/plugins/LibsDisguises/disguiseskins'
  )

  $hits = New-Object System.Collections.Generic.List[string]
  foreach ($t in $trees) {
    if (Test-Path -LiteralPath $t) {
      Get-ChildItem -LiteralPath $t -Recurse -File -Force -ErrorAction SilentlyContinue |
        ForEach-Object { $hits.Add($_.FullName) }
    }
  }
  $hits = $hits | Sort-Object -Unique

  if ($hits.Count -eq 0) {
    Write-Host "Clean - no licensed asset trees present."
  } else {
    $mb = [math]::Round((($hits | ForEach-Object { (Get-Item -LiteralPath $_ -Force).Length } |
           Measure-Object -Sum).Sum)/1MB, 1)
    Write-Host ("{0:N0} licensed asset files ({1} MB) across {2} trees:" -f $hits.Count, $mb, $trees.Count)
    foreach ($t in $trees) {
      $n = @($hits | Where-Object { $_ -like "*$($t -replace '/','\')*" }).Count
      if ($n) { Write-Host ("  {0,6:N0}  {1}" -f $n, $t) }
    }
  }

  # Mixed provenance - not auto-removed, but you should look.
  Write-Host ""
  Write-Host "REVIEW MANUALLY (kept - some are yours, some are other builders'):"
  foreach ($g in @('*.schem','*.schematic')) {
    $s = Get-ChildItem -Path $repo -Recurse -File -Force -Filter $g -ErrorAction SilentlyContinue
    if ($s) {
      Write-Host ("  {0,6:N0}  {1} files - e.g. builds credited to other creators" -f $s.Count, $g)
    }
  }

  if (-not $Apply) { Write-Host ""; Write-Host "Dry run. Re-run with -Apply to remove."; return }
  if ($hits.Count -eq 0) { return }

  foreach ($h in $hits) {
    $rel = $h.Substring($repo.Length+1)
    git rm --cached --quiet -- "$rel" 2>$null
    Remove-Item -LiteralPath $h -Force -ErrorAction SilentlyContinue
  }
  Get-ChildItem -LiteralPath $repo -Recurse -Directory -Force -ErrorAction SilentlyContinue |
    Sort-Object { $_.FullName.Length } -Descending |
    Where-Object { -not (Get-ChildItem -LiteralPath $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue) } |
    ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }

  Write-Host ""
  Write-Host ("Removed {0:N0} files." -f $hits.Count)
  Write-Host "They remain in git history - rewrite history or re-init before publishing."
} finally { Pop-Location }
