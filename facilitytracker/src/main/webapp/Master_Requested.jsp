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
<title>My Requests</title> 
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
	text-align: center;
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
            <!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
            <ol class="breadcrumb">
              <li><i class="icon_menu-square_alt2"></i>SAP Master Requested</li> 
              <li><i class="icon_refresh" style="color: gray;"></i><a href="Master_Requested.jsp" style="font-weight: bold;">Refresh</a>  </li>
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
<!-- ********************************************************************************************************************* -->
<div class="row" style="height:500px;">
          <div class="col-lg-12"> 
             <div class="table-responsive"> 
				<table class="gridtable"> 
					<tr style="background-color: #dedede;color: black;"> 
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
						<th>Call</th> 
						<th>Status</th>
						
						<th>Material Code</th>
						<th>ACC Code</th>
						
						<th>Pending</th> 
						<th>Msg</th>
						<th>Action</th>
						<th>Log</th> 
					</tr>
	<%
		String mat_group="", logBy=""; 
	
	String query = "",pur_log="";
	ps_check = con_master.prepareStatement("SELECT plant  FROM rel_SAPmaster_releaseStrategy where enable=1 and u_id="+uid);
 	rs_check = ps_check.executeQuery();
 	if(rs_check.next()){
 	pur_log="1";
	query = "SELECT * FROM tran_SAPmaster_create where (plant in(SELECT plant  FROM rel_SAPmaster_releaseStrategy where enable=1 and user_type='pur' and u_id="+uid+") or created_by="+uid+") and enable=1 order by id desc";
 	}else{
 		query = "SELECT * FROM tran_SAPmaster_create where enable=1 and  created_by="+uid+" order by id desc";
 	}
	if(dept_id==18){
	 		query = "SELECT * FROM tran_SAPmaster_create where enable=1 order by id desc";
	}
 	
	ps_check = con_master.prepareStatement(query);
	
	 rs_check = ps_check.executeQuery();
     	while(rs_check.next()){
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
	%>
	<tr style="cursor:default; font-size: 12px;">
		<td align="right"><%=rs_check.getInt("id") %>
		<%
		if(rs_check.getInt("fileupload_id")!=0){
		%>
		<strong style="color: blue;">*</strong>
		<%	
		}
		%>
		</td>
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
		<td width="10%"><%=rs_check.getString("reason") %></td>  
		<td align="right"><b><%=logBy %></b><br><%=rs_check.getString("contactNo") %></td>
		<td align="center">
		<% 
		if(rs_check.getInt("stage_no")==1 || (pur_log.equalsIgnoreCase("1") && rs_check.getInt("stage_no")!=0 && rs_check.getInt("stage_no")!=4)){
		%>
		<a href="Master_Edit.jsp?id=<%=rs_check.getInt("id")%>&appr=0" style="font-weight: bold;color: blue;" title="Click to edit/Make corrections if any"><%=rs_check.getString("status_id") %></a> 
		<% 
		}else{	
		%>
		<%=rs_check.getString("status_id") %>
		<%	
		}
		%> 
		</td>
		<td>
		<%
		if(rs_check.getString("material_code")!=null){
		%>
		<strong><%=rs_check.getString("material_code") %></strong>
		<%	
		}
		%>
		</td>
		<td>
		<%
		ps_check1 = con_master.prepareStatement("SELECT asset_code FROM rel_SAPmaster_acc_regCode where enable=1 and newMaster_id="+rs_check.getInt("id") +" order by id desc");
		rs_check1 = ps_check1.executeQuery();
		while (rs_check1.next()) {
		%>
		<strong><%=rs_check1.getString("asset_code") %>,</strong><br>
		<%	
		}
		%>
		</td>
		
		
		<td align="left"><%=rs_check.getString("status") %></td>
		<td align="center">
		<span id="sendMsgBack<%=rs_check.getInt("id") %>">
		<textarea rows="1" cols="10" name="sendMsg<%=rs_check.getInt("id") %>" class="form-control" onkeypress="return checkQuote();" id="sendMsg<%=rs_check.getInt("id") %>" style="font-size: 9px;font-weight: bold;color: black;"></textarea>
		 </span> 
		<td width="100" align="center">
		<span id="delete_record<%=rs_check.getInt("id") %>">
		<img src="img/send.png" title="Send Message" style="cursor: pointer;"  onclick="sendMessage('1',<%=rs_check.getInt("id") %>); return false;" id="msg<%=rs_check.getInt("id") %>">
		</span>
		</td>
		<td>
		<a href="Master_Approval_Log.jsp?id=<%=rs_check.getInt("id")%>&home=5">
		<img src="img/LogHere.png" title="History" style="cursor: pointer;" id="log<%=rs_check.getInt("id") %>">
		</a>
		</td>
	</tr>
	<%  
		}
     	logBy="";
	%>
			</table> 
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