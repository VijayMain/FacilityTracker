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
	int nofile = Integer.valueOf(request.getParameter("nofile"));   
	
%>
<span id="dwmAttach" style="color: black;font-weight: bold;">
<% 
if(nofile>0){
for(int i=0;i<nofile;i++){
%>
<input type="file" name="dwmAttach<%=i%>" id="dwmAttach<%=i%>">
<% 
}
}else{
%>
<select name="noOfAttachdwm" id="noOfAttachdwm"  class="form-control" onchange="GetAttachDocDWM(this.value)" style="color: black;width: 200px;">
						<option value="0">No of Attachments</option>
						<%
						for(int i=1;i<6;i++){
						%>
						<option value="<%=i%>"><%=i%></option>
						<%
						}
						%>
					</select>
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