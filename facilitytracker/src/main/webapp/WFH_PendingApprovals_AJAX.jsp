<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AJAX</title>
</head>
<body>
<%
try{
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	int dept_idCheck = Integer.valueOf(session.getAttribute("dept_id").toString());
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
int u_req = Integer.valueOf(request.getParameter("u"));
String  monthSelected = request.getParameter("m"); 
String  yearsSelected = request.getParameter("y");
String  approvalType = request.getParameter("ap");
DecimalFormat df = new DecimalFormat("00");
DecimalFormat df3 = new DecimalFormat( "00.00" );
int monthpass=Integer.valueOf(monthSelected), yearpass = Integer.valueOf(yearsSelected);

Calendar calendar = Calendar.getInstance(); 
calendar.set(yearpass, monthpass, 1);
int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH); 

String startDate=df.format((monthpass+1)) +"-" +df.format(1) +"-" + yearpass;
String endDate=df.format((monthpass+1)) +"-" +df.format(daysInMonth) +"-" + yearpass;

PreparedStatement ps_user=null,ps_check=null,ps_check1=null;
ResultSet rs_user=null,rs_check=null,rs_check1=null;
int apType=0;
String queryApproval="";
if(approvalType!=""){
	apType = Integer.valueOf(approvalType);
	ps_user = con_master.prepareStatement("SELECT * FROM approval_type where  id="+apType);
	rs_user = ps_user.executeQuery();
	while(rs_user.next()){
		queryApproval=rs_user.getString("approval_Type");
	}
	if(apType>1){
	approvalType = " and approval_id="+queryApproval;
	}else{
	approvalType = " and approval_id is null ";	
	}
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------- Worked Hours Data ----------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------*/
double total_hoursWorked=0.0,total_minutesWorked=0.0;
ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where enable_id=1  and u_id="+u_req+" and tran_date between '"+startDate+"' and '"+endDate+"'");
rs_user = ps_user.executeQuery();
while(rs_user.next()){
	total_minutesWorked=rs_user.getInt("totHr");
}
total_hoursWorked = total_minutesWorked/60;

double total_hoursapproved=0.0,total_minutesapproved=0.0;
ps_user = con_master.prepareStatement("select SUM(CAST(time_elapsed as decimal)) as totHr from tran_dwm_tasks where enable_id=1 and u_id="+u_req+" and approval_id=3 and tran_date between '"+startDate+"' and '"+endDate+"'");
rs_user = ps_user.executeQuery();
while(rs_user.next()){
	total_minutesapproved=rs_user.getInt("totHr");
}
total_hoursapproved = total_minutesapproved/60;

int pend_tickets=0;
ps_user = con_master.prepareStatement("select COUNT(id) as pendtickets from tran_dwm_tasks where enable_id=1 and u_id="+u_req+" and approval_id is null and tran_date between '"+startDate+"' and '"+endDate+"' and id in (select dwm_id from rel_dwm_approvers where enable_id=1 and registered_by="+u_req+" and u_id="+uid+")");
rs_user = ps_user.executeQuery();
while(rs_user.next()){
	pend_tickets=rs_user.getInt("pendtickets");
}
/* System.out.println("worked = " + total_hoursWorked); */
/*--------------------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------- Worked Days Data -------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------*/
%>
<span id="userData">
				<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;color:"> 
             		<th align="center"  style="color: black;">Total Worked Time</th>  
             		<th align="center"  style="color: black;">Total Worked Days</th>
					<th align="center"  style="color: black;">Total Approved Hours</th> 
					<th align="center"  style="color: black;">Total Approved Days</th> 
					<th align="center"  style="color: black;">Total Pending Requests</th>  
				</tr>
				<tr>
					<td align="center" style="background-color:yellow; color: black;font-weight: bold;font-size: 12px;">(<%=df3.format(total_hoursWorked) %> in Hours) &nbsp;&nbsp;(<%=total_minutesWorked %> in Minutes)</td>
					<td align="center" style="background-color:yellow;color: black;font-weight: bold;font-size: 12px;"></td>
					<td align="center" style="background-color:yellow;color: black;font-weight: bold;font-size: 12px;">(<%=df3.format(total_hoursapproved) %> in Hours) &nbsp;&nbsp;(<%=total_minutesapproved %> in Minutes)</td>
					<td align="center" style="background-color:yellow;color: black;font-weight: bold;font-size: 12px;"></td>
					<td align="center" style="background-color:yellow;color: black;font-weight: bold;font-size: 12px;"><%=pend_tickets %></td>
				</tr>
				</table>
				<table style="width: 100%;color: white;" class="gridtable">
             	<tr style="background-color: #DACB74;color:">
             		<th align="center"  style="color: black;"><input type="checkbox" value="all">Check All</th>
             		<th align="center"  style="color: black;">T No</th>  
					<th align="center"  style="color: black;">DWM Task Title</th> 
					<th align="center"  style="color: black;">DWM Task Description</th>  
					<th align="center"  style="color: black;">Time Required 
					<th align="center"  style="color: black;">Requester</th>
					<th align="center"  style="color: black;">Performed Date</th>
					<th align="center"  style="color: black;">Documents (If Any)</th> 
					<th align="center"  style="color: black;">Approval Remark</th> 
					<th align="center"  style="color: black;">Accept / Reject</th> 
				</tr>
				<%-- <%
				PreparedStatement ps_selected = con_master.prepareStatement("select * from");
				ResultSet rs_selected = ps_selected.executeQuery();
				while(rs_selected.next()){
				%>
				<tr>
					<td><input type="checkbox" value=""> </td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<%
				}
				%> --%>
				</table>
	<%
}catch(Exception e){
	e.printStackTrace();
}
	%>
</span>
</body>
</html>