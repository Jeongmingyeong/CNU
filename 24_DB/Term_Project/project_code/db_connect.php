<?php
	// info about MySQL DB connection
	$host = 'localhost'; // DB host
	$username = 'dt202102699'; // user name
	$password = 'jmink021120!!'; // password
	$database = 'term_project'; // DB name
	
	try {
	    // create MySQLi connection
	    $conn = new mysqli($host, $username, $password, $database);
	
	    // check connection
	    if ($conn->connect_error) {
	        throw new Exception("Connection failed: " . $conn->connect_error);
	    }
	} catch (Exception $e) {
	    echo "Failed Connection: " . $e->getMessage();
	}
?>

</body>
</html>


