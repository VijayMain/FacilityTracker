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
<title>Insert title here</title>
</head>
<body>
<%
try{ 
	Connection con = Connection_Util.getLocalUserConnection(); 
	String sapCode = request.getParameter("q"); 
	String compName = "";
	PreparedStatement ps_check = con.prepareStatement("SELECT *  FROM sap_users where Emp_Code='"+sapCode+"'");
	ResultSet rs_check = ps_check.executeQuery();
    while(rs_check.next()){
    	compName = rs_check.getString("Location");
    }
%>
<span id="myDetails" style="color: black;font-weight: bold;"><%=compName %></span>  
<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>