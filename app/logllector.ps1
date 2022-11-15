if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

$LISTENING_PORT = 7777

try {
	$listener = new-object Net.HttpListener
	$listener.Prefixes.Add("http://+:$LISTENING_PORT/")
	$listener.Start()
	echo "Server is running at port $LISTENING_PORT."

	function ContentType ($ext)
	{
		switch ($ext)
		{
			".html" { "text/html" }
			".js" { "text/javascript" }
			".css" { "text/css" }
			".json" { "application/json" }
			".xml" { "text/xml" }
			".gif" { "image/gif" }
			".ico" { "image/x-icon" }
			".jpg" { "image/jpeg" }
			".png" { "image/png" }
			".svg" { "image/svg+xml" }
			".webp" { "image/webp" }
			".zip" { "application/zip" }
			".webp" { "image/webp" }
			Default { "text/plain" }
		}
	}

	while ($true)
	{
		$context = $listener.GetContext()
    $context.Response.StatusCode = 201
    $request = $context.Request

    echo "Request: $($request.HttpMethod) $($request.RawUrl) $($request.UserHostAddress)"

    $content = [Text.Encoding]::UTF8.GetBytes("CREATED")
    $stream = $context.Response.OutputStream
    $stream.Write($content, 0, $content.Length)
    $stream.Close()
	}
} catch {
	Write-Error $_.Exception
}
