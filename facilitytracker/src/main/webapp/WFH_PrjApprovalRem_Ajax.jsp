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
	String appr_remark = request.getParameter("appr_remark"); 
	
	appr_remark = appr_remark.replaceAll("\"", "");
	appr_remark = appr_remark.replaceAll("\'", "");
	
	int id = Integer.valueOf(request.getParameter("id"));  
  	int up=0;
	PreparedStatement ps_check = con.prepareStatement("update tran_wfh_project_task set approval_remark=? where id =" +id);
	ps_check.setString(1, appr_remark);
	up = ps_check.executeUpdate();
	
%>
<span id="remark_Prjajax<%=id %>" style="color: black;font-weight: bold;">
<%
if(up>0){
	PreparedStatement ps_user = con.prepareStatement("select * from  tran_wfh_project_task where id =" +id);
	ResultSet rs_user = ps_user.executeQuery();
	while(rs_user.next()){
%>
<%=rs_user.getString("approval_remark") %>
<%	 
	} 
%>

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