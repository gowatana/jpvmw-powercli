# https://communities.vmware.com/people/gowatana/blog/2013/03/09/cpu%E3%82%A2%E3%83%95%E3%82%A3%E3%83%8B%E3%83%86%E3%82%A3%E8%A8%AD%E5%AE%9A%E3%82%92powercli%E3%81%A7%E7%A2%BA%E8%AA%8D%E3%81%99%E3%82%8B-esxi-5x

$vms = $args[0]
 
# CPUアフィニティ ON/OFF の表示設定
$on  = "[on]"
$off = "[__]"
 
Get-VM $vms | sort -Property VMHost,Name | % {
    # CPUアフィニティ情報格納テーブルを作成
    $cpuset = "" | select hvname,vmname,cnt,
    cpu00,cpu01,cpu02,cpu03,cpu04,cpu05,cpu06,cpu07

    # ESXi名とVM名を取得
    $cpuset.hvname = $_.VMHost
    $cpuset.vmname = $_.Name
    $cpuset.cnt = $_.NumCpu
  
    # CPUアフィニティ情報を取得
    $vm = $_ | Get-View
    $vcpus = $vm.Config.CpuAffinity.AffinitySet
  
    $cpuset.cpu00 =  if ($vcpus -notcontains 0) {$off} else {$on}
    $cpuset.cpu01 =  if ($vcpus -notcontains 1) {$off} else {$on}
    $cpuset.cpu02 =  if ($vcpus -notcontains 2) {$off} else {$on}
    $cpuset.cpu03 =  if ($vcpus -notcontains 3) {$off} else {$on}
    $cpuset.cpu04 =  if ($vcpus -notcontains 4) {$off} else {$on}
    $cpuset.cpu05 =  if ($vcpus -notcontains 5) {$off} else {$on}
    $cpuset.cpu06 =  if ($vcpus -notcontains 6) {$off} else {$on}
    $cpuset.cpu07 =  if ($vcpus -notcontains 7) {$off} else {$on}
  
    # 結果を表示
    $cpuset
} | ft * -AutoSize
