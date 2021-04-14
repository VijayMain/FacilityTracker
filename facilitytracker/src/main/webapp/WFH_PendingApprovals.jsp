<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WFH Approvals</title>
<style type="text/css">
table.gridtable {
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 11px;
	border-width: 1px;
	padding: 3px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 11px;
	border-width: 1px;
	padding: 1px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
</style>
<!-- Bootstrap CSS -->
<link href="css/bootstrap.min.css" rel="stylesheet">
<!-- bootstrap theme -->
<link href="css/bootstrap-theme.css" rel="stylesheet">
<!--external css-->
<!-- font icon -->
<link href="css/elegant-icons-style.css" rel="stylesheet" />
<link href="css/font-awesome.min.css" rel="stylesheet" />
<!-- full calendar css-->
<link href="assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css"
	rel="stylesheet" />
<link href="assets/fullcalendar/fullcalendar/fullcalendar.css"
	rel="stylesheet" />
<!-- easy pie chart-->
<link href="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css"
	rel="stylesheet" type="text/css" media="screen" />
<!-- owl carousel -->
<link rel="stylesheet" href="css/owl.carousel.css" type="text/css">
<link href="css/jquery-jvectormap-1.2.2.css" rel="stylesheet">
<!-- Custom styles -->
<link rel="stylesheet" href="css/fullcalendar.css">
<link href="css/widgets.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/style-responsive.css" rel="stylesheet" />
<link href="css/xcharts.min.css" rel=" stylesheet">
<link href="css/jquery-ui-1.10.4.min.css" rel="stylesheet">
 <script type="text/javascript">
 function decision_call(){
		var userName = document.getElementById('userName').value; 
		var approvalType = document.getElementById('approvalType').value;      
		var monthSelected = document.getElementById('monthSelected').value; 
		var yesrSelected = document.getElementById('yesrSelected').value; 
		if(userName==""){
			alert("Select User First ...!!!");
		}else{
		var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("userData").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "WFH_PendingApprovals_AJAX.jsp?u=" + userName + "&m=" + monthSelected + "&y=" + yesrSelected + "&ap=" + approvalType, true);
			xmlhttp.send();
		}
	};
	
	function listOfMonths_call(val){ 
		if(val==""){
			alert("Select Proper Input...!!!");
		}else{
		var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("pendingMonths").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "WFH_userPendingMonths.jsp?val=" + val, true);
			xmlhttp.send();
		}
	};
 </script>
</head>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: white;">
	<%
		try { 
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			PreparedStatement ps_check=null,ps_check1=null;
			ResultSet rs_check=null,rs_check1=null;
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString());

			Calendar todayCal= Calendar.getInstance();
			Calendar cal = Calendar.getInstance();

			// Last day of month ===>
			int current_mnt_lastDay = cal.getActualMaximum(Calendar.DATE); 
			cal.set(Calendar.DATE,1); 
			SimpleDateFormat sdf=new SimpleDateFormat("EEEE");

			//System.out.println(sdf.format(cal.getTime()) + " = " + current_mnt_lastDay);

			// Days Name ==>
			String[] namesOfDays = DateFormatSymbols.getInstance().getWeekdays(); 

			// first day name
			String firstDayName = namesOfDays[cal.get(Calendar.DAY_OF_WEEK)]; 

			int today = todayCal.get(Calendar.DATE);
			int monthpass = cal.get(Calendar.MONTH);
			int yearpass = cal.get(Calendar.YEAR);
	%>
	<!-- ********************************************************************************************************************* -->
	<div class="panel panel-primary" style="background-color: white;">
				<table style="width: 50%;">
					<tr>
						<th><a href="Home.jsp"><b style="font-size: 15px;color: blue;">Go back to Dashboard</b></a></th>
					</tr>
			</table>					
		<div class="panel">  
                <ul class="nav nav-tabs" style="font-size: 12px;font-weight: bold;">
                  <li class="active">
                    <a data-toggle="tab" href="#home">DWM Pending Approvals</a>
                  </li> 
                </ul>
              <div class="panel-body">
                <div class="tab-content">
                   <table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;"> 
             		<th align="center"  style="color: black;">Select User</th>  
					<th align="center"  style="color: black;">Select Month</th> 
					<th align="center"  style="color: black;">Select Year</th>   
					<th align="center"  style="color: black;">Approval Type</th>
					<th align="center"  style="color: black;">Get Data</th>  
					<th align="center"  style="color: black;width: 10%">Pending Months</th>  
				</tr>
				<tr style="color: black;text-align: center;">
					<td>
					  <select name="userName" id="userName" onchange ="listOfMonths_call(this.value)" style="font-weight: bold;color: black;width: 190px;height: 25px;"> 
					  <option value=""> - - - - Select - - - - </option>
					<%
					ps_check = con_master.prepareStatement("select distinct(u_id) as u_id from tran_dwm_tasks where enable_id=1 and approval_id is null and id in (select dwm_id from rel_dwm_approvers where enable_id=1 and u_id="+uid+")");
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						ps_check1 = con.prepareStatement("select U_Id,U_Name from user_tbl where u_id="+rs_check.getInt("u_id"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<option value="<%=rs_check1.getInt("U_Id")%>"><%=rs_check1.getString("U_Name") %></option>
					<%		
						}
					} 
					%>
					</select>
					</td>
					<td align="center">
					<%
                    List<String> monthsList = new ArrayList<String>();
                    String[] months = new DateFormatSymbols().getMonths(); 
                    Calendar now = Calendar.getInstance();
                    %>
                 <select name="monthSelected" id="monthSelected"  style="font-weight: bold;color: black;width: 190px;height: 25px;">
                  <%
                  int curr_mth = now.get(Calendar.MONTH); 
                  %>
                  <option value="<%=curr_mth%>"><%=months[curr_mth]%></option>  
                    <%
                      for (int i = curr_mth+1; i < months.length-1; i++) {
                      String month = months[i]; 
                      %>
                      <option value="<%=i%>"><%=month%></option>
                      <%  
                    	} 
                    for (int i = 0; i < curr_mth; i++) {
                      String month = months[i]; 
                      %>
                      <option value="<%=i%>"><%=month%></option>
                      <%  
                    	}
                    %>
                 </select>
					</td>
					<td>
					  <select name="yesrSelected" id="yesrSelected"   style="font-weight: bold;color: black;width: 190px;height: 25px;">
                   <%
                      int year = Calendar.getInstance().get(Calendar.YEAR);                     
                      for(int i=year;i>=year-2;i--){
                          %>
                          <option value="<%=i%>"><%=i%></option> 
                          <%  
                          }
                      	  %>
                   </select>
					</td>
					<td>
					  <select name="approvalType" id="approvalType" style="font-weight: bold;color: black;width: 190px;height: 25px;" required> 
					  <option value=""> - - - - Select - - - - </option>
					<%
					ps_check1 = con_master.prepareStatement("select id,approval_type from approval_type where enable=1 order by id desc");
					rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<option value="<%=rs_check1.getInt("id")%>"><%=rs_check1.getString("approval_type") %></option>
					<%		
						}
					  %>
						</select>
					</td>
					<td>
					<button  onclick="decision_call()" style="color: white;font-weight: bold;background-color: #69390f;width: 200px;height: 25px;">Search</button>
					</td>
					
					<td><span id="pendingMonths"></span> </td>
				</tr> 
				</table> 
				
				<span id="userData"></span>
                  </div>
              </div> 
		</div>

	


	</div>
	<%
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	<!--main content end-->

	<!-- container section start -->

	<!-- javascripts -->
	<script src="js/jquery.js"></script>
	<script src="js/jquery-ui-1.10.4.min.js"></script>
	<script src="js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.9.2.custom.min.js"></script>
	<!-- bootstrap -->
	<script src="js/bootstrap.min.js"></script>
	<!-- nice scroll -->
	<script src="js/jquery.scrollTo.min.js"></script>
	<script src="js/jquery.nicescroll.js" type="text/javascript"></script>
	<!-- charts scripts -->
	<script src="assets/jquery-knob/js/jquery.knob.js"></script>
	<script src="js/jquery.sparkline.js" type="text/javascript"></script>
	<script src="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.js"></script>
	<script src="js/owl.carousel.js"></script>
	<!-- jQuery full calendar -->
	<script src="js/fullcalendar.min.js"></script>
	<!-- Full Google Calendar - Calendar -->
	<script src="assets/fullcalendar/fullcalendar/fullcalendar.js"></script>
	<!--script for this page only-->
	<script src="js/calendar-custom.js"></script>
	<script src="js/jquery.rateit.min.js"></script>
	<!-- custom select -->
	<script src="js/jquery.customSelect.min.js"></script>
	<script src="assets/chart-master/Chart.js"></script>

	<!--custome script for all page-->
	<script src="js/scripts.js"></script>
	<!-- custom script for this page-->
	<script src="js/sparkline-chart.js"></script>
	<script src="js/easy-pie-chart.js"></script>
	<script src="js/jquery-jvectormap-1.2.2.min.js"></script>
	<script src="js/jquery-jvectormap-world-mill-en.js"></script>
	<script src="js/xcharts.min.js"></script>
	<script src="js/jquery.autosize.min.js"></script>
	<script src="js/jquery.placeholder.min.js"></script>
	<script src="js/gdp-data.js"></script>
	<script src="js/morris.min.js"></script>
	<script src="js/sparklines.js"></script>
	<script src="js/charts.js"></script>
	<script src="js/jquery.slimscroll.min.js"></script>
	<script>
		//knob
		$(function() {
			$(".knob").knob({
				'draw' : function() {
					$(this.i).val(this.cv + '%')
				}
			})
		});

		//carousel
		$(document).ready(function() {
			$("#owl-slider").owlCarousel({
				navigation : true,
				slideSpeed : 300,
				paginationSpeed : 400,
				singleItem : true

			});
		});

		//custom select box

		$(function() {
			$('select.styled').customSelect();
		});

		/* ---------- Map ---------- */
		$(function() {
			$('#map').vectorMap({
				map : 'world_mill_en',
				series : {
					regions : [ {
						values : gdpData,
						scale : [ '#000', '#000' ],
						normalizeFunction : 'polynomial'
					} ]
				},
				backgroundColor : '#eef3f7',
				onLabelShow : function(e, el, code) {
					el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
				}
			});
		});
	</script>

</body>
</html>