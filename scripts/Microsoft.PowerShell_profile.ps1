# https://communities.vmware.com/people/gowatana/blog/2014/05/13/powercli-%E3%82%B3%E3%83%B3%E3%82%BD%E3%83%BC%E3%83%AB%E8%B5%B7%E5%8B%95%E3%81%A8%E5%90%8C%E6%99%82%E3%81%AB%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%82%92%E5%AE%9F%E8%A1%8C%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B

$log_dir = "c:\work\log"
$time_stamp = Get-Date -Format "yyyyMMddHHmmss"
$log_file = $log_dir + "\" + $Env:COMPUTERNAME + "_" + $Env:USERNAME + "_" + $time_stamp + ".log"
Start-Transcript $log_file
