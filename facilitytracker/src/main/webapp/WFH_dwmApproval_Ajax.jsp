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
	int status = Integer.valueOf(request.getParameter("status")); 
	int id = Integer.valueOf(request.getParameter("id")); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	// *******************************************************************************************************************************************************************
				java.util.Date date = null;
				java.sql.Timestamp timeStamp = null;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
				java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				date = simpleDateFormat.parse(dt.toString() + " "+ sqlTime.toString());
				timeStamp = new java.sql.Timestamp(date.getTime());
				int up = 0;
	// *******************************************************************************************************************************************************************
	String approval = "";
	PreparedStatement ps_check = con.prepareStatement("update tran_dwm_tasks set approval_id=?,approved_by=?,approved_date=?,changed_by=?,changed_date=? where id =" +id);
	ps_check.setInt(1, status);
	ps_check.setInt(2, uid);
	ps_check.setTimestamp(3, timeStamp);
	ps_check.setInt(4, uid);
	ps_check.setTimestamp(5, timeStamp);
	
	up = ps_check.executeUpdate();
	
	ps_check = con.prepareStatement("SELECT * FROM approval_type where id="+status);
	ResultSet rs_check = ps_check.executeQuery();
	while(rs_check.next()){
		approval = rs_check.getString("approval_Type");
	} 
%>
<span id="approval_btn<%=id %>" style="color: black;font-weight: bold;">
<%
if(up>0){
%>
<b style="font-weight: bold;"><%=approval %></b>
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