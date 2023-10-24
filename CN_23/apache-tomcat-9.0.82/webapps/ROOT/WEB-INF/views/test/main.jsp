<!-- 
 KT Global Sode version 1.0
 Copyright (C) 2018 kt Inc. All rights reserved.
 This is a proprietary software of kt Inc, and you may not use this file except in compliance with license agreement with kt Inc. Any redistribution or use of this software, with or without modification shall be strictly prohibited without prior written approval of kt Inc, and the copyright notice above does not evidence any actual or intended publication of such software.
 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.HashMap" %>
<script src="${contextPath}/resources/js/vis.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/d3.js"></script>
<script type="text/javascript">

$(document).ready(docReady);
var flag = 0;
var page_size = 20;	
var totalCount = 0; 
var viewFlag = 0;
var DIR = '<%=request.getContextPath() %>/resources/img/drt/';
var DIR2 = '<%=request.getContextPath() %>/resources/image/';
var DIR3 = '<%=request.getContextPath() %>/resources/js/json/';
function docReady(){
	
	$("#rowCount").change(changeRowCount);
	$("#combo_select01").change(changeDraw);
}
function changeRowCount()
{
	doSrch(1);
}
function changeDraw()
{
	if(viewFlag=="1")
	drawMap('#container');	
}

function doSrch1(pageNo){
	
	page_size      = 30;
	
	var srcFlag  = false;
	var startIndex = (pageNo-1) * page_size + 1;
	var endIndex   = page_size * pageNo ;
	var bonbuName  = '';
	var jisaName   = '';
	var officeCode = '';
	var mainName   = '';
	var searchFlag = '';
	// 본부만 선택시 A, 지사선택시 B, Office선택,  장비명 입력시 기존방법
	if($("#combo_select01").val() !="전체") {
		bonbuName = $("#combo_select01").val();
		searchFlag='A';
	}
	if($("#combo_select02").val() !="전체") {
		jisaName  = $("#combo_select02").val();
		searchFlag='B';
	}
	if($("#combo_select03").val() !="전체") {
		officeCode = $("#combo_select03").val();
		searchFlag='C';
	}
	if($("#txtMainName").val() != "") {
		mainName = $.trim($("#txtMainName").val()).toUpperCase();
		searchFlag='C';
	}
	if(bonbuName !="전체"){
		if(bonbuName !="" ){
			srcFlag =true;
		}
	}
	if(mainName !=""){
		srcFlag =true;
	}
	if(srcFlag){
		param = {
				startIndex  : startIndex,
				endIndex    : endIndex,	
				PAGENO		: pageNo == null ? 1: pageNo,
				PAGESIZE	: page_size,
				bonbuName 	: bonbuName,
				jisaName 	: jisaName,
				officeCode  : officeCode,
				mainName    : mainName,
				searchFlag	: searchFlag,
				DEBUG		: "F"
			};
		$.ajax({
			method	: "post",
			url		: "oltSearch.do",
			data	: param,
			dataType : "JSON",
			async : true, // double Click 등의 중복 동작에서 오류 발생
			beforeSend : beforeAjax,
			success : successMapSrch,
			error : errDoSrch
		});
		
	}else{
		alert("본부를 선택해주세요");
	}
}
function successMapSrch(result) {
	//prgressload(false);
	setOltMapData(result.returnData, result.totalCnt);
	
}
function setOltMapData(returnData, totalCnt){
	currentPageNo = $("#divPaginate").children('strong').html();
	if (returnData.PAGENO == 1) {
		totalCount = totalCnt;
		$("#totalCntLbl").text(totalCount);
	}
	$("#divPaginate").html(paginateSetting(totalCount, page_size, Number(returnData.PAGENO)));
	$('#view02').show();
	$('#totalCNT').show();
	var inHtmlA = '';
	var inHtmlB = '';
	var inHtmlC = '';
	var oltList = returnData.resultData;
	var searchFlag = returnData.searchFlag;
	switch(searchFlag){
		case "A":
			inHtmlA ='<table class="tbl-normal" id ="result_table" style="width:38%;">'+
						'<caption>단말관리</caption>'+
						'<thead>'+
						'<tr id="headerGroup">'+
							'<th nowrap width="auto;"><span>본부명</span></th>'+
							'<th nowrap width="auto;"><span>지사명</span> </th>'+
							'<th nowrap width="auto;"><span>OLT</span></th>'+
							'<th nowrap width="auto;"><span>STB</span></th>'+
						'</tr>'+
						'</thead>'+
						'<colgroup align="center" width="100%" >'+
							'<col align="center" >'+
							'<col align="center" >'+
							'<col align="center" >'+
							'<col align="center" >'+
						'</colgroup>'+
						'<tbody id="tbodyUpgradeData">'+
						'</tbody>'+
					 '</table>';
					 $("#map_table").html(inHtmlA);
					 inHtmlA = '';
			if (oltList.length == 0) {
				inHtmlA += '<tr><td colspan="4">조회된 정보가 없습니다.</td></tr>';
			} else {
				for (var i = 0; i < oltList.length; i++) {
					var value = oltList[i];
					var arrParam = new Array();	
					arrParam.push(value.bonbuName);
					if(value.bonbuName !=null)
					{
						inHtmlA +=   '<tr>'+
									'<td nowrap class="class">'+value.bonbuName +'</td>'+
									'<td nowrap class="class" style="font-weight:bold;">'+value.jisaName+'</td>'+
									'<td nowrap class="class">'+value.oltCnt+'</td>'+
									'<td nowrap class="class">'+value.stbCnt+'</td>'+
									'</tr>';
					}
					else 
					{
						inHtmlA += '<tr><td nowrap></td></tr>';
					}
				}
			}
			$("#tbodyUpgradeData").html(inHtmlA);
			break;
		case "B":
			inHtmlB ='<table class="tbl-normal" id = "result_table" style="width:38%;">'+
						'<caption>단말관리</caption>'+
						'<thead>'+
						'<tr id="headerGroup">'+
							'<th nowrap width="auto;"><span>본부명</span></th>'+
							'<th nowrap width="auto;"><span>지사명</span> </th>'+
							'<th nowrap width="auto;"><span>국사명</span></th>'+
							'<th nowrap width="auto;"><span>OLT</span></th>'+
							'<th nowrap width="auto;"><span>STB</span></th>'+
						'</tr>'+
						'</thead>'+
						'<colgroup align="center" width="100%" >'+
							'<col align="center" >'+
							'<col align="center" >'+
							'<col align="center" >'+
							'<col align="center" >'+
							'<col align="center" >'+
						'</colgroup>'+
						'<tbody id="tbodyUpgradeData">'+
						'</tbody>'+
					 '</table>';
					 $("#map_table").html(inHtmlB);
					 inHtmlB = '';
			if (oltList.length == 0) {
				inHtmlB += '<tr><td colspan="5">조회된 정보가 없습니다.</td></tr>';
			} else {
				for (var i = 0; i < oltList.length; i++) {
					var value = oltList[i];
					var arrParam = new Array();	
					arrParam.push(value.bonbuName);
					if(value.bonbuName !=null)
					{
						inHtmlB +=   '<tr>'+
										'<td nowrap class="class">'+value.bonbuName +'</td>'+
										'<td nowrap class="class">'+value.jisaName+'</td>'+
										'<td nowrap class="class" style="font-weight:bold;">'+value.officeName+'</td>'+
										'<td nowrap class="class">'+value.oltCnt+'</td>'+
										'<td nowrap class="class">'+value.stbCnt+'</td>'+
									 '</tr>';
					}
					else 
					{
						inHtmlB += '<tr><td nowrap></td></tr>';
					}
				}
			}
			$("#tbodyUpgradeData").html(inHtmlB);
			break;
		case "C":
			inHtmlC ='<table class="tbl-normal" id = "result_table" style="width:38%;">'+
						'<caption>단말관리</caption>'+
						'<thead>'+
						'<tr id="headerGroup">'+
							'<th nowrap width="auto;"><span>본부/지사/국사</span></th>'+
							'<th nowrap width="auto;"><span>장비코드</span></th>'+
							'<th nowrap width="auto;"><span>장비명</span> </th>'+
							'<th nowrap width="auto;"><span>셋탑수</span></th>'+
						'</tr>'+
						'</thead>'+
						'<colgroup align="center" width="100%" >'+
							'<col align="center" >'+
							'<col align="center" >'+
							'<col align="center" >'+
						'</colgroup>'+
						'<tbody id="tbodyUpgradeData">'+
						'</tbody>'+
					 '</table>';
					 $("#map_table").html(inHtmlC);
					 inHtmlC = '';
			if (oltList.length == 0) {
				inHtmlC += '<tr><td colspan="4">조회된 정보가 없습니다.</td></tr>';
			} else {
				for (var i = 0; i < oltList.length; i++) {
					var value = oltList[i];
					var arrParam = new Array();	
					arrParam.push(value.mainNesCode);
					if(value.mainNesCode !=null)
					{
						inHtmlC +=   '<tr>'+
									'<td nowrap class="class">'+value.bonbuName +'/'+value.jisaName+'/'+value.officeName+'</td>'+
									'<td nowrap class="class">'+value.mainNesCode +'</td>'+
									'<td nowrap class="class">'+value.mainName+'</td>'+
									'<td nowrap class="class">'+value.stbCnt+'</td>'+
									'</tr>';
					}
					else 
					{
						inHtmlC += '<tr><td nowrap></td></tr>';
					}
				}
			}
			$("#tbodyUpgradeData").html(inHtmlC);
			break;
	}
}

// 본부별 지도 그리기
function drawMapData(){
    $("span#container").remove();
	$("span.chartreport").append('<span id="container" style="width:auto;height:450px;overflow:auto"></span>');
	var target = '#container';
	var width = 300; //지도의 넓이
    var height = 300; //지도의 높이
    var initialScale = 5500; //확대시킬 값
    var initialX = -11900; //초기 위치값 X
    var initialY = 4050; //초기 위치값 Y
    var labels;
    var projection = d3.geo.mercator()
				       .scale(initialScale)
				       .translate([initialX, initialY]);
    var path = d3.geo.path().projection(projection);
    
    var svg = d3.select(target)
			    .append('svg')
			    .attr('width', width + 'px')
			    .attr('height', height + 'px')
			    .attr('id', 'map')
			    .attr('class', 'map');

	var states = svg.append('g')
			        .attr('id', 'states1');
		
	var tooltip = d3.select(target)
					.append("div")
					.attr( "id", "map2")
			    	.attr("class", "toolTip")
			    	.style("display", "none");
		
		states.append('rect')
			  .attr('class', 'background')
			  .attr('width', width + 'px')
			  .attr('height', height + 'px');
	// 점찍기
	var spots = [
	  {
	    "officeName": "평택국사",
	    "nesCode": "JNBS01053",
	    "olt": "384",
	    "lat": 37.26993525201933,
	    "lon": 126.855944337809731
	  },
	  { 
	    "officeName": "의정부국사",
	    "nesCode": "JNBS01463",
	    "olt": "411",
	    "lat": 37.27700694190131,
	    "lon": 126.649626553012541
	  },
	  {
	    "officeName": "안산국사",
	    "nesCode": "JNBS01153",
	    "olt": "620",
	    "lat": 37.26861491396472,
	    "lon": 127.479045607284069
	  },
	  {  
	    "officeName": "안동국사",
	    "nesCode": "JNBS11153",
	    "olt": "3214",
	    "lat": 37.703760723492179,
	    "lon": 126.902129523223635
	  },
	  {  
	    "officeName": "기흥국사",
	    "nesCode": "JNBS02168",
	    "olt": "412",
	    "lat": 37.889668926399963,
	    "lon": 127.507397637594545
	  },
	  {
	    "officeName": "수원국사",
	    "nesCode": "JNBS01689",
	    "olt": "294",
	    "lat": 37.037995867093564,
	    "lon": 126.845274176534892
	  }]; 
	 //geoJson데이터를 파싱하여 지도그리기
    d3.json(DIR3+'area.json', function(json) {
        states.selectAll('path') //지역 설정
              .data(json.gyeonggi)
              .enter()
              .append('path')
              .attr('d', path)
              .attr("r", 3)
              .style('fill',"#0080ff")
              .attr("cx", function(d) { return d.geometry.coordinates[0];})
              .attr("cy", function(d) { return d.geometry.coordinates[1];})
            .attr('id', function(d) {
                return 'path-' + d.properties.name_eng;
            })
         states.selectAll('circle')
			  .data(spots)
			  .enter()
			  .append("circle")
			  .attr("cx", function( d){ return projection( [d.lon, d.lat])[0]; })
      	  	  .attr("cy", function( d){ return projection( [d.lon, d.lat])[1]; })
			  .attr("r", 2)
			  .style('fill',"red")		          
			  .on("mouseover", function() { tooltip.style("display", null); })
              .on("mouseout",  function() { tooltip.style("display", "none"); })
              .on("mousemove", function(d) {
                tooltip.style("left", (d3.event.pageX-100)+"px")
                tooltip.style("top",  (d3.event.pageY-200)+"px")
                tooltip.html("국사명: " + d.officeName+ "<br/>"+"NESCODE: "+d.nesCode +"<br/>"+"OLT: " + d.olt)
            });
        labels = states.selectAll('text')
			           .data(json.gyeonggi) //라벨표시
			           .enter()
			           .append('text')
			           .style('color','white')
				       .attr('transform', translateTolabel)
			           .attr('id', function(d) {
			                return 'label-' + d.properties.name_eng;
			           })
			           .attr('text-anchor', 'middle')
			           .attr('dy', '.35em')
			           .text(function(d) {
			                return d.properties.name;
			           });
        
    });
    
    function zoom() {
        projection.translate(d3.event.translate).scale(d3.event.scale);
        states.selectAll('path').attr('d', path);
        labels.attr('transform', translateTolabel);
    }
    function translateTolabel(d) {
        var arr = path.centroid(d);
        if (d.properties.code == 31) {
            //서울 경기도 이름 겹쳐서 경기도 내리기
            arr[1] +=
                d3.event && d3.event.scale
                    ? d3.event.scale / height + 20
                    : initialScale / height + 20;
        } else if (d.properties.code == 34) {
            //충남은 조금 더 내리기
            arr[1] +=
                d3.event && d3.event.scale
                    ? d3.event.scale / height + 10
                    : initialScale / height + 10;
        } else if (d.properties.code == 39) {
            //충남은 조금 더 내리기
            arr[1] +=
                d3.event && d3.event.scale
                    ? d3.event.scale / height + 10
                    : initialScale / height + 10;
        }
        return 'translate(' + arr + ')';
    }
}



//지도 그리기
function drawMap(target) {
	$('#view02').show();
    $('#container').show(); 
    $("span#container").remove();
	$("span.chartreport").append('<span id="container" style="width:auto;height:450px;overflow:auto"></span>');
	var width = 700; //지도의 넓이
    var height = 550; //지도의 높이
    var initialScale = 5500; //확대시킬 값
    var initialX = -11900; //초기 위치값 X
    var initialY = 4050; //초기 위치값 Y
    var labels;
	var redFill = $("#combo_select01").val();
	var oldRedFill = '';
    var projection = d3.geo.mercator()
				       .scale(initialScale)
				       .translate([initialX, initialY]);
    var path = d3.geo.path().projection(projection);
    var zoom = d3.behavior
		         .zoom()
		         .translate(projection.translate())
		         .scale(projection.scale())
		         .scaleExtent([height, 800 * height])
		         .on('zoom', zoom);
    var svg = d3.select(target)
		        .append('svg')
		        .attr('width', width + 'px')
		        .attr('height', height + 'px')
		        .attr('id', 'map')
		        .attr('class', 'map');

    var states = svg.append('g')
			        .attr('id', 'states')
			        .call(zoom);
	//var map = svg.append("g").attr( "id", "map").call(zoom);
	
	var tooltip = d3.select(target)
	           		.append("div")
	           		.attr( "id", "map2")
				    .attr("class", "toolTip")
				    .style("display", "none");
    states.append('rect')
          .attr('class', 'background')
          .attr('width', width + 'px')
          .attr('height', height + 'px');
    
    //geoJson데이터를 파싱하여 지도그리기
    d3.json(DIR3+'korea.json', function(json) {
        states.selectAll('path') //지역 설정
              .data(json.features)
              .enter()
              .append('path')
              .attr('d', path)
			  .style('fill', function(d) {
				var fillD = d.properties.name;
				var splitD = redFill.substring(0,2);
	           	if(fillD==splitD){
	           		return "#ff0000";
	           	}
	           	else{
	           		return "#8977ad";
	           	}
            })   
	        
            .attr("r", 3)
            .attr("cx", function(d) { return d.geometry.coordinates[0]; })
            .attr("cy", function(d) { return d.geometry.coordinates[1];})
            .on("mouseover", function() { tooltip.style("display", null); })
            .on("mouseout",  function() { tooltip.style("display", "none"); })
            .on("mousemove", function(d) {
                tooltip.style("left", (d3.event.pageX-100)+"px")
                tooltip.style("top",  (d3.event.pageY-200)+"px")
                tooltip.html("본부명: " + d.properties.name + "<br/>" + "본부이름: " + d.properties.name)
            })
            .on('click', spot_clicked_event)
            .attr('id', function(d) {
                return 'path-' + d.properties.name_eng;
            })
        labels = states
            .selectAll('text')
            .data(json.features) //라벨표시
            .enter()
            .append('text')
            .attr('transform', translateTolabel)
            .attr('id', function(d) {
                return 'label-' + d.properties.name_eng;
            })
            .attr('text-anchor', 'middle')
            .attr('dy', '.35em')
            .text(function(d) {
                return d.properties.name;
            });
    });
	function spot_clicked_event( d){
	    alert( d.properties.name);
	}
    
    //텍스트 위치 조절 - 하드코딩으로 위치 조절을 했습니다.
    function translateTolabel(d) {
        var arr = path.centroid(d);
        if (d.properties.code == 31) {
            //서울 경기도 이름 겹쳐서 경기도 내리기
            arr[1] +=
                d3.event && d3.event.scale
                    ? d3.event.scale / height + 20
                    : initialScale / height + 20;
        } else if (d.properties.code == 34) {
            //충남은 조금 더 내리기
            arr[1] +=
                d3.event && d3.event.scale
                    ? d3.event.scale / height + 10
                    : initialScale / height + 10;
        }
        return 'translate(' + arr + ')';
    }

    function zoom() {
        projection.translate(d3.event.translate).scale(d3.event.scale);
        states.selectAll('path').attr('d', path);
        labels.attr('transform', translateTolabel);
    }
}



// <---------------------------------------------------------------------------------------------------------------------------------


function comboBoxDataSetting(){

	var bonbuName  = "";
	var jisaName   = "";
	if($("select[id='combo_select01'] option:selected").val()!='전체'){
		$('#combo_select02').attr('disabled',false);
		bonbuName = $("#combo_select01").val();
		flag = 1;
	}
// 	if($("#combo_select02").val() !="전체")
	if($("select[id='combo_select02'] option:selected").val()!='전체'){
		$('#combo_select03').attr('disabled',false);
		jisaName = $("#combo_select02").val();
		flag = 2;
	}
		
	param = {
			bonbuName 		: bonbuName,
			jisaName 		: jisaName
			};
	
		$.ajax({
			method	: "post",
			url		: "comboBoxDataSetting.do",
			data	: param,
			dataType : "JSON",
			async : false,
			beforeSend : beforeAjax,
			success : sucComboBox,
			error : errSearchCode
		});
}
function sucComboBox(result){
	//prgressload(false);
	setComboData(result.returnData);
}
function errSearchCode(xhr,status,error) {
	//prgressload(false);
}
function setComboData(returnData){
 	var inHtml00 = '<option value="전체" selected="selected">전체</option>';
 	var inHtml01 = '<option value="전체" selected="selected">전체</option>';
 	var inHtml02 = '<option value="전체" selected="selected">전체</option>';
// 	var inHtml00 = '';
// 	var inHtml01 = '';
// 	var inHtml02 = '';
	var comboData = returnData.resultData_bonbuName;
	if(flag == 0){
		for(var i = 0; i<comboData.length; i++){
			var value = comboData[i];
			inHtml00 += '<option value="'+value.bonbuName+'">'+value.bonbuName+'</option>';	
		}
		$("#combo_select01").html(inHtml00);
		//document.getElementById('combo_select01').innerHTML=inHtml00;
	}
	if(returnData.resultData_jisaName != null && flag == 1){
		var comboData02 = returnData.resultData_jisaName;
		for(var i = 0; i<comboData02.length; i++){
			var value = comboData02[i];
			inHtml01 += '<option value="'+value.jisaName+'">'+value.jisaName+'</option>';
		}
		$("#combo_select02").html(inHtml01);
		//document.getElementById('combo_select02').innerHTML=inHtml01;
	}
	if(returnData.resultData_officeName != null && flag == 2){
		var comboData03 = returnData.resultData_officeName;
		for(var i = 0; i<comboData03.length; i++){
			var value = comboData03[i];
			inHtml02 += '<option value="'+value.officeCode+'" value2="'+value.officeName+'">'+value.officeName+'</option>';
		}
		$("#combo_select03").html(inHtml02);
		//document.getElementById('combo_select03').innerHTML=inHtml02;
	}
}

// SelectBox change Evt
$(function() {
//<------------------- 부장님 휴가
	$("#combo_select01").change(function() {
		$("#combo_select02").val("전체");
		$("#combo_select03").val("전체");
		$('#combo_select03').attr('disabled',true);
		comboBoxDataSetting();
		$('#result_table').remove();
		$('#totalCNT').hide();
		if($("select[id='combo_select01'] option:selected").val()=='전체'){
			$('#combo_select02').attr('disabled',true);
		}
	})
	$("#combo_select02").change(function() {
		if($("select[id='combo_select02'] option:selected").val()=='전체'){
			$('#combo_select03').attr('disabled',true);
			//$('#topologyView').attr("disabled",true);
		}
		comboBoxDataSetting();
		$('#result_table').remove();
		$('#totalCNT').hide();
	})
	$("#combo_select03").change(function() {
		if($("select[id='combo_select03'] option:selected").val()!='전체'){
			//$('#topologyView').attr("disabled",false);
		}
		if($("select[id='combo_select03'] option:selected").val()=='전체'){
			//$('#topologyView').attr("disabled",true);
		}
		$('#result_table').remove();
		$('#totalCNT').hide();
	})
//<------------------- 부장님 휴가


	// viewFlag default : 0 , table: 0 , topology: 1
// 	$(document).on('click','#tableView',function(){
// 		viewFlag=0;
// 		$('#container').hide();
// 		$('#btn_srch1').hide();
// 		$('#btn_srch').show();
// 	});
// 	$(document).on('click','#topologyView',function(){
// 		viewFlag=1;
// 		drawMap('#container');
// 		$('#btn_srch').hide();
// 		$('#btn_srch1').show();
// 		$('#view01').hide();
// 	});
	$('input[name=viewMode]').change(function(){
		var radioVal = $(this).val();
		if(radioVal == "0"){
	 		viewFlag=0;
	 		$('#container').hide();
	 		$('#btn_srch1').hide();
	 		$('#btn_srch').show();
	 		$('#totalCNT').hide();
	 		$('#view02').hide();
		}else{
	 		viewFlag=1;
	 		drawMap('#container');
	 		$('#btn_srch').hide();
	 		$('#btn_srch1').show();
	 		$('#totalCNT').hide();
	 		$('#view01').hide();
		}
		
	});
	
});

// key event mainName 
function mainNameSrch(txt)
{
	var checkStr = txt.value;
	txt.value = txt.value.replace(/ /gi,"");
	vCurrent = txt.value;
    if(checkStr != vCurrent) return false;   
    var l = checkStr.length;
}
function doSrch(pageNo){
	
	page_size      = $("#rowCount").val();
	
	var srcFlag  = false;
	var startIndex = (pageNo-1) * page_size + 1;
	var endIndex   = page_size * pageNo ;
	var bonbuName  = '';
	var jisaName   = '';
	var officeCode = '';
	var mainName   = '';
	var searchFlag = '';
	// 본부만 선택시 A, 지사선택시 B, Office선택,  장비명 입력시 기존방법
	if($("#combo_select01").val() !="전체") {
		bonbuName = $("#combo_select01").val();
		searchFlag='A';
	}
	if($("#combo_select02").val() !="전체") {
		jisaName  = $("#combo_select02").val();
		searchFlag='B';
	}
	if($("#combo_select03").val() !="전체") {
		officeCode = $("#combo_select03").val();
		searchFlag='C';
	}
	if($("#txtMainName").val() != "") {
		mainName = $.trim($("#txtMainName").val()).toUpperCase();
		searchFlag='C';
	}
	if(bonbuName !="전체"){
		if(bonbuName !="" ){
			srcFlag =true;
		}
	}
	if(mainName !=""){
		srcFlag =true;
	}
	if(srcFlag){
		param = {
				startIndex  : startIndex,
				endIndex    : endIndex,	
				PAGENO		: pageNo == null ? 1: pageNo,
				PAGESIZE	: page_size,
				bonbuName 	: bonbuName,
				jisaName 	: jisaName,
				officeCode  : officeCode,
				mainName    : mainName,
				searchFlag	: searchFlag,
				DEBUG		: "F"
			};
		$.ajax({
			method	: "post",
			url		: "oltSearch.do",
			data	: param,
			dataType : "JSON",
			async : true, // double Click 등의 중복 동작에서 오류 발생
			beforeSend : beforeAjax,
			success : successSrch,
			error : errDoSrch
		});
		
	}else{
		alert("본부를 선택해주세요");
	}
}

function beforeAjax(xmlHttpRequest) {
	xmlHttpRequest.setRequestHeader("AJAX", "true");
}

function successSrch(result) {
	//prgressload(false);
	setOltListData(result.returnData, result.totalCnt);
	
}
function setOltListData(returnData, totalCnt){
	switch(viewFlag){
	case 0:
		currentPageNo = $("#divPaginate").children('strong').html();
		if (returnData.PAGENO == 1) {
			totalCount = totalCnt;
			$("#totalCntLbl1").text(totalCount);
		}
		$("#divPaginate").html(paginateSetting(totalCount, page_size, Number(returnData.PAGENO)));
		$('#view01').show();
		var inHtmlA = '';
		var inHtmlB = '';
		var inHtmlC = '';
		var oltList = returnData.resultData;
		var searchFlag = returnData.searchFlag;
		switch(searchFlag){
			case "A":
				inHtmlA ='<table class="tbl-normal" id = "result_table" style="width:100%;">'+
							'<caption>단말관리</caption>'+
							'<thead>'+
							'<tr id="headerGroup">'+
								'<th nowrap width="auto;"><span>본부명</span></th>'+
								'<th nowrap width="auto;"><span>지사명</span> </th>'+
								'<th nowrap width="auto;"><span>OLT</span></th>'+
								'<th nowrap width="auto;"><span>STB</span></th>'+
							'</tr>'+
							'</thead>'+
							'<colgroup align="center" width="100%" >'+
								'<col align="center" >'+
								'<col align="center" >'+
								'<col align="center" >'+
								'<col align="center" >'+
							'</colgroup>'+
							'<tbody id="tbodyUpgradeData">'+
							'</tbody>'+
						 '</table>';
						 $("#main_table").html(inHtmlA);
						 inHtmlA = '';
				if (oltList.length == 0) {
					inHtmlA += '<tr><td colspan="4">조회된 정보가 없습니다.</td></tr>';
				} else {
					for (var i = 0; i < oltList.length; i++) {
						var value = oltList[i];
						var arrParam = new Array();	
						arrParam.push(value.bonbuName);
						if(value.bonbuName !=null)
						{
							inHtmlA +=   '<tr>'+
										'<td nowrap class="class">'+value.bonbuName +'</td>'+
										'<td nowrap class="class" style="font-weight:bold;">'+value.jisaName+'</td>'+
										'<td nowrap class="class">'+value.oltCnt+'</td>'+
										'<td nowrap class="class">'+value.stbCnt+'</td>'+
										'</tr>';
						}
						else 
						{
							inHtmlA += '<tr><td nowrap></td></tr>';
						}
					}
				}
				$("#tbodyUpgradeData").html(inHtmlA);
				break;
			case "B":
				inHtmlB ='<table class="tbl-normal" id = "result_table" style="width:100%;">'+
							'<caption>단말관리</caption>'+
							'<thead>'+
							'<tr id="headerGroup">'+
								'<th nowrap width="auto;"><span>본부명</span></th>'+
								'<th nowrap width="auto;"><span>지사명</span> </th>'+
								'<th nowrap width="auto;"><span>국사명</span></th>'+
								'<th nowrap width="auto;"><span>OLT</span></th>'+
								'<th nowrap width="auto;"><span>STB</span></th>'+
							'</tr>'+
							'</thead>'+
							'<colgroup align="center" width="100%" >'+
								'<col align="center" >'+
								'<col align="center" >'+
								'<col align="center" >'+
								'<col align="center" >'+
								'<col align="center" >'+
							'</colgroup>'+
							'<tbody id="tbodyUpgradeData">'+
							'</tbody>'+
						 '</table>';
						 $("#main_table").html(inHtmlB);
						 inHtmlB = '';
				if (oltList.length == 0) {
					inHtmlB += '<tr><td colspan="5">조회된 정보가 없습니다.</td></tr>';
				} else {
					for (var i = 0; i < oltList.length; i++) {
						var value = oltList[i];
						var arrParam = new Array();	
						arrParam.push(value.bonbuName);
						if(value.bonbuName !=null)
						{
							inHtmlB +=   '<tr>'+
											'<td nowrap class="class">'+value.bonbuName +'</td>'+
											'<td nowrap class="class">'+value.jisaName+'</td>'+
											'<td nowrap class="class" style="font-weight:bold;">'+value.officeName+'</td>'+
											'<td nowrap class="class">'+value.oltCnt+'</td>'+
											'<td nowrap class="class">'+value.stbCnt+'</td>'+
										 '</tr>';
						}
						else 
						{
							inHtmlB += '<tr><td nowrap></td></tr>';
						}
					}
				}
				$("#tbodyUpgradeData").html(inHtmlB);
				break;
			case "C":
				inHtmlC ='<table class="tbl-normal" id = "result_table" style="width:100%;">'+
							'<caption>단말관리</caption>'+
							'<thead>'+
							'<tr id="headerGroup">'+
								'<th nowrap width="auto;"><span>본부/지사/국사</span></th>'+
								'<th nowrap width="auto;"><span>장비코드</span></th>'+
								'<th nowrap width="auto;"><span>장비명</span> </th>'+
								'<th nowrap width="auto;"><span>셋탑수</span></th>'+
							'</tr>'+
							'</thead>'+
							'<colgroup align="center" width="100%" >'+
								'<col align="center" >'+
								'<col align="center" >'+
								'<col align="center" >'+
							'</colgroup>'+
							'<tbody id="tbodyUpgradeData">'+
							'</tbody>'+
						 '</table>';
						 $("#main_table").html(inHtmlC);
						 inHtmlC = '';
				if (oltList.length == 0) {
					inHtmlC += '<tr><td colspan="4">조회된 정보가 없습니다.</td></tr>';
				} else {
					for (var i = 0; i < oltList.length; i++) {
						var value = oltList[i];
						var arrParam = new Array();	
						arrParam.push(value.mainNesCode);
						if(value.mainNesCode !=null)
						{
							inHtmlC +=   '<tr>'+
										'<td nowrap class="class">'+value.bonbuName +'/'+value.jisaName+'/'+value.officeName+'</td>'+
										'<td nowrap class="class">'+value.mainNesCode +'</td>'+
										'<td nowrap class="class">'+value.mainName+'</td>'+
										'<td nowrap class="class">'+value.stbCnt+'</td>'+
										'</tr>';
						}
						else 
						{
							inHtmlC += '<tr><td nowrap></td></tr>';
						}
					}
				}
				$("#tbodyUpgradeData").html(inHtmlC);
				break;
		}
		break;
	}
		
}


function errDoSrch(xhr,status,error) {
// 	prgressload(false);
	if(xhr.status == 999) {
		alert("세션이 종료되었습니다.");
	} else {
		alert("조회중 에러가 발생하였습니다.");
	}
}

</script>
<style type="text/css">
#container {
	width: 700px;
	min-height: 700px;
	float: left;
	margin: 15px 35px;
	fill: #f6f6f6;
}
#states path {
/* 	fill: #8977ad; */
	stroke: #fff;
	stroke-width: 1.5px;
}

#states path:hover {
	fill: #0080ff;
}

#states .active {
	fill: #0080ff;
}

#states .activeDetail {
	fill: #0080ff;
}
#states1 .active {
	fill: red;
}

#states1 .activeDetail {
	fill: red;
}


#states path {
	cursor: pointer;
}

#states text {
	cursor: pointer;
	font-size: 12px;
	font-weight:bold;
	fill: #000
}
.toolTip {
    position: absolute;
    border: 1px solid;
    border-radius: 4px 4px 4px 4px;
    background: rgba(0, 0, 0, 0.8);
    color : white;
    padding: 5px;
    text-align: center;
    font-size: 12px;
    min-width: 30px;
}
</style>
<section >
<div class="wrap">
		<div class="content" style="height:870px;">
			<div class="sub-breadcrumb">
				<div class="section">
					<div class="breadcrumb" >
						<a href="#" class="home">Home</a>
						<a href="#" class="first-depth">단말품질모니터링</a>
					</div>
				</div>
			</div>
		<div class="section" style="min-height: 790px;">
			<div class="main-content">
				<h3 class="title">단말 품질 모니터링</h3>
				<!-- 검색조건 -->
				<div class="tbl-wrap">
					<div class="search">							
						<table class="tbl-search" id = "contents_table">
						<caption>Search Condition</caption>
						<colgroup>
							<col style="width:7%;" />
							<col style="width:15%;" />
							<col style="width:7%;" />
							<col style="width:15%;" />
							<col style="width:8%;" />
							<col style="width:15%;" />
							<col style="width:10%;" />
							<col style="width:15%;" />
						</colgroup>
						<tbody>
						<tr>
							<th>
								 <span>본부</span>  
							</th>
							<td id="leftTd">
								<span>
									<select name="comboBox" class="w100p" id="combo_select01">
										<option value="전체" selected="selected">전체</option>	
									</select>
								</span>
							</td>
							<th>
								<span>지사</span>
							</th>
							<td>
								<span>
									<select name="comboBox" class="w100p" id="combo_select02">
										<option value="전체" selected="selected">전체</option>
									</select>
								</span>
							</td>
							<th>
								<span>국사</span> 
							</th>
							<td>
								<span>
									<select name="comboBox" class="w100p" id="combo_select03">
										<option value="전체" selected="selected">전체</option>
									</select>
								</span>
							</td>
						</tr>
						<tr>
							<th>
								<span>NE</span>							
							</th>
							<td>
								<span>
									<input type="text" id="txtMainName" class="w100p" autocomplete="off" maxlength="7" onkeydown="mainNameSrch(this);" onkeyup="mainNameSrch(this);"/>
								</span>
							</td>
							<th>
								<span>출력화면</span>							
							</th>
							<td>
								<span>
									<input type="radio" name="viewMode" id="tableView" checked="checked" value="0"  /><label>table</label>
									<input type="radio" name="viewMode" id="topologyView" value="1"/><label>map</label>
								</span>
							</td>
						</tr>
						</tbody>
						</table>
					</div>
					<div class="search-btn-area">
						<div class="search-btn">
							<a href="#" onclick="doSrch(1)" class="btn-sch" id="btn_srch">검색</a>
							<a href="#" onclick="doSrch1(1)" class="btn-sch" id="btn_srch1" style="display:none;">검색</a>
						</div>
					</div>
<!-- 					<span class="table-normal" id="map_table" style="height: 450px;overflow: auto;"> -->
<!-- 					</span> -->
<!-- 					<span class="chartreport"> -->
<!-- 						<span id="container" style="padding-left:25%;width:auto;height:450px;overflow:auto;display: none;"></span> -->
<!-- 					</span> -->
					<div id="view02" style="display:none; padding-left:5%; height:570px; overflow: auto;">
						<span class="chartreport">
							<span id="container" style="padding-left:25%;width:auto;height:450px;overflow:auto;display: none;"></span>
						</span>
						<span><br><br></span>
						<span class="table-normal" id="map_table" style="height: 400px;overflow: auto;">
						</span>
<!-- 						<span class="grid-control" id="tableView01"> -->
<!-- 							<span class="left"> -->
<!-- 								<span class="row">row:</span> -->
<!-- 								<select id="rowCount"> -->
<!-- 									<option>20</option> -->
<!-- 									<option>50</option> -->
<!-- 									<option>100</option> -->
<!-- 								</select> -->
<!-- 							</span> -->
<!-- 							<span class="center"> -->
<!-- 								<span class="paginate_complex" id="divPaginate"></span> -->
<!-- 							</span> -->
							<span class="right" id="totalCNT" style="display:none; padding-left:13%">
								<span>Total: <strong><label id="totalCntLbl" style="color:red">0</label></strong></span>
							</span>
<!-- 						</span> -->
					</div> <!-- map end -->
					
					<div id="view01" style="display:none;">
						<div class="table-normal" id="main_table" style="height: 450px;overflow: auto;">
						</div>
						<div class="grid-control" id="tableView01">
							<div class="left">
								<span class="row">row:</span>
								<select id="rowCount">
									<option>20</option>
									<option>50</option>
									<option>100</option>
								</select>
							</div>
							<div class="center">
								<div class="paginate_complex" id="divPaginate"></div>
							</div>
							<div class="right">
								<span>Total: <strong><label id="totalCntLbl1" style="color:red">0</label></strong></span>
							</div>											
						</div>
					</div> <!-- table end -->
				
				<div id=loading style=’position:absolute;left:100;top:130;’>
					<img src="/resources/img/loader-icon-spacer.gif" style="position:absolute;top:60%;left:50%;margin-top:-112px;margin-left:-100px;">
				</div>
			</div>
		</div>
		</div>
	</div>
</div>
</section>
