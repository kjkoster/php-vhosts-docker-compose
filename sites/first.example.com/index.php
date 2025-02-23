<h1>First Example</h1>
<?php
echo "PHP Version: " . phpversion() . "<br>\n";
echo date(DATE_ISO8601, strtotime(date("Y-m-d H:i:s"))) . "<br>\n";
echo "Full Server Name: " . $_SERVER["SERVER_NAME"] . "\n";

?>
