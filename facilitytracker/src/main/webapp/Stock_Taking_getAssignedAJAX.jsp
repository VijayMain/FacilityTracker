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
<span id="getPHYLoc">
<%
try{
	String plant = request.getParameter("plant");
	int sub_loc_auditors_id = Integer.valueOf(request.getParameter("phy_loc"));
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));
	int store_loc = Integer.valueOf(request.getParameter("store_loc"));
	
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null, ps_check1 = null;
	ResultSet rs_check = null,rs_check1 = null;
	
 
%>
<table  class="gridtable" width="100%"> 
 <tr> 
 	<th>Plant</th>
 	<th>Storage Location</th>
 	<th>Sub Location</th>
 	<th>Owner</th> 
 	<th>Assigned From</th>
 	<th>Assigned To</th>
</tr>
<%
String storage_location="",storage_locationDesc="",sub_locationr="",owner="";

ps_check = con.prepareStatement("SELECT * FROM stocktaking_tagAssign where enable=1 and fiscal_year="+fiscal+" and plant='"+plant+
						"' and sub_loc_auditors_id="+sub_loc_auditors_id+" and store_loc_id="+store_loc);
rs_check = ps_check.executeQuery();
while(rs_check.next()){
	ps_check1 = con.prepareStatement("select storage_location,storage_locationDesc from stocktaking_storageLocation where id="+rs_check.getInt("store_loc_id"));
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
		storage_location=rs_check1.getString("storage_location");
		storage_locationDesc=rs_check1.getString("storage_locationDesc");
	}
	
	ps_check1 = con.prepareStatement("select sub_locationName,loc_owner_name from stocktaking_loc_auditors_sub where id="+ rs_check.getInt("sub_loc_auditors_id"));
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
		sub_locationr=rs_check1.getString("sub_locationName");
		owner=rs_check1.getString("loc_owner_name");
	}
%>
<tr>
	<td><%=rs_check.getString("plant") %></td>
	<td><%=storage_location %></td>
	<td><%=sub_locationr %></td>
	<td><%=owner %></td>
	<td><%=rs_check.getInt("assigned_from") %></td>
	<td><%=rs_check.getInt("assigned_to") %></td>
</tr>
<%
storage_location="";   storage_locationDesc="";sub_locationr="";owner="";
}
%>
</table>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>