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
<title>Search Mastar Data</title> 
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
	margin-left: 10px;
	margin-right: 5px;
}

table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #4866AA;
	color: white;
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
function GetStorageLocation(val) {
	var fiscal_year = document.getElementById("fiscal_year").value;
	var xmlhttp,xmlhttp1;
		if (window.XMLHttpRequest) {
			// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp = new XMLHttpRequest();
			xmlhttp1 = new XMLHttpRequest();
		} else {
			// code for IE6, IE5
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
			xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP"); 
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				document.getElementById("getInput").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp1.onreadystatechange = function() {
			if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
				document.getElementById("importdata").innerHTML = xmlhttp1.responseText; 
			}
		};
		
		xmlhttp.open("POST", "GetStockTaking_input.jsp?comp=" + val + "&fiscal="+fiscal_year, true);
		xmlhttp.send();
		xmlhttp1.open("POST", "Get_StorageLocationSearch.jsp?plant=" + val + "&fiscal="+fiscal_year, true);
		xmlhttp1.send();
};
function GetStockTaking_search(val) {
	var company  = document.getElementById("company").value;  
	var fiscal_year = document.getElementById("fiscal_year").value;
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
				document.getElementById("getInput").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "GetStockTaking_search.jsp?plant=" + company + "&fiscal="+fiscal_year + "&loc="+val, true);   
		xmlhttp.send();		
};

function alreadyavailCheckMatCode(val) {
	var import_for = document.getElementById("import_for").value;   
	document.getElementById("material_desc").value="";
	var company  = document.getElementById("company").value;  
	var fiscal_year = document.getElementById("fiscal_year").value;
	var material_code = document.getElementById("material_code").value;
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
				document.getElementById("checkmat").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "Stock_TakingSearchBYcode.jsp?plant=" + company + "&fiscal="+fiscal_year + "&import_for="+import_for +"&matCode="+material_code, true);   
		xmlhttp.send();		
};



function alreadyavailCheckMatName() { 
	var import_for = document.getElementById("import_for").value;   
	document.getElementById("material_code").value="";
	var company  = document.getElementById("company").value;  
	var fiscal_year = document.getElementById("fiscal_year").value;
	var material_desc = document.getElementById("material_desc").value;
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
				document.getElementById("checkmat").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "Stock_TakingSearchBYDescr.jsp?plant=" + company + "&fiscal="+fiscal_year + "&import_for="+import_for +"&matName="+material_desc, true);   
		xmlhttp.send();		
};
</script>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
<br>
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
<%-- <!-- container section start -->
<section id="container" class="">
<!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
<%@include file="Header.jsp" %>
<!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
<%@include file="Sidebar.jsp" %>
<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->	
 --%>  	      
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
			<%
            int year = Calendar.getInstance().get(Calendar.YEAR);
			year--;
            %>
            <table class="gridtable" width="99%">
					<tr style="color: black;">
						<th style="background-color: #004364;color: white;font-size: 12px;text-align: center;">
						Mutha Group Inventory Search Facility
						</th>
						<td style="text-align: center;"><a href="Stock_TakingSearch.jsp"><b style="font-size: 15px;color: blue;">Refresh Page</b></a></td>
					</tr>
			</table>			
			<input type="hidden" id="fiscal_year" name="fiscal_year" value="<%=year%>">
			<table class="gridtable">
					<tr style="color: black;">
						<th style="background-color: #4866AA;color: white;">&nbsp;Search By Plant &nbsp;&nbsp;</th>
						<td>&nbsp;
				<select name="company" id="company"  onchange="GetStorageLocation(this.value)" style="font-weight: bold;color: black;width: 200px;height: 30px;font-size: 15px;">
                      <option value=""> - - - - Select Plant - - - -  </option>
                      <%
                      ps_check = con.prepareStatement("SELECT * FROM stocktaking_company where enable=1");
                      rs_check = ps_check.executeQuery();
                      while(rs_check.next()){
                      %>
                      <option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("plant") %> - <%=rs_check.getString("shortname") %></option>
                      <%
                      }
                      %>
                 </select>&nbsp;
						</td>
					</tr>
			</table>						
      
         <span id="importdata"></span>      
           
         <span id="getInput"></span>
    <%
	}catch(Exception e){
		e.printStackTrace();
	}
    %>
    
      
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