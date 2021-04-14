<%@page import="java.util.Calendar"%>
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
<title>Review and Action planning</title>
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
  <script type="text/javascript">
  function decision_call(val) {
	  var retVal = confirm("Are you sure to delete...?"); 
      if( retVal == true ) {
      alert("You Pressed OK!");
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
					document.getElementById("delete_record"+val).innerHTML = xmlhttp.responseText; 
				}
			};  
			xmlhttp.open("POST", "Master_DeleteReq.jsp?id=" + val, true);  
			xmlhttp.send();    
	      } else {
	    	  alert("You Pressed Cancel!");
	    	  return false;
	      }
	};
	
	function sendMessage(code,val) {
		 var msg = document.getElementById('msg'+val); 
		 var sendMsg = document.getElementById('sendMsg'+val);  
		  
		 if(sendMsg.value!="" && code==1){
		 sendMsg.readOnly = true;
		 msg.style.display = "none"; 
		 
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
					document.getElementById("sendMsgBack"+val).innerHTML = xmlhttp.responseText; 
				}
			};
		 	xmlhttp.open("POST", "Master_MSGSend.jsp?id=" + val + "&sendMsg=" + sendMsg.value + "&select=" + code, true);  
			xmlhttp.send(); 
		}else{
			alert("No message Found!, Error Occurred...!!!!");
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
	font-size: 10px;
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: #666666; 
	color: black;
	background-color: #dedede;
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
</head>

<body style="color: black;">
<%
try{
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0;
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	boolean availFlag=false ;
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	PreparedStatement ps_check = null, ps_check1=null,ps_local=null;
	ResultSet rs_check = null,rs_check1=null,rs_local=null; 
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date date2cmp;
	Calendar calobj = Calendar.getInstance();
	String todays_date = format2.format(calobj.getTime());
	date2cmp = format2.parse(todays_date);
	/* date1cmp = sdf2.parse(october_date);
	diff = Math.abs(date2cmp.getTime() - date1cmp.getTime()) / (1000 * 60 * 60 * 24); */
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
        <%
        String actPlan_data="actPlan_data";
        %>
        <jsp:include page="SixSigma_Header.jsp" > 
  		<jsp:param name="define" value="<%=actPlan_data %>" />
		</jsp:include>
        
        <%
  		if(request.getParameter("success")!=null){
		%> 
         <strong class="alert alert-success fade in"><%=request.getParameter("success") %> </strong> 
        <%
		}if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"><%=request.getParameter("statusNop") %> </strong> 
	        <%
			}
		%>
              
        </div> 
<!-- ********************************************************************************************************************* -->
<div  style="height:900px;"> 

<table class="gridtable" width="100%"> 
  <tr>
  	<td align="center" style="background-color: #e2ef77;width: 80px;"><input type="submit" class="btn-primary" name="submit" id="submit" value=" SAVE  " style="font-weight: bold;height: 20px !important;"></td>
    <td align="center" style="font-size: 12px;font-weight: bold;background-color: #a59eff">Review and Action planning Phase</td>
    <td align="center" style="background-color: #18124d;color: white;font-weight: bold;width: 100px;">Plant</td> 
    <td align="center" style="background-color: red;font-weight: bold;color: white;width: 130px;">LOW IMPACT</td>
  </tr>
  </table>
 <table class="gridtable" width="100%"> 
  <tr>
    <th>Problem ID</th>
    <td>&nbsp;</td>
    <th>Problem Title</th>
    <td colspan="5">&nbsp;</td> 
  </tr>
  <tr>
    <th>Product Code</th>
    <td>&nbsp;</td>
    <th>Product Description</th>
    <td colspan="5">&nbsp;</td> 
  </tr>
  <tr>
    <th>Project Type</th>
    <td>&nbsp;</td> 
    <th>Department</th>
    <td>&nbsp;</td> 
    <th>Problem Registered By</th>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <th>Baseline in PPM</th>
    <td>&nbsp;</td>
    <th>Target</th>
    <td>&nbsp;</td>
    <th>Project Score</th>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <th>Baseline</th>
    <td>&nbsp;</td>
    <th>Target</th>
    <td>&nbsp;</td>
    <th>Project Rating</th>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <th>Classification of Project</th>
    <td>&nbsp;</td>
    <th>Impact    on Internal Customer</th>
    <td>&nbsp;</td>
    <th>Impact on External Customer</th>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <th>Data Oriented Analysis</th>
    <td>&nbsp;</td>
    <th>Cross functional rating</th>
    <td>&nbsp;</td>
    <th>Expected    Savings in Rupees Lakhs</th>
    <td colspan="3">&nbsp;</td>
  </tr> 
</table>
 

  

<div style="width: 55%;overflow: scroll;float: left;">
<table class="gridtable" width="100%"> 
  <tr align="center"> 
    <td colspan="7" style="font-size: 12px;font-weight: bold;background-color: #a59eff">Project Timeline</td>
  </tr>
  <tr align="center">
    <td style="background-color: #e2ef77">
    <input type="submit" class="btn-primary" name="submit" id="submit" value=" SAVE  " style="font-weight: bold;height: 20px !important;">
    </td>
    <td colspan="2" align="center" style="background-color: #093256;color:white;font-size:12px;font-weight: bold;">Score</td>
    <td colspan="2" align="center" style="background-color: #093256;color:white;font-size:12px;font-weight: bold;">Plan</td>
    <td colspan="2" align="center" style="background-color: #093256;color:white;font-size:12px;font-weight: bold;">Actual</td>
  </tr>
  <tr>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Phase</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Plan</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Actual</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Start date</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">End date</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Start date</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">End date</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Define</td>
    <td align="right">5</td>
    <td align="right" style="background-color: #e8e8e8;color: black;font-weight: bold;font-size: 12px;">5</td>
    <td align="right" style="background-color: #e8e8e8;color: black;">25.11.2020</td>
    <td align="right" style="background-color: #e8e8e8;color: black;">25.11.2020</td>
    <td align="right" style="background-color: #e8e8e8;color: black;">25.11.2020</td>
    <td align="right" style="background-color: #e8e8e8;color: black;">25.11.2020</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Measure</td>
    <td align="right">15</td>
    <td align="right"><input type="text" maxlength="3" minlength="1" class="form-control" style="height: 23px !important;width: 60px;color: black;"></td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Analyze</td>
    <td align="right">25</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Improve</td>
    <td align="right">45</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Control</td>
    <td align="right">10</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Total</td>
    <td align="right">100</td>
    <td></td>
    <td colspan="4">&nbsp;</td> 
  </tr>
</table>
</div>
<div style="width: 44%;overflow: scroll;float: right;height: 200px;">
<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="2" style="font-size: 12px;font-weight: bold;background-color: #a59eff;" align="center">Select Team</td>
  </tr>
  <tr>
    <td> 
	<select class="form-control" style="height: 23px !important;width: 350px;">
		<option value=""></option>
	</select>
	</td>
    <td align="center" style="background-color: #e2ef77">
    <input type="submit" class="btn-primary" name="submit" id="submit" value=" ADD  " style="font-weight: bold;height: 20px !important;">
    </td>
  </tr>
  </table>
  <table class="gridtable" width="100%"> 
  <tr>
    <th style="background-color: #a59eff;font-size: 12px !important;">Team Selected</th> 
    <th colspan="4" style="background-color: #0a0628;font-size: 11px !important;color: white;">LEAD : Name</th>
  </tr>
  <tr>
    <th>Employee Name &amp; ID</th>
    <th>Dept</th>
    <th>Email</th>
    <th>Contact</th>
    <th>left</th>
  </tr>
  <tr>
    <td>vijay main - test case 100024</td>
    <td>Department</td>
    <td>vijay.main@muthagroup.com</td>
    <td>9923399361</td>
    <td>left</td>
  </tr>
</table>
</div>


<table class="gridtable" width="100%">  
<tr>
 <th colspan="9">List of Action Planned during the Execution of the Project</th>
</tr>
<tr>
 <th>Review Date</th>
 <th>Action Details</th>
 <th>Status</th>
 <th>Responsibility</th>
 <th>Target Date</th>
 <th>Completion Date </th>
 <th>Reason for Planning action</th>
 <th>Findings</th>
 <th>Save</th>
</tr>
<tr>
 <td>Date Picker</td>
 <td>Data Entry</td>
 <td> </td>
 <td>Drop down from the Team charter</td>
 <td>Date Picker</td>
 <td>Date Picker</td>
 <td>Data Entry</td>
 <td>Data Entry</td>
 <td>Save</td>
</tr>
</table>

<br> 
<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="8" align="center" style="font-size: 12px;font-weight: bold;background-color: #a59eff">Score History Data</td>
  </tr>
  <tr>
    <th>History No</th>
    <th>Define</th>
    <th>Measure</th>
    <th>Analyze</th>
    <th>Improve</th>
    <th>Control</th>
    <th>Total</th>
    <th>History Date</th>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
 
</div> 
</section> 
</section>
    
 <!---------------------------------------------------------------------------------- User Profile Screen Ends ----------------------------------------------------------------------->                
 
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