# https://communities.vmware.com/people/gowatana/blog/2014/02/02/esxi-%E3%83%87%E3%83%BC%E3%82%BF%E3%82%B9%E3%83%88%E3%82%A2%E3%81%B8%E3%81%AE-vm-%E9%85%8D%E7%BD%AE%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6-%E7%A9%BA%E3%81%8D%E5%AE%B9%E9%87%8F%E3%81%A8-iops-%E3%82%92%E8%A6%8B%E3%81%A6%E3%81%BF%E3%82%8B

$stat_counter = "datastore.numberwriteaveraged.average","datastore.numberreadaveraged.average"
# 統計情報を取得
$stat = Get-VMHost | Get-Stat -Realtime -Stat $stat_counter | sort Timestamp
$stat | group MetricId,Instance,Unit | % { 
    $stat_name = $_.Name
    $stat_gr = $_.Group
    # データストア名を取得
    $ds_id = ($stat_gr | select Instance -Unique).Instance
    $ds_name = (Get-Datastore | where {$_.ExtensionData.Summary.Url -like ("*"+ $ds_id +"*")} | select -Unique).Name
    # 統計名を取得
    $metric_name = ($stat_gr | select MetricId -Unique).MetricId
    # 取得した統計情報の期間を取得（1時間）
    $stat_time_sort = $stat_gr | sort Timestamp
    $begin_time = $stat_time_sort | select Timestamp -First 1
    $begin_time = $begin_time.Timestamp.toString("HH:mm:ss")
    $end_time   = $stat_time_sort | select Timestamp -Last 1
    $end_time   = $end_time.Timestamp.toString("HH:mm:ss")
    
    $stat_gr | measure -Property Value -Average -Sum -Maximum -Minimum |
    select `
        @{N="Datastore";E={$ds_name}},
        @{N="Metric";E={$metric_name}},
        Count,
        @{N="Average";E={"{0:0.00}" -F [math]::Round($_.Average,2)}},
        Sum,
        Maximum,
        Minimum,
        @{N="Begin";E={$begin_time}},
        @{N="End";E={$end_time}}
}
