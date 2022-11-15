
enum LoggerLevel {
  All = 0
  Debug = 1
  Info = 2
  Warn = 3
  Error = 4
  Fatal = 5
  Off = 99
}

class Logger {
  Logger() {}
  Logger([string]$mode) {
    if ($mode -match "[01]{3}") {
      $mode_components = $mode.ToCharArray()
      $this.FileOutput = $mode_components[0] == "1"
      $this.ConsoleOutput = $mode_components[1] == "1"
      $this.EventLogOutput = $mode_components[2] == "1"
    } else {
      Write-Error "mode format is invalid."
    }
  }
  Logger([Boolean]$fileoutput = $true) {
    $this.FileOutput = $fileoutput
  }
  Logger([Boolean]$fileoutput = $true, [Boolean]$consoleoutput = $true) {
    $this.FileOutput = $fileoutput
    $this.ConsoleOutput = $consoleoutput
  }
  Logger([Boolean]$fileoutput = $true, [Boolean]$consoleoutput = $true, [Boolean]$httpoutput = $false) {
    $this.FileOutput = $fileoutput
    $this.ConsoleOutput = $consoleoutput
    $this.HttpOutput = $httpoutput
  }

  [Boolean] $FileOutput = $true
  [Boolean] $ConsoleOutput = $true
  [Boolean] $HttpOutput = $false

  [void] ChangeFileOutputMode([Boolean]$mode) {
    $this.FileOutput = $mode
  }
  [void] ChangeConsoleOutputMode([Boolean]$mode) {
    $this.ConsoleOutput = $mode
  }
  [void] ChangeHttpOutputMode([Boolean]$mode) {
    $this.HttpOutput = $mode
  }

  [String] $LogFilePath = ".\.log"
  [String] $HttpPostUri = $null

  [void] SetLogFilePath([String]$path) {
    $this.LogFilePath = $path
  }
  [void] SetHttpPostUri([String]$uri) {
    $this.SetHttpPostUri = $uri
  }

  [LoggerLevel] $EmittingLevel
  [void] SetEmittingLevel([LoggerLevel]$level) {
    $this.EmittingLevel = $level
  }

  [void] Debug([String]$message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("DEBUG", $message, $null)
  }
  [void] Info([String]$message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("INFO", $message, "Green")
  }
  [void] Warn([String]$message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("WARN", $message, "Magenta")
  }
  [void] Error([String]$message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("ERROR", $message, "Magenta")
  }
  [void] Fatal([string]$message) {
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("FATAL", $message, "Red")
  }

  [void] PrintOut([String]$level, [String]$message, $color) {
    $level = ([String]$level).PadRight(5)
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    if ($this.FileOutput) {
      Write-Output "[$($logger.GetDate())] $level | $message" >> $this.LogFilePath
    }
    if ($this.ConsoleOutput) {
      if ($null -eq $color) {
        Write-Host "[$($logger.GetDate())] $level | $message"
      } else {
        echo "|$color|"
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
        Invoke-RestMethod -Uri $uri -Method Post -Body $body -SkipCertificateCheck
      }
    }
  }
  [String] GetDate() {
    return Get-Date -format "yyyy-MM-dd HH:mm:ss"
  }
}
