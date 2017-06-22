# https://communities.vmware.com/people/gowatana/blog/2013/08/06/powercli-%E3%81%A7-esxi%E3%81%AEcpu%E3%82%AA%E3%83%BC%E3%83%90%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88-%E8%A6%8B%E3%81%88%E3%82%8B%E5%8C%96

Get-VMHost | % {
    $hv = $_
    $hv_pcpu = $hv.NumCpu
    $hv_vcpus = 0
    $hv | Get-VM | where {$_.PowerState -eq "PoweredOn"} | % {
        $vm = $_
        $hv_vcpus += $vm.NumCpu
    }
    "$hv では、 $hv_pcpu 物理コアに $hv_vcpus vCPUあります。"
    "CPU物理コアのオーバーコミット: " + ($hv_vcpus / $hv_pcpu * 100) + "%"
    "vCPU: " + ("■" * $hv_vcpus)
    "pCPU: " + ("□" * $hv_pcpu)
} | ft -AutoSize
