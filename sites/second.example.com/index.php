<h1>Second Example</h1>
<?php
echo "PHP Version: " . phpversion() . "<br>\n";
echo date(DATE_ISO8601, strtotime(date("Y-m-d H:i:s"))) . "<br>\n";
echo "Full Server Name: " . $_SERVER["SERVER_NAME"] . "<br>\n";
echo "Connecting to " . getenv("MYSQL_USER") . "@" . getenv("MYSQL_HOST");


?>
