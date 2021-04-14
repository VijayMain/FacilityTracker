<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.Calendar"%>
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
<title>WFH Day Details</title>
<style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif;
	
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 11px;
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
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
<script type="text/javascript">
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
</script>
</head>

<body style="font-family: Arial, Helvetica, sans-serif; color: black;background-color: white;">
	<%
		try { 
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			PreparedStatement ps_check=null;
			ResultSet rs_check=null;
			int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString());
			int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Calendar todayCal= Calendar.getInstance();
			Calendar cal = Calendar.getInstance();

			// Last day of month ===>
			int current_mnt_lastDay = cal.getActualMaximum(Calendar.DATE); 
			cal.set(Calendar.DATE,1); 
			SimpleDateFormat sdf=new SimpleDateFormat("EEEE");
			DecimalFormat df = new DecimalFormat( "00" );
			DecimalFormat df3 = new DecimalFormat( "00.00" );
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			//System.out.println(sdf.format(cal.getTime()) + " = " + current_mnt_lastDay);

			// Days Name ==>
			String[] namesOfDays = DateFormatSymbols.getInstance().getWeekdays(); 

			// first day name
			String firstDayName = namesOfDays[cal.get(Calendar.DAY_OF_WEEK)]; 

			int today = todayCal.get(Calendar.DATE);
			int monthpass = cal.get(Calendar.MONTH);
			int yearpass = cal.get(Calendar.YEAR);
			
			PreparedStatement ps_user=null, ps_check1=null;
			ResultSet rs_user=null, rs_check1=null;
			
			int day=Integer.valueOf(request.getParameter("day")),
			month=Integer.valueOf(request.getParameter("month")),
			year=Integer.valueOf(request.getParameter("year"));
			String startDate=df.format((month+1)) +"-" +df.format(day) +"-" + year;
			String endDate=df.format((month+1)) +"-" +df.format(day) +"-" + year + " 23:59:59"; 
	%>
	<!-- ********************************************************************************************************************* -->
	<div class="panel panel-primary" style="background-color: white;">
				<table style="width: 50%;">
					<tr>
						<th><a href="WFH_TaskPerformed.jsp"><b style="font-size: 15px;color: blue;">Go back to Dashboard</b></a></th>
					</tr>
				</table>					
		 
		  
               <ul class="nav nav-tabs" style="font-size: 12px;font-weight: bold;">
        <%
  		if(request.getParameter("tabsave")!=null){
  		%>
  		<li class="">
  		<%	
  		}else{
  		%>
  		 <li class="active">
  		<%	
  		}
		%>  
                    <a data-toggle="tab" href="#DWM">DWM Tasks</a>
                  </li>
                  <li class="">
                    <a data-toggle="tab" href="#project">Project Tasks</a>
                  </li>
        <%
  		if(request.getParameter("tabsave")!=null){
  		%>
  		<li class="active">
  		<%	
  		}else{
  		%>
  		 <li class="">
  		<%	
  		}
		%>            
                    <!-- <a data-toggle="tab" href="#addTasks">Add Task</a> -->
                  </li>
                </ul> 
              <div class="panel-body">
                <div class="tab-content">
    <%
  		if(request.getParameter("tabsave")!=null){
  		%>
  		<div id="DWM" class="tab-pane"  style="height: 600px;overflow: scroll;">
  		<%	
  		}else{
  		%>
  		 <div id="DWM" class="tab-pane active"  style="height: 600px;overflow: scroll;">
  		<%	
  		}
		%>            
                
                
                  
                
                
                  <table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;color:"> 
             		<th align="center"  style="color: black;">T No</th>  
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;">DWM Task Description</th>  
					<th align="center"  style="color: black;">Time Required 
					<th align="center"  style="color: black;">Task Assigned By</th>
					<th align="center"  style="color: black;">Registered Date</th>					
					<th align="center"  style="color: black;">Documents</th>
					<th align="center"  style="color: black;">Status</th> 
					<th align="center"  style="color: black;">Approval by</th>
					<th align="center"  style="color: black;">Approval Date</th>
					<th align="center"  style="color: black;">Approval Remark</th>						
				</tr>
				<% 
				String dwmAprBy="", dwmaprDate="",dwmApRemark="";
				ps_user = con_master.prepareStatement("SELECT  * from tran_dwm_tasks  where u_id="+uid+" and  enable_id=1 and tran_date= '"+startDate+"'");
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
					ps_check = con_master.prepareStatement("select * from rel_dwm_approvers where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						ps_check1 = con.prepareStatement("select * from user_tbl where U_Id=" +rs_check.getInt("u_id"));
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
					ps_check = con_master.prepareStatement("select * from rel_dwm_tasks_Attach where dwm_id=" +rs_user.getInt("id"));
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
					
						ps_check = con_master.prepareStatement("select * from approval_type where id=" +rs_user.getInt("approval_id"));
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
					%>
					<b style="color: black;background-color: yellow;">Pending</b>
					<%	
					}
					%>
					</td>
						<td align="center"  style="color: black;"><%=dwmAprBy %></td>
					<td align="center"  style="color: black;"><%=dwmaprDate %></td>
					<td align="center"  style="color: black;"><%=dwmApRemark %></td>
				</tr>
				<%	  
				dwmAprBy=""; dwmaprDate="";dwmApRemark="";
				}
				%>
				</table> 
                  
                  
                  
                  
                  </div>
                  <div id="project" class="tab-pane" style="height: 600px;overflow: scroll;">



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
					<th align="center"  style="color: white;">Approval by</th>
					<th align="center"  style="color: white;">Approval Date</th>
					<th align="center"  style="color: white;">Approval Remark</th>
					<th align="center"  style="color: white;">Approval status</th> 
				</tr>
			
			<%
			boolean flagApp=false;
			String app_rem="", app_by="", app_date="",appStatus="Pending"; 
			 
		 	ps_check = con_master.prepareStatement("SELECT tran_wfh_project_task.approval_id as approval_id,tran_wfh_project_task.approval_remark AS approval_remark, tran_wfh_project_task.approved_by AS approved_by, tran_wfh_project_task.id as taskId,tran_wfh_project.id as id, tran_wfh_project.project_title as project_title, tran_wfh_project.project_description as project_description, tran_wfh_project_task.u_id as requestor, tran_wfh_project_task.task_performed as task_performed, tran_wfh_project_task.remark as taskdescr, tran_wfh_project_task.time_spent_mins as timereqd, tran_wfh_project_task.status_id as status_id, tran_wfh_project_task.sys_date as sys_date, tran_wfh_project_task.approval_remark as approval_remark, tran_wfh_project_task.approval_id as approval_id FROM rel_project_approvers inner join tran_wfh_project_task on rel_project_approvers.project_id=tran_wfh_project_task.project_id inner join tran_wfh_project on rel_project_approvers.project_id=tran_wfh_project.id where rel_project_approvers.enable_id=1 and tran_wfh_project_task.enable_id=1 and tran_wfh_project_task.u_id="+uid+" and tran_wfh_project_task.sys_date between '"+startDate+"' and '"+endDate+"'");
			rs_check = ps_check.executeQuery();
			while(rs_check.next()){  
			%>	
			<tr style="background-color: #DACB74;color:"> 
             		<td style="color: black;" align="center"><%=rs_check.getInt("id") %></td>  
					<td style="color: black;"><%=rs_check.getString("project_title") %></td> 
					<td style="color: black;"><%=rs_check.getString("project_description") %></td>   
					<td style="color: black;">
					<% 
						ps_check1 = con.prepareStatement("select * from user_tbl where U_Id=" +rs_check.getInt("requestor"));
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
					ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id=" +rs_check.getInt("status_id"));
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
					ps_check1 = con_master.prepareStatement("select * from rel_wfh_project_Attach where project_id=" +rs_check.getInt("id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){
					%>
					<a href="WFH_PrjDocs_Display.jsp?field=<%=rs_check1.getInt("id")%>"><strong style="color: blue;font-weight: bold;"><%=rs_check1.getString("file_name") %></strong></a> &nbsp; ,
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
		</div> 
 		<%-- <%
  		if(request.getParameter("tabsave")!=null){
  		%>
  		<div id="addTasks" class="tab-pane active" style="height: 600px;overflow: scroll;">
  		<%	
  		}else{
  		%>
  		 <div id="addTasks" class="tab-pane" style="height: 600px;overflow: scroll;">
  		<%	
  		}
		%>   --%> 		 
					
				<!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- DWM Entry Screen --------------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
             <%-- <form action="DWM_Register_Control" method="post" enctype="multipart/form-data" id="feedback_form" class="form-validate form-horizontal">
             	<% 
                SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    			java.util.Date trandate = sdf1.parse(year + "-"+df.format((month+1))+"-"+df.format(day));
    			java.sql.Date date = new java.sql.Date(trandate.getTime());
             	%>
             	<input type="hidden" name="tran_date" id="tran_date" value="<%=date.toString()%>">
             	<input type="hidden" name="frm" id="frm" value="WFH_DayDetails.jsp?day=<%=df.format(day)%>&month=<%=df.format(month)%>&year=<%=year%>">
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
					<textarea rows="2" cols="100" class="form-control" style="font-weight: bold;color: black;" id="dwm_task_desc" onkeypress="return checkQuote();" name="dwm_task_desc" type="text" required title="Single quotes and double quotes are not allowed"></textarea>
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
			<select class="form-control" name="taskAssigned_By" id="taskAssigned_By" style="font-weight: bold; color: black;font-size: 12px !important;" required>
                <option value=""> - - - - Select - - - - </option>
                <%   
				ps_check = con.prepareStatement("SELECT * FROM user_tbl where dept_id="+dept_id+" and enable_id=1 and u_id!="+uid);
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>"><%=rs_check.getString("U_Name")%></option>  
                <%
                }
                ps_check = con.prepareStatement("SELECT * FROM user_tbl where enable_id=1 and company_id=6");
                rs_check = ps_check.executeQuery();
                while(rs_check.next()){
                %>                              
                  <option value="<%=rs_check.getString("u_id")%>">Management - <%=rs_check.getString("U_Name")%></option>  
                <%
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
				
				<div  style="height: 550px;overflow: scroll;margin-top: 5px;">
				<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;color:"> 
             		<th align="center"  style="color: black;">T No</th>  
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;">DWM Task Description</th>  
					<th align="center"  style="color: black;">Time Required 
					<th align="center"  style="color: black;">Task Assigned By</th>
					<th align="center"  style="color: black;">Registered Date</th>					
					<th align="center"  style="color: black;">Documents</th>
					<th align="center"  style="color: black;">Status</th> 
					<th align="center"  style="color: black;">Approval by</th>
					<th align="center"  style="color: black;">Approval Date</th>
					<th align="center"  style="color: black;">Approval Remark</th>						
				</tr>
				<% 
				dwmAprBy=""; dwmaprDate="";dwmApRemark="";
				ps_user = con_master.prepareStatement("SELECT  * from tran_dwm_tasks  where u_id="+uid+" and  enable_id=1 and tran_date='"+date+"' order by id desc");
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
					ps_check = con_master.prepareStatement("select * from rel_dwm_approvers where dwm_id=" +rs_user.getInt("id"));
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						ps_check1 = con.prepareStatement("select * from user_tbl where U_Id=" +rs_check.getInt("u_id"));
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
					ps_check = con_master.prepareStatement("select * from rel_dwm_tasks_Attach where dwm_id=" +rs_user.getInt("id"));
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
					
						ps_check = con_master.prepareStatement("select * from approval_type where id=" +rs_user.getInt("approval_id"));
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
					%>
					<b style="color: black;background-color: yellow;">Pending</b>
					<%	
					}
					%>
					</td>
						<td align="center"  style="color: black;"><%=dwmAprBy %></td>
					<td align="center"  style="color: black;"><%=dwmaprDate %></td>
					<td align="center"  style="color: black;"><%=dwmApRemark %></td>
				</tr>
				<%	  
				dwmAprBy=""; dwmaprDate="";dwmApRemark="";
				}
				%>
				</table> 
				</div> --%>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!---------------------------------------------------------------------------------- DWM Entry Screen Ends ----------------------------------------------------------------------->                
  <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>
 <!------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------>                
 	
					
					
					
					
					
					
					
					
					
					</div>
					 
                </div>
              </div> 
		 
		 
		 
	</div>
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