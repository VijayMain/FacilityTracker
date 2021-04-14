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
	<span id="checkList">
	<%
		try {
			
			int select = Integer.valueOf(request.getParameter("select"));
			int cnt = Integer.valueOf(request.getParameter("cnt"));
			int id = Integer.valueOf(request.getParameter("id"));
			if(select==1){
				session.setAttribute("tools"+cnt, id);	 
			}else{
				session.removeAttribute("tools"+cnt);
			}
			
		/* 	if(session.getAttribute("tools"+cnt)!=null){
				System.out.println("session = " + session.getAttribute("tools"+cnt).toString());
			}else{
				System.out.println("session deleted");
			} */
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	</span>
</body>
</html>