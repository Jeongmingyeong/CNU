<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>login</title>
    <link rel="stylesheet" href="../style/styles.css">
</head>
<body>
    <div class="container">
        <img src="../images/logo.png" alt="서비스 로고" class="logo">
        <form action="../login_process.php" method="post"> <!-- login_process.php로 데이터를 전송 -->
            <input type="text" id="username" name="username" placeholder="ID">
            <input type="password" id="password" name="password" placeholder="Password">
            <button type="submit">로그인</button>
        </form>
    </div>
</body>
</html>

