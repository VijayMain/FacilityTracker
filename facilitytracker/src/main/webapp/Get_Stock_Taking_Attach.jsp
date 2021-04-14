<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AJAX</title>
</head>
<body>
<span id="plant_data">
<%
try{
	Connection con = Connection_Util.getConnectionMaster();
	Connection conLocal = Connection_Util.getLocalUserConnection();
	PreparedStatement ps_check=null;
	ResultSet rs_check=null;
	SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss"); 
	String plant = request.getParameter("plant");
	if(plant==""){
%>
<table style="width: 100%;" class="gridtable">
					<tr>
						<th style="color: black;">S.No</th>
						<th style="color: black;">Plant</th> 
						<th style="color: black;">Storage Location</th>
						<th style="color: black;">Stock Type</th>
						<th style="color: black;">Fiscal Year</th>
						<th style="color: black;">Active Status</th>
						<th style="color: black;">Uploaded by</th>
						<th style="color: black;">Upload Date</th>
						<th style="color: black;">Changed By</th>
						<th style="color: black;">Changed Date</th> 
						<th style="color: black;">Attachments</th>
					</tr>
					<%
					int s_no=0;
					PreparedStatement ps_up=null;
					ResultSet rs_up=null;
					PreparedStatement ps_file = con.prepareStatement("SELECT  * FROM  stocktaking_attachments order by plant");
					ResultSet rs_files = ps_file.executeQuery();
					while(rs_files.next()){
						s_no++;
					%>
					<tr>
						<td align="right"><%=s_no %></td>
						<td align="right"><%=rs_files.getString("plant") %></td>
						<td align="left"><%=rs_files.getString("storage_loc") %></td>
						<td align="left"><%=rs_files.getString("stocktype_desc") %></td>
						<td align="right"><%=rs_files.getString("fiscal_year") %></td>
						
						<%
						if(rs_files.getInt("enable")==0){
						%>
						<td align="left" style="background-color: red;color: white;"><b>Deleted</b></td> 
						<%
						}else{
						%>
						<td align="left" style="background-color: green; color: white;"><b>Active</b></td> 
						<%
						}
						ps_up = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id=" +rs_files.getInt("created_by"));
						rs_up = ps_up.executeQuery();
						while(rs_up.next()){
						%>						
						<td align="left"><%=rs_up.getString("u_name") %></td>
						<%
						}
						%>
						<td align="left"><%=format.format(rs_files.getTimestamp("sys_date")) %></td>
						<%
						ps_up = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id=" +rs_files.getInt("updated_by"));
						rs_up = ps_up.executeQuery();
						while(rs_up.next()){
						%>						
						<td align="left"><%=rs_up.getString("u_name") %></td>
						<%
						}
						%>  
						<td align="left"><%=format.format(rs_files.getTimestamp("update_date")) %></td>
						<td align="left"><a href="StockTakingDocs_View.jsp?field=<%=rs_files.getInt("id")%>"><strong><%=rs_files.getString("filename") %></strong></a></td>
					</tr>
					<%
					}
					%>
             		</table>
<%		
	}else{
%>
<table style="width: 100%;" class="gridtable">
					<tr>
						<th style="color: black;">S.No</th>
						<th style="color: black;">Plant</th> 
						<th style="color: black;">Storage Location</th>
						<th style="color: black;">Stock Type</th>
						<th style="color: black;">Fiscal Year</th>
						<th style="color: black;">Active Status</th>
						<th style="color: black;">Uploaded by</th>
						<th style="color: black;">Upload Date</th>
						<th style="color: black;">Changed By</th>
						<th style="color: black;">Changed Date</th> 
						<th style="color: black;">Attachments</th>
					</tr>
					<%
					int s_no=0;
					PreparedStatement ps_up=null;
					ResultSet rs_up=null;
					PreparedStatement ps_file = con.prepareStatement("SELECT  * FROM  stocktaking_attachments where plant='"+plant+"' order by sys_date");
					ResultSet rs_files = ps_file.executeQuery();
					while(rs_files.next()){
						s_no++;
					%>
					<tr>
						<td align="right"><%=s_no %></td>
						<td align="right"><%=rs_files.getString("plant") %></td>
						<td align="left"><%=rs_files.getString("storage_loc") %></td>
						<td align="left"><%=rs_files.getString("stocktype_desc") %></td>
						<td align="right"><%=rs_files.getString("fiscal_year") %></td>
						
						<%
						if(rs_files.getInt("enable")==0){
						%>
						<td align="left" style="background-color: red;color: white;"><b>Deleted</b></td> 
						<%
						}else{
						%>
						<td align="left" style="background-color: green; color: white;"><b>Active</b></td> 
						<%
						}
						ps_up = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id=" +rs_files.getInt("created_by"));
						rs_up = ps_up.executeQuery();
						while(rs_up.next()){
						%>						
						<td align="left"><%=rs_up.getString("u_name") %></td>
						<%
						}
						%>
						<td align="left"><%=format.format(rs_files.getTimestamp("sys_date")) %></td>
						<%
						ps_up = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id=" +rs_files.getInt("updated_by"));
						rs_up = ps_up.executeQuery();
						while(rs_up.next()){
						%>						
						<td align="left"><%=rs_up.getString("u_name") %></td>
						<%
						}
						%>  
						<td align="left"><%=format.format(rs_files.getTimestamp("update_date")) %></td>
						<td align="left"><a href="StockTakingDocs_View.jsp?field=<%=rs_files.getInt("id")%>"><strong><%=rs_files.getString("filename") %></strong></a></td>
					</tr>
					<%
					}
					%>
             		</table>
<%		
	}
	
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>