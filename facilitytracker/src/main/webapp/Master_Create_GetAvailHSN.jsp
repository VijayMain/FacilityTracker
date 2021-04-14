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
		String hsn_no = request.getParameter("hsn_no");
 %>
  				<table style="width: 100%;" class="gridtable">
					<tr style="background-color: #dedede;color: black;"> 
						<th style="color: black;">HSN NO</th> 
						<th style="color: black;">Description</th> 
					</tr>
<% 
	 PreparedStatement ps_check = con.prepareStatement("SELECT * FROM  rel_SAPmaster_HSN where hsnCode like '%"+hsn_no+"%'");
     ResultSet rs_check = ps_check.executeQuery();
     while(rs_check.next()){
%>
	<tr>
		<td><%=rs_check.getString("hsnCode") %></td>
		<td><%=rs_check.getString("desc1") %></td> 
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