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
<span id="myDetails" style="color: black;">
<%
try{ 
	Connection con = Connection_Util.getLocalUserConnection(); 
	int participant = Integer.valueOf(request.getParameter("participant"));  
	String tot_part = request.getParameter("tot_part");   
	String part_group = request.getParameter("part_group"); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	if(tot_part.equalsIgnoreCase("0")){
		tot_part = String.valueOf(uid);
	} 
	PreparedStatement ps_check = con.prepareStatement("SELECT *  FROM user_tbl where u_id=" + participant);
	ResultSet rs_check = ps_check.executeQuery();
    while(rs_check.next()){
    	
%> 
<input type="hidden" name="tot_part" id="tot_part" value="<%=tot_part %>,<%=rs_check.getInt("U_Id")%>"> 
<textarea rows="1" class="form-control"  style="color: black;" id="part_group" readonly="readonly"><%=part_group %>,&#13;&#10; <%=rs_check.getString("U_Name") %> </textarea>
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