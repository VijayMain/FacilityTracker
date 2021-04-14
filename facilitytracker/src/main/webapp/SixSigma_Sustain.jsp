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
<title>Sustain</title>
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
	function sendMessage(val) {
		 var sendMsg = document.getElementById('sendMsg'+val);  
		 var msgTeam = document.getElementById('msgSend'+val);
		 
		 if(sendMsg.value!=""){
			 sendMsg.readOnly = true;
			 msgTeam.style.display = "none"; 
			 
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
		 	xmlhttp.open("POST", "SixSigma_msgSendtoTeam.jsp?id=" + val + "&sendMsg=" + sendMsg.value + "&select=1", true);  
			xmlhttp.send(); 
		}else{
			alert("Message For Team...?");
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
	font-size: 11px;
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	color: black;
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
        String sustPlan_data="sustPlan";
        %>
        <jsp:include page="SixSigma_Header.jsp" > 
  		<jsp:param name="define" value="<%=sustPlan_data %>" />
		</jsp:include>
     </div> 
<!-- ********************************************************************************************************************* -->
<div style="height:500px;overflow: scroll;"> 
			<table class="gridtable" width="100%"> 
					<tr style="background-color: #dedede;color: black;"> 
						<th>No</th>
						<th>Plant</th>
						<th>Problem Description</th>
						<th>Product</th>
						<th>Product Other Name</th>
						<th>Type of Project</th> 
						<th>Department</th> 
						<th>Project Lead</th> 
						<th>Log Date</th>  
						<th>Phase</th>
						<th>Message</th>
						<th>Send</th>
					</tr>
					<%
					String deptsearchTerm = "",matCode="",phase="",approval="",searchTerm="";
					PreparedStatement ps_data=null;
					int company_id=0;
					ResultSet rs_data=null;
					String defineQuery ="";
					
					/* defineQuery = "select * from tran_pt_problem where phase_id=9 and enable=1 "+
							" and id in (select problem_id from rel_pt_resultPhase where enable=1) and project_lead=" +uid+
							" union select * from tran_pt_problem where phase_id=9 and id in "+
							" (select problem_id from rel_pt_releaseStrategies where enable=1 and relMaster_id in "+ 
							" (select id from rel_pt_releaseMaster where enable=1 and app_uid="+uid+"))"+
							" and id in (select problem_id from rel_pt_resultPhase where enable=1)"; 
					
					ps_data = con_master.prepareStatement("select u_id from rel_pt_reviewer where enable=1 and u_id="+uid);
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						defineQuery = "select * from tran_pt_problem where enable=1 and phase_id=9 and id in (select problem_id from rel_pt_resultPhase where enable=1) order by changed_date desc";
					}
					*/
					ps_data = con_master.prepareStatement("select id from rel_pt_releaseMaster where enable=1 and app_uid=" +uid);
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						defineQuery = "select * from tran_pt_problem where enable=1 and phase_id=9 and id in (select problem_id from rel_pt_resultPhase where enable=1) order by changed_date desc";
					}
					
					
					ps_data = con_master.prepareStatement("select * from tran_pt_problem where phase_id=9 and enable=1 and project_lead=" +uid);
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						defineQuery = "select * from tran_pt_problem where enable=1 and phase_id=9 and project_lead=" +uid +" and id in (select problem_id from rel_pt_resultPhase where enable=1) order by changed_date desc";
					}
					
					
					ps_data = con_master.prepareStatement("select u_id from rel_pt_reviewer where enable=1 and u_id="+uid);
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						defineQuery = "select * from tran_pt_problem where enable=1 and phase_id=9 and id in (select problem_id from rel_pt_resultPhase where enable=1) order by changed_date desc";
					}
					
					if(defineQuery!=""){
					ps_check = con_master.prepareStatement(defineQuery);
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						deptsearchTerm = "";matCode="";phase="";approval="";searchTerm="";
						ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("dept_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							deptsearchTerm = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("select material from rel_SAPmaster_mm60 where id="+rs_check.getInt("product_code"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							matCode = rs_data.getString("material");
						} 
						ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("typeProject"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							searchTerm = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("select approval_Type from approval_type where id="+rs_check.getInt("approval_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							approval = rs_data.getString("approval_Type");
						} 
						ps_data = con_master.prepareStatement("select phase from rel_pt_phase where id="+rs_check.getInt("phase_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							phase = rs_data.getString("phase");
						}
					%>
					<tr>
						<td align="right" style="cursor: pointer;"><%=rs_check.getInt("id") %></td>
						<td align="right"><%=rs_check.getString("plant") %></td>
						<td><%=rs_check.getString("problem_descr") %></td>
						<td><b><%=matCode %></b><br><%=rs_check.getString("product_codeDescr") %></td>
						<td><%=rs_check.getString("type_product_code") %></td>
						<td><%=searchTerm %></td>
						<td><%=deptsearchTerm %></td>
						<td><strong><%=rs_check.getString("project_leadName") %></strong><br>[Creator: <%=rs_check.getString("created_byName")%>]</td>
						<td><%=format.format(rs_check.getDate("tran_date")) %></td>
						<td><%=phase %></td>
<td>
	<span id="sendMsgBack<%=rs_check.getInt("id")%>">
	<textarea class="form-control" placeholder="Message For Team ..." onkeypress="return checkQuote();" style="color: black !important;font-size: 10px;" rows="1" cols="3" id="sendMsg<%=rs_check.getInt("id")%>" name="sendMsg<%=rs_check.getInt("id")%>"></textarea>
	</span>	
</td>
<td align="center" style="width: 100px;">
<a href="SixSigma_Sustain_Data.jsp?problem_id=<%=rs_check.getInt("id")%>" style="color: black;" title="Update Data"><img alt="#" src="img/update.png" style="height: 20px;"> </a>
<img src="img/send.png" title="Send Message" style="cursor: pointer;"  onclick="sendMessage(<%=rs_check.getInt("id") %>); return false;" id="msgSend<%=rs_check.getInt("id") %>">
<a data-toggle="modal" href="#myModalCall<%=rs_check.getInt("id")%>">
<img src="img/LogHere.png" title="History" style="cursor: pointer;" id="log22<%=rs_check.getInt("id") %>">
</a> 
			<!-- Modal -->
                <div class="modal fade" id="myModalCall<%=rs_check.getInt("id") %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-body">
                      <table class="gridtable" width="100%"> 
                      <tr style='font-size: 12px; background-color: #fbffd4; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th colspan='4'>Message History</th></tr> 
						<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th>Message No </th><th>Sent By</th><th>Message</th><th>Sent Date</th></tr>
                        <%
                        ps_data = con_master.prepareStatement("select * from rel_pt_messgeLog where problem_id="+rs_check.getInt("id") + " order by seq_no desc");
                		rs_data = ps_data.executeQuery();
                		while(rs_data.next()){
                		%>
                		<tr style="font-size: 11px;">
                			<td style="text-align: right;width: 40px;"><%=rs_data.getInt("seq_no") %></td>
                			<td><%=rs_data.getString("user_name")%></td> 
                			<td><%=rs_data.getString("msg_data")%></td>
                			<td><%=format.format(rs_data.getDate("changed_date")) %></td>
                		</tr>
                		<%		
                		}
                        %>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
    		<!-- modal -->
</td>
				</tr>
					<%
					}
					}
					%>
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