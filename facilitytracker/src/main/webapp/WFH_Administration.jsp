<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin</title> 
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
	
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 13px;
	border-width: 1px;
	padding: 8px;
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
<script type="text/javascript">
function time_convert(min,id)
{     
	var hours = min / 60;   
	document.getElementById("inHr"+id).innerText = hours.toFixed(2); 
}

function time_id(id)
{
	var time = document.getElementById("time_required"+id).value;   
	var lay_hid = document.getElementById("lay_hid").value; 
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
				document.getElementById("tmG_reqd").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_Config_Ajax.jsp?id=" + id +"&time=" + time +"&lay_hid=" + lay_hid, true);
		xmlhttp.send();
}

function pass_type(val)
{ 
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
				document.getElementById("display_layout").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_Administration_Ajax.jsp?val=" + val, true);
		xmlhttp.send();
}

</script>
</head> 
<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getLocalUserConnection();
Connection con_Master = Connection_Util.getConnectionMaster();
PreparedStatement ps_check=null,ps_check1=null;
ResultSet rs_check=null,rs_check1=null;
String company="";
String lay_hid="";
DecimalFormat formatter = new DecimalFormat("00.00");
SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString()); 
int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
int uid = Integer.valueOf(session.getAttribute("uid").toString());  
String username = session.getAttribute("username").toString(); 
String deptName = session.getAttribute("deptName").toString();
PreparedStatement ps_company = con.prepareStatement("select * from user_tbl_company where Company_Id="+comp_id);
ResultSet rs_company = ps_company.executeQuery();
while (rs_company.next()) {
	company=rs_company.getString("Company_Name");
}
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
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
	<div class="row">
          <div class="col-lg-12">
            <section class="panel">
              <header class="panel-heading"><span  style="color: black;font-weight: bold;">Add DWM Task Details</span>
              <%
  		if(request.getParameter("status")!=null){
		%> 
         <strong class="alert alert-success fade in"><%=request.getParameter("status") %> </strong> 
        <%
		}else if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"><%=request.getParameter("statusNop") %> </strong> 
	        <%
			}
		%>
              </header>
              <div class="panel-body">
                <div class="form"> 
              <div style="height: 500px;overflow: scroll;">    
              <!-- <form action="WFH_ConfigControl" method="post" id="feedback_form" class="form-validate form-horizontal"> -->
               <table style="width: 70%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;"> 
             		<th align="center"  style="color: black;">Selected Layout :</th>  
		<th align="center"  style="color: black;">
			<select name="pass_type" id="pass_type" class="form-control" onchange="pass_type(this.value)" style="font-weight: bold;color: black; font-size: 12px !important;">
             <%
             ps_check = con_Master.prepareStatement("select distinct(specification3) as specification3 from tran_wfh_config where enable_id=1");
             rs_check = ps_check.executeQuery();
             while(rs_check.next()){
            	 lay_hid = rs_check.getString("specification3");
             %>
             <option value="<%=rs_check.getString("specification3") %>"><%=rs_check.getString("specification3") %></option>
             <%
             } 
             ps_check = con_Master.prepareStatement("select distinct(specification3) as specification3 from tran_wfh_config where enable_id=0");
             rs_check = ps_check.executeQuery();
             while(rs_check.next()){
             %>
             <option value="<%=rs_check.getString("specification3") %>"><%=rs_check.getString("specification3") %></option>
             <%
             }
             %>
            </select>
		</th> 
				</tr>
				</table>	
             <span id="display_layout">  
             <input type="hidden" id="lay_hid" name="lay_hid" value="<%=lay_hid%>">  
             <table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;"> 
             		<th align="center"  style="color: black;">S.No</th>  
					<th align="center"  style="color: black;">Parameter</th> 
					<th align="center"  style="color: black;">Details</th>   
					<th align="center"  style="color: black;">In Minutes</th>
					<th align="center"  style="color: black;">In hours</th>
					<th align="center"  style="color: black;">Update</th>	 					
				</tr>
				<%
				Double mm=0.0,hh=0.0;
				PreparedStatement ps_upload = con_Master.prepareStatement("SELECT * FROM tran_wfh_config where enable_id =1");
				ResultSet rs_upload = ps_upload.executeQuery();
				while(rs_upload.next()){
					if(rs_upload.getString("specification1")!=null){
						mm =Double.valueOf(rs_upload.getString("specification1"));
					}
					if(rs_upload.getString("specification2")!=null){
						hh =Double.valueOf(rs_upload.getString("specification2"));
					}
				%>
				<tr style="color: black;">
					<td align="center"><%=rs_upload.getInt("id") %></td>
					<td><%=rs_upload.getString("parameter") %></td>
					<td><%=rs_upload.getString("details") %></td>
					<td>
					
					<select name="time_required" id="time_required<%= rs_upload.getInt("id")%>" class="form-control" onchange="time_convert(this.value,<%=rs_upload.getInt("id") %>)" style="font-weight: bold;color: black;width: 80px;font-size: 12px !important;" required>
                     <%
                     if(rs_upload.getString("specification1")!=null){
                     %>
                      	<option value="<%=rs_upload.getString("specification1")%>"><%=rs_upload.getString("specification1") %></option> 
                      <%
                     }else{
                    %>
                      	<option value="">0</option>
                    <%	 
                     }
                      	for(int i=1;i<=1440;i++){
                      	%>
                      	<option value="<%=i%>"><%=i%></option> 
                      	<%
                      	}
                      	%>
                      </select> 
					<input type="hidden" name="id" id="id<%=rs_upload.getInt("id") %>">
					</td>
					<td>
					<span id="inHr<%=rs_upload.getInt("id") %>" style="font-weight: bold;color: black;font-size: 12px;">
					<%
					if(rs_upload.getString("specification2")!=null){
						hh =Double.valueOf(rs_upload.getString("specification2"));
					%>
					<%= formatter.format(hh) %>
					<%
					}else{
					%>
					0.00
					<%
					}
					%>
					</span></td>
	<td><input type="submit" class="form-control" onclick="time_id(<%=rs_upload.getInt("id") %>)" style="font-weight: bold;background-color: #99c9f2" value="Update"> </td>
				<%
					}
				%>
				</tr> 
			</table>
			</span>
			<span id="tmG_reqd"></span>	  
			<!-- </form>  -->  
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