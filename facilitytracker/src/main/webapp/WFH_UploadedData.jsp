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
<title>WFH Reports</title>
<style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif;
	
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 12px;
	border-width: 1px;
	padding: 3px;
	border-style: solid;
	border-color: #666666;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 12px;
	border-width: 1px;
	padding: 2px;
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

<body style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: white;">
	<%
		try { 
			Connection con = Connection_Util.getLocalUserConnection(); 
			Connection con_master = Connection_Util.getConnectionMaster();
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString()); 
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			SimpleDateFormat tranFormat = new SimpleDateFormat("dd/MM/yyyy");
		//	System.out.println("Dept = " + dept_idCheck + " = " + uid);
			
			PreparedStatement ps_user=null,ps_check=null,ps_check1=null,ps_check2=null;
			ResultSet rs_user=null,rs_check=null,rs_check1=null,rs_check2=null;
			
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
	
				<table style="width: 50%;">
					<tr>
						<th><a href="Home.jsp"><b style="font-size: 15px;color: blue;">Go back to Dashboard</b></a></th>
					</tr>
			</table>
			<div style="background-color: white;overflow: scroll;height: 600px;">					
		 <table class="gridtable" cellspacing="0" id="gvMain" style="width: 100%;">
             	<tr style="background-color: #DACB74;"> 
             		<th align="center"  style="color: black;">T No</th>  
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;">DWM Task Description</th>  
					<th align="center"  style="color: black;">Time Required 
					<th align="center"  style="color: black;">Task Assigned By</th>
					<th align="center"  style="color: black;">Date</th>					
					<th align="center"  style="color: black;">Documents</th>
					<th align="center"  style="color: black;">Status</th> 
					<th align="center"  style="color: black;">Approval by</th>
					<th align="center"  style="color: black;">Approval Date</th>
					<th align="center"  style="color: black;">Approval Remark</th> 			
				</tr>
				<% 
				String dwmAprBy="", dwmaprDate="",dwmApRemark="";
				ps_user = con_master.prepareStatement("SELECT * from tran_dwm_tasks where u_id="+uid+" and enable_id=1 order by tran_date desc");
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
				%>
				<tr style="color: black;">
					<td align="center"><%=rs_user.getInt("id")%></td>
					<td style="width: 15%"><%=rs_user.getString("task_title") %></td>
					<td style="width: 30%">
					<textarea disabled="disabled" style="width: 100%;background-color: white;color: black;"><%=rs_user.getString("task_description") %></textarea>
					</td>
					<td><%=rs_user.getString("time_elapsed") %>Min</td>
					<td>
					<%
					ps_check = con_master.prepareStatement("select u_id from rel_dwm_approvers where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" +rs_check.getInt("u_id"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<%=rs_check1.getString("U_Name") %>,
					<%		
						}
					}
					%>	
					</td>
					<td><%= tranFormat.format(rs_user.getTimestamp("tran_date")) %></td>
					<td style="width: 10%">
					<%
					ps_check = con_master.prepareStatement("select id,file_name from rel_dwm_tasks_Attach where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){ 
					%>
					<a href="WFH_DWMDocs_Display.jsp?field=<%=rs_check.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check.getString("file_name") %></strong></a> &nbsp; ,
				 	<%	 
					}
					%>
					</td>
					<td>
					<%
					if(rs_user.getInt("approved_by")>0){
					
						ps_check = con_master.prepareStatement("select approval_Type from approval_type where id=" +rs_user.getInt("approval_id"));
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
					%>
					<b style="color: black;"><%=rs_check.getString("approval_Type") %></b>
					<%		
						} 
						 ps_check = con.prepareStatement("SELECT U_Name FROM user_tbl where U_Id="+rs_user.getInt("approved_by"));
			             rs_check = ps_check.executeQuery();
			             while(rs_check.next()){
			                 dwmAprBy=rs_check.getString("U_Name");
			             }
			             dwmaprDate = mailDateFormat.format(rs_user.getTimestamp("approved_date"));
			             dwmApRemark = rs_user.getString("approval_remark");
					}else{ 
					%>
					<b style="color: black;background-color: yellow;">Pending</b>
					<%	
					}
					%>
					</td>
					<td align="center"  style="color: black;"><%=dwmAprBy %></td>
					<td align="center"  style="color: black;"><%=dwmaprDate %></td>
					<td align="center"  style="color: black;"><%=dwmApRemark %></td> 
				</tr>
				<% 
				dwmAprBy=""; dwmaprDate="";dwmApRemark=""; 
				}
				%>
				</table>  

	


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