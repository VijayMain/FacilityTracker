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
<title>Delete</title>
</head>
<body>

	<%
	try{
	Connection con = Connection_Util.getConnectionMaster();
	
	java.util.Date date = null;
	java.sql.Timestamp timeStamp = null;
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
	java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
	timeStamp = new java.sql.Timestamp(date.getTime());
	int id = Integer.valueOf(request.getParameter("id"));
	%>
	<span id="delete_record<%=id%>">
	<%
	String status = "";
	
	PreparedStatement ps_wfhTaskDelete =con.prepareStatement("update tran_SAPmaster_create set enable=0,changed_by="+Integer.valueOf(session.getAttribute("uid").toString())+",changed_date ='"+timeStamp+"' where id="+id);
	int up = ps_wfhTaskDelete.executeUpdate();
 	if(up>0){
 	%>
 	<strong style="color: red;">Deleted</strong>
 	<%	
 	}else{
 	%>
 	<strong style="color: yellow;">Error !</strong>
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