function is_hhvm() {
    return defined('HHVM_VERSION');
}

if (is_hhvm()) {
    echo HHVM is working\n;
} else {
    echo HHVM is not working\n;
}
