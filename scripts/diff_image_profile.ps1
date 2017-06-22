# https://communities.vmware.com/people/gowatana/blog/2014/01/26/esxi-5x-%E3%83%91%E3%83%83%E3%83%81-%E3%82%AA%E3%83%95%E3%83%A9%E3%82%A4%E3%83%B3%E3%83%90%E3%83%B3%E3%83%89%E3%83%AB%E3%81%AEvib%E6%AF%94%E8%BC%83%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E4%BD%9C%E3%81%A3%E3%81%A6%E3%81%BF%E3%81%BE%E3%81%97%E3%81%9F

# オフラインバンドルに含まれるイメージプロファイルの差分を表示する。
# 【実行方法】
# PowerCLI> .\diff_image_profile.ps1 ＜OfflineBundle1.zip＞,＜OfflineBundle2.zip＞,...
 
$same_version = "SAME_VERSION" #"同一バージョン"
$no_vib = "NOT_INCLUDED" #"なし"
 
# ソフトウェアデポを初期化してからオフラインバンドル登録
Get-EsxSoftwareDepot | Remove-EsxSoftwareDepot
Add-EsxSoftwareDepot $args[0]
 
$profile_set = Get-EsxImageProfile | sort Name
$profile_set | ft -AutoSize | Out-String
$prof1_name = Read-Host -Prompt "比較するイメージプロファイル1"
$prof2_name = Read-Host -Prompt "比較するイメージプロファイル2"
 
$prof1 = $profile_set | where {$_.Name -eq $prof1_name}
$prof2 = $profile_set | where {$_.Name -eq $prof2_name}
$vib_list = $prof1.VibList + $prof2.VibList | select Name -Unique | sort
$diff_list = $vib_list | % {
    $vib_name = $_.Name
    $prof1_vib_ver = ($prof1.VibList | where {$_.Name -eq $vib_name}).Version
    $prof2_vib_ver = ($prof2.VibList | where {$_.Name -eq $vib_name}).Version
    if($prof1_vib_ver -eq $prof2_vib_ver){$prof2_vib_ver = $same_version}
    if($prof1_vib_ver -eq $null){$prof1_vib_ver = $no_vib}
    if($prof2_vib_ver -eq $null){$prof2_vib_ver = $no_vib}
    $_ | select Name,@{N="$prof1_name";E={$prof1_vib_ver}},@{N="$prof2_name";E={$prof2_vib_ver}}
}
# 比較結果を表示
$diff_list | sort Name | ft -AutoSize | Out-String
 
# ソフトウェアデポから登録解除
Get-EsxSoftwareDepot | Remove-EsxSoftwareDepot
