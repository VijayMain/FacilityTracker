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
int matCode = Integer.valueOf(request.getParameter("matCode"));  
PreparedStatement ps_check = con.prepareStatement("SELECT id,material,material_description FROM rel_SAPmaster_mm60 where id="+matCode);
ResultSet rs_check = ps_check.executeQuery();
while(rs_check.next()){
 %>
<span id="adoptprodCode">
<input type="hidden" name="MtCode" id="MtCode" value="<%=rs_check.getInt("id")%>">
<input class="form-control" readonly="readonly" style="font-weight: bold;color: black;font-size: 10px;" id="search_product" name="search_product" 
  	onkeypress="return checkQuote();" onkeyup="GetmatDetails(this.value)" type="text" value="<%=rs_check.getString("material")%>" required/>
 <input class="form-control" name="product_name" id="product_name" value="<%=rs_check.getString("material_description") %>" readonly="readonly" style="font-weight: bold;color: black;font-size: 10px;" required />
</span>
<%
}
}catch(Exception e){
	e.printStackTrace();
}
%>   
</body>
</html>