<%@page import="java.text.DecimalFormat"%>
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
<title>AJAX</title>
</head>
<body>

<%
try{
		int up=0; 
	 	int uid = Integer.valueOf(session.getAttribute("uid").toString());
		Connection con = Connection_Util.getConnectionMaster(); 
		DecimalFormat formatter = new DecimalFormat( "00.00" );
		String time_reqd = request.getParameter("time");
		String id = request.getParameter("id"); 
		String lay_hid = request.getParameter("lay_hid");
		
		Double timemm = Double.valueOf(time_reqd);
		String timeHH = formatter.format(timemm/60); 
		// *******************************************************************************************************************************************************************
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

		// *******************************************************************************************************************************************************************
		
		PreparedStatement ps_config = con.prepareStatement("update tran_wfh_config set specification1=?,specification2=?,changed_by=?,changed_date=?,enable_id=? where id="+Integer.valueOf(id));
		ps_config.setString(1, String.valueOf(timemm));
		ps_config.setString(2, timeHH);
		ps_config.setInt(3, uid);
		ps_config.setTimestamp(4, timeStamp);
		ps_config.setInt(5, 1);
		up = ps_config.executeUpdate();
%>              
<span id="tmG_reqd">
<b style="color: green;">Above Configuration is set successfully.....</b> 
</span> 
<%	 
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>