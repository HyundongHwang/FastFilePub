# https://docs.microsoft.com/en-us/azure/storage/common/storage-powershell-guide-full
# https://blogs.technet.microsoft.com/paulomarques/2017/01/17/working-with-azure-storage-tables-from-powershell/



$global:G_STORAGE_CONTEXT = $null



<#
.SYNOPSIS
.EXAMPLE
#>
function ffp-write-log
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $NAME,

        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [object]
        $VALUE
    )



    if ($VALUE -eq $null) 
    {
        Write-Warning $NAME
    }
    else 
    {
        $valueStr = $VALUE | fl | Out-String
        Write-Warning "[$($VALUE.GetType())] $NAME : $valueStr"
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function ffp-module-install-import
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $MODULE_NAME
    )



    $module = Get-InstalledModule $MODULE_NAME

    if ($module -eq $null) 
    {
        ffp-write-log "$MODULE_NAME install ..."
        Install-Module $MODULE_NAME
        $module = Get-InstalledModule $MODULE_NAME
    }
    else 
    {
        # ffp-write-log "$MODULE_NAME update ..."
        # Update-Module $MODULE_NAME
    }

    ffp-write-log "$MODULE_NAME import ..."
    Import-Module $MODULE_NAME
}




<#
.SYNOPSIS
.EXAMPLE
PS> ffp-init -STORAGE_ACCOUNT_NAME blackboxandroid -STORAGE_ACCOUNT_KEY cZg2h0pMVDjDE...==
#>
function ffp-init
{
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $AZURE_STORAGE_CONNECTION_STR
    )

    $global:G_STORAGE_CONTEXT = New-AzureStorageContext -ConnectionString $AZURE_STORAGE_CONNECTION_STR
    return $global:G_STORAGE_CONTEXT
}



<#
.SYNOPSIS
.EXAMPLE
#>
function ffp-upload
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $FILE_NAME,

        [switch]
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        $KEEP_DIR_STRUCTURE
    )



    try 
    {
        $pubContainer = Get-AzureStorageContainer -Context $global:G_STORAGE_CONTEXT -Name pub    
    }
    catch 
    {
    }
    
    if($pubContainer -eq $null) 
    {
        ffp-write-log "pubContainer create ..."
        $pubContainer = New-AzureStorageContainer -Context $global:G_STORAGE_CONTEXT -Name pub -Permission Blob
    }
    
    try 
    {
        $pubHashUrlTable = Get-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubHashUrl
    }
    catch 
    {
    }
    
    if($pubHashUrlTable -eq $null)
    {
        $pubHashUrlTable = New-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubHashUrl
    }

    try 
    {
        $pubUrlHashTable = Get-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubUrlHash
    }
    catch 
    {
    }
    
    if($pubUrlHashTable -eq $null)
    {
        $pubUrlHashTable = New-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubUrlHash
    }

    
    
    ls $FILE_NAME -File -Force -Recurse | 
    foreach {
        $obj = New-Object -typename PSObject
        $obj | Add-Member -MemberType NoteProperty -Name LocalFilePath -Value $_.FullName
        $extName = [System.IO.Path]::GetExtension($_.Name)
        $blobName = ""

        if ($KEEP_DIR_STRUCTURE)
        {
            $idx = $_.FullName.IndexOf($FILE_NAME)
            $blobName = $_.FullName.Substring($idx)
        }
        else
        {
            $randomId = New-PronounceablePassword
            $blobName = "$randomId/$($_.Name)"
        }

        $hashStr = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
        $blobDownloadUrl = $null
        $row = $null

        try 
        {
            $row = Get-AzureStorageTableRowByColumnName -table $pubHashUrlTable -columnName RowKey -value $hashStr -operator Equal
        }
        catch 
        {
        }
    
        if ($row -eq $null)
        {
            if ($extName -eq ".html") 
            {
                $props = @{"ContentType" = "text/html"};
            }
            elseif ($extName -eq ".css") 
            {
                $props = @{"ContentType" = "text/css"};
            }
            elseif ($extName -eq ".js") 
            {
                $props = @{"ContentType" = "application/javascript"};
            }
            elseif ($extName -eq ".json") 
            {
                $props = @{"ContentType" = "application/json"};
            }
            elseif ($extName -eq ".xml") 
            {
                $props = @{"ContentType" = "application/xml"};
            }
            elseif ($extName -eq ".txt") 
            {
                $props = @{"ContentType" = "text/plain"};
            }
            elseif ($extName -eq ".text") 
            {
                $props = @{"ContentType" = "text/plain"};
            }
            elseif ($extName -eq ".jpg") 
            {
                $props = @{"ContentType" = "image/jpeg"};
            }
            elseif ($extName -eq ".jpeg") 
            {
                $props = @{"ContentType" = "image/jpeg"};
            }
            elseif ($extName -eq ".png") 
            {
                $props = @{"ContentType" = "image/png"};
            }
            elseif ($extName -eq ".gif") 
            {
                $props = @{"ContentType" = "image/gif"};
            }
            elseif ($extName -eq ".mp3") 
            {
                $props = @{"ContentType" = "audio/mpeg"};
            }
            elseif ($extName -eq ".mp4") 
            {
                $props = @{"ContentType" = "video/mp4"};
            }
            else 
            {
                $props = @{"ContentType" = "application/octet-stream"};
            }
        
            $blob = Set-AzureStorageBlobContent -Context $global:G_STORAGE_CONTEXT -Container pub -File $_.FullName -Blob $blobName -Force -Properties $props
            $blobDownloadUrl = $blob.ICloudBlob.Uri.AbsoluteUri.ToString()
            $blobDownloadUrlEnc = [System.Web.HttpUtility]::UrlEncode($blobDownloadUrl) 

            $unused = Add-StorageTableRow -table $pubHashUrlTable -partitionKey "partitionKey" -rowKey $hashStr -property @{
                "BlobDownloadUrl" = $blobDownloadUrl;
            }
    
            $unused = Add-StorageTableRow -table $pubUrlHashTable -partitionKey "partitionKey" -rowKey $blobDownloadUrlEnc -property @{
                "HashStr" = $hashStr;
            }
        }
        else 
        {
            $blobDownloadUrl = $row.BlobDownloadUrl
        }
    
        $obj | Add-Member -MemberType NoteProperty -Name BlobDownloadUrl -Value $blobDownloadUrl
        return $obj
    }
}




<#
.SYNOPSIS
.EXAMPLE
#>
function ffp-list
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $FILTER_STR
    )



    $blobList = Get-AzureStorageBlob -Context $global:G_STORAGE_CONTEXT -Container pub -Blob "*$FILTER_STR*"

    $blobList | 
    foreach {
        $blobDownloadUrl = $_.ICloudBlob.Uri.AbsoluteUri.ToString()
        return $blobDownloadUrl
    }
}




<#
.SYNOPSIS
.EXAMPLE
#>
function ffp-remove
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [string]
        $FILTER_STR
    )

    $blobList = Get-AzureStorageBlob -Context $global:G_STORAGE_CONTEXT -Container pub -Blob "*$FILTER_STR*"

    $blobList | 
    foreach {
        $blobDownloadUrl = $_.ICloudBlob.Uri.AbsoluteUri.ToString()
        return $blobDownloadUrl
    }

    if ($blobList.Length -eq 0) 
    {
        return
    }

    $res = Read-Host "Do you really remove these? [y/n]"
    
    if ($res -ne "y")
    {
        return
    }



    $pubHashUrlTable = Get-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubHashUrl
    $pubUrlHashTable = Get-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubUrlHash

    $blobList |
    foreach {
        try 
        {
            $blobDownloadUrl = $_.ICloudBlob.Uri.AbsoluteUri.ToString()
            $blobDownloadUrlEnc = [System.Web.HttpUtility]::UrlEncode($blobDownloadUrl) 
            $unused = Remove-AzureStorageBlob -Context $global:G_STORAGE_CONTEXT -Blob $_.Name -Container pub

            $urlHashRow = Get-AzureStorageTableRowByColumnName -table $pubUrlHashTable -columnName RowKey -value $blobDownloadUrlEnc -operator Equal
            $hashStr = $urlHashRow.HashStr
            $hashUrlRow = Get-AzureStorageTableRowByColumnName -table $pubHashUrlTable -columnName RowKey -value $hashStr -operator Equal
            $unused = Remove-AzureStorageTableRow -table $pubUrlHashTable -partitionKey partitionKey -rowKey $blobDownloadUrlEnc
            $unused = Remove-AzureStorageTableRow -table $pubHashUrlTable -partitionKey partitionKey -rowKey $hashStr
        }
        catch
        {
        }
    }
}



ffp-module-install-import MlkPwgen
ffp-module-install-import AzureRmStorageTable
Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\System.Web.dll"



# function ffp-debug-remove-all-containers-tables
# {
#     Remove-AzureStorageContainer -Context $global:G_STORAGE_CONTEXT -Name pub
#     Remove-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubUrlHash
#     Remove-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubHashUrl
# }



# function ffp-debug-list-all-blobs-rows
# {
#     Get-AzureStorageBlob -Context $global:G_STORAGE_CONTEXT -Container pub

#     $pubHashUrlTable = Get-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubHashUrl
#     Get-AzureStorageTableRowAll -table $pubHashUrlTable

#     $pubUrlHashTable = Get-AzureStorageTable -Context $global:G_STORAGE_CONTEXT -Name pubUrlHash
#     Get-AzureStorageTableRowAll -table $pubUrlHashTable
# }