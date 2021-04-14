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
 <span id="avail_mat">
 <%
 try{
		Connection con = Connection_Util.getConnectionMaster();
		String matName = request.getParameter("matName");
 %>
  				<table style="width: 100%;" class="gridtable"> 
					<tr style="background-color: #dedede;color: black;"> 
						<th style="color: black;">Plant</th> 
						<th style="color: black;">Material</th> 
						<th style="color: black;">Description</th>
						<th style="color: black;">Type</th> 
					</tr>
<% 
	 PreparedStatement ps_check = con.prepareStatement("SELECT TOP 1000 plant,material,material_description,material_type  FROM rel_SAPmaster_mm60 where material_description like '%"+matName+"%'");
     ResultSet rs_check = ps_check.executeQuery();
     while(rs_check.next()){
%>
	<tr>
		<td><%=rs_check.getString("plant") %></td>
		<td><%=rs_check.getString("material") %></td>
		<td><%=rs_check.getString("material_description") %></td>
		<td><%=rs_check.getString("material_type") %></td>
	</tr>
<%
     }  
     ps_check  = con.prepareStatement("select * from tran_SAPmaster_create where enable=1 and stage_no in (1,2,3) and materialName like '"+matName+"'");
	 rs_check = ps_check.executeQuery();
	 if (rs_check.next()) {
%>
			<tr>
				<td><%=rs_check.getString("plant") %></td>
				<td>Pending...</td>
				<td><%=rs_check.getString("materialName") %></td>
				<td><%=rs_check.getString("materialType") %></td>
			</tr>
<% 		 
	 }
}catch(Exception e){
	e.printStackTrace();
} 
%> 
 
			</table>
	</span>
</body>
</html>