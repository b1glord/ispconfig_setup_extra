<?php
function is_hhvm() {
    return defined('HHVM_VERSION');
}

if (is_hhvm()) {
    echo HHVM is working\n;
} else {
    echo HHVM is not working\n;
}
?>

<?php
if (defined('HHVM_VERSION')) {
 echo 'Hip Hop Virtual Machine is working';
}
else {
echo 'Hip Hop Virtual Machine is not working';
}
?>
