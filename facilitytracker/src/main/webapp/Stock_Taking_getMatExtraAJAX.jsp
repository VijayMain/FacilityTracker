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
<span id="getMaterialData">
<div style="overflow: scroll;">
<%
 try{			       
		Connection con = Connection_Util.getConnectionMaster();
		String plant = request.getParameter("plant");
		String matSearch = request.getParameter("matSearch");  
		String mat_type = request.getParameter("mat_type");
%>
  				 <table style="width: 100%;" class="gridtable">
             	<tr>
             		<th>Product Code</th>
                    <th>Product Description</th>
                    <th>Adopt</th>
             	</tr>  
<%
PreparedStatement ps_check = con.prepareStatement("SELECT id,material,material_description FROM rel_SAPmaster_mm60 where plant='"+plant+"' and enable=1 and material_type='"+mat_type+"' AND material_description like '%"+ matSearch +"%' OR material like '%"+ matSearch +"%'");
ResultSet rs_check = ps_check.executeQuery();
while(rs_check.next()){
%>
<tr>
	<td><%=rs_check.getString("material") %></td>
	<td><%=rs_check.getString("material_description") %></td>
	<td><input type="button" value="Adopt" onclick="adopt_ProductCode(<%=rs_check.getInt("id") %>)" style="font-weight: bold;color: black;font-size: 12px;"> </td>
</tr>
<%
}
%>
</table>
</div>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>