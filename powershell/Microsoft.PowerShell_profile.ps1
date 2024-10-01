#echo $PROFILE


Import-Module -Name Terminal-Icons

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

#Import-Module posh-sshell
#Import-Module oh-my-posh
#Set-PoshPrompt -Theme paradox
#Set-PoshPrompt -Theme bubbles
#Set-PoshPrompt
# Get-PoshThemes
#Set-PoshPrompt -Theme marcduiker
Set-PoshPrompt -Theme paradox


function Add-To-Path  {
<#
        .SYNOPSIS
            Adds directory to the PATH environment variables

        .EXAMPLE
			Add-To-Path Path-To-Add
#> 
       Param(
        [Parameter(Mandatory=$true)]
        [String]$PathToAdd
    )
    $env:Path += ";$PathToAdd"
}


function Reload-Env {
<#
        .SYNOPSIS
            Reloads env variables 

        .EXAMPLE
			Reload-Env
#> 
    refreshenv
}



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

function Set-PgPass {
<#
        .SYNOPSIS
            SET psql PGPASS ENV variable

        .EXAMPLE
            Set-PgPass 
#>
Param(
        [Parameter(Mandatory=$true)]
        [String]$Password
    )
    Add-To-Path "C:\Program Files\PostgreSQL\14\bin\"
    [System.Environment]::SetEnvironmentVariable('PGPASSWORD', $Password)
    [System.Environment]::SetEnvironmentVariable('PGUSER', 'postgres')
}


function Qemu-Shell {
<#
        .SYNOPSIS
            Add Qemu and NASM to PATH

        .EXAMPLE
            Qemu-Shell
#>
    Add-To-Path "C:\Program Files\qemu\"
	Add-To-Path "C:\Program Files\NASM"
    # qemu-system-i386.exe -hda .\print-hello-bios -S -s
    # -s == -gdb tcp::1234 
    # target remote tcp::1234
    # br *0x7c00 c
    # layout asm
    # # # https://stackoverflow.com/questions/32955887/how-to-disassemble-16-bit-x86-boot-sector-code-in-gdb-with-x-i-pc-it-gets-tr/32960272
    #https://superuser.com/questions/988473/why-is-the-first-bios-instruction-located-at-0xfffffff0-top-of-ram
    #https://web.archive.org/web/20150901145101/http://www.drdobbs.com/parallel/booting-an-intel-architecture-system-par/232300699?pgno=2
}



function Add-Github-Key {
<#
        .SYNOPSIS
            Add public github key 

        .EXAMPLE
			No-Proxy
#> 
    Add-SshKey C:\Users\rabliyev\.ssh\id_ed25519
}



function Parse-Etl  {
<#
        .SYNOPSIS
            This Function parses a given ETL file 

        .EXAMPLE
            Parse-Etl trace001.etl
			Parse-Etl trace001.etl c:\temp\path-to\driver.pdb
#>    
    Param(
        [Parameter(Mandatory=$true)]
        [String]$TraceFileName,
		
		[String]$PathToPdb
    )
	$Env:TRACE_FORMAT_PREFIX='%1!s! %!FUNC! %4!s!  %3! 8d!  '
	$etl_file_with_path=$TraceFileName
	$etl_file=Split-Path -Path $etl_file_with_path -Leaf
	$etl_path=Split-Path -Path $etl_file_with_path
	$out_dir=Join-Path -Path out -ChildPath $etl_path
	
	
	if ([string]::IsNullOrEmpty($PathToPdb)) {
		$pdb_parameter = ''
	} else {
		if (($PathToPdb).IndexOf('.pdb') -ne -1 )  {	
			$pdb_file = $PathToPdb
		} else {
# Release or Debug		
			$pdb_file="Once something was here"
		}
		$pdb_parameter="-pdb $pdb_file"
	}
#	Echo "PDB $pdb_parameter"
	New-Item -Path . -Name $out_dir -ItemType "directory" -Force
	Start-Process "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\tracefmt.exe" -Verbose -Wait  -NoNewWindow -PassThru  -ArgumentList "$etl_file_with_path $pdb_parameter -nosummary -o $out_dir\$etl_file.txt"
}


function Parse-Etl-Ifr  {
<#
        .SYNOPSIS
            This Function parses a given ETL file 

        .EXAMPLE
            Parse-Etl trace001.etl
			Parse-Etl trace001.etl c:\temp\path-to\driver.pdb
#>    
    Param(
        [Parameter(Mandatory=$true)]
        [String]$TraceFileName,
		
		[String]$PathToPdb
    )
	$Env:TRACE_FORMAT_PREFIX='%1!s! %!FUNC! '
	$etl_file_with_path=$TraceFileName
	$etl_file=Split-Path -Path $etl_file_with_path -Leaf
	$etl_path=Split-Path -Path $etl_file_with_path
	$out_dir=Join-Path -Path out -ChildPath $etl_path
	
	if ([string]::IsNullOrEmpty($PathToPdb)) {
		$pdb_parameter = ''
	} else {
		if (($PathToPdb).IndexOf('.pdb') -ne -1 )  {	
			$pdb_file = $PathToPdb
		} else {
# Release or Debug		
			$pdb_file="$PathToPdb\your-pdb.pdb"
		}
		$pdb_parameter="-pdb $pdb_file"
	}
#	Echo "PDB $pdb_parameter"
	New-Item -Path . -Name $out_dir -ItemType "directory" -Force
	Start-Process "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\tracefmt.exe" -Verbose -Wait  -NoNewWindow -PassThru  -ArgumentList "$etl_file_with_path $pdb_parameter -nosummary -o $out_dir\$etl_file.txt"
}

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







function ll { Get-ChildItem -Path $pwd -File }
function reload-profile {
        & $profile
}
function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
                Write-Output "${place_path}\${_}"
        }
}
function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function grep($regex, $dir) {
        if ( $dir ) {
                Get-ChildItem $dir | select-string $regex
                return
        }
        $input | select-string $regex
}
function touch($file) {
        "" | Out-File $file -Encoding ASCII
}
function df {
        get-volume
}
function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
        set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
        Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
        Get-Process $name
}

#function make-link ($target, $link) {
function make-link {
	 Param(
        [Parameter(Mandatory=$true)]
        [String]$LinkName,
		
		[Parameter(Mandatory=$true)]
		[String]$TargetName
    )
    New-Item -Path $LinkName -ItemType SymbolicLink -Value $TargetName
}

