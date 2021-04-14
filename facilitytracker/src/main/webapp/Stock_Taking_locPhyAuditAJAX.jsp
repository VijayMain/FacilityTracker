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
<title>AJAX</title>
</head>
<body>
<span id="getPHYAuditLoc">
<%
try{ 
	String plant = request.getParameter("data_entryPLant"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));    
	String phy_loc = request.getParameter("phy_loc"); 
	 
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;  
%>
<table class="gridtable" width="100%"> 
 <tr>
 <th>Location Owner Name</th>
 <th>Location Auditor Name</th> 
 </tr>
 		<% 
 		if(phy_loc!=""){
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_loc_auditors_sub where id="+Integer.valueOf(phy_loc));
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){ 
        %>
  <tr style="height: 30px;font-weight: bold;font-size: 12px;">
 	<td><%=rs_check.getString("loc_owner_name") %></td>
 	<td><%=rs_check.getString("loc_auditor_name") %></td> 
 </tr>
 		<%
        }
 		}else{
        %>
        <tr style="height: 30px;">
 	<td></td>
 	<td></td> 
 </tr>
        <%	
        }
 		%>
</table>

<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>