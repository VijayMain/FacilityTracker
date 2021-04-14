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
	String location = request.getParameter("loc"); 
	String comp = request.getParameter("plant"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));
	Connection con = Connection_Util.getConnectionMaster(); 
%>
 <span id="getInput">
<%
if(!comp.equalsIgnoreCase("")){
%>

	<table class="gridtable">
					<tr style="color: black;">
						<th style="background-color: #8EA2CE;color: black;"><b>Search Material Description :</b></th>
						<td>
						<input type="text" style="color: black;width: 400px;height: 30px;font-size: large;" maxlength="40" name="material_desc" id="material_desc" onkeyup="alreadyavailCheckMatName()">
						</td>
					</tr>
					<tr style="color: black;">
						<th style="background-color: #8EA2CE;color: black;"><b>Search Material Code :</b></th>
						<td><input type="text" style="color: black;width:400px;height: 30px;font-size: large;" maxlength="17" name="material_code" id="material_code" onkeyup="alreadyavailCheckMatCode()"></td>
					</tr>	
	</table> 
     	<span id="checkmat">
     	<table style="width: 98%;" class="gridtable">
					<tr>
						<th>SNO</th>
						<th>Plant</th> 
						<th>Stock Type</th>
						<th>Inv Doc</th>
						<th>Location</th>  
						<th>Mat Code</th>
						<th>Mat Descr</th>
						<th>UOM</th>
						<th>Mat Type</th> 
					</tr>
				<%-- 	<%
					PreparedStatement	ps_check = con.prepareStatement("SELECT  * FROM stocktaking_summary where enable=1 and Plant='"
											+ comp + "' and fiscal_year='" +fiscal +"' and storage_loc='" +location +"'  order by stocktype_desc desc");
					ResultSet rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
					%>
					<tr>
						<td align="center"><b><%=rs_check.getString("sno")%></b></td>
						<td><%=rs_check.getString("Plant")%></td> 
						<td><%=rs_check.getString("stocktype_desc")%></td> 
						<td><%=rs_check.getString("physical_inv_doc")%></td>
						<td><%=rs_check.getString("storage_loc")%></td>  
						<td><%=rs_check.getString("material_no")%></td>
						<td><%=rs_check.getString("material_desc")%></td>
						<td><%=rs_check.getString("uom")%></td>
						<td><%=rs_check.getString("mat_type")%></td> 
					</tr>
					<%
						}
					%> --%>
				</table> 
				</span>
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