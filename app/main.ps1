.".\app\logger.ps1"

chcp 65001
Clear-Host

$logger = [Logger]::new()

$logger.Debug("デバグ用ロガー")
$logger.Info("情報用ロガー")
$logger.Warn("警告用ロガー")
$logger.Error("エラー用ロガー")
$logger.Fatal("致命的エラー用ロガー")
