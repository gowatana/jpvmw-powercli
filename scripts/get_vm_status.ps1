# https://communities.vmware.com/people/gowatana/blog/2014/04/13/vm-%E3%81%AE-%E3%82%A2%E3%83%A9%E3%83%BC%E3%83%A0%E3%82%92-powercli-%E3%81%A7%E8%A6%8B%E3%81%A6%E3%81%BF%E3%82%8B

$vms = $args[0]
$vms | % {
  $vm =$_
  $alarm = $vm.ExtensionData.TriggeredAlarmState | sort Time -Descending | select -First 1
  $alarm_id = $alarm.Alarm
  $alarm_name = if($alarm_id -ne $null){Get-AlarmDefinition -Id $alarm_id}
  $vm | select `
    Name,
    @{N="Status";E={$_.ExtensionData.OverallStatus}},
    @{N="Alarm";E={$alarm_name}}
} | sort Name | ft -AutoSize
