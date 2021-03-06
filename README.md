<!-- TOC -->

- [FastFilePub](#fastfilepub)
- [Intro](#intro)
- [Install](#install)
- [Initialize](#initialize)
- [Upload file](#upload-file)
- [List blobs](#list-blobs)
- [Remove blobs](#remove-blobs)

<!-- /TOC -->

<br>
<br>
<br>

# FastFilePub
![](https://raw.githubusercontent.com/HyundongHwang/FastFilePub/master/FastFilePub-icon.png)

[한국어로 보기](/README-ko.md)

# Intro
- Very simple file upload script
- Azure Storage Table, Blob is used to set up Azure Storage Connection in advance.
- For security purposes, create url in the form `https://fastfilepub.blob.core.windows.net/pub/{RANDOM-ID}/{FILE-NAME}`.
- Once a file has been uploaded, it hash value is calculated and stored separately, so if the same file is uploaded more than once, the url of the same file is returned immediately.

# Install

```powershell
PS> Install-Module fastfilepub
```

# Initialize

```powershell
PS> ffp-init "DefaultEndpointsProtocol=https;AccountName=fastfilepub;AccountKey=icAGEnuTjSO26H....G98H5LbSBNFEEKY4rA==;EndpointSuffix=core.windows.net"
```

# Upload file

```powershell
PS> ffp-upload .\keep-canonical-history-correct.html

LocalFilePath                               BlobDownloadUrl
-------------                               ---------------
C:\temp\keep-canonical-history-correct.html https://fastfilepub.blob.core.windows.net/pub/Ceuretater/keep-canonical-history-correct.html
```

```powershell
PS> ffp-upload *.html

LocalFilePath                               BlobDownloadUrl
-------------                               ---------------
C:\temp\keep-canonical-history-correct.html https://fastfilepub.blob.core.windows.net/pub/Ceuretater/keep-canonical-history-correct.html
C:\temp\maintain-git.html                   https://fastfilepub.blob.core.windows.net/pub/TledtPular/maintain-git.html
C:\temp\manual.html                         https://fastfilepub.blob.core.windows.net/pub/EmateDhave/manual.html
C:\temp\new-command.html                    https://fastfilepub.blob.core.windows.net/pub/EsaximpEin/new-command.html
C:\temp\rebase-from-internal-branch.html    https://fastfilepub.blob.core.windows.net/pub/CeanSNnSte/rebase-from-internal-branch.html
C:\temp\rebuild-from-update-hook.html       https://fastfilepub.blob.core.windows.net/pub/BoxiacterK/rebuild-from-update-hook.html
C:\temp\recover-corrupted-blob-object.html  https://fastfilepub.blob.core.windows.net/pub/RaArdemand/recover-corrupted-blob-object.html
C:\temp\recover-corrupted-object-harder.... https://fastfilepub.blob.core.windows.net/pub/SerrummTed/recover-corrupted-object-harder....
C:\temp\revert-a-faulty-merge.html          https://fastfilepub.blob.core.windows.net/pub/ChescherAs/revert-a-faulty-merge.html
C:\temp\revert-branch-rebase.html           https://fastfilepub.blob.core.windows.net/pub/TrieLiJezr/revert-branch-rebase.html
```

# List blobs

```powershell
PS> ffp-list
https://fastfilepub.blob.core.windows.net/pub/BoxiacterK/rebuild-from-update-hook.html
https://fastfilepub.blob.core.windows.net/pub/CeanSNnSte/rebase-from-internal-branch.html
https://fastfilepub.blob.core.windows.net/pub/Ceuretater/keep-canonical-history-correct.html
https://fastfilepub.blob.core.windows.net/pub/ChescherAs/revert-a-faulty-merge.html
https://fastfilepub.blob.core.windows.net/pub/EmateDhave/manual.html
https://fastfilepub.blob.core.windows.net/pub/EsaximpEin/new-command.html
https://fastfilepub.blob.core.windows.net/pub/RaArdemand/recover-corrupted-blob-object.html
https://fastfilepub.blob.core.windows.net/pub/SerrummTed/recover-corrupted-object-harder.html
https://fastfilepub.blob.core.windows.net/pub/TledtPular/maintain-git.html
https://fastfilepub.blob.core.windows.net/pub/TrieLiJezr/revert-branch-rebase.html
```

# Remove blobs

```powershell
PS C:\temp> ffp-remove "*recover*"
https://fastfilepub.blob.core.windows.net/pub/RaArdemand/recover-corrupted-blob-object.html
https://fastfilepub.blob.core.windows.net/pub/SerrummTed/recover-corrupted-object-harder.html
Do you really remove these? [y/n]: y

PS C:\temp> ffp-list
https://fastfilepub.blob.core.windows.net/pub/BoxiacterK/rebuild-from-update-hook.html
https://fastfilepub.blob.core.windows.net/pub/CeanSNnSte/rebase-from-internal-branch.html
https://fastfilepub.blob.core.windows.net/pub/Ceuretater/keep-canonical-history-correct.html
https://fastfilepub.blob.core.windows.net/pub/ChescherAs/revert-a-faulty-merge.html
https://fastfilepub.blob.core.windows.net/pub/EmateDhave/manual.html
https://fastfilepub.blob.core.windows.net/pub/EsaximpEin/new-command.html
https://fastfilepub.blob.core.windows.net/pub/TledtPular/maintain-git.html
https://fastfilepub.blob.core.windows.net/pub/TrieLiJezr/revert-branch-rebase.html
```