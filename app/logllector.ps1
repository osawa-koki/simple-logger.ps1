if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

try {
	$listener = new-object Net.HttpListener
	$listener.Prefixes.Add("http://+:7777/")
	$listener.Start()
	echo "Server is running at port 7777"

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
		$path = $context.Request.Url.AbsolutePath
		if ($path.EndsWith("/")) {
			$path += "index.html"
		}
		$filepath = join-path (get-location) $path
		$exists = [IO.File]::Exists($filepath)
		echo "$($path) --> $($filepath) [$($exists)]"
		if ($exists) {
			$extension = [IO.Path]::GetExtension($filepath)
			$context.Response.ContentType = ContentType($extension)
			$rstream = [IO.File]::OpenRead($filepath)
			$stream = $context.Response.OutputStream
			$rstream.CopyTo($stream)
			$stream.Close()
			$rstream.Dispose()
		} else {
			$context.Response.ContentType = "text/html"
			$context.Response.StatusCode = 404
			$content = [Text.Encoding]::UTF8.GetBytes("File Not Found")
			$stream = $context.Response.OutputStream
			$stream.Write($content, 0, $content.Length)
			$stream.Close()
		}
	}
} catch {
	Write-Error $_.Exception
}
