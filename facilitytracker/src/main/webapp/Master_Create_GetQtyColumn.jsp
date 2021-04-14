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
	String matType = request.getParameter("matType");
	
	 PreparedStatement ps_check = con.prepareStatement("SELECT mat_type FROM stocktaking_mattype where mat_type='"+matType+"'");
     ResultSet rs_check = ps_check.executeQuery();
     while(rs_check.next()){
    	 if(rs_check.getString("mat_type").equalsIgnoreCase("ZAST")){
 %>
 <span id="qtyColumn">
  <input type="text" onkeyup="this.value=this.value.replace(/[^\d]/,'')" value="1" name="qty" id="qty" maxlength="6" class="form-control m-bot15" style="color: black;" required>
 </span>
 <%		 
    		}else{
 %>
  <span id="qtyColumn">
  <input type="text" onkeyup="this.value=this.value.replace(/[^\d]/,'')" value="1" name="qty" id="qty" maxlength="6" class="form-control m-bot15" style="color: black;" readonly="readonly">
  </span>
 <%   			
    		}
     }  
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>