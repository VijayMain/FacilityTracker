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
Connection con = Connection_Util.getConnectionMaster();
int matCode = Integer.valueOf(request.getParameter("id"));  
PreparedStatement ps_check = con.prepareStatement("SELECT id,material,material_description FROM rel_SAPmaster_mm60 where id="+matCode);
ResultSet rs_check = ps_check.executeQuery();
while(rs_check.next()){
 %>
<span id="getCode" style="font-size: 10px;">
<input type="hidden" name="MtCode" id="MtCode" value="<%=rs_check.getInt("id")%>">

<input class="form-control" style="font-weight: bold;color: black;font-size: 10px;" id="material_search" name="material_search" 
value="<%=rs_check.getString("material") %>"
 onkeypress="return checkQuote();" onkeyup="GetmatDetails(this.value)" type="text" required /> 
</span>
<%
}
}catch(Exception e){
	e.printStackTrace();
}
%>   
</body>
</html>