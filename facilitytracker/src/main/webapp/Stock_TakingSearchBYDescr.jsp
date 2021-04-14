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
	String comp = request.getParameter("plant"); 
	String matName = request.getParameter("matName"); 
	String import_for = request.getParameter("import_for"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));  
	
	Connection con = Connection_Util.getConnectionMaster(); 
%> 
<span id="checkmat"> 
<%
if(!comp.equalsIgnoreCase("")){
%> 
  
     		<table style="width: 98%;" class="gridtable">
					<tr style="color: black;">
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
					<%
				 PreparedStatement	ps_check = con.prepareStatement("SELECT  * FROM stocktaking_summary where enable=1 and Plant='"
											+ comp + "' and fiscal_year='" +fiscal +"' and storage_loc='"+import_for+"' and material_desc like '%"+matName+"%'  order by stocktype_desc desc");
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
					%>
				</table>  
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