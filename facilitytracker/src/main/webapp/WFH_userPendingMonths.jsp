<%@page import="java.text.DateFormatSymbols"%>
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
<span id="pendingMonths"> 
<%
try{
	Connection con = Connection_Util.getConnectionMaster();
	int U_id = Integer.valueOf(request.getParameter("val"));
	DateFormatSymbols dfs = new DateFormatSymbols();
    String[] months = dfs.getMonths();
	
	PreparedStatement ps_check1 = con.prepareStatement("select distinct(MONTH(tran_date)) as mnt from tran_dwm_tasks where u_id="+U_id+" and enable_id=1");
	ResultSet rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
%>
<b><%=months[rs_check1.getInt("mnt")] %>,</b>
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