# https://communities.vmware.com/people/gowatana/blog/2013/12/25/powercli-%E3%81%A7%E3%81%AE-vm-%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88%E7%A2%BA%E8%AA%8D%E3%81%A8%E7%A7%BB%E5%8B%95%E6%96%B9%E6%B3%95

$template_name = $args[0]
$hv_name = $args[1]
$vm = Set-Template -Template $template_name -ToVM
$vm | Move-VM -Destination (Get-VMHost $hv_name)
$vm | Set-VM -ToTemplate -Confirm:$false
