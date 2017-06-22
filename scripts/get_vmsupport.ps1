# https://communities.vmware.com/people/gowatana/blog/2013/10/25/powercli-%E3%81%A7-esxi-%E3%83%AD%E3%82%B0%E3%83%90%E3%83%B3%E3%83%89%E3%83%AB%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B%E3%81%A8%E3%81%8D%E3%81%AE%E5%B7%A5%E5%A4%AB

$hv_list = $args[0]
$log_dir = "C:\work\logs" #★保存先フォルダはここ
$hvs = Get-VMHost $hv_list
$hvs | % {
    $hv = $_
    $hv_name = $hv.Name
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"

    # ESXiのログバンドルファイル（vm-support）取得
    $info = $hv | Get-Log -Bundle -DestinationPath $log_dir

    # ESXiのログバンドルファイルの（vm-support）取得
    $info | select @{N="ESXi";E={$_.Host}},
      @{N="VmSupportFile";E={$_.Data.Name}},
      @{N="FileSize";E={$_.Data.Length}} | 
      ft -AutoSize | Out-String

    # vm-supportのファイル名を変更
    $org_name = $log_dir + "\" + $info.Data.Name
    $new_name = $log_dir + "\" + "vmsupport_" + $hv_name + "_" + $timestamp + ".tgz"
    $info = $null
    "ログバンドル名： " + $new_name
    mv $org_name $new_name
}
