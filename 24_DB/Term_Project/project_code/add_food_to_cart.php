<?php
session_start();
include './db_connect.php';

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $foodname = $_POST['foodname'];
    $quantity = $_POST['quantity'];
    $userid = $_SESSION['user_id'];

	  // 현재 가장 큰 itemno를 찾기
	  $sql_max_itemno = "SELECT MAX(itemno) AS max_itemno FROM OrderDetail";
	  $result = $conn->query($sql_max_itemno);
	  if ($result->num_rows > 0) {
	      $row = $result->fetch_assoc();
	      $new_itemno = $row['max_itemno'] + 1;
	  } else {
	      $new_itemno = 1; // 테이블이 비어있는 경우 itemno를 1로 설정
	  }

    // 장바구니에 추가하는 SQL 쿼리 (주문 한번에 대한 정보 저장 -> 결제 버튼 클릭 시에는 Cart table에 저장)
		$create_cart_sql = "INSERT INTO CART (cno, id, orderDateTime) VALUES ('$userid', 0, NOW())";

		// 장바구니에 추가하고자 하는 음식이 이미 존재한다면, 새로 정보를 추가하는 것이 아닌 그 음식의 수량을 update
		$isExistFood_sql = "SELECT COUNT(*) AS cnt 
												FROM OrderDetail od
												WHERE od.foodname = '$foodname' AND od.id = 0;";
		
		$res_q = $conn->query($isExistFood_sql);
		$isExistFood = ($res_q && $res_q->num_rows > 0 && $res_q->fetch_assoc()['cnt'] > 0) ? 1 : 0; // cnt로 접근시의 값이 0이면 존재x, 0이 아니면 존재o
		if($isExistFood === 0) {
			// 장바구니에 존재하지 않는 음식이므로 insert
			$create_orderDetail_sql = "INSERT INTO OrderDetail (itemno, id, quantity, totalPrice, foodName) VALUES 
																('$new_itemno',
																 0, 
																 '$quantity', 
																 (SELECT price FROM Food WHERE foodName = '$foodname') * '$quantity', 
																 '$foodname')";
		} else {
			// 장바구니에 존재하는 음식이므로 quantity만 update
			$create_orderDetail_sql = "UPDATE OrderDetail 
																 SET quantity = quantity + '$quantity',
																 totalPrice = totalPrice + ((SELECT price FROM Food WHERE foodName = '$foodname') * '$quantity')
																 WHERE foodname = '$foodname' AND id = 0";
		}

		// 장바구니에 음식이 있어 0번 cart(결제 전 장바구니)가 활성되어있는지 확인
		$check_sql = "SELECT COUNT(*) AS cnt FROM CART c WHERE c.id = 0";
		$res = $conn->query($check_sql);
		$isActivate = ($res && $res->num_rows > 0 && $res->fetch_assoc()['cnt'] > 0) ? 1 : 0;

		if($isActivate === 1) {
			// 활성화되어있으면 orderdetail만 추가
			if($conn->query($create_orderDetail_sql) === TRUE) {
				echo "<script>alert('장바구니에 추가되었습니다!');</script>";
				echo "<script>window.location.href = './page/main.php';</script>";
			}
			else {
	       echo "Error: " . $create_orderDetail_sql . "<br>" . $conn->error;
			}
		} else {
			// 활성화되어있지 않기 때문에 Cart도 만들어줌.
	    if ($conn->query($create_cart_sql) === TRUE) {
				if($conn->query($create_orderDetail_sql) === TRUE) {
					echo "<script>alert('장바구니에 추가되었습니다!');</script>";
					echo "<script>window.location.href = './page/main.php';</script>";
				}
				else {
	        echo "Error: " . $create_orderDetail_sql . "<br>" . $conn->error;
				}
			} 
			else {
	      echo "Error: " . $create_cart_sql . "<br>" . $conn->error;
			}
		}
		
    $conn->close();
}
?>

