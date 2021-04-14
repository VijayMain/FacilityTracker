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
	String plant = request.getParameter("plant"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));
	int stock_type = Integer.valueOf(request.getParameter("stock_type"));
	String stock_typeDescr="";
	
	PreparedStatement ps_check = con.prepareStatement("SELECT *  FROM stocktaking_stocktype where enable=1 and id="+stock_type);
	ResultSet rs_check = ps_check.executeQuery();
    while(rs_check.next()){
    	stock_typeDescr = rs_check.getString("stock_type");
    } 
%>
 <span id="importdata">
    <select name="import_for" id="import_for" class="form-control m-bot15" style="font-weight: bold;color: black;" required>
    <option value="">- - - - - Select - - - - -</option>   
    <%
    ps_check = con.prepareStatement("select * from stocktaking_storageLocation where enable=1 and plant='"+plant+"' and storage_location not in(SELECT storage_loc  FROM stocktaking_attachments where plant='"+plant+"'  and enable=1 and fiscal_year='"+fiscal+"' and stocktype_desc='"+stock_typeDescr+"')");
    rs_check = ps_check.executeQuery();
   while(rs_check.next()){
	%>
	<option value="<%=rs_check.getString("storage_location")%>"><%=rs_check.getString("storage_location")%> - <%=rs_check.getString("storage_locationDesc")%></option> 
	<%   
   }
    %>              
    </select>  
</span>                      
<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>