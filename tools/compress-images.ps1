Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$assets = Join-Path $root "assets"

$targets = @(
  @{ Input = "hero-property-operations.png"; Output = "hero-property-operations.jpg"; Width = 1280; Quality = 78L },
  @{ Input = "office-coordination.png"; Output = "office-coordination.jpg"; Width = 960; Quality = 76L },
  @{ Input = "site-inspection-risk.png"; Output = "site-inspection-risk.jpg"; Width = 960; Quality = 76L }
)

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
  Where-Object { $_.MimeType -eq "image/jpeg" } |
  Select-Object -First 1

foreach ($target in $targets) {
  $inputPath = Join-Path $assets $target.Input
  $outputPath = Join-Path $assets $target.Output

  $source = [System.Drawing.Image]::FromFile($inputPath)
  try {
    $scale = [Math]::Min(1, $target.Width / $source.Width)
    $width = [int][Math]::Round($source.Width * $scale)
    $height = [int][Math]::Round($source.Height * $scale)

    $bitmap = New-Object System.Drawing.Bitmap -ArgumentList $width, $height
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.Clear([System.Drawing.Color]::White)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $graphics.DrawImage($source, 0, 0, $width, $height)
      } finally {
        $graphics.Dispose()
      }

      $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
      $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
        [System.Drawing.Imaging.Encoder]::Quality,
        [int64]$target.Quality
      )
      $bitmap.Save($outputPath, $jpegCodec, $encoderParams)
    } finally {
      if ($bitmap) { $bitmap.Dispose() }
    }
  } finally {
    $source.Dispose()
  }
}
