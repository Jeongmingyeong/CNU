<%@page import="org.slf4j.Logger"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.Properties"%>
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.HashMap" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {
	font-family: Arial, Helvetica, sans-serif;
	display: flex;
    justify-content: center;
    align-items: center;
}

/* Full-width input fields */
input[type=text], input[type=password] {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  box-sizing: border-box;
}

/* Set a style for all buttons */
button {
  background-color: #04AA6D;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  cursor: pointer;
  width: 100%;
}

button:hover {
  opacity: 0.8;
}

/* Extra styles for the cancel button */
.cancelbtn {
  width: auto;
  padding: 10px 18px;
  background-color: #f44336;
}

/* Center the image and position the close button */
.imgcontainer {
  text-align: center;
  margin: 24px 0 12px 0;
  position: relative;
}

img.avatar {
  width: 40%;
  border-radius: 10%;
}

.container {
  padding: 16px;
}

span.psw {
  float: right;
  padding-top: 16px;
}

/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
  padding-top: 60px;
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 5% auto 15% auto; /* 5% from the top, 15% from the bottom and centered */
  border: 1px solid #888;
  width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button (x) */
.close {
  position: absolute;
  right: 25px;
  top: 0;
  color: #000;
  font-size: 35px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: red;
  cursor: pointer;
}

/* Add Zoom Animation */
.animate {
  -webkit-animation: animatezoom 0.6s;
  animation: animatezoom 0.6s
}

@-webkit-keyframes animatezoom {
  from {-webkit-transform: scale(0)} 
  to {-webkit-transform: scale(1)}
}
  
@keyframes animatezoom {
  from {transform: scale(0)} 
  to {transform: scale(1)}
}

/* Change styles for span and cancel button on extra small screens */
@media screen and (max-width: 300px) {
  span.psw {
     display: block;
     float: none;
  }
  .cancelbtn {
     width: 100%;
  }
}


.closebtn {
  margin-left: 15px;
  color: white;
  font-weight: bold;
  float: right;
  font-size: 22px;
  line-height: 20px;
  cursor: pointer;
  transition: 0.3s;
}

.closebtn:hover {
  color: black;
}
.countDown{
  text-align: center;
  font-size: 60px;
  margin-top: 0px;
}
</style>
<script type="text/javascript">
var loginUser ='';
function login(){	
	
	var hakbun ='';
	var srcFlag = true;
	if($("#hakbun").val() !="") {
		$("#alertDiv").hide();
		hakbun = $("#hakbun").val();
		console.log("입력하신 학번은-->"+hakbun);
		srcFlag=true;
	}else{
		$("#alertDiv").show();
		srcFlag=false;
	}
	
		
	if(srcFlag){	
		param = {
				HAKBUN 	: hakbun,
				DEBUG	: "F"
			};
		
		$.ajax({
			method	: "post",
			url		: "checkHakbun.do",
			data	: param,
			dataType : "JSON",
			async : true, 
			beforeSend : beforeAjax,
			success : successCheckHakbun,
			error : errCheckHakbun
		});
		
	}
}
function beforeAjax(xmlHttpRequest) {
	xmlHttpRequest.setRequestHeader("AJAX", "true");
}
function errCheckHakbun(xhr,status,error) {

	if(xhr.status == 999) {
		alert("세션이 종료되었습니다.");
	} else {
		alert("조회중 에러가 발생하였습니다.");
	}
}
function successCheckHakbun(result) {
	var data = result.returnData.resultData_hakbun[0];
	$("#alertDiv").hide();
	if(typeof data!="undefined"){
		console.log("학번-->"+data.HAKBUN+" 이름-->"+data.NAME);
		loginUser = data.NAME;
		var inHtml = '<div class="alert alert-success" style=\'text-align:center\'>' +
				      '<span class="closebtn" onclick="this.parentElement.style.display=\'none\';">&times;</span>' +
				      '<strong>반갑습니다 ' + data.NAME + ' 학생   </strong>' +
				      '<span id="demo"></span></div>';
		$("#changeArea").html(inHtml);
		var countDownDate = new Date("Jan 5, 2024 15:37:24").getTime();
		var now = new Date("Jan 5, 2024 15:37:22").getTime();
		var distance = countDownDate - now;
		var seconds = Math.floor((distance % (1000 * 60)) / 1000);
		var x = setInterval(function() {				
			document.getElementById("demo").innerHTML = seconds + "초 ";
			seconds -= 1;
			if (seconds < 0) {
				clearInterval(x);
				document.getElementById("demo").innerHTML = "인증완료";
			}
		}, 1000);
		setTimeout(function() {
			$("#id01").hide();
			$("#clearBoard").html("");
			step1();
		}, 3000);
	}else{
		$("#alertDiv").show();		
	}
}
var item='';

function logging(value){	
	var studentNm = loginUser;
	var srcFlag = true;
	item = value;
	if(studentNm !="" && item !="") {
		console.log("item-->"+item+" 이름-->"+studentNm);	
	
	}else{
		srcFlag = false;
	}
		
	if(srcFlag){	
		param = { studentNm : studentNm, item : item };		
		$.ajax({
			method	: "post",
			url		: "logging.do",
			data	: param,
			dataType : "JSON",
			async : true, 
			beforeSend : beforeAjax,
			success : successLogging,
			error : errLoggingAdd
		});
		
	}
}

function errLoggingAdd(xhr,status,error) {

	if(xhr.status == 999) {
		alert("세션이 종료되었습니다.");
	} else {
		alert("로그 생성중 에러가 발생하였습니다.");
	}
}
function successLogging(result) {
	var data = result.returnData;
	alert("["+data+"] 로그 생성완료")
}


function step1(){
	var inHtml = '';
	var inHtml = 
	    '<nav class="w3-sidebar w3-bar-block w3-white w3-collapse w3-top" style="z-index:3;width:250px" id="mySidebar">' +
	    '<div class="w3-container w3-display-container w3-padding-16">' +
	    '<i onclick="w3_close()" class="fa fa-remove w3-hide-large w3-button w3-display-topright"></i>' +
	    '<h3 class="w3-wide"><a href="/"><b>컴퓨터네트워크</b></a></h3>' +
	    '</div>' +
	    '<div class="w3-padding-64 w3-large w3-text-grey" style="font-weight:bold">' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Shirts 클릭\');">Shirts</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Dresses 클릭\');">Dresses</a>' +
	    '<a onclick="myAccFunc()" href="javascript:void(0)" class="w3-button w3-block w3-white w3-left-align" id="myBtn">' +
	    'Jeans <i class="fa fa-caret-down"></i>' +
	    '</a>' +
	    '<div id="demoAcc" class="w3-bar-block w3-hide w3-padding-large w3-medium">' +
	    '<a href="#" class="w3-bar-item w3-button w3-light-grey" onclick="logging(\'Skinny 클릭\');"><i class="fa fa-caret-right w3-margin-right"></i>Skinny</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Relaxed 클릭\');">Relaxed</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Bootcut 클릭\');">Bootcut</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Straight 클릭\');">Straight</a>' +
	    '</div>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Jackets 클릭\');">Jackets</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Gymwear 클릭\');">Gymwear</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Blazers 클릭\');">Blazers</a>' +
	    '<a href="#" class="w3-bar-item w3-button" onclick="logging(\'Shoes 클릭\');">Shoes</a>' +
	    '</div>' +
	    '<a href="#footer" class="w3-bar-item w3-button w3-padding" onclick="logging(\'Contact 클릭\');">Contact</a>' +
	    //'<a href="javascript:void(0)" class="w3-bar-item w3-button w3-padding" onclick="document.getElementById(\'newsletter\').style.display=\'block\'">Newsletter</a>' +
	    '<a href="#" class="w3-bar-item w3-button w3-padding" onclick="logging(\'Newsletter 클릭\');">Newsletter</a>' +
	    '<a href="#footer" class="w3-bar-item w3-button w3-padding" onclick="logging(\'Subscribe 클릭\');">Subscribe</a>' +
	    '</nav>' +

	    // Top menu on small screens
	    '<header class="w3-bar w3-top w3-hide-large w3-black w3-xlarge">' +
	    '<div class="w3-bar-item w3-padding-24 w3-wide">LOGO</div>' +
	    '<a href="javascript:void(0)" class="w3-bar-item w3-button w3-padding-24 w3-right" onclick="w3_open()"><i class="fa fa-bars"></i></a>' +
	    '</header>' +

	    // Overlay effect when opening sidebar on small screens
	    '<div class="w3-overlay w3-hide-large" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>' +

	    // !PAGE CONTENT!
	    '<div class="w3-main" style="margin-left:250px">' +

	    // Push down content on small screens
	    '<div class="w3-hide-large" style="margin-top:83px"></div>' +

	    // Top header
	    '<header class="w3-container w3-xlarge">' +
	    '<p class="w3-left">Jeans</p>' +
	    '<p class="w3-right">' +
	    '<i class="fa fa-shopping-cart w3-margin-right"></i>' +
	    '<i class="fa fa-search"></i>' +
	    '</p>' +
	    '</header>' +

	    // Image header
	    '<div class="w3-display-container w3-container">' +
	    '<img src="../resources/image/jeans.jpg" alt="Jeans" style="width:100%">' +
	    '<div class="w3-display-topleft w3-text-white" style="padding:24px 48px">' +
	    '<h1 class="w3-jumbo w3-hide-small">New arrivals</h1>' +
	    '<h1 class="w3-hide-large w3-hide-medium">New arrivals</h1>' +
	    '<h1 class="w3-hide-small">COLLECTION 2023</h1>' +
	    '<p><a href="#jeans" class="w3-button w3-black w3-padding-large w3-large" onclick="logging(\'LOGGING NOW 클릭\');">LOGGING NOW</a></p>' +
	    '</div>' +
	    '</div>' +

	    '<div class="w3-container w3-text-grey" id="jeans">' +
	    '<p>8 items</p>' +
	    '</div>' +

	    // Product grid
	    '<div class="w3-row w3-grayscale">' +
	    '<div class="w3-col l3 s6">' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans1.jpg" style="width:100%">' +
	    '<span class="w3-tag w3-display-topleft">Sale</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black" onclick="logging(\'무릎만 찢어진 청바지\');">Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>무릎만 찢어진 청바지<br></p>' +
	    '</div>' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans2.jpg" style="width:100%">' +
	    '<span class="w3-tag w3-display-topleft">Sale</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black" onclick="logging(\'허벅지 찢어진 청바지\');">Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>허벅지 찢어진 청바지<br></p>' +
	    '</div>' +
	    '</div>' +

	    '<div class="w3-col l3 s6">' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans5.jpg" style="width:381px;height:476px;">' +
	    '<span class="w3-tag w3-display-topleft">New</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black" onclick="logging(\'청반바지(남)\');">Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>청반바지(남)<br></p>' +
	    '</div>' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans6.jpg" style="width:381px;height:476px;">' +
	    '<span class="w3-tag w3-display-topleft">New</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black"  onclick="logging(\'청반바지(여)\');" >Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>청반바지(여)<br></p>' +
	    '</div>' +
	    '</div>' +

	    '<div class="w3-col l3 s6">' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans3.jpg" style="width:100%">' +
	    '<span class="w3-tag w3-display-topleft">Sale</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black" onclick="logging(\'멀쩡한 청바지\');" >Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>멀쩡한 청바지<br></p>' +
	    '</div>' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image//jeans4.jpg" style="width:100%">' +
	    '<span class="w3-tag w3-display-topleft">Sale</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black"  onclick="logging(\'빈티지 청바지\');" >Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>빈티지 청바지<br></p>' +
	    '</div>' +
	    '</div>' +

	    '<div class="w3-col l3 s6">' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans7.jpg" style="width:381px;height:476px;">' +
	    '<span class="w3-tag w3-display-topleft">Sale</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black" onclick="logging(\'무릎 많이 찢어진 청바지\');">Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>무릎 많이 찢어진 청바지<br></p>' +
	    '</div>' +
	    '<div class="w3-container">' +
	    '<div class="w3-display-container">' +
	    '<img src="../resources/image/jeans8.jpg" style="width:381px;height:476px;">' +
	    '<span class="w3-tag w3-display-topleft">Sale</span>' +
	    '<div class="w3-display-middle w3-display-hover">' +
	    '<button class="w3-button w3-black" onclick="logging(\'군데 군데 찢어진 청바지\');">Buy now <i class="fa fa-shopping-cart"></i></button>' +
	    '</div>' +
	    '</div>' +
	    '<p>군데 군데 찢어진 청바지<br></p>' +
	    '</div>' +
	    '</div>' +
	    '</div>' +

	    // Subscribe section
	    '<div class="w3-container w3-black w3-padding-32">' +
	    '<h1>Subscribe</h1>' +
	    '<p>To get special offers and VIP treatment:</p>' +
	    '<p><input class="w3-input w3-border" type="text" placeholder="Enter e-mail" style="width:100%"></p>' +
	    '<button type="button" class="w3-button w3-red w3-margin-bottom">Subscribe</button>' +
	    '</div>' +

	    // Footer
	    '<footer class="w3-padding-64 w3-light-grey w3-small w3-center" id="footer">' +
	    '<div class="w3-row-padding">' +
	    '<div class="w3-col s4">' +
	    '<h4>Contact</h4>' +
	    '<p>Questions? Go ahead.</p>' +
	    '<form action="/action_page.php" target="_blank">' +
	    '<p><input class="w3-input w3-border" type="text" placeholder="Name" name="Name" id="txtName"></p>' +
	    '<p><input class="w3-input w3-border" type="text" placeholder="Email" name="Email" id="txtMail"></p>' +
	    '<p><input class="w3-input w3-border" type="text" placeholder="Subject" name="Subject" id="txtSub"></p>' +
	    '<p><input class="w3-input w3-border" type="text" placeholder="Message" name="Message" id="txtMsg"></p>' +
	    '<button class="w3-button w3-block w3-black" onclick="logging(\'Send 클릭\');">Send</button>' +
	    '</form>' +
	    '</div>' +

	    '<div class="w3-col s4">' +
	    '<h4>About</h4>' +
	    '<p><a href="#">About us</a></p>' +
	    '<p><a href="#">We\'re hiring</a></p>' +
	    '<p><a href="#">Support</a></p>' +
	    '<p><a href="#">Find store</a></p>' +
	    '<p><a href="#">Shipment</a></p>' +
	    '<p><a href="#">Payment</a></p>' +
	    '<p><a href="#">Gift card</a></p>' +
	    '<p><a href="#">Return</a></p>' +
	    '<p><a href="#">Help</a></p>' +
	    '</div>' +

	    '<div class="w3-col s4 w3-justify">' +
	    '<h4>Store</h4>' +
	    '<p><i class="fa fa-fw fa-map-marker"></i> 컴퓨터네트워크</p>' +
	    '<p><i class="fa fa-fw fa-phone"></i> +8242-821-6879</p>' +
	    '<p><i class="fa fa-fw fa-envelope"></i> lbhzzang@o.cnu.ac.kr</p>' +
	    '<h4>We accept</h4>' +
	    '<p><i class="fa fa-fw fa-cc-amex"></i> Amex</p>' +
	    '<p><i class="fa fa-fw fa-credit-card"></i> Credit Card</p>' +
	    '<br>' +
	    '<i class="fa fa-facebook-official w3-hover-opacity w3-large"></i>' +
	    '<i class="fa fa-instagram w3-hover-opacity w3-large"></i>' +
	    '<i class="fa fa-snapchat w3-hover-opacity w3-large"></i>' +
	    '<i class="fa fa-pinterest-p w3-hover-opacity w3-large"></i>' +
	    '<i class="fa fa-twitter w3-hover-opacity w3-large"></i>' +
	    '<i class="fa fa-linkedin w3-hover-opacity w3-large"></i>' +
	    '</div>' +
	    '</div>' +
	    '</footer>' +

	    '<div class="w3-black w3-center w3-padding-24">Powered by <a href="https://sites.google.com/view/monetcnu" title="CNU" target="_blank" class="w3-hover-opacity"CNU</a></div>' +

	    // Newsletter Modal
	    '<div id="newsletter" class="w3-modal">' +
	    '<div class="w3-modal-content w3-animate-zoom" style="padding:32px">' +
	    '<div class="w3-container w3-white w3-center">' +
	    '<i onclick="document.getElementById(\'newsletter\').style.display=\'none\'" class="fa fa-remove w3-right w3-button w3-transparent w3-xxlarge"></i>' +
	    '<h2 class="w3-wide">NEWSLETTER</h2>' +
	    '<p>Join our mailing list to receive updates on new arrivals and special offers.</p>' +
	    '<p><input class="w3-input w3-border" type="text" placeholder="Enter e-mail"></p>' +
	    '<button type="button" class="w3-button w3-padding-large w3-red w3-margin-bottom" onclick="document.getElementById(\'newsletter\').style.display=\'none\'">Subscribe</button>' +
	    '</div>' +
	    '</div>' +
	    '</div>';

	$("#clearBoard").html(inHtml);
	// Click on the "Jeans" link on page load to open the accordion for demo purposes
	document.getElementById("myBtn").click();
	/*
	$( document ).ready( function() {	
	    $("#itemBtn").click(function(){
	       console.log($(this).attr('value'));
	       item = $(this).attr('value');
	    });

	});
	*/
}

//Accordion 
function myAccFunc() {
  var x = document.getElementById("demoAcc");
  if (x.className.indexOf("w3-show") == -1) {
    x.className += " w3-show";
  } else {
    x.className = x.className.replace(" w3-show", "");
  }
}

// Open and close sidebar
function w3_open() {
  document.getElementById("mySidebar").style.display = "block";
  document.getElementById("myOverlay").style.display = "block";
}
 
function w3_close() {
  document.getElementById("mySidebar").style.display = "none";
  document.getElementById("myOverlay").style.display = "none";
}


var modal = document.getElementById('id01');
//When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
 if (event.target == modal) {
     modal.style.display = "none";
 }
}
$(function(){
	$("#hakbun").keypress(function(e){
		if(e.keyCode && e.keyCode == 13){
			 //e.preventDefault();
			 login();
	    }
	});
});

</script>

</head>
<body>
<div id="clearBoard">
<div><h2>Logging 실습</h2></div>
<div><button onclick="document.getElementById('id01').style.display='block'" style="width:auto;margin-left: 50px;">접속하기</button></div>

<div class="modal" id="id01">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <span onclick="document.getElementById('id01').style.display='none'" class="close" title="Close Modal">&times;</span>
        <img src="../resources/image/cnu_logo.png" alt="CNU" class="avatar" style="margin-left: 120px;">
      </div>

      <!-- Modal body -->
      <div class="modal-body" style="height:290px;" id="changeArea">
		<label for="hakbun"><b>학번</b></label>      
	    <input type="text" id="hakbun" placeholder="자신의 학번을 입력하세요" name="hakbun" maxlength="9">        
	    <a href="#" onclick="login()" class="btn-sch" id="btn_srch">로그인</a>
	    <div id ="alertDiv" class="alert" style="display:none;">
			<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
			<strong style="color: red;">정확한 학번</strong>을 입력해 주세요.
	    </div>   
      </div>
    </div>
  </div>
</div>
</div>




</body>
</html>
