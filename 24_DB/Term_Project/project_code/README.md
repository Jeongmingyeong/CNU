## in page directory
### - login.php : login 화면
### - main.php : (관리자 제외) 사용자가 확인하는 메인화면
### - main_manager.php : 관리자가 확인하는 메인화면
### - admin_stats.php : 관리자가 판매통계를 확인할 수 있는 페이지
### - cart.php : 장바구니 조회 화면
### - order_history.php : 주문내역을 조회할 수 있는 페이지
 - 아직 결제가 되지 않은 내역에 대해서는 주문내역에서 조회가 되지 않으며, 결제 후 조회가능

---
## db_connect.php : db와 연결하는 기능

## login_process.php : login 시 비밀번호 일치여부 확인 등 로그인과 관련된 처리

## search_results.php : 음식 이름을 키워드로 검색 시 처리되는 화면
## search_price.php : 음식의 금액을 설정하여 검색하는 기능 처리
## get_foods.php : 카테고리 선택하여 음식을 검색하는 기능 처리
## add_food_to_cart.php : 음식을 선택한 후 수량정보 입력 후 장바구니 담기 버튼 클릭 시의 처리
## cart_to_history.php : 장바구니에 있는 음식을 결제하면, 주문내역으로 이동하는 처리
