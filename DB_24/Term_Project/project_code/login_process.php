<?php
	// session 정보 가져오기
	session_start();

	// db 연결파일 가져오기
	include 'db_connect.php';

	// login 처리 시 메세지
	$error_msg = '';

	// 사용자 입력 값 받기
	$username = $_POST['username'];
	$password = $_POST['password'];

	// SQL 쿼리문 작성 : 사용자 정보 조회
	$sql = "SELECT * FROM Customer WHERE name = ?";
	$stmt = $conn->prepare($sql);
	$stmt->bind_param("s", $username); // 첫번째 인자는 바인딩할 값의 데이터타입
	$stmt->execute();
	$result = $stmt->get_result();

	// 사용자가 한명이라도 있는지 확인 후 로그인 진행
	if ($result->num_rows > 0) {
		$userinfo = $result->fetch_assoc(); // col name 으로 접근

		// 비밀번호가 일치하는 경우 세션에 정보저장
		if($password === $userinfo['password']) {
			$_SESSION['user_id'] = $userinfo['cno'];
			$_SESSION['username'] = $userinfo['name'];
			if($userinfo['cno'] === 'C0') {
				header("Location: ./page/main_manager.php"); // login 성공시 관리자 전용 메인화면으로 이동
			} else {
				header("Location: ./page/main.php"); // login 성공시 메인화면으로 이동
			}
			exit();
		} 
		
		// 비밀번호가 일치하지 않는 경우
		else {
		 // 비밀번호가 일치하지 않는 경우
     echo "<script>
             alert('비밀번호가 잘못되었습니다.');
             window.location.href = './page/login.php';
           </script>";
		}
	// 사용자가 존재하지 않는 경우
	} else {
		// 사용자가 존재하지 않는 경우
    echo "<script>
            alert('존재하지 않는 사용자입니다.');
            window.location.href = './page/login.php';
					</script>";
	}
?>

</body>
</html>

