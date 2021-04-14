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
<script type="text/javascript">
	function getUserRecords() {  
	var monthSelected = document.getElementById("monthSelected").value;
	var yearsSelected = document.getElementById("yesrSelected").value; 
	var dept_name = document.getElementById("dept_name").value; 
	
	if(monthSelected!=""){
		document.getElementById("loaderId").style.visibility = "visible"; 
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
				document.getElementById("getDetails").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_ReportAjax.jsp?monthSelected=" + monthSelected + "&yearsSelected="+yearsSelected + "&dept_name="+dept_name, true);
		xmlhttp.send();
	}else{
		alert("Select month");
	} 
}
	function generateExcel(val1,val2,val3) {  
		document.getElementById("loaderExcelId").style.visibility = "visible"; 
		var monthSelected = val1;
		var yearsSelected = val2;    
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
					document.getElementById("excel_data").innerHTML = xmlhttp.responseText; 
				}
			};
			xmlhttp.open("POST", "WFH_ExcelReportAjax.jsp?monthSelected=" + monthSelected + "&yearsSelected="+yearsSelected +"&dept_name="+val3, true);
			xmlhttp.send();
	}
</script>
</head>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: white;">
	<%
		try { 
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			PreparedStatement ps_check=null;
			ResultSet rs_check=null;
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String layoutType="";
			Calendar todayCal= Calendar.getInstance();
			Calendar cal = Calendar.getInstance();
			Double confDay=0.0,confhalfDay=0.0;
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
			ps_check = con_master.prepareStatement("select * from tran_wfh_config where enable_id=1");
			rs_check = ps_check.executeQuery();
			while(rs_check.next()){
				layoutType=	rs_check.getString("specification3");
				if(rs_check.getString("parameter").equalsIgnoreCase("Day")){
					// System.out.println("day = " + rs_check.getString("parameter"));
					confDay = Double.valueOf(rs_check.getString("specification1"));
				}
				if(rs_check.getString("parameter").equalsIgnoreCase("Half Day")){
					// System.out.println("day = " + rs_check.getString("parameter"));
					confhalfDay = Double.valueOf(rs_check.getString("specification1"));
				}
			}
	%>
	<!-- ********************************************************************************************************************* -->
	  		<table style="width: 50%;">
					<tr>
						<th><a href="Home.jsp"><b style="font-size: 15px;color: blue;">Go back to Dashboard</b></a></th>
					</tr>
			</table>		  
                <ul class="nav nav-tabs" style="font-size: 12px;font-weight: bold;">
                  <li class="active">
                    <a data-toggle="tab" href="#home"><%=layoutType %> : <b style="background-color: yellow;">(1 Day : <%=confDay/60 %>) (Half Day : <%=confhalfDay/60 %>)</b> (Week off Hours Considered)</a>
                  </li>
                </ul> 
            <div style="width: 100%;margin-top: 10px;margin-left: 10px;"> 
                    <%
                    List<String> monthsList = new ArrayList<String>();
                    String[] months = new DateFormatSymbols().getMonths(); 
                    Calendar now = Calendar.getInstance();
                    %>
                   <b style="font-weight: bold;color: black;margin-left: 10px;">  Month : </b>
                   <select name="monthSelected" id="monthSelected" onchange="getUserRecords()" style="font-weight: bold;color: black;width: 190px;height: 30px;">
                  <option value=""> - - - - Select - - - - </option>
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
                <b style="font-weight: bold;color: black;margin-left: 10px;"> Year : </b>
                <select name="yesrSelected" id="yesrSelected" onchange="getUserRecords()" style="font-weight: bold;color: black;width: 190px;height: 30px;">
                   <%
                      int year = Calendar.getInstance().get(Calendar.YEAR);                     
                      for(int i=year;i>=year-2;i--){
                          %>
                          <option value="<%=i%>"><%=i%></option> 
                          <%  
                          }
                      %>
                   </select>
                <b style="font-weight: bold;color: black;margin-left: 10px;"> Dept : </b>
                <select name="dept_name" id="dept_name" onchange="getUserRecords()" style="font-weight: bold;color: black;width: 190px;height: 30px;">
				<%
				if(dept_id==18 || dept_id==26 || comp_id==6){
				%>
				<option value="All">- - - All- - -</option>
					<%
					ps_check = con.prepareStatement("SELECT distinct(orgunit_text) as dept_name FROM sap_users where Emp_Code in (SELECT sap_id FROM user_tbl where sap_id !='null' and company_id!=6 and Enable_id=1)");
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
					%>
					<option value="<%=rs_check.getString("dept_name")%>"><%=rs_check.getString("dept_name")%></option>
					<%
					}
				}else{
					ps_check = con.prepareStatement("SELECT distinct(orgunit_text) as dept_name FROM sap_users where emp_code in (SELECT sap_id FROM user_tbl where u_id="+uid+")");
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
				%>
				<option value="<%=rs_check.getString("dept_name")%>"><%=rs_check.getString("dept_name")%></option>
				<%
				}
				}
				%>	
				</select>
           		<a href="WFH_Reports.jsp" style="color: black;font-weight: bold;margin-left: 50px;margin-right: 20px;" class="btn btn-primary btn-sm">Reset</a>
               </div> 
   			<div style="width: 100%;">
   			<span id="getDetails">
               <img alt="#" src="img/load.gif" style="visibility: hidden;height: 50px;margin-left: 50px;" id="loaderId">
            </span>
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