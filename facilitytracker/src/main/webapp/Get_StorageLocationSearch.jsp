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
	String plant = request.getParameter("plant"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal")); 
	Connection con = Connection_Util.getConnectionMaster();  
%>
 <span id="importdata">
 <%
 if(!plant.equalsIgnoreCase("")){
 %>
 <table class="gridtable">
				<tr style="color: black;">
					<th style="background-color: #93C8C8;color: black;font-size: 12px;">
						 <b>Search By Storage Location : </b>
					</th>
					<td>
					<select name="import_for" id="import_for"  onchange="GetStockTaking_search(this.value)" style="font-weight: bold;font-size: 14px;color: black;height: 30px;">
    				<option value="">- - - - - Select - - - - -</option>   
    				<%
    				PreparedStatement ps_check = con.prepareStatement("select * from stocktaking_storageLocation where enable=1 and plant='"+plant+"' and storage_location in(SELECT storage_loc  FROM stocktaking_attachments where plant='"+plant+"'  and enable=1 and fiscal_year='"+fiscal+"')");
   					ResultSet rs_check = ps_check.executeQuery();
   					while(rs_check.next()){
					%>
					<option value="<%=rs_check.getString("storage_location")%>"><%=rs_check.getString("storage_location")%> - <%=rs_check.getString("storage_locationDesc")%></option> 
					<%   
  					}
    				%>              
    				</select>
					</td>
				</tr>	
  
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