<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- ===== #38.  tiles 중 sideinfo 페이지 만들기 ===== --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	${demo.css}
</style>

<script type="text/javascript" src="<%= request.getContextPath() %>/resources/js/highcharts.js"></script>        <!-- 차트그리기 --> 
<script type="text/javascript" src="<%= request.getContextPath() %>/resources/js/modules/data.js"></script>
<script type="text/javascript" src="<%= request.getContextPath() %>/resources/js/modules/drilldown.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		loopshowNowTime();
//		showRank();
	}); // end of ready(); ---------------------------------

	function showNowTime() {
		
		var now = new Date();
	
		var strNow = now.getFullYear() + "-" + (now.getMonth() + 1) + "-" + now.getDate();
		
		var hour = "";
		if(now.getHours() > 12) {
			hour = " 오후 " + (now.getHours() - 12);
		} else if(now.getHours() < 12) {
			hour = " 오전 " + now.getHours();
		} else {
			hour = " 정오 " + now.getHours();
		}
		
		var minute = "";
		if(now.getMinutes() < 10) {
			minute = "0"+now.getMinutes();
		} else {
			minute = ""+now.getMinutes();
		}
		
		var second = "";
		if(now.getSeconds() < 10) {
			second = "0"+now.getSeconds();
		} else {
			second = ""+now.getSeconds();
		}
		
		strNow += hour + ":" + minute + ":" + second;
		
		$("#clock").html("<span style='color:green; font-weight:bold;'>"+strNow+"</span>");
	
	}// end of function showNowTime() -----------------------------


	function loopshowNowTime() {
		showNowTime();
		
		var timejugi = 1000;   // 시간을 1초 마다 자동 갱신하려고.
		
		setTimeout(function() {
						loopshowNowTime();	
					}, timejugi);
		
	}// end of loopshowNowTime() --------------------------
	
	/*
	function getTableRank() {
		
		$.getJSON("rankShowJSON.action", function(data){
	 								 // data => ajax 요청에 의해 서버로 부터 리턴받은 데이터.
			$("#displayRank").empty();   // <div id="displayRank"> 엘리먼트를 모두 비워서 새 데이터를 채울 준비를 한다.
		
			// $.each() 함수는 $(selector).each()와는 다르다.
			// $.each(순회해야할 collection 또는 배열, callback(indexInArray, valueOfElement) );
			// 배열을 다루는 경우에는, 콜백 함수는 인덱스와 값을 인자로 갖는다.
			// 만약 map 형태의 집합을 다루게 되면 key와 value의 쌍으로 동작한다.
			
			var html = "<table class='table table-hover' align='center' width='250px' height='180px'>";
				html += "<tr>";
				html += "<th>등수</th>";
				html += "<th>제품명</th>";
				html += "<th>주문량합</th>";
				html += "</tr>";
			
			$.each(data, function(entryIndex, entry){  
				html += "<tr>";
				html += "<td class='mynumber'>";
				html += "<span class='myrank'>" + entry.RANK + "</span>";
				html += "</td>";
				html += "<td>";
				html += ""+ entry.JEPUMNAME;
				html += "</td>";
				html += "<td class='mynumber'>";
				html += ""+ entry.TOTALQTY;
				html += "</td>";
				html += "</tr>";
			});
		
				html += "</table>";
		
			$("#displayRank").append(html);
			
		}); // end of $.getJSON("rankShowJSON.action", function(data) {} )-----------
	}// end of function getTableRank() { }--------------------------
	
	
	function getChartRank() {
		
		$.getJSON("rankShowJSON.action", function(data){
	 								     // data => ajax 요청에 의해 서버로 부터 리턴받은 데이터.
            var jepumObjArr = [];
            	 		
			$.each(data, function(entryIndex, entry){ 
				jepumObjArr.push({
	                name: entry.JEPUMNAME,
	                y: parseFloat(entry.PERCENT),
	                drilldown: entry.JEPUMNAME
	            });
			});	// end of $.each(data, function(entryIndex, entry)----------------
			
			
    			var jepumDetailNamePercentObjArr = [];
 		// 또는 var jepumDetailNamePercentObjArr = new Array();
		    			
			$.each(data, function(entryIndex, entry) { 
				
				$.getJSON("jepumdetailnameRankShowJSON.action?jepumname="+entry.JEPUMNAME, function(data2){
					
					var subArr = [];
			// 또는 var subArr = new Array();

					$.each(data2, function(entryIndex2, entry2){ 
						
						subArr.push([
									 entry2.JEPUMDETAILNAMEPERCENT.jepumdetailname,
									 entry2.JEPUMDETAILNAMEPERCENT.percent
								    ]);
					});	
					
					jepumDetailNamePercentObjArr.push({
						name: entry.JEPUMNAME,
						id: entry.JEPUMNAME,
						data: subArr
					});	
					
				});
				
			}); // end of $.each(data, function(entryIndex, entry){ ----------------------
			
			
	 								 
		    // Create the chart
		    $('#chart-container').highcharts({
		        chart: {
		            type: 'column'
		        },
		        title: {
		            text: '제품별 판매 점유율'
		        },
		        subtitle: {
		           // text: 'Click the columns to view versions. Source: <a href="http://netmarketshare.com">netmarketshare.com</a>.'
		        },
		        xAxis: {
		            type: 'category'
		        },
		        yAxis: {
		            title: {
		                text: '점유율(%)'
		            }

		        },
		        legend: {
		            enabled: false
		        },
		        plotOptions: {
		            series: {
		                borderWidth: 0,
		                dataLabels: {
		                    enabled: true,
		                    format: '{point.y:.1f}%'
		                }
		            }
		        },

		        tooltip: {
		            headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
		            pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
		        },

		        series: [{
		            name: 'Brands',
		            colorByPoint: true,
		            data: jepumObjArr   // **** 위에서 구한값을 대입시킴. ****
		        }],
		        drilldown: { 
		        	series: jepumDetailNamePercentObjArr  // **** 위에서 구한값을 대입시킴. ****
		         /* series: [{
		                name: jepumObjArr[0].name,  // *** 위에서 한 작업으로 키값이 JEPUMNAME 에서 name 으로 변경됨.
		                id: jepumObjArr[0].name,    // *** 위에서 한 작업으로 키값이 JEPUMNAME 에서 name 으로 변경됨.
		                data: [
		                    [
		                        'v11.0',
		                        24.13
		                    ],
		                    [
		                        'v8.0',
		                        17.2
		                    ],
		                    [
		                        'v9.0',
		                        8.11
		                    ],
		                    [
		                        'v10.0',
		                        5.33
		                    ],
		                    [
		                        'v6.0',
		                        1.06
		                    ],
		                    [
		                        'v7.0',
		                        0.5
		                    ]
		                ]
		            }, {
		                name: jepumObjArr[1].name,
		                id: jepumObjArr[1].name,
		                data: [
		                    [
		                        'v40.0',
		                        5
		                    ],
		                    [
		                        'v41.0',
		                        4.32
		                    ],
		                    [
		                        'v42.0',
		                        3.68
		                    ],
		                    [
		                        'v39.0',
		                        2.96
		                    ],
		                    [
		                        'v36.0',
		                        2.53
		                    ],
		                    [
		                        'v43.0',
		                        1.45
		                    ],
		                    [
		                        'v31.0',
		                        1.24
		                    ],
		                    [
		                        'v35.0',
		                        0.85
		                    ],
		                    [
		                        'v38.0',
		                        0.6
		                    ],
		                    [
		                        'v32.0',
		                        0.55
		                    ],
		                    [
		                        'v37.0',
		                        0.38
		                    ],
		                    [
		                        'v33.0',
		                        0.19
		                    ],
		                    [
		                        'v34.0',
		                        0.14
		                    ],
		                    [
		                        'v30.0',
		                        0.14
		                    ]
		                ]
		            }, {
		                name: jepumObjArr[2].name,
		                id: jepumObjArr[2].name,
		                data: [
		                    [
		                        'v35',
		                        2.76
		                    ],
		                    [
		                        'v36',
		                        2.32
		                    ],
		                    [
		                        'v37',
		                        2.31
		                    ],
		                    [
		                        'v34',
		                        1.27
		                    ],
		                    [
		                        'v38',
		                        1.02
		                    ],
		                    [
		                        'v31',
		                        0.33
		                    ],
		                    [
		                        'v33',
		                        0.22
		                    ],
		                    [
		                        'v32',
		                        0.15
		                    ]
		                ]
		            }, {
		                name: jepumObjArr[3].name,
		                id: jepumObjArr[3].name,
		                data: [
		                    [
		                        'v8.0',
		                        2.56
		                    ],
		                    [
		                        'v7.1',
		                        0.77
		                    ],
		                    [
		                        'v5.1',
		                        0.42
		                    ],
		                    [
		                        'v5.0',
		                        0.3
		                    ],
		                    [
		                        'v6.1',
		                        0.29
		                    ],
		                    [
		                        'v7.0',
		                        0.26
		                    ],
		                    [
		                        'v6.2',
		                        0.17
		                    ]
		                ]
		            }, {
		                name: jepumObjArr[4].name,
		                id: jepumObjArr[4].name,
		                data: [
		                    [
		                        'v12.x',
		                        0.34
		                    ],
		                    [
		                        'v28',
		                        0.24
		                    ],
		                    [
		                        'v27',
		                        0.17
		                    ],
		                    [
		                        'v29',
		                        0.16
		                    ]
		                ]
		            }] 
		        
		        }  
		    });	 								 
		
		}); // end of $.getJSON("rankShowJSON.action", function(data) {} )-----------
	}// end of function getChartRank() { }--------------------------
	
	
	function showRank(){
		getTableRank();
		getChartRank();
		
	//	var timejugi = 10000;   // 시간을 10초 마다 자동 갱신하려고.
		
	//	setTimeout(function() {
	//			showRank();	
	//		}, timejugi);
	}// end of showRank()-------------------------
	*/
</script>


<div style="margin: 0 auto;" align="center">
	현재시각 :&nbsp; 
	<div id="clock" style="display:inline;"></div>
</div>
<%-- <div id="displayRank" style="min-width: 90%; margin: 0 auto;  margin-top: 20px; margin-bottom: 70px; padding-left: 10px; padding-right: 10px;"></div>
<div id="chart-container" style="min-width: 90%; min-height: 400px; margin: 0 auto; border: solid #F0FFFF 5px;"></div>
 --%>	
	
	
	
	
	