<?php 

$operator = $argv[3] ?? '>=';
if (version_compare($argv[1], $argv[2],$operator)) 
    echo 1;
else
    echo 0;
?>