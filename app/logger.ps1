
class Logger {
  [void] Debug($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("DEBUG", $message, $null)
  }
  [void] Info($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("INFO", $message, "Green")
  }
  [void] Warn($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("WARN", $message, "Magenta")
  }
  [void] Error($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("ERROR", $message, "Magenta")
  }
  [void] Fatal($message) {
    $logger = [Logger]::new()
    $logger.PrintOut("FATAL", $message, "Red")
  }
  [void] PrintOut($level, $message, $color) {
    $level = ([string]$level).PadLeft(5)
    $logger = [Logger]::new()
    if ($null -eq $color) {
      Write-Host "[$($logger.GetDate())] $level | $message"
    } else {
      Write-Host "[$($logger.GetDate())] $level | $message" -ForegroundColor $color
    }
  }
  [string] GetDate() {
    return Get-Date -format "yyyy-MM-dd HH:mm:ss"
  }
}
