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
 <%
 try{			      
		Connection con_master = Connection_Util.getConnectionMaster();
		int id = Integer.valueOf(request.getParameter("id")); 
		PreparedStatement ps_data = null; 
		int up=0;
		ps_data = con_master.prepareStatement("update rel_pt_teamSelect set enable=0 where id="+id);
		up = ps_data.executeUpdate(); 
%>
<span id="deleteMember<%= id %>">
<%
if(up>0){
%>
<span style="background-color: red;color: white;font-size: 8px;">Removed</span>
<%
}else{
%>
<span style="background-color: red;color: white;font-size: 8px;">Issue Occurred..!</span>
<%
}
%>
</span>
<%
}catch(Exception e){
	e.printStackTrace();
} 
%> 
</body>
</html>