
# defining the log emitting level.
# having 5 levels: Debug, Info, Warning, Error, Fatal
# following the log4net's log level.
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
  # defining class constructor.
  # as primary constructor, accepting 3 parameters.
  # 1st parameter: whether to output log to file or not.
  # 2nd parameter: whether to output log to console or not.
  # 3rd parameter: whether to output log as http request or not.
  # to describe in short, make it omit some parameters overloading constructor.
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

  # defining class properties.
  # 1st property: whether to output log to file or not.
  # 2nd property: whether to output log to console or not.
  # 3rd property: whether to output log as http request or not.
  # default value is as down below.
  # 1st property(file output): true
  # 2nd property(console output): true
  # 3rd property(http output): false
  [Boolean] $FileOutput = $true
  [Boolean] $ConsoleOutput = $true
  [Boolean] $HttpOutput = $false

  # defining class methods which change the emitting mode.
  # changer can be used as one by one method.
  [void] ChangeFileOutputMode([Boolean]$mode) {
    $this.FileOutput = $mode
  }
  [void] ChangeConsoleOutputMode([Boolean]$mode) {
    $this.ConsoleOutput = $mode
  }
  [void] ChangeHttpOutputMode([Boolean]$mode) {
    $this.HttpOutput = $mode
  }

  # defining class methods which emit log.
  # LogFilePath is a path to log file.
  # HttpPostUri is a uri to post log.
  [String] $LogFilePath = ".\.log"
  [String] $HttpPostUri = $null

  # defining class methods which changes where to emit log.
  # can be used as one by one method.
  [void] SetLogFilePath([String]$path) {
    $this.LogFilePath = $path
  }
  [void] SetHttpPostUri([String]$uri) {
    $this.SetHttpPostUri = $uri
  }

  # here, you can change the log level.
  # default value is LoggerLevel.All
  # LoggerLevel.All means all levels of log will be emitted.
  # It's following the log4net's log level.
  [LoggerLevel] $EmittingLevel = [LoggerLevel]::All
  [void] SetEmittingLevel([LoggerLevel]$level) {
    $this.EmittingLevel = $level
  }

  # defining class methods which emit log.
  # this can be used from outside of this class.
  # It's following the log4net's log level.
  # having 5 logger levels to emit log.
  # 1st level: Debug
  # 2nd level: Info
  # 3rd level: Warning
  # 4th level: Error
  # 5th level: Fatal
  # if you want to emit log, you can use this method.
  # this method is public, so you can use this method from outside of this class.
  # if current emitting level is higher than the level of the log you want to emit, the log will be emitted.
  # if current emitting level is lower than the level of the log you want to emit, the log will not be emitted.
  [void] Debug([String]$message) {
    if ([int]$this.EmittingLevel -lt [int][LoggerLevel]::Debug) {
      return
    }
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("DEBUG", $message, $null)
  }
  [void] Info([String]$message) {
    if ([int]$this.EmittingLevel -lt [int][LoggerLevel]::Info) {
      return
    }
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("INFO", $message, "Green")
  }
  [void] Warn([String]$message) {
    if ([int]$this.EmittingLevel -lt [int][LoggerLevel]::Warn) {
      return
    }
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("WARN", $message, "Magenta")
  }
  [void] Error([String]$message) {
    if ([int]$this.EmittingLevel -lt [int][LoggerLevel]::Error) {
      return
    }
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("ERROR", $message, "Magenta")
  }
  [void] Fatal([string]$message) {
    if ([int]$this.EmittingLevel -lt [int][LoggerLevel]::Fatal) {
      return
    }
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)
    $logger.PrintOut("FATAL", $message, "Red")
  }

  # defining class methods which emit log.
  # this method is private, and can't be used from outside of this class.
  [void] PrintOut([String]$level, [String]$message, $color) {
    $level = ([String]$level).PadRight(5)
    $logger = [Logger]::new($this.FileOutput, $this.ConsoleOutput, $this.HttpOutput)

    # if class property of FileOutput is true, the log will be emitted to file.
    if ($this.FileOutput) {
      Write-Output "[$($logger.GetDate())] $level | $message" >> $this.LogFilePath
    }

    # if class property of ConsoleOutput is true, the log will be emitted to console.
    # coloring according to the log level.
    # default color for debug level.
    # color with green for info level.
    # color with magenta for warn and error level.
    # color with red for fatal level.
    if ($this.ConsoleOutput) {
      if ($null -eq $color) {
        Write-Host "[$($logger.GetDate())] $level | $message"
      } else {
        Write-Host "[$($logger.GetDate())] $level | $message" -ForegroundColor $color
      }
    }

    # if class property of HttpOutput is true, the log will be emitted as http request.
    # to emit log as http request, you have to set the uri to post log.
    # you can set the uri by using SetHttpPostUri method.
    # otherwise, the log will not be emitted as http request.
    # be careful that if http uri is not be set, it would be ignored without making any error.
    if ($this.HttpOutput) {
      $uri = $this.HttpPostUri
      if ($null -eq $uri) {
        Write-Error "HttpPostUri is not set."
      } else {
        # if HttpOutput is true, and HttpPostUri is set, the log will be emitted as http request.
        # using Invoke-RestMethod to emit log as http request.
        $body = @{
          "level" = $level
          "message" = $message
        }
        $body = $body | ConvertTo-Json
        Invoke-RestMethod -Uri $uri -Method Post -Body $body -SkipCertificateCheck
      }
    }
  }

  # defining class methods which returns current date.
  [String] GetDate() {
    return Get-Date -format "yyyy-MM-dd HH:mm:ss"
  }
}
