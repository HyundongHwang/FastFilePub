<!-- TOC -->

- [FastFilePub](#fastfilepub)
- [소개](#소개)
- [설치](#설치)
- [초기화](#초기화)
- [파일 업로드](#파일-업로드)
- [blob 조회](#blob-조회)
- [blob 삭제](#blob-삭제)

<!-- /TOC -->

<br>
<br>
<br>

#FastFilePub

![](https://raw.githubusercontent.com/HyundongHwang/FastFilePub/master/FastFilePub-icon.png)

# 소개
- 아주 간단한 파일 업로드 스크립트
- Azure Storage Table, Blob 을 이용하기 때문에 사전에 Azure Storage Connection 을 설정해 주어야 함.
- 보안을 위해서 `https://fastfilepub.blob.core.windows.net/pub/{RANDOM-ID}/{FILE-NAME}` 형태로 url을 만들어줌.
- 한번 올라간 파일은 hash값을 계산해서 따로 저장하고 있기 때문에, 같은파일이 한번더 업로드 되면 같은파일의 url을 즉시 반환함.

# 설치

```powershell
PS> Install-Module fastfilepub
```

# 초기화

```powershell
PS> ffp-init "DefaultEndpointsProtocol=https;AccountName=fastfilepub;AccountKey=icAGEnuTjSO26H....G98H5LbSBNFEEKY4rA==;EndpointSuffix=core.windows.net"
```

# 파일 업로드

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

# blob 조회

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

# blob 삭제

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