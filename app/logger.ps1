
class Logger {
  Logger() {}
  Logger($fileoutput = $true) {
    $this.FileOutput = $fileoutput
  }
  Logger($fileoutput = $true, $consoleoutput = $true) {
    $this.FileOutput = $fileoutput
    $this.ConsoleOutput = $consoleoutput
  }
  Logger($fileoutput = $true, $consoleoutput = $true, $httpoutput = $false) {
    $this.FileOutput = $fileoutput
    $this.ConsoleOutput = $consoleoutput
    $this.HttpOutput = $httpoutput
  }

  [Boolean] $FileOutput = $true
  [Boolean] $ConsoleOutput = $true
  [Boolean] $HttpOutput = $false

  [void] ChangeFileOutputMode($mode) {
    $this.FileOutput = $mode
  }
  [void] ChangeConsoleOutputMode($mode) {
    $this.ConsoleOutput = $mode
  }
  [void] ChangeConsoleOutputMode($mode) {
    $this.HttpOutput = $mode
  }

  [String] $LogFilePath = ".\.log"
  [String] $HttpPostUri = $null

  [void] SetLogFilePath($path) {
    $this.LogFilePath = $path
  }

  [void] SetHttpPostUri($uri) {
    $this.SetHttpPostUri = $uri
  }

  [void] Debug($message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("DEBUG", $message, $null)
  }
  [void] Info($message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("INFO", $message, "Green")
  }
  [void] Warn($message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("WARN", $message, "Magenta")
  }
  [void] Error($message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("ERROR", $message, "Magenta")
  }
  [void] Fatal($message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("FATAL", $message, "Red")
  }

  [void] PrintOut($level, $message, $color) {
    $level = ([string]$level).PadRight(5)
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    if ($this.FileOutput) {
      Write-Output "[$($logger.GetDate())] $level | $message" >> $this.LogFilePath
    }
    if ($this.ConsoleOutput) {
      if ($null -eq $color) {
        Write-Host "[$($logger.GetDate())] $level | $message"
      } else {
        Write-Host "[$($logger.GetDate())] $level | $message" -ForegroundColor $color
      }
    }
    if ($this.HttpOutput) {
      $uri = $this.HttpPostUri
      if ($null -eq $uri) {
        Write-Error "HttpPostUri is not set."
      } else {
        $body = @{
          "level" = $level
          "message" = $message
        }
        $body = $body | ConvertTo-Json
        Invoke-RestMethod -Uri $uri -Method Post -Body $body
      }
    }
  }
  [string] GetDate() {
    return Get-Date -format "yyyy-MM-dd HH:mm:ss"
  }
}
