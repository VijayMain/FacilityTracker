<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
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
	Connection con = Connection_Util.getConnectionMaster();
	String status = "";
	int id = Integer.valueOf(request.getParameter("q"));
	PreparedStatement ps_wfhTaskDelete =con.prepareStatement("update tran_dwm_tasks set enable_id=0 where id="+id);
	int up = ps_wfhTaskDelete.executeUpdate();
	if(up>0){
		status="Deleted";
	}else{
		status="Error";
	}
%>
<span id="deleteDWM_task<%=id%>">
<%=status %>
</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>