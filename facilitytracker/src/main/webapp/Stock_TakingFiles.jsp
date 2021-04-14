<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
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
<title>Uploaded Data</title> 
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.min.css" rel="stylesheet" />
  <!-- full calendar css-->
  <link href="assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css" rel="stylesheet" />
  <link href="assets/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" />
  <!-- easy pie chart-->
  <link href="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen" />
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
  <style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif;
	font-size: 11px;
	color: #333333;
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
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
</style>
</head>
<script type="text/javascript">
function Getattachments(val) {   
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
				document.getElementById("plant_data").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "Get_Stock_Taking_Attach.jsp?plant=" + val, true);
		xmlhttp.send();
};
 
</script>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getConnectionMaster();
Connection conLocal = Connection_Util.getLocalUserConnection();
PreparedStatement ps_check=null;
ResultSet rs_check=null;
SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
/*-------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/
%>
<!-- container section start -->
<section id="container" class="">
<!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
<%@include file="Header.jsp" %>
<!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
<%@include file="Sidebar.jsp" %>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->	
<!--main content start-->
    <section id="main-content">
      <section class="wrapper">
        <!--overview start-->
        <div class="row">
          <div class="col-lg-12">
            <!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
            <ol class="breadcrumb">
              <li><i class="fa fa-home"></i><a href="Home.jsp">Home</a></li>  
              <li><b><i class="icon_tags_alt"></i>Check Uploaded Files</b> 
              </li>
            </ol>
          </div>
        </div> 
				      
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
	<div class="row">
          <div class="col-lg-12">
            <section class="panel">
              <header class="panel-heading">
 <span  style="color: black;font-weight: bold;">
 Select Plant : <select id="company" onchange="Getattachments(this.value)" name="company" style="background-color: #adcdff;font-weight: bold;">
 <option value="">- - - - - Select Plant - - - - -</option>
 <%
                      ps_check = con.prepareStatement("SELECT * FROM stocktaking_company where enable=1");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("plant") %> - <%=rs_check.getString("shortname") %></option>
                      <%
                      }
                      %>
 <%
 
 %>
 </select>
</span>
</header>
              <div class="panel-body">
                <div class="form"> 
                <span id="plant_data">
             		<table style="width: 100%;" class="gridtable">
					<tr>
						<th style="color: black;">S.No</th>
						<th style="color: black;">Plant</th> 
						<th style="color: black;">Storage Location</th>
						<th style="color: black;">Stock Type</th>
						<th style="color: black;">Fiscal Year</th>
						<th style="color: black;">Active Status</th>
						<th style="color: black;">Uploaded by</th>
						<th style="color: black;">Upload Date</th>
						<th style="color: black;">Changed By</th>
						<th style="color: black;">Changed Date</th> 
						<th style="color: black;">Attachments</th>
					</tr>
					<%
					int s_no=0;
					PreparedStatement ps_up=null;
					ResultSet rs_up=null;
					PreparedStatement ps_file = con.prepareStatement("SELECT  * FROM  stocktaking_attachments order by plant");
					ResultSet rs_files = ps_file.executeQuery();
					while(rs_files.next()){
						s_no++;
					%>
					<tr>
						<td align="right"><%=s_no %></td>
						<td align="right"><%=rs_files.getString("plant") %></td>
						<td align="left"><%=rs_files.getString("storage_loc") %></td>
						<td align="left"><%=rs_files.getString("stocktype_desc") %></td>
						<td align="right"><%=rs_files.getString("fiscal_year") %></td>
						
						<%
						if(rs_files.getInt("enable")==0){
						%>
						<td align="left" style="background-color: red;color: white;"><b>Deleted</b></td> 
						<%
						}else{
						%>
						<td align="left" style="background-color: green; color: white;"><b>Active</b></td> 
						<%
						}
						ps_up = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id=" +rs_files.getInt("created_by"));
						rs_up = ps_up.executeQuery();
						while(rs_up.next()){
						%>						
						<td align="left"><%=rs_up.getString("u_name") %></td>
						<%
						}
						%>
						<td align="left"><%=format.format(rs_files.getTimestamp("sys_date")) %></td>
						<%
						ps_up = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id=" +rs_files.getInt("updated_by"));
						rs_up = ps_up.executeQuery();
						while(rs_up.next()){
						%>						
						<td align="left"><%=rs_up.getString("u_name") %></td>
						<%
						}
						%>  
						<td align="left"><%=format.format(rs_files.getTimestamp("update_date")) %></td>
						<td align="left"><a href="StockTakingDocs_View.jsp?field=<%=rs_files.getInt("id")%>"><strong><%=rs_files.getString("filename") %></strong></a></td>
					</tr>
					<%
					}
					%>
             		</table>
             </span>
                </div>

              </div>
            </section>
          </div>
        </div>
        
        
        
        <!-- project team & activity end -->

      </section> 
    </section>
    
    <%
	}catch(Exception e){
		e.printStackTrace();
	}
    %>
    
     
    <!--main content end-->
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
  <<script src="js/fullcalendar.min.js"></script>
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
          'draw': function() {
            $(this.i).val(this.cv + '%')
          }
        })
      });

      //carousel
      $(document).ready(function() {
        $("#owl-slider").owlCarousel({
          navigation: true,
          slideSpeed: 300,
          paginationSpeed: 400,
          singleItem: true

        });
      });

      //custom select box

      $(function() {
        $('select.styled').customSelect();
      });

      /* ---------- Map ---------- */
      $(function() {
        $('#map').vectorMap({
          map: 'world_mill_en',
          series: {
            regions: [{
              values: gdpData,
              scale: ['#000', '#000'],
              normalizeFunction: 'polynomial'
            }]
          },
          backgroundColor: '#eef3f7',
          onLabelShow: function(e, el, code) {
            el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
          }
        });
      });
    </script>

</body>
</html>