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
<title>Update Location</title> 
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
</head>
<script type="text/javascript">
function getStorageLocation(val) { 
	
	var fiscal_year = document.getElementById("fiscal").value;
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
				document.getElementById("getLoc").innerHTML = xmlhttp.responseText;
			}
		};
		xmlhttp.open("POST", "Stock_Taking_StorageAJAX.jsp?plant=" + val + "&fiscal="+fiscal_year, true);
		xmlhttp.send();
};
function checkQuote() {
	if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
		event.keyCode = 0;
		return false;
	}
}
</script>
<style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif; 
	color: black;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 12px;
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: #666666; 
	color: black;
	background-color: #9ECEE0;
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
<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getConnectionMaster();
Connection con_local = Connection_Util.getLocalUserConnection();

String plant_code = session.getAttribute("plant").toString();
String username = session.getAttribute("username").toString();		
int dept_idlog = Integer.valueOf(session.getAttribute("dept_id").toString());
int year = Calendar.getInstance().get(Calendar.YEAR);
year--;
int uid = Integer.valueOf(session.getAttribute("uid").toString());
PreparedStatement ps_check=null,ps_check1=null;
ResultSet rs_check=null,rs_check1=null;
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
              <li><b><i class="icon_check"></i>Add Physical Location and owner</b> 
              	<%
					if (request.getParameter("error") != null) {
				%> <strong style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;<%=request.getParameter("error")%></strong> 
				<%
 				} 
 				%> 
              </li>
            </ol>
          </div>
        </div> 
				      
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
	<div class="row">
          <div class="col-lg-12">
            <section class="panel">
               <div class="panel-body">
                <div class="form"> 
<div style="float: left;width: 50%">
<form action="SixSigma_PhysicalLocation" method="post" name="formLoc" id="formLoc" onsubmit="submit.disabled = true; return true;">    
<table  class="gridtable" width="100%">  
<tr>
 <th style="font-weight: bold;color: black;background-color: #C7C7C7;">Data Entry Plant</th>  
 </tr>
<tr style="height: 30px;">
 	<td>
 	<input type="hidden" name="fiscal" id="fiscal" value="<%=year%>">
 	<select name="plant" id="plant" class="form-control" onchange="getStorageLocation(this.value)" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - - Select - - - </option>
	 	<%
	 	String selectPlant = ""; 
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_company where enable=1");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){ 
        %>
        <option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("plant") %> - <%=rs_check.getString("shortname") %></option>
        <%
        } 
        %>
	</select> 
 	</td> 
</tr> 
<tr>
 <th style="font-weight: bold;color: black;background-color: #C7C7C7;">Storage Location</th>  
 </tr>
 <tr style="height: 30px;">
 <td>
 	<span id="getLoc">
 	<select name="store_loc" id="store_loc" onchange="getphysical_Location(this.value)" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<%
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_storageLocation where enable=1 and plant='"+selectPlant+"'");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("id") %>"><%=rs_check.getString("storage_location") %> - <%=rs_check.getString("storage_locationDesc") %></option>
        <%
        }
        %>
	</select>
	</span>
 	</td> 
 </tr>
 
 <tr>
 <th style="font-weight: bold;color: black;background-color: #C7C7C7;">Location Owner</th>  
 </tr>
 <tr style="height: 30px;">
 <td>
  <select name="loc_owner" id="loc_owner" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - - Select - - - </option>
	 	<%
        ps_check = con_local.prepareStatement("SELECT u_id,u_name,company_name,sap_id,department FROM user_tbl inner join user_tbl_company on user_tbl.Company_Id = user_tbl_company.company_id "+
        		" inner join user_tbl_dept on user_tbl_dept.dept_id= user_tbl.Dept_Id where user_tbl.enable_id=1 order by user_tbl_company.company_id");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("u_id") %>"><%=rs_check.getString("u_name") %> - <%=rs_check.getString("company_name") %> - <%=rs_check.getString("department") %></option>
        <%
        }
        %>
	</select>
 </td>
 </tr>
 
 <tr>
 <th style="font-weight: bold;color: black;background-color: #C7C7C7;">Sub Location Name</th>  
 </tr>
 <tr style="height: 30px;">
 <td>
 <input class="form-control" style="font-weight: bold;color: black;font-size: 14px;" id="phy_location" name="phy_location" 
 	maxlength="40" onkeypress="return checkQuote();" type="text" required />
 </td>
 </tr>
 
 
  <tr>
 <th style="font-weight: bold;color: black;background-color: #C7C7C7;">Sub Location Owner Name</th>  
 </tr>
 <tr style="height: 30px;">
 <td>
  <select name="sub_loc_owner" id="sub_loc_owner" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - - Select - - - </option>
	 	<%
        ps_check = con_local.prepareStatement("SELECT u_id,u_name,company_name,sap_id,department FROM user_tbl inner join user_tbl_company on user_tbl.Company_Id = user_tbl_company.company_id "+
        		" inner join user_tbl_dept on user_tbl_dept.dept_id= user_tbl.Dept_Id where user_tbl.enable_id=1 order by user_tbl_company.company_id");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("u_id") %>"><%=rs_check.getString("u_name") %> - <%=rs_check.getString("company_name") %> - <%=rs_check.getString("department") %></option>
        <%
        }
        %>
	</select>
 </td>
 </tr>
 
  <tr>
 <th style="font-weight: bold;color: black;background-color: #C7C7C7;">Sub Location Auditor Name</th>  
 </tr>
 <tr style="height: 30px;">
 <td>
  <select name="sub_loc_auditor" id="sub_loc_auditor" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - - Select - - - </option>
	 	<%
        ps_check = con_local.prepareStatement("SELECT u_id,u_name,company_name,sap_id,department FROM user_tbl inner join user_tbl_company on user_tbl.Company_Id = user_tbl_company.company_id "+
        		" inner join user_tbl_dept on user_tbl_dept.dept_id= user_tbl.Dept_Id where user_tbl.enable_id=1 order by user_tbl_company.company_id");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("u_id") %>"><%=rs_check.getString("u_name") %> - <%=rs_check.getString("company_name") %> - <%=rs_check.getString("department") %></option>
        <%
        }
        %>
	</select>
 </td>
 </tr>
 
 <tr>
 <td>
 <input type="submit" name="submit" id="submit" value="SAVE" class="btn-primary" style="height: 30px;font-weight: bold;">
 
 </td>
 </tr>
 </table>    
</form>
</div>


<div style="float: right;width: 49.5%;overflow: scroll;height: 500px;">
<table  class="gridtable" width="100%"> 
 <tr>
 <th>ID</th>
 <th>Plant</th>
 <th>Storage Location</th>
 <th>Location Owner</th>
 <th>Sub Location Name</th> 
 <th>Sub Location Owner Name</th>
 <th>Sub Location Auditor Name</th>
</tr>
<%
String strLoc="",locOwner="";
ps_check = con.prepareStatement("select * from stocktaking_loc_auditors_sub where enable=1 and fiscal_year="+year + " order by plant");
rs_check = ps_check.executeQuery();
while(rs_check.next()){
	ps_check1 = con.prepareStatement("select storage_location from stocktaking_storageLocation where id="+rs_check.getInt("stock_loc_id"));
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
		strLoc = rs_check1.getString("storage_location");
	}
	ps_check1 = con.prepareStatement("select distinct(loc_owner_name) as loc_owner_name from stocktaking_loc_owner where stock_loc_id="+rs_check.getInt("stock_loc_id") + " and enable=1 and fiscal_year="+year);
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
		locOwner = rs_check1.getString("loc_owner_name") + ","+ locOwner;
	}
%>
<tr>
<td align="right" style="font-size: 10px;"><%=rs_check.getInt("id") %></td>
<td style="font-size: 10px;"><%=rs_check.getString("plant") %></td>
<td style="font-size: 10px;"><%=strLoc %></td>
<td style="font-size: 10px;"><%=locOwner %></td>
<td style="font-size: 10px;"><%=rs_check.getString("sub_locationName") %></td>
<td style="font-size: 10px;"><%=rs_check.getString("loc_owner_name") %></td>
<td style="font-size: 10px;"><%=rs_check.getString("loc_auditor_name") %></td>
<%
strLoc="";locOwner="";
}
%>
</tr>
</table>
</div>        
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
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