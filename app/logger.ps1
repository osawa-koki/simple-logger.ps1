
class Logger {
  [void] Debug($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("DEBUG", $message, $null)
  }
  [void] Info($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("INFO", $message, "green")
  }
  [void] Warn($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("WARN", $message, "magenta")
  }
  [void] Error($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("ERROR", $message, "magenta")
  }
  [void] Fatal($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("FATAL", $message, "red")
  }
  [void] PrintOut($level, $message, $color) {
    $level = ([string]$level).PadLeft(5)
    $logger = [Logger]::new()
    if ($null -eq $color) {
      Write-Host "[$($logger.GetDate())] $level | $message"
    } elseif ($color -eq "red") {
      Write-Host "[$($logger.GetDate())] $level | $message" -ForegroundColor Red
    } elseif ($color -eq "green") {
      Write-Host "[$($logger.GetDate())] $level | $message" -ForegroundColor Green
    } elseif ($color -eq "magenta") {
      Write-Host "[$($logger.GetDate())] $level | $message" -ForegroundColor Magenta
    } else {
      Write-Host "[$($logger.GetDate())] $level | $message"
    }
  }
  [string] GetDate() {
    return Get-Date -format "yyyy-MM-dd HH:mm:ss"
  }
}
