#echo $PROFILE



function No-Proxy {
<#
        .SYNOPSIS
            Disables proxy 

        .EXAMPLE
			No-Proxy
#> 
    [System.Environment]::SetEnvironmentVariable('https_proxy', '')

    [System.Environment]::SetEnvironmentVariable('http_proxy', '')
}
