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
font-size: 10px;
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
 function time_convert(min)
 {    
 	var hours = min / 60;   
 	document.getElementById("inHr").innerText = hours.toFixed(2);
 }
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
	function checkQuote() {
		
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
	}
 </script>
</head>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: white;">
	<%
		try {
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			int prjID=Integer.valueOf(request.getParameter("prjID"));
			boolean flag = false, userInfoFlag=false;
			int dwmAppr=0,prjAppr=0;
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
			
		//	System.out.println("Dept = " + dept_idCheck + " = " + uid);
			
			PreparedStatement ps_user=null,ps_check=null,ps_check1=null;
			ResultSet rs_user=null,rs_check=null,rs_check1=null;
			 
			
			ps_user = con_master.prepareStatement("select COUNT(id) as count from rel_dwm_approvers where u_id='"+uid+"' and dwm_id in (SELECT  id  FROM  tran_dwm_tasks where enable_id=1 and approval_id is null)");
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				dwmAppr=rs_user.getInt("count");
			}
			
	%>
	<!-- ********************************************************************************************************************* -->
	<div class="panel panel-primary" style="background-color: white;">
				<table style="width: 50%;">
					<tr>
						<th><a href="WFH_Transaction.jsp?none=1&prjtab=ok"><b style="font-size: 15px;color: blue;">Go back to Project List</b></a></th>
					</tr>
			</table>
		<div class="panel">  
		<%
		Double tot_hoursAp=0.0,tot_hoursrej=0.0,todays_tot =0.0,pend_hours=0.0;		 
		Double tot_PrjhoursAp=0.0,tot_Prjhoursrej=0.0,todays_Prjtot =0.0,pend_Prjhours=0.0;		 
		
		ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			todays_tot=rs_user.getDouble("totHr");
		}
		ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			todays_Prjtot=rs_user.getDouble("totHr");
		} 
		ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=3 and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			tot_hoursAp=rs_user.getDouble("totHr");
		}
		ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=3 and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			tot_PrjhoursAp=rs_user.getDouble("totHr");
		} 
		ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id=2 and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			tot_hoursrej=rs_user.getDouble("totHr");
		}
		
		ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id=2 and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			tot_Prjhoursrej=rs_user.getDouble("totHr");
		} 
		ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where u_id="+uid+" and approval_id is null and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			pend_hours=rs_user.getDouble("totHr");
		} 
		ps_user = con_master.prepareStatement("select SUM(CAST(time_spent_mins as decimal)) as totHr from tran_wfh_project_task where u_id="+uid+" and approval_id is null and enable_id=1 and cast(sys_date as Date) = cast(getdate() as Date)");
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			pend_hours=rs_user.getDouble("totHr");
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
			<table style="width: 100%;border-width: 1px;height:25px;border-style: solid;border-color: #666666;text-align: center;">
				<tr>  
					<th align="center"  style="color: black;font-size: 20px;">Todays Hours : <b style="color: blue;font-size: 20px;"><%=df3.format(todays_tot/60)  %>  </b></th>
					<th align="center"  style="color: black;font-size: 20px;">Todays Approved Hours : <b style="color: green;font-size: 20px;"><%=df3.format(tot_hoursAp/60)  %>  </b></th>
					<th align="center"  style="color: black;font-size: 20px;">Todays Pending Hours : <b style="color: red; font-size: 20px;"><%=df3.format(pend_hours/60)  %> [ <%= df2.format(pend_hours)%> Min ]  </b></th>
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
 <!---------------------------------------------------------------------------------- Project List Screen ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
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
					<th align="center"  style="color: black;">Update</th> 	
				</tr>
				<%
				boolean flagEdit=false;
				ps_user = con_master.prepareStatement("select * from tran_wfh_project where id="+prjID+" and registered_by="+uid);
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
					flagEdit=true;
				}
				
				 ps_check = con_master.prepareStatement("select * from rel_wfh_project_assignUsers inner join tran_wfh_project on tran_wfh_project.id=rel_wfh_project_assignUsers.project_id where rel_wfh_project_assignUsers.u_id="+uid+" and tran_wfh_project.enable_id=1 and rel_wfh_project_assignUsers.enable_id=1 and rel_wfh_project_assignUsers.project_id="+prjID);
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                	// System.out.println("tran_wfh_project.registered_by = " + rs_check.getString("registered_by"));
				%>
				<tr style="background-color: #DACB74;">
             		<td style="color: black;font-size: 12px;" align="right"><%=rs_check.getInt("project_id") %></td> 
					<td style="color: black;font-size: 12px;"><%=rs_check.getString("project_title") %></td> 
					<td style="color: black;font-size: 12px;"><%=rs_check.getString("project_description") %></td>   
					<td style="color: black;font-size: 12px;"><%=rs_check.getString("remark") %></td>  	
					<td style="color: black;font-size: 12px;">
					<%
					ps_user = con_master.prepareStatement("SELECT * FROM rel_wfh_project_assignUsers where project_id="+rs_check.getInt("project_id")+" and enable_id=1 and registered_by="+uid);
					rs_user = ps_user.executeQuery();
					while(rs_user.next()){
						ps_check1 = con.prepareStatement("select * from user_tbl where Enable_id=1 and U_Id=" +rs_user.getInt("u_id") +" and U_Id!="+rs_user.getInt("registered_by"));
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
					ps_check1 = con.prepareStatement("select * from user_tbl where U_Id=" +rs_check.getInt("registered_by"));
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
					ps_check1 = con_master.prepareStatement("select * from rel_wfh_project_Attach where project_id=" +rs_check.getInt("project_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<a href="WFH_PrjDocs_Display.jsp?field=<%=rs_check1.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check1.getString("file_name") %></strong></a> &nbsp; ,
				 	<%
					}
					%> 
					</td>
					<td style="color: black;" align="center">
					<%
					if(flagEdit==true){
					%>
					<a href="#"><strong style="color: blue;font-weight: bold;">Close/Update</strong></a>
					<%	
					}else{
					ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id=" +rs_check.getInt("status_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<%=rs_check1.getString("Status") %>
					<%		
					}
					}
					%>
					</td>
				</tr>
				<%
                }
				%>
				</table>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------------------- Project List Screen End --------------------------------------------------------------------->                
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
    		
  		
  		
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------- Add New Project Task --------------------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  	 		 
  		 <form action="PRJ_Task_Register_Control" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal">
             	<input type="hidden" name="prj_Id" id="prj_Id" value="<%=prjID%>">
             	<table style="width: 100%;color: white;margin-top: 5px;" class="gridtable">
             	<tr style="background-color: #dedede;color:"> 
					<th align="center"  style="color: black;">Task Performed</th> 
					<th align="center"  style="color: black;">Task Description</th>  
					<th align="center"  style="color: black;">Time (in Minutes)</th>
					<th align="center"  style="color: black;">Time (in Hours)</th> 
					<th align="center"  style="color: black;">Status</th> 	
					<th align="center"  style="color: black;">Documents (If Any)</th>
					<th align="center"  style="color: black;">Add</th> 	
				</tr>
				<tr>
					<td  align="left" style="color: black;">
					<input class="form-control" style="font-weight: bold;color: black;" id="prj_task_title" onkeypress="return checkQuote();" name="prj_task_title" size="15" maxlength="50" minlength="5" type="text" required />
					</td>
					<td  align="left" style="color: black;">
					<textarea rows="1" cols="50" class="form-control" style="font-weight: bold;color: black;" id="prj_task_task_desc" onkeypress="return checkQuote();" name="prj_task_task_desc" required></textarea>
					<!-- <input class="form-control" style="font-weight: bold;color: black;" id="prj_task_task_desc" onkeypress="return checkQuote();" name="prj_task_task_desc" size="15" maxlength="50" minlength="5" type="text" required /> -->
					</td> 
					<td  align="center" style="color: black;">
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
					<select name="status" id="status" class="form-control"  style="font-weight: bold;color: black;width: 80px;font-size: 12px !important;" required>
                   <%
					ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id in (2,5)");
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%> 
					<option value="<%=rs_check1.getInt("Status_Id")%>"><%=rs_check1.getString("Status") %></option> 
					<%		
					}
					%>
					</select>
					</td>
					<td  align="left" style="color: black;"> 
					<input type="hidden" name="tot_prjfile" id="tot_prjfile" value="0">
					<span id="projAttach"> 
						<select name="noOfAttachproj" id="noOfAttachproj"  class="form-control" onchange="GetAttachDocProj(this.value)" style="font-size:11px; color: black;width: 200px;">
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
 <!----------------------------------------------------------------------- Add New Project Task End ------------------------------------------------------------------------------>                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
   <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------- Project Task List Details  ------------------------------------------------------------------------------>                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  		 	 
  		 <table style="width: 100%;color: white;margin-top: 5px;" class="gridtable">
             	<tr style="background-color: #5f9c94;font-weight: bold;">
             		<th align="center"  style="color: white;">T. No</th> 
					<th align="center"  style="color: white;">Task Performed</th> 
					<th align="center"  style="color: white;">Task Description</th>  
					<th align="center"  style="color: white;">Time Required </th> 
					<th align="center"  style="color: white;">Status</th> 
					<th align="center"  style="color: white;">Done By</th>
					<th align="center"  style="color: white;">Date</th>
					<th align="center"  style="color: white;">Documents (If Any)</th> 
					<th align="center"  style="color: white;">Approval by</th>
					<th align="center"  style="color: white;">Approval Date</th>
					<th align="center"  style="color: white;">Approval Remark</th>
					<th align="center"  style="color: white;">Approval status</th>
				</tr>
				<%
				boolean flagApp=false;
				String app_rem="", app_by="", app_date="",appStatus="Pending";
				ps_check = con_master.prepareStatement("SELECT * FROM tran_wfh_project_task where project_id="+prjID + "  order by u_id");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) { 
				%>
				<tr style="background-color: #DACB74;">
             		<td style="color: black;" align="center"><%=rs_check.getInt("id") %></td> 
					<td style="color: black;"><%=rs_check.getString("task_performed") %></td> 
					<td style="color: black;"><%=rs_check.getString("remark") %></td>   
					<td style="color: black;"><%=rs_check.getString("time_spent_mins") %> mins</td>  	
					<td style="color: black;">
					<%
					ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id ="+rs_check.getInt("status_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%> 
					 <%=rs_check1.getString("Status") %>  
					<%		
					}
					%>
					</td>
					<td style="color: black;">
					<%
					ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id ="+rs_check.getInt("registered_by"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					 <%=rs_check1.getString("U_Name") %>  
					<%		
					}
					%>
					</td> 
					<td style="color: black;"><%= mailDateFormat.format(rs_check.getTimestamp("sys_date")) %></td> 
					<td style="color: black;">
					<%
					ps_check1 = con_master.prepareStatement("select * from rel_wfh_project_task_attach where project_id=" +rs_check.getInt("project_id") + " and projectTask_id="+rs_check.getInt("id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<a href="WFH_Prj_TaskDocs_Display.jsp?field=<%=rs_check1.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check1.getString("file_name") %></strong></a> &nbsp; ,
				 	<%
					}
					%> 
					</td>   
					<%
					ps_check1 = con_master.prepareStatement("select * from approval_type where id ="+rs_check.getInt("approval_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
						flagApp = true;
						appStatus = rs_check1.getString("approval_Type");
					} 
					if(flagApp==true){
						app_date =  mailDateFormat.format(rs_check.getTimestamp("sys_date"));
						app_rem = rs_check.getString("approval_remark"); 
						
						ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id ="+rs_check.getInt("approved_by"));
						rs_check1 = ps_check1.executeQuery();
						while(rs_check1.next()){  
							app_by = rs_check1.getString("U_Name"); 
						} 
					}
					%> 
					<td style="color: black;"><%=app_by %></td>
					<td style="color: black;"><%=app_date %></td>
					<td style="color: black;"><%=app_rem %></td>
					<td style="color: black;"><%=appStatus %></td>
				</tr>
				<%
				app_rem=""; app_by=""; app_date="";appStatus="Pending";
				}
				%>		
  		 </table>
  		 
  	 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!----------------------------------------------------------------------- Project Task List Details End  ------------------------------------------------------------------------------>                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
  		 	 
  	 
  		 
  		 
  		 
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