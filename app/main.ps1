.".\app\logger.ps1"

chcp 65001
# Clear-Host

$logger = [Logger]::new($true, $true, $true)
# $logger = [Logger]::new()

$logger.SetHttpPostUri("http://127.0.0.1:7777/")
# $logger.SetEmittingLevel([LoggerLevel]::Error)

# $logger.Hello("")
$logger.Debug("")

# $logger.Debug("デバグ用ロガー")
# $logger.Info("情報用ロガー")
# $logger.Warn("警告用ロガー")
# $logger.Error("エラー用ロガー")
# $logger.Fatal("致命的エラー用ロガー")

# $debug = [Debug]::new()
# $debug.SetHttpPostUri("http://osawa.com")
# $debug.Hello()
