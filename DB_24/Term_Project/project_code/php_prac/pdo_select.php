<html>
<head>
    <meta charset="UTF-8">
    <title>Database SQL : SELECT</title>
    <link rel="stylesheet" href="pdo_select.css">
</head>
<body>

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
    echo "Success connection to DB!";
    echo "<br><br>";

    // SQL Query : lookup foodname & price from Food table
    $sql = 'SELECT foodname, price FROM Food';
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table id='t1'>";
        echo "<tr>";
        echo "<th>음식이름</th>";
        echo "<th>가격</th>";
        echo "</tr>";

        // fetch data
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row['foodname'] . "</td><td>" . $row['price'] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }
} catch (Exception $e) {
    echo "Failed Connection: " . $e->getMessage();
}

// Disconnect DB
$conn->close();
?>

    <script src="pdo_select.js"></script>
</body>
</html>

