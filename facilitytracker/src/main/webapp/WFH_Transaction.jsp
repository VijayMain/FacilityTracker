<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
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
<title>WFH</title>
<style type="text/css">
table.gridtable {
	font-family: Arial, Helvetica, sans-serif;
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 12px;
	border-width: 1px;  
	height:25px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 12px;
	border-width: 1px; 
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
<script type="text/javascript" src="js/tabledeleterow.js"></script> 
<script type="text/javascript" src="js/tabledeleterow1.js"></script> 
<script type="text/javascript">
window.onload = function() {
	 const myInput = document.getElementById('dwm_title'); 
 	 const prj_title = document.getElementById('prj_title'); 
 	 const remark_project = document.getElementById('remark_project'); 
	 
	 myInput.onpaste = function(e) {
	   e.preventDefault();
	 }
 	 prj_title.onpaste = function(e) {
		   e.preventDefault();
	}
 	 remark_project.onpaste = function(e) {
		   e.preventDefault();
	}
};

function validateForm() {
	var email=document.getElementById('email').value;  
	var contact=document.getElementById('contact').value;
	 
	if(email !="" && email.includes("@")==false){
		alert("Proper E-Mail ID Required...!!!");
		document.getElementById("Save").disabled = false;
		return false; 
	} 
	
	if(contact =="" || contact==null || contact=="" || contact=="null" || contact.length!=10){
		alert("Contact No ...!!!");
		document.getElementById("Save").disabled = false;
		return false; 
	}
	
	document.getElementById("Save").disabled = true;
	return true;
} 



function validateFormProj() {
	var tot_part=document.getElementById('tot_part').value;     
	if(tot_part =="0"){
		alert("Participants are not added in list ...!!!");
		document.getElementById("saveProject").disabled = false;
		return false; 
	}
	
	document.getElementById("saveProject").disabled = true;
	return true;
}






function getDetails(str) {
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
			var a = null;
			document.getElementById("myDetails").innerHTML = xmlhttp.responseText; 
		}
	};
	xmlhttp.open("POST", "WFH_GetUserDetails_Ajax.jsp?q=" + str, true);  
	xmlhttp.send();
}

function time_convert(min)
{    
	var hours = min / 60;   
	document.getElementById("inHr").innerText = hours.toFixed(2);
}


function GetAttachDocDWM(val) {  
	document.getElementById('tot_file').value = val; 
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
				document.getElementById("dwmAttach").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_dwmAttach_Ajax.jsp?nofile=" + val , true);
		xmlhttp.send();
};
function GetAttachDocProj(val) {
	document.getElementById('tot_prjfile').value = val; 
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
				document.getElementById("projAttach").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_projAttach_Ajax.jsp?nofile=" + val , true);
		xmlhttp.send();
};
function decision_call(val,val1) {
	var cnt = document.getElementById('cnt').value; 
	var appr_remark = document.getElementById('appr_remark'+val1).value;
	var xmlhttp, xmlhttp2,xmlhttp1;
		if (window.XMLHttpRequest) {
			// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp = new XMLHttpRequest(); 
			xmlhttp2 = new XMLHttpRequest();
			xmlhttp1 = new XMLHttpRequest();
		} else {
			// code for IE6, IE5
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
			xmlhttp2 = new ActiveXObject("Microsoft.XMLHTTP"); 
			xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP"); 
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				document.getElementById("remark_ajax"+val1).innerHTML = xmlhttp.responseText; 
			}
		}; 
		xmlhttp2.onreadystatechange = function() {
			if (xmlhttp2.readyState == 4 && xmlhttp2.status == 200) {
				document.getElementById("approval_btn"+val1).innerHTML = xmlhttp2.responseText; 
			}
		}; 
		xmlhttp1.onreadystatechange = function() {
			if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
				document.getElementById("countApproval").innerHTML = xmlhttp1.responseText; 
			}
		}; 
		xmlhttp.open("POST", "WFH_dwmApprovalRem_Ajax.jsp?appr_remark=" + appr_remark + "&id=" + val1 , true); 
		xmlhttp2.open("POST", "WFH_dwmApproval_Ajax.jsp?status=" + val + "&id=" + val1 , true);
		xmlhttp1.open("POST", "WFH_dwmApprovalCt_Ajax.jsp?cnt=" + cnt, true);
		 
		xmlhttp.send(); 
		xmlhttp2.send();
		xmlhttp1.send();
};







function addUsers_call() { 
	var participant = document.getElementById('participant').value;  
	var tot_part = document.getElementById('tot_part').value;  
	var part_group = document.getElementById('part_group').value; 
	if(participant==""){
	alert("No Participants Selected....!!!");
	}else{
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
				document.getElementById("addMe").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "WFH_projParticipants_Ajax.jsp?participant=" + participant + "&tot_part=" + tot_part + "&part_group=" + part_group, true);
		xmlhttp.send();
	}
};

function checkQuote() {
	
	if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
		event.keyCode = 0;
		return false;
	}
}









function decision_callPrj(val,val1) { 
	var prjcnt = document.getElementById('prjcnt').value;
	var appr_remark = document.getElementById('prjappr_remark'+val1).value;
	
	var xmlhttp, xmlhttp2,xmlhttp1;
		if (window.XMLHttpRequest) {
			// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp = new XMLHttpRequest(); 
			xmlhttp2 = new XMLHttpRequest();
			xmlhttp1 = new XMLHttpRequest();
		} else {
			// code for IE6, IE5
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
			xmlhttp2 = new ActiveXObject("Microsoft.XMLHTTP"); 
			xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP"); 
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				document.getElementById("remark_Prjajax"+val1).innerHTML = xmlhttp.responseText; 
			}
		}; 
		xmlhttp2.onreadystatechange = function() {
			if (xmlhttp2.readyState == 4 && xmlhttp2.status == 200) {
				document.getElementById("approval_Prjbtn"+val1).innerHTML = xmlhttp2.responseText; 
			}
		}; 
		xmlhttp1.onreadystatechange = function() {
			if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
				document.getElementById("prjcountApproval").innerHTML = xmlhttp1.responseText; 
			}
		}; 
		xmlhttp.open("POST", "WFH_PrjApprovalRem_Ajax.jsp?appr_remark=" + appr_remark + "&id=" + val1 , true); 
		xmlhttp2.open("POST", "WFH_PrjApproval_Ajax.jsp?status=" + val + "&id=" + val1 , true);
		xmlhttp1.open("POST", "WFH_PrjApprovalCt_Ajax.jsp?cnt=" + prjcnt, true);
		 
		xmlhttp.send(); 
		xmlhttp2.send();
		xmlhttp1.send();
};

function delete_call(str) { 
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
			var a = null;
			document.getElementById("deleteDWM_task"+str).innerHTML = xmlhttp.responseText; 
		}
	};
	xmlhttp.open("POST", "WFH_deleteDWM_task_Ajax.jsp?q=" + str, true);  
	xmlhttp.send();
}

</script>
</head>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: white;">
	<%
		try {
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			boolean flag = false;
			int dwmAppr=0,dwmApprall=0,prjAppr=0,prjApprall=0;
			int day=0;
			int month=0;
			int year=0;
			DecimalFormat df2 = new DecimalFormat( "00" );
			DecimalFormat df3 = new DecimalFormat( "00.00" );
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			if(request.getParameter("none").equalsIgnoreCase("1")){
				flag=true;
			}else {
			day=Integer.valueOf(request.getParameter("day"));
			month=Integer.valueOf(request.getParameter("month"))+1;
			year=Integer.valueOf(request.getParameter("year"));
			
			flag=false;
			}
			
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			int dept_idCheck = Integer.valueOf(session.getAttribute("dept_id").toString());
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			
		//	System.out.println("Dept = " + dept_idCheck + " = " + uid);
			
			PreparedStatement ps_user=null,ps_check=null,ps_check1=null,ps_check2=null;
			ResultSet rs_user=null,rs_check=null,rs_check1=null,rs_check2=null;
			
			/* ps_user = con.prepareStatement("select * from  user_tbl where U_Id="+uid+" and sap_id!='null'");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				userInfoFlag=true;
			}  */
			
			ps_user = con_master.prepareStatement("select COUNT(id) as count from rel_dwm_approvers where u_id='"+uid+"' and dwm_id in (SELECT  id  FROM  tran_dwm_tasks where enable_id=1 and tran_date between DATEADD(DAY, -4, GETDATE()) and GETDATE() and  approval_id is null)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				dwmAppr=rs_user.getInt("count");
			}
			
			ps_user = con_master.prepareStatement("select COUNT(id) as count from rel_dwm_approvers where dwm_id in (SELECT  id  FROM  tran_dwm_tasks where enable_id=1 and tran_date between DATEADD(DAY, -4, GETDATE()) and GETDATE() and approval_id is null)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				dwmApprall=rs_user.getInt("count");
			}
			 
			ps_user = con_master.prepareStatement("select COUNT(id) as count from tran_wfh_project_task where enable_id=1 and approval_id is null and project_id in (select project_id from rel_project_approvers where enable_id=1 and u_id="+uid+")");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				prjAppr=rs_user.getInt("count");
			}
			
			ps_user = con_master.prepareStatement("select COUNT(id) as count from tran_wfh_project_task where enable_id=1 and approval_id is null and project_id in (select project_id from rel_project_approvers where enable_id=1)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				prjApprall=rs_user.getInt("count");
			}
			
	%>
	<!-- ********************************************************************************************************************* -->
	<div class="panel panel-primary" style="background-color: white;">
				<table style="width: 50%;">
					<tr>
						<th><a href="Home.jsp"><b style="font-size: 15px;color: blue;">Go back to Dashboard</b></a></th>
					</tr>
			</table>	 	
		<div class="panel">  
		<%
		/* if(userInfoFlag==true){ */	
			Double tot_hoursAp=0.0,tot_hoursrej=0.0,todays_tot =0.0,pend_hours=0.0;		 
			Double tot_PrjhoursAp=0.0,tot_Prjhoursrej=0.0,todays_Prjtot =0.0,pend_Prjhours=0.0;		 
			
			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and cast(tran_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				todays_tot=rs_user.getDouble("totHr");
			}
			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				todays_Prjtot=rs_user.getDouble("totHr");
			} 
			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and cast(tran_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				tot_hoursAp=rs_user.getDouble("totHr");
			}
			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				tot_PrjhoursAp=rs_user.getDouble("totHr");
			}
			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=2 and enable_id=1 and cast(tran_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				tot_hoursrej=rs_user.getDouble("totHr");
			}
			
			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=2 and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				tot_Prjhoursrej=rs_user.getDouble("totHr");
			} 
			ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id is null and enable_id=1 and cast(tran_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				pend_hours=rs_user.getDouble("totHr");
			} 
			ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id is null and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				pend_Prjhours=rs_user.getDouble("totHr");
			}
			  
			tot_hoursAp = tot_PrjhoursAp+tot_hoursAp;
			tot_hoursrej = tot_Prjhoursrej + tot_hoursrej;
			todays_tot = todays_Prjtot+ todays_tot;
			pend_hours = pend_Prjhours+pend_hours;
		%>
		
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------- Header Details ---------------------------------------------------------------------------------->
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>		
			<table style="width: 100%;"  class="gridtable">
				<tr>  
					<%
					DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
					Date dateobj = new Date(); 
					%>
					<th align="center"  style="color: black;">Date : <b style="color: blue;font-size: 15px;"><%=df.format(dateobj)  %>  </b></th>
					<th align="center"  style="color: black;">Todays Hours : <b style="color: blue;font-size: 15px;"><%=df3.format(todays_tot/60)  %>  </b></th>
					<th align="center"  style="color: black;">Todays Approved Hours : <b style="color: green;font-size: 15px;"><%=df3.format(tot_hoursAp/60)  %>  </b></th>
					<th align="center"  style="color: black;">Todays Rejected Hours : <b style="color: green;font-size: 15px;"><%=df3.format(tot_hoursrej/60)  %>  </b></th>
					<th align="center"  style="color: black;">Todays Pending Hours : <b style="color: red; font-size: 15px;"><%=df3.format(pend_hours/60)  %> [ <%= df2.format(pend_hours)%> Min ]  </b></th>
					<th  align="right">
		<%
  		if(request.getParameter("statusok")!=null){
		%> 
         <strong class="alert alert-success fade in"><%=request.getParameter("statusok") %> </strong> 
        <%
		}else if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"><%=request.getParameter("statusNop") %> </strong> 
	        <%
			}
		%>
					</th> 
				</tr>
			</table>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------- Header End --------------------------------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  			
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------- Tab Logic ----------------------------------------------------------------------------------------------->
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>			  
       <ul class="nav nav-tabs" style="font-size: 12px;font-weight: bold;">
		<%
  		if(request.getParameter("prjtab")!=null){
  		%>
  		<li id="actdwmCheck">
  		<%	
  		}else{
  		%>
  		  <li id="actdwmCheck" class="active">
  		<%	
  		}
		%>   
        <a data-toggle="tab" href="#DWM">DWM</a>
        </li>
   		<%
  		if(request.getParameter("prjtab")!=null){
  		%>
  	  		<li id="actprjCheck"  class="active">
  	  	<%	
  		}else{
  		%>
  		<li id="actprjCheck">
  		<%	
  		}
		%>        
        <a data-toggle="tab" href="#My_Project">My Projects</a>
        </li>
                 <%--  <%
                  if(dwmAppr>0){
                  %> --%>
                   <li class="">
                     <%
                   if(dept_idCheck==26){
                	   dwmAppr = dwmApprall;
                	   prjAppr = prjApprall;
                   } 
                   %> 
                    <a data-toggle="tab" href="#DWM_Approve">
                    DWM Approvals [ <span id="countApproval"><input type="hidden" id="cnt" value="<%=dwmAppr%>"> <%=dwmAppr %></span> ] </a>
                  </li>
                  <%-- <%
                  }
                  %>  --%>
                  <li class="">
                    <a data-toggle="tab" href="#Project_Approve">  
                   Projects Approvals [ <span id="prjcountApproval"><input type="hidden" id="prjcnt" value="<%=prjAppr%>"> <%=prjAppr %></span> ]
                    
                     </a>
                  </li> 
                </ul>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!-------------------------------------------------------------------------------- Tab Login Ends -------------------------------------------------------------------------------->
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
 
  
                 
              <div class="panel-body">
                <div class="tab-content">
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- DWM Entry Screen --------------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
          <%
  		if(request.getParameter("prjtab")!=null){
  		%>
  		<div id="DWM" class="tab-pane"> 
  		<%	
  		}else{
  		%>
  		  <div id="DWM" class="tab-pane active"> 
  		<%	
  		}
		%>    
             
              <form action="DWM_Register_Control" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal">
             	<%
             	 long millis=System.currentTimeMillis();  
                java.sql.Date date=new java.sql.Date(millis);   
             	%>
             	<input type="hidden" name="tran_date" id="tran_date" value="<%=date.toString()%>">
             	<input type="hidden" name="frm" id="frm" value="0">
             	<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;" colspan="4">DWM Task Description</th>  
				</tr>
				<tr>
					<td  align="left" style="color: black;">
					<input class="form-control" style="font-weight: bold;color: black;" id="dwm_title" onkeypress="return checkQuote();" name="dwm_title" size="15" maxlength="50" minlength="5" type="text" required />
					</td>
					<td  align="left" style="color: black;"  colspan="4">
					<textarea rows="1" cols="100" class="form-control" style="font-weight: bold;color: black;" id="dwm_task_desc" onkeypress="return checkQuote();" name="dwm_task_desc" type="text" required title="Single quotes and double quotes are not allowed"></textarea>
					<!-- <input class="form-control" style="font-weight: bold;color: black;" id="dwm_task_desc" onkeypress="return checkQuote();" name="dwm_task_desc" size="15" maxlength="50" minlength="5" type="text" required /> -->
					</td> 					
				</tr>
				
				<tr style="background-color: #dedede;color:">  
					<th align="center"  style="color: black;">Time (in Minutes)</th>
					<th align="center"  style="color: black;">Time (in Hours)</th> 
					<th align="center"  style="color: black;">Task Assigned By</th> 	
					<th align="center"  style="color: black;">Documents (If Any)</th>
					<th align="center"  style="color: black;">Add</th> 	
				</tr>
				<tr> <td  align="center" style="color: black;">
					<select name="time_required" id="time_required" class="form-control" onchange="time_convert(this.value)" style="font-weight: bold;color: black;width: 80px;font-size: 12px !important;" required>
                      	<option value="">0</option> 
                      	<%
                      	for(int i=1;i<=1440;i++){
                      	%>
                      	<option value="<%=i%>"><%=i%></option> 
                      	<%
                      	}
                      	%>
                      </select> 
					</td>
					<td  align="center" style="color: black;">
					<span id="inHr" style="font-weight: bold;color: black;font-size: 12px;">0.00</span>&nbsp;in Hours
					</td>
					<td  align="left" style="color: black;font-weight: bold;">
			<select class="form-control" name="taskAssigned_By" id="taskAssigned_By" style="font-weight: bold; color: black;font-size: 13px !important;" required>
                <option value=""> - - - - Select - - - - </option>
                <%
                 String comp_user="";
						ps_check1 = con_master.prepareStatement("select * from rel_userReportingManager where enable_id=1 and u_id=" + uid);
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
							ps_check = con.prepareStatement("SELECT * FROM user_tbl where Enable_id=1 and u_id="+rs_check1.getInt("approver_id"));
							rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
								ps_check2 = con.prepareStatement("SELECT * FROM user_tbl_company where Company_Id="+rs_check.getInt("Company_Id"));
								rs_check2 = ps_check2.executeQuery();
								while (rs_check2.next()) {
									comp_user = rs_check2.getString("Company_Name");
								}	
					%>
					<option value="<%=rs_check.getInt("U_Id")%>"><%=rs_check.getString("U_Name") %> &nbsp;&nbsp;- - &nbsp;&nbsp; <%=comp_user %></option> 
					<% 
					comp_user="";
							}
						} 
				    %>
	        </select> 
					</td>
					<td  align="left" style="color: black;"> 
					<input type="hidden" name="tot_file" id="tot_file" value="0">
					<span id="dwmAttach">
					 	<select name="noOfAttachdwm" id="noOfAttachdwm"  class="form-control" onchange="GetAttachDocDWM(this.value)" style="color: black;font-size:11px; width: 200px;">
						<option value="0">No of Attachments</option>
						<%
						for(int i=1;i<6;i++){
						%>
						<option value="<%=i%>"><%=i%></option>
						<%
						}
						%>
					</select>		
					</span> 
					</td>
					<td  align="left" style="color: black;">
					<input type="submit" value="Add" class="form-control" style="color: white;font-weight: bold;background-color: #69390f;">
					</td>
				</tr>					 
				</table>
				</form> 
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- DWM Entry Screen Ends ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
 
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- DWM List Screen --------------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  				<div  style="height: 500px;overflow: scroll;margin-top: 5px;">
				<table style="width: 100%;color: white;" class="gridtable">
				<tr style="background-color: #DACB74;color:"> 
             		<th colspan="12" align="left" style="color: black;"><b style="background-color: yellow;">Last 3 days Summary</b></th> 						
				</tr>
             	<tr style="background-color: #DACB74;color:"> 
             		<th align="center"  style="color: black;">T No</th>  
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;">DWM Task Description</th>  
					<th align="center"  style="color: black;">Time Required 
					<th align="center"  style="color: black;">Task Assigned By</th>
					<th align="center"  style="color: black;">Date</th>					
					<th align="center"  style="color: black;">Documents</th>
					<th align="center"  style="color: black;">Status</th> 
					<th align="center"  style="color: black;">Approval by</th>
					<th align="center"  style="color: black;">Approval Date</th>
					<th align="center"  style="color: black;">Approval Remark</th>
					<th align="center"  style="color: black;">Delete</th>						
				</tr>
				<% 
				String dwmAprBy="", dwmaprDate="",dwmApRemark="",appStatuscheck="";
				ps_user = con_master.prepareStatement("SELECT * from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and tran_date between DATEADD(DAY, -4, GETDATE()) and GETDATE() order by id desc");
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
				%>
				<tr style="color: black;">
					<td align="center"><%=rs_user.getInt("id")%></td>
					<td style="width: 15%"><%=rs_user.getString("task_title") %></td>
					<td style="width: 30%">
					<textarea disabled="disabled" style="width: 100%;background-color: white;color: black;"><%=rs_user.getString("task_description") %></textarea>
					</td>
					<td><%=rs_user.getString("time_elapsed") %>Min</td>
					<td>
					<%
					ps_check = con_master.prepareStatement("select u_id from rel_dwm_approvers where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" +rs_check.getInt("u_id"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<%=rs_check1.getString("U_Name") %>,
					<%		
						}
					}
					%>	
					</td>
					<td><%= mailDateFormat.format(rs_user.getTimestamp("tran_date")) %></td>
					<td style="width: 10%">
					<%
					ps_check = con_master.prepareStatement("select id,file_name from rel_dwm_tasks_Attach where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){ 
					%>
					<a href="WFH_DWMDocs_Display.jsp?field=<%=rs_check.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check.getString("file_name") %></strong></a> &nbsp; ,
				 	<%	 
					}
					%>
					</td>
					<td>
					<%
					if(rs_user.getInt("approved_by")>0){
					
						ps_check = con_master.prepareStatement("select approval_Type from approval_type where id=" +rs_user.getInt("approval_id"));
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
					%>
					<b style="color: black;"><%=rs_check.getString("approval_Type") %></b>
					<%		
						} 
						 ps_check = con.prepareStatement("SELECT U_Name FROM user_tbl where U_Id="+rs_user.getInt("approved_by"));
			             rs_check = ps_check.executeQuery();
			             while(rs_check.next()){
			                 dwmAprBy=rs_check.getString("U_Name");
			             }
			             dwmaprDate = mailDateFormat.format(rs_user.getTimestamp("approved_date"));
			             dwmApRemark = rs_user.getString("approval_remark");
					}else{
						appStatuscheck="Pending";
					%>
					<b style="color: black;background-color: yellow;">Pending</b>
					<%	
					}
					%>
					</td>
					<td align="center"  style="color: black;"><%=dwmAprBy %></td>
					<td align="center"  style="color: black;"><%=dwmaprDate %></td>
					<td align="center"  style="color: black;"><%=dwmApRemark %></td>
					<td>
					<%
					if(appStatuscheck=="Pending"){
					%>
					<span id="deleteDWM_task<%=rs_user.getInt("id")%>">
					<button onclick="delete_call(<%=rs_user.getInt("id")%>)" style="font-size:12px; background-color: red;font-weight: bold;color: white;">Delete</button>
					</span>
					<%
					}
					%>
					</td>
				</tr>
				<% 
				dwmAprBy=""; dwmaprDate="";dwmApRemark="";appStatuscheck="";
				}
				%>
				</table> 
				</div>
			  </div>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------------------------- DWM List Screen Ends --------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                

<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- Project Entry Screen ----------------------------------------------------------------------->                
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
        <%
  		if(request.getParameter("prjtab")!=null){
  		%>
  	  		<div id="My_Project" class="tab-pane active">
  	  	<%	
  		}else{
  		%>
  			<div id="My_Project" class="tab-pane">
  		<%	
  		}
		%> 
                  <form action="WFHProject_Register_Control" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal" onsubmit="return validateFormProj()">
             		<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;">Project Title</th> 
					<th align="center"  style="color: black;" >Project Description</th>    
					<th align="center"  style="color: black;" >Select Participants</th>
				</tr>	
				<tr>
					<td  align="left" style="color: black;">
					<input class="form-control" style="font-weight: bold;color: black;" id="prj_title" onkeypress="return checkQuote();" name="prj_title" size="15" maxlength="50" minlength="5" type="text" required />
					</td> 
					<td>
					<textarea rows="4" class="form-control" style="font-weight: bold;color: black;" id="prj_desc" onkeypress="return checkQuote();" name="prj_desc" required></textarea>
					<!-- <input class="form-control" style="font-weight: bold;color: black;" onkeypress="return checkQuote();" id="remark_project" name="remark_project"  size="15" minlength="5" type="text"/> -->
					</td>
					<td >
				<select class="form-control" name="participant" id="participant" style="font-weight: bold; color: black;font-size: 13px !important;" required>
                <option value=""> - - - - Add New Participants - - - - </option>
                <% 
               	comp_user="";
						ps_check1 = con_master.prepareStatement("select * from rel_userReportingManager where enable_id=1 and u_id=" + uid);
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
							ps_check = con.prepareStatement("SELECT * FROM user_tbl where Enable_id=1 and u_id="+rs_check1.getInt("approver_id"));
							rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
								ps_check2 = con.prepareStatement("SELECT * FROM user_tbl_company where Company_Id="+rs_check.getInt("Company_Id"));
								rs_check2 = ps_check2.executeQuery();
								while (rs_check2.next()) {
									comp_user = rs_check2.getString("Company_Name");
								}	
					%>
					<option value="<%=rs_check.getInt("U_Id")%>"><%=rs_check.getString("U_Name") %> &nbsp;&nbsp;- - &nbsp;&nbsp; <%=comp_user %></option> 
					<% 
					comp_user="";
							}
						} 
                
				ps_check = con.prepareStatement("SELECT * FROM user_tbl inner join sap_users on user_tbl.sap_id=sap_users.emp_code where user_tbl.enable_id=1 and user_tbl.dept_id="+dept_idCheck+" and user_tbl.u_id!="+uid);
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("emp_code")%> - <%=rs_check.getString("Name_Of_Emp").replaceAll("Mr.", "") %></option>  
                <%
                }
                ps_check = con.prepareStatement("SELECT * FROM user_tbl inner join sap_users on user_tbl.sap_id=sap_users.emp_code where user_tbl.enable_id=1 and user_tbl.dept_id!="+dept_idCheck+" and user_tbl.u_id!="+uid);
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("emp_code")%> - <%=rs_check.getString("Name_Of_Emp").replaceAll("Mr.", "") %></option>  
                <%
                }
                ps_check = con.prepareStatement("SELECT u_id,U_Name FROM user_tbl where enable_id=1 and company_id=6");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>">Management - <%=rs_check.getString("U_Name")%></option>  
                <%
                }
                %>
                 
	        </select> <input type="button" class="form-control"  onclick="addUsers_call()" value="Click to Select" style="font-weight: bold;background-color: #b5ffa9;color: black;height: 30px;">
	         	<span id="addMe">
					<input type="hidden" name="tot_part" id="tot_part" value="0" required> 
					<textarea rows="1" id="part_group" class="form-control" style="color: black;" readonly="readonly">&#13;&#10;</textarea>
					</span>
				</td>
				</tr>
					
				<tr style="background-color: #dedede;color:">	  
					<th align="center"  style="color: black;">Remark / Suggesions</th>
					<th align="center"  style="color: black;">Documents (If any)</th>
					<th align="center"  style="color: black;">Add</th>  
				</tr> 
				<tr> 
				<td  align="left" style="color: black;" >
					<textarea rows="1" class="form-control" style="font-weight: bold;color: black;" onkeypress="return checkQuote();" id="remark_project" name="remark_project"></textarea>
					<!-- <input class="form-control" style="font-weight: bold;color: black;" id="prj_desc" onkeypress="return checkQuote();" name="prj_desc" size="15" maxlength="50" minlength="5" type="text" required /> -->
					</td>
					 			
					<td  align="left" style="color: black;" > 
						<input type="hidden" name="tot_prjfile" id="tot_prjfile" value="0">
					<span id="projAttach"> 
						<select name="noOfAttachproj" id="noOfAttachproj"  class="form-control" onchange="GetAttachDocProj(this.value)" style="font-size:11px; color: black;">
						<option value="0"> - - - - - Select No of Attachments  - - - - - </option>
						<%
						for(int i=1;i<6;i++){
						%>
						<option value="<%=i%>"><%=i%></option>
						<%
						}
						%>
					</select>		
					</span>			 
					</td> 
					
					<td  align="left" style="color: black;" >
					<input type="submit" value="Click To Add New Project" class="form-control" id="saveProject" style="color: white;font-weight: bold;background-color: #69390f;width: 200px;">
					</td>
				</tr>
				<tr> 
				
				 
				</tr>		 
				</table> 
				</form>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- Project Entry Screen Ends ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
				
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- Project List Screen ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
				<div  style="height: 550px;overflow: scroll;margin-top: 5px;">
				<table style="width: 100%;color: white;" class="gridtable"> 
				<tr style="background-color: #DACB74;">
             		<th align="center"  style="color: black;">P.No</th> 
					<th align="center"  style="color: black;">Project Title</th> 
					<th align="center"  style="color: black;">Project Description</th>    
					<th align="center"  style="color: black;">Remark / Suggesions</th> 	
					<th align="center"  style="color: black;">Other Participants</th>
					<th align="center"  style="color: black;">Assigned By</th>
					<th align="center"  style="color: black;">Registered Date</th>
					<th align="center"  style="color: black;">Documents (If Any)</th>
					<th align="center"  style="color: black;">Open Project</th> 	
				</tr>
				<%
				 ps_check = con_master.prepareStatement("select * from rel_wfh_project_assignUsers inner join tran_wfh_project on tran_wfh_project.id=rel_wfh_project_assignUsers.project_id where rel_wfh_project_assignUsers.u_id="+uid+" and tran_wfh_project.enable_id=1 and rel_wfh_project_assignUsers.enable_id=1 order by rel_wfh_project_assignUsers.id desc");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
				%>
				<tr style="background-color: #DACB74;">
             		<td style="color: black;" align="center"><%=rs_check.getInt("project_id") %></td> 
					<td style="color: black;"><%=rs_check.getString("project_title") %></td> 
					<td style="color: black;"><%=rs_check.getString("project_description") %></td>   
					<td style="color: black;"><%=rs_check.getString("remark") %></td>  	
					<td style="color: black;">
					<%
					ps_user = con_master.prepareStatement("SELECT u_id,registered_by FROM rel_wfh_project_assignUsers where project_id="+rs_check.getInt("project_id")+" and enable_id=1 and registered_by="+uid);
					rs_user = ps_user.executeQuery();
					while(rs_user.next()){
						ps_check1 = con.prepareStatement("select U_Name from user_tbl where Enable_id=1 and U_Id=" +rs_user.getInt("u_id") +" and U_Id!="+rs_user.getInt("registered_by"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<%=rs_check1.getString("U_Name") %> , 
					<%		
						}
					}
					%>
					</td>
					<td style="color: black;">
					<%
					ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" +rs_check.getInt("registered_by"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<%=rs_check1.getString("U_Name") %> , 
					<%		
					}
					%>
					</td>
					<td style="color: black;"><%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td>
					<td style="color: black;">
					<%
					ps_check1 = con_master.prepareStatement("select id,file_name from rel_wfh_project_Attach where project_id=" +rs_check.getInt("project_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<a href="WFH_PrjDocs_Display.jsp?field=<%=rs_check1.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check1.getString("file_name") %></strong></a> &nbsp; ,
				 	<%
					}
					%> 
					</td>
					<td style="color: black;"align="center"> 
					<a href="WFH_ProjectTask.jsp?prjID=<%=rs_check.getInt("project_id")%>&none=1">Click to Open</a>  
					</td>
				</tr>
				<%
                }
				%>
				</table>
				</div>
				</div>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------------------- Project List Screen End --------------------------------------------------------------------->                
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  
  			
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
<!----------------------------------------------------------------------------- DWM Approval ------------------------------------------------------------------------------------>                
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
                  <%
                /*   if(dwmAppr>0){ */
                	  String ap_stat ="Pending";
                  %>
                  <div id="DWM_Approve" class="tab-pane">
                  <div style="overflow:scroll;">
                  <input type="hidden" id="uid" value="<%=uid%>">
		<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;color:"> 
             		<th align="center"  style="color: black;">T No</th>  
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;">DWM Task Description</th>  
					<th align="center"  style="color: black;">Time Required </th>
					<th align="center"  style="color: black;">Requestor</th>
					<th align="center"  style="color: black;">Performed Date</th>
					<th align="center"  style="color: black;">Documents (If Any)</th> 
					<th align="center"  style="color: black;">Approval Remark</th> 
					<th align="center"  style="color: black;">Accept / Reject</th> 
				</tr>
				<%  
				String query="SELECT tran_dwm_tasks.id as id,tran_dwm_tasks.task_title as task_title, tran_dwm_tasks.task_description as task_description,tran_dwm_tasks.time_elapsed as time_elapsed, tran_dwm_tasks.u_id as u_id,tran_dwm_tasks.tran_date as tran_date,tran_dwm_tasks.approval_id as approval_id, tran_dwm_tasks.approval_remark as approval_remark,tran_dwm_tasks.approved_by as approved_by,tran_dwm_tasks.approved_date as approved_date  FROM tran_dwm_tasks inner join rel_dwm_approvers on tran_dwm_tasks.id=rel_dwm_approvers.dwm_id where rel_dwm_approvers.u_id="+uid+" and tran_dwm_tasks.approval_id is null and tran_dwm_tasks.enable_id=1 and rel_dwm_approvers.enable_id=1 and tran_date between DATEADD(DAY, -4, GETDATE()) and GETDATE() order by tran_dwm_tasks.tran_date desc";
				if(dept_idCheck==26){
					String u_idHrList="";
					ps_check1 = con.prepareStatement("select U_Id from user_tbl where Enable_id=1 and Company_Id="+comp_id);
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
						u_idHrList = u_idHrList + "," + String.valueOf(rs_check1.getInt("U_Id"));
					}
					u_idHrList= u_idHrList.substring(1);
					
					// query="SELECT tran_dwm_tasks.id as id,tran_dwm_tasks.task_title as task_title, tran_dwm_tasks.task_description as task_description,tran_dwm_tasks.time_elapsed as time_elapsed, tran_dwm_tasks.u_id as u_id,tran_dwm_tasks.tran_date as tran_date,tran_dwm_tasks.approval_id as approval_id, tran_dwm_tasks.approval_remark as approval_remark,tran_dwm_tasks.approved_by as approved_by,tran_dwm_tasks.approved_date as approved_date  FROM tran_dwm_tasks inner join rel_dwm_approvers on tran_dwm_tasks.id=rel_dwm_approvers.dwm_id where tran_dwm_tasks.u_id in ("+u_idHrList+") and tran_dwm_tasks.approval_id is null and tran_dwm_tasks.enable_id=1 and rel_dwm_approvers.enable_id=1 and tran_date between DATEADD(DAY, -4, GETDATE()) and GETDATE() order by tran_dwm_tasks.tran_date desc";
					 query="SELECT tran_dwm_tasks.id as id,tran_dwm_tasks.task_title as task_title, tran_dwm_tasks.task_description as task_description,tran_dwm_tasks.time_elapsed as time_elapsed, tran_dwm_tasks.u_id as u_id,tran_dwm_tasks.tran_date as tran_date,tran_dwm_tasks.approval_id as approval_id, tran_dwm_tasks.approval_remark as approval_remark,tran_dwm_tasks.approved_by as approved_by,tran_dwm_tasks.approved_date as approved_date  FROM tran_dwm_tasks inner join rel_dwm_approvers on tran_dwm_tasks.id=rel_dwm_approvers.dwm_id where tran_dwm_tasks.u_id in ("+u_idHrList+") and tran_dwm_tasks.approval_id is null and tran_dwm_tasks.enable_id=1 and rel_dwm_approvers.enable_id=1 order by tran_dwm_tasks.tran_date desc";
				}
				ps_user = con_master.prepareStatement(query);
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
				%>
				<tr style="color: black;">
					<td align="center"><%=rs_user.getInt("id")%></td>
					<td><%=rs_user.getString("task_title") %></td>
					<td><%=rs_user.getString("task_description") %></td>
					<td><%=rs_user.getString("time_elapsed") %>Min (<%= df3.format(Double.valueOf(rs_user.getString("time_elapsed"))/60) %> Hr)</td>
					<td>
					<% 
						ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" +rs_user.getInt("u_id"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<%=rs_check1.getString("U_Name") %>,
					<%		
						}
						rs_check1.close();
					%>	
					</td>
					<td><%= mailDateFormat.format(rs_user.getTimestamp("tran_date")) %></td>
					<td style="width: 20%">
					<%
					ps_check = con_master.prepareStatement("select id,file_name from rel_dwm_tasks_Attach where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){ 
					%>
			<a href="WFH_DWMDocs_Display.jsp?field=<%=rs_check.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check.getString("file_name") %></strong></a> &nbsp; ,
				 	<%	 
					}
					%>
					</td>
					 
					<% 
						ps_check = con_master.prepareStatement("select approval_Type from approval_type where id=" +rs_user.getInt("approval_id"));
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							ap_stat=rs_check.getString("approval_Type");
						}
					%>   
					<td>
					<span id="remark_ajax<%=rs_user.getInt("id") %>">
					<%
					if(rs_user.getString("approval_remark") !=null){
					%><%=rs_user.getString("approval_remark") %>					
					<%
					}else{
					%>
					<input type="text"  class="form-control" style="color: black;" name="appr_remark" id="appr_remark<%=rs_user.getInt("id") %>" value="" onkeypress="return checkQuote();"> 
					<%
					}
					%> 
					</span></td> 
					<td align="left">
					<span id="approval_btn<%=rs_user.getInt("id") %>">
					<%
					if(ap_stat=="Pending"){
					%>
					<button onclick="decision_call('3',<%=rs_user.getInt("id") %>)" style="font-size:12px; background-color: green;font-weight: bold;color: white;">Accept</button>
					<button onclick="decision_call('2',<%=rs_user.getInt("id") %>)" style="font-size:12px; background-color: red;font-weight: bold;color: white;">Reject</button>
					
					
				<%-- 	<a href="javascript:decision_call('3',<%=rs_user.getInt("id") %>);" style="font-size:12px; background-color: green;font-weight: bold;color: white;">Accept</a>
					<a href="javascript:decision_call('2',<%=rs_user.getInt("id") %>);" style="font-size:12px; background-color: red;font-weight: bold;color: white;">Reject</a>
				 --%>	<%
					}else{
					%>
					<%=ap_stat %>
					<%	
					}
					%>					
					</span>
					</td>
				
				</tr> 
				<% 
				ap_stat="Pending"; 
				}
				%>
				</table>  
				</div>
				</div>
                 <%--  <%
                  }
                  %> --%>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------ DWM Approval Ends ----------------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  
  
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                   
                  
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!--------------------------------------------------------------------------------------------- Project Approvals ----------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
      <div id="Project_Approve" class="tab-pane">
      <div style="overflow:scroll; height: 550px;">
                <input type="hidden" id="uid" value="<%=uid%>">
				<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;color:"> 
             		<th align="center"  style="color: black;">P No</th>  
					<th align="center"  style="color: black;">Project Title</th> 
					<th align="center"  style="color: black;">Project Description</th>  
					<th align="center"  style="color: black;">Requestor</th>
					<th align="center"  style="color: black;">T No</th>
					<th align="center"  style="color: black;">Task Performed</th>
					<th align="center"  style="color: black;">Task Description</th>
					<th align="center"  style="color: black;">Time Required </th>
					<th align="center"  style="color: black;">Status </th>
					<th align="center"  style="color: black;">Registered Date</th>
					<th align="center"  style="color: black;">Documents (If Any)</th> 
					<th align="center"  style="color: black;">Approval Remark</th> 
					<th align="center"  style="color: black;">Accept / Reject</th> 
				</tr>
			<%
			ap_stat="Pending";
			
			query="SELECT tran_wfh_project_task.id as taskId,tran_wfh_project.id as id, tran_wfh_project.project_title as project_title, tran_wfh_project.project_description as project_description, tran_wfh_project_task.u_id as requestor, tran_wfh_project_task.task_performed as task_performed, tran_wfh_project_task.remark as taskdescr, tran_wfh_project_task.time_spent_mins as timereqd, tran_wfh_project_task.status_id as status_id, tran_wfh_project_task.sys_date as sys_date, tran_wfh_project_task.approval_remark as approval_remark, tran_wfh_project_task.approval_id as approval_id FROM rel_project_approvers inner join tran_wfh_project_task on rel_project_approvers.project_id=tran_wfh_project_task.project_id inner join tran_wfh_project on rel_project_approvers.project_id=tran_wfh_project.id where rel_project_approvers.enable_id=1 and tran_wfh_project_task.enable_id=1 and rel_project_approvers.u_id="+uid + "  order by tran_wfh_project_task.approval_id";
			if(dept_idCheck==26){
				query="SELECT tran_wfh_project_task.id as taskId,tran_wfh_project.id as id, tran_wfh_project.project_title as project_title, tran_wfh_project.project_description as project_description, tran_wfh_project_task.u_id as requestor, tran_wfh_project_task.task_performed as task_performed, tran_wfh_project_task.remark as taskdescr, tran_wfh_project_task.time_spent_mins as timereqd, tran_wfh_project_task.status_id as status_id, tran_wfh_project_task.sys_date as sys_date, tran_wfh_project_task.approval_remark as approval_remark, tran_wfh_project_task.approval_id as approval_id FROM rel_project_approvers inner join tran_wfh_project_task on rel_project_approvers.project_id=tran_wfh_project_task.project_id inner join tran_wfh_project on rel_project_approvers.project_id=tran_wfh_project.id where rel_project_approvers.enable_id=1 and tran_wfh_project_task.u_id!="+uid + " and  tran_wfh_project_task.enable_id=1  order by tran_wfh_project_task.approval_id";
			}
			
			ps_check = con_master.prepareStatement(query);
			rs_check = ps_check.executeQuery();
			while(rs_check.next()){ 
			%>	
			<tr style="background-color: #DACB74;color:"> 
             		<td style="color: black;" align="center"><%=rs_check.getInt("id") %></td>  
					<td style="color: black;"><%=rs_check.getString("project_title") %></td> 
					<td style="color: black;"><%=rs_check.getString("project_description") %></td>   
					<td style="color: black;">
					<% 
						ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" +rs_check.getInt("requestor"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){
					%>
					<%=rs_check1.getString("U_Name") %>,
					<%		
						} 
					%>  
					</td>
					<td style="color: black;" align="center"><%=rs_check.getInt("taskId") %></td> 
					<td style="color: black;"><%=rs_check.getString("task_performed") %></td>
					<td style="color: black;"><%=rs_check.getString("taskdescr") %></td>
					<td style="color: black;" align="right"><%=rs_check.getString("timereqd") %> Mins</td>
					<td style="color: black;">
					<%
					ps_check1 = con.prepareStatement("select Status from status_tbl where Status_Id=" +rs_check.getInt("status_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<%=rs_check1.getString("Status") %> 
					<%		
					} 
					%>
					</td>
					<td style="color: black;"><%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td>
					<td style="color: black;">
					<%
					ps_check1 = con_master.prepareStatement("select id,file_name from rel_wfh_project_Attach where project_id=" +rs_check.getInt("id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<a href="WFH_PrjDocs_Display.jsp?field=<%=rs_check1.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check1.getString("file_name") %></strong></a> &nbsp; ,
				 	<%
					}
					%> 
					</td>
					<td style="color: black;"> 
					<span id="remark_Prjajax<%=rs_check.getInt("taskId") %>">
					<%
					if(rs_check.getString("approval_remark") !=null){
					%><%=rs_check.getString("approval_remark") %>					
					<%
					}else{
					%>
					<input type="text" style="color: black;" class="form-control" name="prjappr_remark" id="prjappr_remark<%=rs_check.getInt("taskId") %>" value="" onkeypress="return checkQuote();"> 
					<%
					}
					%> 
					</span>
					</td> 
					<td style="color: black;">
					<span id="approval_Prjbtn<%=rs_check.getInt("taskId") %>">
					<%  
					ps_user = con_master.prepareStatement("select approval_Type from approval_type where id=" +rs_check.getInt("approval_id"));
					rs_user = ps_user.executeQuery();
					while(rs_user.next()){
						ap_stat=rs_user.getString("approval_Type");
					} 
					if(ap_stat=="Pending"){
					%>
					<button onclick="decision_callPrj('3',<%=rs_check.getInt("taskId") %>)" style="font-size:12px; background-color: green;font-weight: bold;color: white;">Accept</button>
					<button onclick="decision_callPrj('2',<%=rs_check.getInt("taskId") %>)" style="font-size:12px; background-color: red;font-weight: bold;color: white;">Reject</button>
					
					<%-- <a href="javascript:decision_callPrj('3',<%=rs_check.getInt("taskId") %>);" style="font-size:12px; background-color: green;font-weight: bold;color: white;">Accept</a>
					<a href="javascript:decision_callPrj('2',<%=rs_check.getInt("taskId") %>);" style="font-size:12px; background-color: red;font-weight: bold;color: white;">Reject</a> --%>
					<%
					}else{
					%>
					<%=ap_stat %>
					<%	
					}
					%>					
					</span>
					</td> 
				</tr>
			<%
			}
			%>	
		</table>
		</div>                  
      </div>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------- Project Approvals Ends ------------------------------------------------------------------------------>                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
                    
                </div>
              </div> 
            
<%--              <%
			}else{
             %>
<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- User Profile Screen ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
            <form action="WFH_UserControl" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal" onsubmit="return validateForm()">
          <table style="width: 100%;color: white;" class="gridtable">
				<tr> 
					<th  align="right"><b style="color: black;">Please Verify Your Personal Information and update if wrong/missing</b></th> 
				</tr>
			</table> 
           <%
           ps_user = con.prepareStatement("select * from  user_tbl where U_Id="+uid);
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){ 
           %>
             <table style="width: 60%;color: white;" class="gridtable">
             	<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;">Profile Image : </th>
					<td  align="left" style="color: black;">
					<%
					if(rs_user.getString("user_photoName")==null){
					%>
					<input type="file" class="form-control" style="color: black;" name="photo" id="photo"  accept="image/png, image/jpeg" required>
					<%
					}else{
					%>
					<img src="View_photo.jsp?field=<%=uid%>" height="80" width="80"/><br/>
					<%	
					}
					%>
					</td> 
				</tr>
				<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;">User Name : </th>
					<td  align="left"><b style="color: black;"><%=rs_user.getString("U_Name") %></b></td> 
				</tr>
				<tr style="background-color: #dedede;color:">
					<th align="center"  style="color: black;">SAP Code : </th>
					<td  align="left" style="color: black;"> 
				<select class="form-control" name="sapCode" id="sapCode" onchange="getDetails(this.value)" style="font-weight: bold;color: black;" required>
                <option value=""> - - - - Select - - - - </option>
                <%  
                ps_check = con.prepareStatement("SELECT * from sap_users where enable=1");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("Emp_Code")%>"><%=rs_check.getString("Emp_Code")%> - <%=rs_check.getString("Name_Of_Emp")%></option>  
                <%
                }
                %>
	        </select> 
					</td> 
				</tr>
				<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;">Company : </th>
					<td  align="left" style="color: black;"> 
					<span id="myDetails"></span>
					</td> 
				</tr>
				<tr style="background-color: #dedede;color:">
					<th align="center"  style="color: black;">Email ID(Company) : </th>
					<td  align="left" style="color: black;">  
					<input style="color: black;" type="text" id="email" name="email" class="form-control" value="<%=rs_user.getString("U_Email") %>" required>
					</td> 
				</tr>
				<tr style="background-color: #dedede;color:">
					<th align="center"  style="color: black;">Contact No : </th>
					<td  align="left" style="color: black;">  
					<input style="color: black;" type="text" id="contact" name="contact" class="form-control"  value="<%=rs_user.getString("phone_no") %>" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" minlength="10" maxlength="10" required>
					</td> 
				</tr>
				<tr style="background-color: #dedede;color:"> 
					<td align="center" style="color: black;" colspan="2">
					<input type="submit" id="Save" name="Save" style="background-color: #99cfff;width: 200px;color: black;font-weight: bold;" value="Save Information" class="form-control">
					</td>
				</tr>
			</table> 
			<%
			}
			%>
			
            </form> 
            <%
			}
           --%>
              
		</div>
	<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- User Profile Screen Ends ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
 	</div>
	<%
	con.close();
	con_master.close();
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
</div>
</div>
</body>
</html>