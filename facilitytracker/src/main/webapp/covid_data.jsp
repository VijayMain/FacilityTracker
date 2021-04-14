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
<title>Self Declaration</title> 
<style type="text/css">
 table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}
table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666; 
	text-align: center;
}
table.gridtable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666; 
}
</style>
<script type="text/javascript">
	 
	function generateExcel() { 
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
				document.getElementById("covid19").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "GetExcelAJAX_COVID.jsp", true);   
		xmlhttp.send();	
	}
	
	
	
	
	
	
	
	function ChangeColor(tableRow, highLight) {
		if (highLight) {
			tableRow.style.backgroundColor = '#CFCFCF';
		} else {
			tableRow.style.backgroundColor = '#FFFFFF';
		}
	} 
	function button1(val) {
		var val1 = val; 
		document.getElementById("hid").value = val1;
		edit.submit();
	}
</script>
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
</head>

<body>
	<%
		try { 
			Connection con = Connection_Util.getLocalUserConnection();
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString()); 
			PreparedStatement ps_check=null,ps_check1=null;
			ResultSet rs_check=null, rs_check1=null;
	/*-------------------------------------------------------------------------------------------------------------------*/
	%>
	<!-- container section start -->
	<section id="container" class=""> <!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
	<%@include file="Header.jsp"%> <!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
	<%@include file="Sidebar.jsp"%> <!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<!--main content start--> <section id="main-content"> <section
		class="wrapper"> <!--overview start-->
	 
<!-- **************************************************** Data Goes Here ************************************************* -->
	<!-- ********************************************************************************************************************* -->
	<div class="row" style="height: 550px; overflow: scroll;background-color: white;width: 100%;"> 
	<form action="Covid19_Dashboard.jsp" method="post" id="edit" name="edit">
			<input type="hidden" name="hid" id="hid">
				<table style="width: 100%;" class="gridtable">  
				<tr>
				<td colspan="18"><span id="covid19"><a href="javascript:generateExcel();"><b>Click to Generate excel</b></a> </span> </td>
				</tr>
						<tr style="text-align: center;background-color: #dedede;">
							<th>No</th>
							<th style="width: 30%;">Name</th>
							<th>Contact</th>
							<th>Work in</th> 
							<th>Emergency Contact</th> 
							<th style="width: 4%;">Fever</th>
							<th style="width: 4%;">Cough</th>
							<th style="width: 4%;">Breathlessness</th>
							<th style="width: 4%;">Sore throat</th>
							<th>Other</th>
							<th style="width: 4%;">Travel Before 14 Days</th>
							<th style="width: 10%;">Location</th> 
							<th style="width: 4%;">Contact with +ve Case</th> 	
							<th style="width: 4%;">Aarogya Setu reg.</th>	
							<th style="width: 20%;">Log Date</th>			
						</tr>  
						<%
						String company="";
						ps_check = con.prepareStatement("SELECT * FROM selfdeclare_tbl where enable_id=1 order by sys_date desc");
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							ps_check1 = con.prepareStatement("SELECT * FROM user_tbl_company where Company_Id="+Integer.valueOf(rs_check.getString("working_in")));
							rs_check1 = ps_check1.executeQuery();
							while(rs_check1.next()){
							company = rs_check1.getString("Company_Name");	
							}
						%>
						 <tr style="height: 30px;  cursor: pointer;" onclick="button1('<%=rs_check.getInt("id")%>');" onmouseover="ChangeColor(this, true);"	onmouseout="ChangeColor(this, false);">
						 <td align="center"><%=rs_check.getInt("id") %></td>
						 <td><%=rs_check.getString("user_name") %></td>
						 <td><%=rs_check.getString("contact_no") %></td>
						 <td><%=company %></td> 
						 <td><%=rs_check.getString("emergency_contactno") %></td>  
						 <% if(rs_check.getString("sympt_fever").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("sympt_fever") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("sympt_fever") %></td>
						<%	 
						 } 
						if(rs_check.getString("sympt_cough").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("sympt_cough") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("sympt_cough") %></td>
						<%	 
						 } 
						if(rs_check.getString("sympt_brethlessness").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("sympt_brethlessness") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("sympt_brethlessness") %></td>
						<%	 
						 }  
						 if(rs_check.getString("sympt_sorethroat").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("sympt_sorethroat") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("sympt_sorethroat") %></td>
						<%	 
						 }
						%>
						 <td><%=rs_check.getString("sympt_other") %> </td>  
					<% if(rs_check.getString("trav_before14days").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("trav_before14days") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("trav_before14days") %></td>
						<%	 
						 }
						%>  
						 <td><%=rs_check.getString("trav_location") %></td> 
						  
						 <% if(rs_check.getString("contact_positive14daysCase").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("contact_positive14daysCase") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("contact_positive14daysCase") %></td>
						<%	 
						 }
						%>   
						
						<% if(rs_check.getString("asetu_register").equalsIgnoreCase("no")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("asetu_register") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("asetu_register") %></td>
						<%	 
						 }
						%> 
						<td><%=mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td>  
						 </tr>
						  
						<%
						}
						%> 
				</table>  
				</form>
	</div>
 
	<!-- project team & activity end --> </section> </section> <%
 	} catch (Exception e) {
 		e.printStackTrace();
 	}
 %> <!--main content end--> 
 
 </section>
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
	<
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