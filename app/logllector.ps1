if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

$LISTENING_PORT = 7777

try {
	$listener = new-object Net.HttpListener
	$listener.Prefixes.Add("http://+:$LISTENING_PORT/")
	$listener.Start()
	echo "Server is running at port $LISTENING_PORT."

	while ($true)
	{
		$context = $listener.GetContext()
    $request = $context.Request

    Write-Host "Request: " -NoNewline
    if ($request.HttpMethod -eq "POST") {
      Write-Host "POST" -ForegroundColor Red -NoNewline
    } else {
      Write-Host "$($request.HttpMethod) " -ForegroundColor Blue -NoNewline
    }
    Write-Host "$($request.RawUrl) $($request.UserHostAddress)"

    if ($request.HttpMethod -eq "POST")
    {
      $context.Response.StatusCode = 201
      $content = [Text.Encoding]::UTF8.GetBytes("CREATED")

      [System.IO.Stream] $body = $request.InputStream

      if ($body -eq $null) {
        echo "empty body from $($request.UserHostAddress)."
        continue
      }

      [System.Text.Encoding] $encoding = [System.Text.Encoding]::UTF8
      [System.IO.StreamReader] $reader = New-Object System.IO.StreamReader($body, $encoding)
      $requestBody = $reader.ReadToEnd()


      echo "Request body: $requestBody"
    } else {
      $context.Response.StatusCode = 405
      $content = [Text.Encoding]::UTF8.GetBytes("METHOD NOT ALLOWED")
    }

    $stream = $context.Response.OutputStream
    $stream.Write($content, 0, $content.Length)
    $stream.Close()
	}
} catch {
	Write-Error $_.Exception
}
