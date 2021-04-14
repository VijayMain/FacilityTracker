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
<title>Take Action</title>
<script type="text/javascript">
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

<body style="color: black;">
	<%
		try {
			int count = 0;
			Connection con = Connection_Util.getLocalUserConnection();
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
			
			boolean availFlag=false;
			PreparedStatement ps_check = null, ps_check1=null;
			ResultSet rs_check = null,rs_check1=null;
			int status = Integer.valueOf(request.getParameter("new"));
			String facility ="",assignedUser="",priority="",department="",requester="",company="", statusLog="",assigned_String="";
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			
			ps_check = con.prepareStatement("SELECT * FROM facility_user_access where access_company=6 and enable=1 and uid="+uid);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				availFlag=true;
			}
			
			if(availFlag==false){
				assigned_String = " and assigned_comp_id ="+comp_id;
			}
			
			ps_check1 = con.prepareStatement("select * from user_tbl where u_id="+uid);
			rs_check1 = ps_check1.executeQuery();
			while(rs_check1.next()){
				requester = rs_check1.getString("U_Name");
			}  
			
			
			ps_check = con.prepareStatement("SELECT count(id) as newCount FROM facility_req_tbl where enable=1 and status_id="+status +assigned_String);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				count = rs_check.getInt("newCount");
			}
			
			
	/*-------------------------------------------------------------------------------------------------------------------*/
	%>
	<!-- container section start -->
	<section id="container" class=""> <!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
	<%@include file="Header.jsp"%> <!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
	<%@include file="Sidebar.jsp"%> <!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
	<!--main content start--> <section id="main-content"> <section
		class="wrapper"> <!--overview start-->
	<div class="row">
		<div class="col-lg-12">
			<!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
			<ol class="breadcrumb">
				<li><i class="fa fa-home"></i><a href="Home.jsp"> Home </a> </li>
				<%
				if(status==1){
				%>
				<li><i class="icon_pencil"></i> NEW REQUEST 
				<%
				}
				if(status==2){
					%>
					<li><i class="icon_question"></i> OPEN REQUEST 
					<%
					}
				if(status==4){
					%>
					<i class="icon_lock-open"></i> RE-OPEN REQUEST
					<%
					}
				if(status==5){
					%>
					<i class="icon_lock"></i> CLOSED REQUEST 
					<%
					}
				%>
				( <b style="color: maroon;"><i class="icon_download"></i> <%=count%> </b> ) <%
					if (request.getParameter("success") != null) {
				%> <strong class="alert alert-success fade in"><%=request.getParameter("success")%>
				</strong> 
			<%
 			}
 			%>
 	</li>
	</ol>
	</div>
</div>
<!-- **************************************************** Data Goes Here ************************************************* -->
	<!-- ********************************************************************************************************************* -->
	<div class="row" style="height: 550px; overflow: scroll;">
		<div class="col-lg-12">
			<section class="panel">
			<div class="table-responsive">
			<form method="post" name="edit" action="Action_Resp.jsp" id="edit">
			<input type="hidden" name="hid" id="hid">
				<table class="table"> 
						<tr style="background-color: #03c6fc">
							<th width="25%" style="color: black  !important;">Issue Statement</th>
							<th style="color: black  !important;">Facility</th>
							<th style="color: black  !important;">Requester</th>
							<th style="color: black  !important;">Assigned Company</th>
							<th style="color: black  !important;">Assigned Dept.</th>
							<th style="color: black  !important;">Registered Date</th>
							<th style="color: black  !important;">Priority</th>
							<th style="color: black  !important;">Status</th> 
						</tr>  
						
						
						<% 
						ps_check = con.prepareStatement("select * from facility_req_tbl where enable=1 and status_id="+status +assigned_String);
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							 
								ps_check1 = con.prepareStatement("select * from facility_tbl where id="+rs_check.getInt("facility_for"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									facility = rs_check1.getString("name");
								}  
								ps_check1 = con.prepareStatement("select * from user_tbl where u_id="+rs_check.getInt("requester_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									requester = rs_check1.getString("U_Name");
								}  
								
								ps_check1 = con.prepareStatement("select * from facility_tbl_priority where id="+rs_check.getInt("priority"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									priority = rs_check1.getString("name");
								}  
								ps_check1 = con.prepareStatement("select * from user_tbl_dept where dept_id="+rs_check.getInt("assigned_dept_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									department = rs_check1.getString("Department");
								}
								ps_check1 = con.prepareStatement("select * from user_tbl_company where Company_Id="+rs_check.getInt("assigned_comp_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									company = rs_check1.getString("Company_Name");
								}
								ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id="+rs_check.getInt("status_id"));
								rs_check1 = ps_check1.executeQuery();
								while(rs_check1.next()){
									statusLog = rs_check1.getString("Status");
								}
						%>
						<tr onmouseover="ChangeColor(this, true);"
								onmouseout="ChangeColor(this, false);"
								onclick="button1('<%=rs_check.getInt("id")%>');" style="cursor: pointer;font-size: 12px;">
							<td><%=rs_check.getInt("id") %></td>
							<td><%=rs_check.getString("issue_found") %></td>
							<td><%=requester %></td>
							<td><%=company %></td>
							<td><%=department %></td>
							<td><%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td>
							<td><%=priority %></td>
							<td><%=statusLog %></td>
						</tr>
						<% 
						}
						%> 
				</table>
				</form>
			</div> 
			</section>
		</div>
	</div>
 
	<!-- project team & activity end --> </section> </section> <%
 	} catch (Exception e) {
 		e.printStackTrace();
 	}
 %> <!--main content end--> </section>
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