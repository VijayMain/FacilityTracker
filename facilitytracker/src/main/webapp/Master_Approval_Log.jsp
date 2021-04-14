<%@page import="java.util.concurrent.TimeUnit"%>
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
<title>Log</title> 
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
	function checkQuote() {
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47  || event.keyCode == 63) {
			event.keyCode = 0;
			return false;
		}
	}
  
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
					document.getElementById("delete_record").innerHTML = xmlhttp.responseText; 
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
		 var approve = document.getElementById('approve'+val);
		 var reject = document.getElementById('reject'+val); 
		 
		 var cndCheck='';
		 
		 if(sendMsg.value!="" && (code==1 || code==4)){
			 cndCheck='1';
		 }else if(code!=1 && code!=4){
			 cndCheck='1';
		 }else{
			 alert("No message received...!!!!");
		 }
		 
		if(cndCheck!=''){ 
		 sendMsg.readOnly = true;
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
		 
		 msg.style.display = "none"; 
		 
		}else{
			alert("No message received, Error Occurred...!!!!");
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
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	text-align: center; 
	color: black;
	/* color: white;
	background-color: #dedede; */
}

table.gridtable td {
font-size: 10px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: white;
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
	boolean availFlag=false,userInfoFlag=false,userreport=false;
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");  
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat format3 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	long diff,diffHours;
	
	java.util.Date date2cmp;
	Calendar calobj = Calendar.getInstance();
	String todays_date = format2.format(calobj.getTime());
	date2cmp = format2.parse(todays_date);
	
	PreparedStatement ps_check = null, ps_check1=null,ps_local=null;
	ResultSet rs_check = null,rs_check1=null,rs_local=null; 
	int id = Integer.valueOf(request.getParameter("id"));
	int home = Integer.valueOf(request.getParameter("home"));
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
             <li><i class="icon_id-2"></i><strong>History </strong></li> 
             <%
             if(home==1){
             %> 
             <li><i class="icon_ribbon_alt"></i><a href="Master_Home.jsp" style="font-weight: bold;">My Requests</a></li>
             <li><i class="icon_pencil" style="color: gray;"></i><a href="Master_Create.jsp" style="font-weight: bold;">Create New</a></li>
             <!-- <li><i class="arrow_expand_alt2" style="color: gray;"></i><a href="Master_Create_EXTCode.jsp" style="font-weight: bold;">Extend Material Code</a></li> -->
             <li><i class="icon_upload" style="color: gray;"></i><a href="Master_Create_BulkUpload.jsp"  style="font-weight: bold;">Bulk Upload</a>  </li>
             <%
             }else if(home==0){
             %>
             <li><i class="icon_ribbon_alt"></i><a href="Master_Approval.jsp" style="font-weight: bold;">Provide Approval</a></li>
        	<%
             }else if(home==2){
            %>
             <li><i class="icon_error-circle_alt"></i><a href="Master_Reject.jsp" style="font-weight: bold;">Rejected Master Data</a></li>
            <%
             }else if(home==3){
            %>
             <li><i class="icon_check"></i><a href="Master_Done.jsp" style="font-weight: bold;">SAP Master Created In SAP</a></li>
            <%
             }else if(home==5){
            %>
             <li><i class="icon_menu-square_alt2"></i><a href="Master_Requested.jsp" style="font-weight: bold;">SAP Master Requested</a></li>
            <%
                }else if(home==4){
            %>
            <li><i class="icon_ribbon_alt"></i><a href="Master_Generate.jsp" style="font-weight: bold;">Master Generate</a></li>
              <!-- <li><i class="icon_box-checked" style="color: gray;"></i><a href="Master_Approval.jsp" style="font-weight: bold;">All Approvals</a>  </li> --> 
              <!-- <li><a href="Master_Approval.jsp" style="font-weight: bold;"><i class="icon_floppy" style="color: black;"></i>Generate Excel</a>  </li> -->
            <%	 
             }
        	%>
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
            </ol> 
          </div>
        </div> 
<!-- ********************************************************************************************************************* -->
<div class="row" style="height:1000px; overflow: scroll;">
          <div class="col-lg-12"> 
            <div class="table-responsive"> 
            <table style="width: 100%;" class="gridtable"> 
            <%
            int sno=1;
            ps_check = con_master.prepareStatement("select material_code from tran_SAPmaster_create where enable=1 and id="+id+" and material_code is not null");
          	rs_check = ps_check.executeQuery();
          	if(rs_check.next()){
          	%>
          	<tr style="background-color: #b1dbf6;font-size:20x; color: black;text-align: left: ;"> 
				 <th colspan="2"><strong style="font-size: 14px;">Material Code Created : <%=rs_check.getString("material_code") %></strong></th>   
				 </tr>
			<tr>
          	<tr style="background-color: #dedede;color: black;text-align: center;"> 
				 <th>S.No</th>
				 <th>Account Register Code</th>   
			</tr>
          	<%	
          	ps_check1 = con_master.prepareStatement("SELECT asset_code FROM rel_SAPmaster_acc_regCode where enable=1 and newMaster_id="+id +" order by id desc");
			rs_check1 = ps_check1.executeQuery();
			while (rs_check1.next()) {
          	%>
			<tr>
				<td align="center"><%=sno %></td>
				<td align="left"><%=rs_check1.getString("asset_code") %></td>
			</tr>
			<%
			sno++;
			}
			%>		
			</table>		
          	<%	
          	}
            %>
				
	
	
	<table style="width: 100%;" class="gridtable"> 
					<tr style="background-color: #dedede;color: black;text-align: center;"> 
						<th>NO</th>
						<th>Plant</th>
						<th>Mat Type</th>
						<th>Material Group</th>
						<th>Material Name</th>
						<th>Qty</th>
						<th>Location</th>
						<th>UOM</th> 
						<th>Required In</th>
						<th>Amount</th> 
						<th>HSN NO</th>
						<th>Reason</th> 
						<th>Created Date</th> 
						<th>Status</th>
						<th>Pending</th>    
					</tr>
	<%
		String mat_group="", logBy="",crtd_date="",rel_date="", start_date="", end_date="",changed_by="";   
	
		ps_check = con_master.prepareStatement("SELECT * FROM tran_SAPmaster_create where id="+id);
     	rs_check = ps_check.executeQuery();
     	while(rs_check.next()){
     		crtd_date = rs_check.getString("log_date");
			ps_check1 = con_master.prepareStatement("SELECT descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code="+rs_check.getString("materialGroup"));
			rs_check1 = ps_check1.executeQuery();
			while (rs_check1.next()) {
				mat_group=rs_check1.getString("descr");
			}
			ps_local = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_check.getInt("created_by"));
			rs_local = ps_local.executeQuery();
			while(rs_local.next()){
				logBy = rs_local.getString("u_name");
			}
			ps_local = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_check.getInt("changed_by"));
			rs_local = ps_local.executeQuery();
			while(rs_local.next()){
				changed_by = rs_local.getString("u_name");
			}
	%> 
	<tr style="cursor:default;">
		<td align="right"><%=rs_check.getInt("id") %></td>
		<td><%=rs_check.getString("plant") %></td>
		<td><%=rs_check.getString("materialType") %></td>
		<td><%=mat_group %></td>
		<td><%=rs_check.getString("materialName") %></td>
		<td align="right"><%=rs_check.getInt("qty") %></td>
		<td><%=rs_check.getString("storageLocation") %></td>
		<td><%=rs_check.getString("uom") %></td> 
		<td width="7%"><%=rs_check.getString("plant_toExtend") %></td>
		<td align="right"><%=rs_check.getString("price") %></td> 
		<td align="right"><%=rs_check.getString("hsn_code") %></td>
		<td><%=rs_check.getString("reason") %></td>    
		<td><%=format.format(rs_check.getDate("created_date")) %></td>   
		<td align="center"><%=rs_check.getString("status_id") %></td> 
		<td><%=rs_check.getString("status") %></td>
	</tr> 
	<tr align="center">
		<td colspan="5"><strong style="font-size: 12px;">Requested by : <%=logBy %> [call : <%=rs_check.getString("contactNo") %>]</strong></td>
		<td colspan="4"><strong style="font-size: 12px;">Last Change date : <%=format3.format(rs_check.getTimestamp("changed_date")) %></strong> </td>
		<td colspan="3"><strong style="font-size: 12px;">Last Change By : <%=changed_by %></strong></td>
		<td colspan="3">
		<%
		 if(rs_check.getString("filename")!=null){
		%> 
		<a href="Master_DisplayDoc.jsp?id=<%=id%>" style="font-size: 10px;"><%=rs_check.getString("filename") %></a>
		<%
			}
		%>
		</td>
	</tr>
	<%
		}
	%>
	</table>
	
	
	<div style="width: 70%;overflow: scroll;height: 400px;float: left;">
		<table style="width: 100%;" class="gridtable"> 
					<tr style="background-color: #dedede;color: black;text-align: center;">   
						<th colspan="16" align="center" style="background-color: #c3a61f;color: white;"><strong style="font-size: 12px;">:::::: History ::::::</strong></th>  
					</tr>
					<tr style="background-color: #e2ecef;text-align: center;">  
						<th>Plant</th>
						<th>Mat Type</th>
						<th>Material Group</th>
						<th>Material Name</th>
						<th>Qty</th>
						<th>Location</th>
						<th>UOM</th> 
						<th>Required In</th>
						<th>Amount</th> 
						<th>HSN NO</th>
						<th>Reason</th>
						<th>Changed By</th>
						<th>Changed Date</th> 
						<th>Status</th>
						<th>Pending</th>  
						<th>Attachment</th>  
					</tr>
					<%
					changed_by="";
					ps_check = con_master.prepareStatement("SELECT * FROM rel_SAPmaster_create_history where newMaster_id="+id +" order by id desc");
			     	rs_check = ps_check.executeQuery();
			     	while(rs_check.next()){
			     		ps_local = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_check.getInt("changed_by"));
						rs_local = ps_local.executeQuery();
						while(rs_local.next()){
							changed_by = rs_local.getString("u_name");
						}
					%>
				<tr>
					<td><%=rs_check.getString("Plant") %></td>
					<td><%=rs_check.getString("materialType") %></td>
					<td><%=rs_check.getString("materialGroup") %></td>
					<td><%=rs_check.getString("materialName") %></td>
					<td><%=rs_check.getString("qty") %></td>
					<td><%=rs_check.getString("storageLocation") %></td>
					<td><%=rs_check.getString("uom") %></td>
					<td><%=rs_check.getString("plant_toExtend") %></td>
					<td><%=rs_check.getString("price") %></td>
					<td><%=rs_check.getString("hsn_code") %></td>
					<td><%=rs_check.getString("reason") %></td>
					<td><%=changed_by %></td>
					<td><%=rs_check.getString("changed_date") %></td>
					<td><%=rs_check.getString("status_id") %></td>
					<td><%=rs_check.getString("status") %></td>
					<td>
					<%
		 			if(rs_check.getString("filename")!=null){
					%> 
					<a href="Master_DisplayDocHist.jsp?id=<%=rs_check.getInt("id")%>" style="font-size: 10px;"><%=rs_check.getString("filename") %></a>
					<%
						}
					%>
					</td>
				</tr>
					<%
					changed_by="";
			     	}
					%>
		</table>		
	</div>			
	
	
	
	
	
	
	
	
	
	
	<div style="width: 29.5%;overflow: scroll;height: 400px;float: right;">
	<table style="width: 100%;" class="gridtable"> 
					<tr style="background-color: #dedede;color: black;text-align: center;">   
						<th colspan="5" align="center" style="background-color: #c3a61f;color: white;"><strong style="font-size: 12px;">:::::: Message History ::::::</strong></th>  
					</tr>
					<tr style="background-color: #dedede;color: black;"> 
						<th>Msg No</th>
						<th>User Name</th>
						<th>Message Received</th>
						<th>Status</th>
						<th>Created Date</th>   
						<!-- <th>Overdue Hrs</th>  -->  
					</tr>
					<%
					ps_check = con_master.prepareStatement("SELECT * FROM  rel_SAPmaster_release where newMaster_id="+id +" and enable=1 order by id");
			     	rs_check = ps_check.executeQuery();
			     	while(rs_check.next()){
					%>
					<tr style="background-color: #dec31f;color: black;text-align: center;">
						<td align="right"><%=rs_check.getInt("id") %></td>
						<td align="left"><%=rs_check.getString("userName") %></td> 
						<td align="left"><%=rs_check.getString("reply_msg") %></td>
						<td align="left"><%=rs_check.getString("status") %></td>
						<td align="left"><%=format3.format(rs_check.getTimestamp("created_date")) %></td>
						<%-- <td>
						<%   
						ps_local = con_master.prepareStatement("select top 1 created_date from rel_SAPmaster_release where newMaster_id="+id+" and status='REL' and enable=1");
				     	rs_local = ps_local.executeQuery();
				     	if(rs_local.next()){
				     		rel_date = rs_local.getString("created_date"); 
				     	} 
				     	ps_local = con_master.prepareStatement("select top 1 created_date from  rel_SAPmaster_release where newMaster_id="+id+" and enable=1 and status='REL'");
				     	rs_local = ps_local.executeQuery();
				     	if(rs_local.next()){
				     		start_date = rs_local.getString("created_date"); 
				     	}
				     	ps_local = con_master.prepareStatement("select top 1 created_date  from  rel_SAPmaster_release where newMaster_id="+id+" and enable=1 and status in('DONE','REJ')");
				     	rs_local = ps_local.executeQuery();
				     	if(rs_local.next()){
				     		end_date = rs_local.getString("created_date"); 
				     	}
						%> 
						<%
						if(rs_check.getString("status").equalsIgnoreCase("CRTD") || rs_check.getString("status").equalsIgnoreCase("REL")){
							diff = Math.abs(format2.parse(crtd_date).getTime() - format2.parse(rel_date).getTime())  / (60 * 60 * 1000); 
						}else{
							diff = Math.abs(format2.parse(end_date).getTime() - format2.parse(start_date).getTime())  / (60 * 60 * 1000); 
						}
						%>
						<%=diff %>
						</td> --%>
					</tr>
					<%
			     	}
					%>
				</table>	
	
	</div>			
				 
				
        </div>
          </div>
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