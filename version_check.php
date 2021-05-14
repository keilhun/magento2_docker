<?php 
if (version_compare($argv[1], $argv[2], '>=')) 
    echo 1;
else
    echo 0;
?>