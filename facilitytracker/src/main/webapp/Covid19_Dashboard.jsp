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
<title>Covid19 Dashboard</title>
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
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
	padding: 8px;
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
</head>

<body>
	<%
		try {
			Connection con = Connection_Util.getLocalUserConnection();
			int hid = Integer.valueOf(request.getParameter("hid"));
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			SimpleDateFormat mailDateFormat2 = new SimpleDateFormat("dd/MM/yyyy");
			PreparedStatement ps_check = null, ps_check1 = null,ps_check2 = null;
			ResultSet rs_check = null,rs_check1 = null, rs_check2 = null;
			String company="",relation="";
			ps_check = con.prepareStatement("SELECT * FROM selfdeclare_tbl where enable_id=1 and id=" + hid);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				ps_check1 = con.prepareStatement("SELECT * FROM user_tbl_company where Company_Id="+Integer.valueOf(rs_check.getString("working_in")));
				rs_check1 = ps_check1.executeQuery();
				while(rs_check1.next()){
				company = rs_check1.getString("Company_Name");	
				}
				/*-------------------------------------------------------------------------------------------------------------------*/
	%>
	<!-- ********************************************************************************************************************* -->

	<div class="panel panel-primary">
		<h4 class="panel-title panel-heading"
			style="font-weight: bold; font-size: 20px;">Coronavirus
			Self-Declaration Form Details</h4>
		<a href="covid_data.jsp"><b style="font-size: 15px;">Go back
				to List</b></a>

		<div class="panel panel-success">
			<div class="panel-heading">
				<b>Details of Reg. No : <%=rs_check.getInt("id") %> . </b><strong style="color: blue;"> <%=rs_check.getString("user_name").toUpperCase()%></strong>
				<b> updated on dt. : <%=mailDateFormat.format(rs_check.getTimestamp("sys_date"))%>
				</b>
			</div>
			<div class="panel-content">
				<table style="width: 100%;" class="gridtable">
					<tr>
						<th>Employee ID</th>
						<th>Working In</th>
						<th>Contact No</th>
						<th>Emergency Contact No</th>
						<th>Contact Address</th>
						<th>Email ID</th>
						<th>Registered with Arogya Setu</th>
					</tr>
					<tr>
						<td><%=rs_check.getString("employee_id") %></td>
						<td><%=company %></td>
						<td><%=rs_check.getString("contact_no") %></td>
						<td><%=rs_check.getString("emergency_contactno") %></td>
						<td><%=rs_check.getString("contact_address") %></td>
						<td><%=rs_check.getString("email_id") %></td>
						
						<% if(rs_check.getString("asetu_register").equalsIgnoreCase("no")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("asetu_register") %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("asetu_register") %></td>
						<%	 
						 }
						%> 
						 
					</tr> 
					<tr>
					<th colspan="7"><b>Flu-like symptoms </b></th>
					</tr>
					<tr>
						<th>Fever (38<sup>0</sup> or higher)</th>
						<th>Cough</th>
						<th>Breathlessness</th>
						<th>Sore throat</th>
						<th colspan="3">Others</th> 
					</tr>
					<tr>
						<% if(rs_check.getString("sympt_fever").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;text-align: center;"> <b><%=rs_check.getString("sympt_fever").toUpperCase() %></b>   </td>
						 <% }else{
						%>
						<td style="text-align: center;"><%=rs_check.getString("sympt_fever").toUpperCase() %></td>
						<%	 
						 } 
						if(rs_check.getString("sympt_cough").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;text-align: center;"> <b><%=rs_check.getString("sympt_cough").toUpperCase() %></b>   </td>
						 <% }else{
						%>
						<td style="text-align: center;"><%=rs_check.getString("sympt_cough").toUpperCase() %></td>
						<%	 
						 } 
						if(rs_check.getString("sympt_brethlessness").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;text-align: center;"> <b><%=rs_check.getString("sympt_brethlessness").toUpperCase() %></b>   </td>
						 <% }else{
						%>
						<td style="text-align: center;"><%=rs_check.getString("sympt_brethlessness").toUpperCase() %></td>
						<%	 
						 }  
						 if(rs_check.getString("sympt_sorethroat").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;text-align: center;"> <b><%=rs_check.getString("sympt_sorethroat").toUpperCase() %></b>   </td>
						 <% }else{
						%>
						<td style="text-align: center;"><%=rs_check.getString("sympt_sorethroat").toUpperCase() %></td>
						<%
						 }
						%>
						<td colspan="3"><%=rs_check.getString("sympt_other").toUpperCase() %> </td>  
					</tr>
					<tr>
					<th colspan="7"><b>Country/cities Traveled to in the last 14 days prior to arriving at Mutha Group Premises </b></th>
					</tr> 
					<tr>
						<th>Traveled Before 14 Days</th>
						<th>Name of Country/City</th>
						<th>Date of arrival</th>
						<th colspan="4">Date of departure</th> 
					</tr>
					<tr>
						<% if(rs_check.getString("trav_before14days").equalsIgnoreCase("yes")){ %>
						<td style="background-color: red;color: white;"> <b><%=rs_check.getString("trav_before14days").toUpperCase() %></b>   </td>
						 <% }else{
						%>
						<td><%=rs_check.getString("trav_before14days").toUpperCase() %></td>
						<%	 
						 }
						%>  
						 <td><%=rs_check.getString("trav_location").toUpperCase() %></td> 
						 <td> 
						 <%
						 if(rs_check.getDate("trav_arrivalDate")!=null){
						 %>
						 <%=mailDateFormat2.format(rs_check.getDate("trav_arrivalDate"))%> 
						 <%
						 }
						 %>
						 </td>
						   
						<td colspan="4">
						<%
						 if(rs_check.getDate("trav_departureDate")!=null){
						 %>
						<%=mailDateFormat2.format(rs_check.getDate("trav_departureDate"))%>
						<%
						 }
						%>
						</td> 
					</tr>
					<tr>
					<th colspan="7"><b>Have you or an immediate family member come in close contact with a confirmed case of the coronavirus in the last 14 days? ("Close contact" means being at a distance of less than one metre for more than 15 minutes.) </b></th>
					</tr> 
					 <tr> 
						<% if(rs_check.getString("contact_positive14daysCase").equalsIgnoreCase("yes")){ %>
						<td colspan="7" style="background-color: red;color: white;font-size: 12px;"> <b><%=rs_check.getString("contact_positive14daysCase").toUpperCase() %></b>   </td>
						 <% }else{
						%>
						<td colspan="7" style="font-size: 12px;"><%=rs_check.getString("contact_positive14daysCase").toUpperCase() %></td>
						<%	 
						 }
						%> 
					</tr>
				</table> 
				<table style="width: 100%;" class="gridtable">
				<tr>
				<th colspan="6"><b>Family Details (Total Family Members : <%=rs_check.getInt("totalFamilyMembers") %>)</b></th>
				</tr>
					<tr>
						<th>Name</th>
						<th>Relation</th>
						<th>Age</th>
						<th>flu-like symptoms</th>
						<th>Traveled to in the last 14 days</th>
						<th>close contact with a confirmed case of corona virus in the last 14 days</th>
					</tr>
					<%
					
					ps_check1 = con.prepareStatement("select * from selfdeclare_rel_tbl where enable=1 and co_id="+rs_check.getInt("id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
						ps_check2 = con.prepareStatement("select * from selfdeclare_family_rel_tbl where id="+rs_check1.getInt("relation"));
						rs_check2 = ps_check2.executeQuery();
						while(rs_check2.next()){
							relation=rs_check2.getString("relationEN");
						}
						
					%>
					<tr>
						<td><%=rs_check1.getString("name") %></td>
						<td><%=relation %></td>
						<td><%=rs_check1.getString("age") %></td>
						<td><%=rs_check1.getString("flu_symptoms") %></td>
						<td><%=rs_check1.getString("travel14Before") %></td>
						<td><%=rs_check1.getString("closecontact") %></td>
					</tr>  
					<%
					relation="";
					}
					%>					
				</table>	
				</div>
                </div>




	</div>
	<%
		}
	%>
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