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
<title>Stock Taking Sheet</title>
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
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 10px;
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
function GetStorageLocation() {  		
	
	 if (confirm("Are you sure to delete below data...!")) {
		    alert("Data delete selected....");  
	
	var comp = document.getElementById("comp").value;
	var location = document.getElementById("location").value;
	var ct = document.getElementById("ct").value;  
	var fiscal = document.getElementById("fiscal").value;   
	var stockType = document.getElementById("stockType").value; 
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
				document.getElementById("deleteData").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "DeleteStockSheet_Ajax.jsp?comp=" + comp + "&location="+location+ "&ct="+ct+ "&fiscal="+fiscal + "&stockType="+stockType , true);
		xmlhttp.send();
	}else {
	 alert("canceled");
	}
};
</script>
</head>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
	<%
		try {
			Connection con = Connection_Util.getConnectionMaster();
			Connection connection = Connection_Util.getLocalUserConnection();
			String comp = request.getParameter("comp"), location = request.getParameter("str"), 	ct = request.getParameter("ct"),
					path = "C:/reportxls/"+request.getParameter("path"),
					pathMain_A4 = "C:/reportxls/"+request.getParameter("a4"),
					pathA3 ="C:/reportxls/"+ request.getParameter("p3"),
					pathA4 ="C:/reportxls/"+ request.getParameter("p4"),
					stocktype = request.getParameter("st"),
					fiscal = request.getParameter("fiscal");
			boolean flagCheck=false;
			int dept_idCheck = Integer.valueOf(session.getAttribute("dept_id").toString());
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			SimpleDateFormat mailDateFormat2 = new SimpleDateFormat(	"dd/MM/yyyy");
			PreparedStatement ps_check = null, ps_check1 = null, ps_check2 = null,ps_user=null;
			ResultSet rs_check = null, rs_check1 = null, rs_check2 = null,rs_user=null;
			String company = "", relation = "";
			/*-------------------------------------------------------------------------------------------------------------------*/
			   ps_user = connection.prepareStatement("SELECT * FROM user_tbl where dept_id in(18,31) and enable_id=1");
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
					if(rs_user.getInt("dept_id")==dept_idCheck){
						flagCheck=true;
					}
				}  
	%>
	<!-- ********************************************************************************************************************* -->
	<div class="panel panel-primary">
				<table style="width: 50%;">
					<tr>
					<%
					if(flagCheck==true){
					%>
						<th><a href="Stock_Taking.jsp"><b style="font-size: 15px;color: blue;">Go back to File Upload</b></a></th>
					<%
					}
					%>	
						<th><a href="Stock_TakingCheck.jsp"><b style="font-size: 15px;color: green;">Go back to Check File Upload Data</b></a></th>
					</tr>
			</table>
<%
int totcnt=0;
ps_check = con.prepareStatement("SELECT  count(id) as totcnt FROM stocktaking_summary where enable=1 and Plant='"
			+ comp + "' and storage_loc='" + location + "' and fiscal_year='" +fiscal +"' and stocktype_desc='" +stocktype+"'");
rs_check = ps_check.executeQuery();
while (rs_check.next()) {
	totcnt = rs_check.getInt("totcnt");
}
/* System.out.println(totcnt+"year fiscal = " + fiscal + " = " + stocktype); */
%>
		

		<div class="panel panel-success"> 
			<input type="hidden" id="comp" value="<%=comp%>">
			<input type="hidden" id="location" value="<%=location%>">
			<input type="hidden" id="ct" value="<%=ct%>">
			<input type="hidden" id="fiscal" value="<%=fiscal%>">
			<input type="hidden" id="stockType" value="<%=stocktype%>">
			
			<table style="width: 100%;color: white;" class="gridtable">
					<tr style="background-color: #dedede;color:"> 
						<th align="center" style="color: black;"><b> Plant : <%=comp%> </b></th>
						<th align="center"  style="color: black;"><b>Location : <%=location%> </b></th>
						<th align="center"  style="color: black;"><b><%=stocktype%> Stock</b></th>
						<th align="center"  style="color: black;"><b> Fiscal Year : <%=fiscal%> </b></th>
						<th align="center"  style="color: black;"><b> Total Rows :<span style="background-color: yellow;">&nbsp;<%=totcnt%>&nbsp; </span> </b></th>
						<th  align="right"><b style="color: black;">Stock Sheet (Use A3 or A4) <br> </b>
						<a href="DownloadFile.jsp?filepath=<%=path %>" style="margin-left: 7px;color: blue;"><b><i class="icon_download" title="Download Report"></i> A3 pdf</b></a>  <b style="color: black;"> or</b>
						<a href="DownloadFile.jsp?filepath=<%=pathMain_A4 %>" style="margin-left: 7px;color: blue;"><b><i class="icon_download" title="Download Report"></i> A4 pdf</b></a>
						</th>
						<%
						if(flagCheck==true){
						%>
						<th align="center"  style="color: black;">Found Issues : <button style="background-color: red;font-family: Arial, Helvetica, sans-serif; color: white;" onclick="GetStorageLocation()">Delete below Data</button></th>
						<%
						}
						%>
						<th align="center"  style="color: black;">Extra Sheets :<br>
						<a href="DownloadFile.jsp?filepath=<%=pathA3 %>" style="margin-left: 7px;color: blue;"><b><i class="icon_download" title="Download Report"></i> A3 Pdf </b></a> <b style="color: black;"> or</b>
						<a href="DownloadFile.jsp?filepath=<%=pathA4 %>" style="margin-left: 7px;color: blue;"><b><i class="icon_download" title="Download Report"></i> A4 Pdf </b></a>
						</th>
					</tr>
			</table>
			  
			<div class="panel-content">
			<span id="deleteData">
				<table style="width: 100%;" class="gridtable">
					<tr style="background-color: #dedede;color: black;">
						<th style="color: black;">SNO</th>
						<th style="color: black;">Plant</th> 
						<th style="color: black;">Loc</th> 
						<th style="color: black;">Inv Doc</th>
						<th style="color: black;">FSYr</th>
						<th style="color: black;">CountDate</th>
						<th style="color: black;">ItemNo</th>
						<th style="color: black;">Mat Code</th>
						<th style="color: black;">Mat Descr</th>
						<th style="color: black;">UOM</th>
						<th style="color: black;">Mat Type</th>
						<th style="color: black;">Entry Qty</th>
						<th style="color: black;">Zero cnt</th>
						<th style="color: black;">Serial no</th>
						<th style="color: black;">Reason</th>
						<th style="color: black;">Batch</th>
						<th style="color: black;">Tag No</th>
					</tr>
					<%
						ps_check = con.prepareStatement("SELECT  * FROM stocktaking_summary where enable=1 and Plant='"
											+ comp + "' and storage_loc='" + location + "' and fiscal_year='" +fiscal +"' and stocktype_desc='" +stocktype+"'");
							rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
					%>
					<tr>
						<td align="right"><%=rs_check.getString("sno")%></td>
						<td align="right"><%=rs_check.getString("Plant")%></td> 
						<td align="left"><%=rs_check.getString("storage_loc")%></td> 
						<td><%=rs_check.getString("physical_inv_doc")%></td>
						<td align="right"><%=rs_check.getString("fiscal_year")%></td>
						<td><%=rs_check.getString("countdate")%></td>
						<td align="right"><%=rs_check.getString("item_no")%></td>
						<td><%=rs_check.getString("material_no")%></td>
						<td><%=rs_check.getString("material_desc")%></td>
						<td><%=rs_check.getString("uom")%></td>
						<td><%=rs_check.getString("mat_type")%></td>
						<td align="right"><%=rs_check.getString("entry_qty")%></td>
						<td><%=rs_check.getString("zero_cnt")%></td>
						<td><%=rs_check.getString("serial_no")%></td>
						<td align="right"><%=rs_check.getString("Reason")%></td>
						<td><%=rs_check.getString("batch_no")%></td> 
						<td><%=rs_check.getString("tag_no")%></td> 
					</tr>
					<%
						}
					%>
				</table>
				</span>
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