# https://communities.vmware.com/people/gowatana/blog/2013/03/31/powercli%E3%81%A7esxi%E3%83%95%E3%82%A1%E3%82%A4%E3%82%A2%E3%82%A6%E3%82%A9%E3%83%BC%E3%83%AB%E3%82%92%E8%A8%AD%E5%AE%9A%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B

# 設定変更するルールセット名を指定
$ruleset_name = $args[0]
 
# リストから ESXi の一覧を読み込む
$hvs   = Get-Content $args[1]
 
# CSV から通信許可するネットワーク（IP）を読み込む
$rules = Import-Csv $args[2]
 
# 通信許可するネットワーク（IP）数を指定している。
$rule_num = $rules.Count
 
# FW 設定の準備
$spec = New-Object VMware.Vim.HostFirewallRulesetRulesetSpec
$spec.allowedHosts = New-Object VMware.Vim.HostFirewallRulesetIpList
$spec.allowedHosts.ipNetwork = New-Object VMware.Vim.HostFirewallRulesetIpNetwork[]($rule_num)
$cnt = 0
$rules | sort | % {
    $spec.allowedHosts.ipNetwork[$cnt] = New-Object VMware.Vim.HostFirewallRulesetIpNetwork
    $spec.allowedHosts.ipNetwork[$cnt].network = $_.network
    $spec.allowedHosts.ipNetwork[$cnt].prefixLength = $_.prefixLength
    $cnt = $cnt + 1
}
$spec.allowedHosts.allIp = $false
 
# ESXi に FW 設定
$hvs | sort | % {
    $fw = Get-View (Get-VMHost $_ | Get-View).ConfigManager.FirewallSystem
    $fw.UpdateRuleset($ruleset_name, $spec)
}
