<?php
	// session 정보 가져오기
	session_start();

	// db 연결파일 가져오기
	include 'db_connect.php';

	// 현재 가장 큰 cartId를 찾기
  $sql_max_cartid = "SELECT MAX(id) AS max_cartid FROM Cart";
  $result = $conn->query($sql_max_cartid);
  if ($result->num_rows > 0) {
      $row = $result->fetch_assoc();
      $new_cartid = $row['max_cartid'] + 1;
  } else {
      $new_cartid = 1; // 테이블이 비어있는 경우 cartId를 1로 설정
  }

	// 장바구니 정보를 order_history로 옮기기 == cartid를 0이 아닌 값으로 변경
	$sql_update_cartid = "UPDATE Cart SET id='$new_cartid' WHERE id = 0";

	if ($conn->query($sql_update_cartid) === TRUE) {
		echo "<script>alert('결제가 완료되었습니다!');</script>";
		echo "<script>window.location.href = './page/main.php';</script>";
	}
	else {
     echo "Error: " . $sql_update_cartid . "<br>" . $conn->error;
	}
?>

</body>
</html>


