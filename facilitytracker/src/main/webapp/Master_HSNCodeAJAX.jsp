<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.Connection"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AJAX</title>
</head>
<body>
	<span id="searchDetails">
		<table class="gridtable" width="100%"> 
		<tr style="background-color: #dedede; color: black;">
					<th>HSN Code</th>
					<th>HSN Description</th>
				</tr>
			<%
			Connection con = Connection_Util.getConnectionMaster();
			String nameSearch="", nameCode="", query="";
			if(request.getParameter("nameSearch")!=""){ 
				nameSearch = " and desc1 like '%" + request.getParameter("nameSearch")+"%' ";
			}
			if(request.getParameter("nameCode")!=""){
				nameCode = " and hsnCode like '%" + request.getParameter("nameCode")+"%' ";
			} 
			query = "SELECT hsnCode,desc1 FROM  rel_SAPmaster_HSN where enable=1 " + nameSearch + nameCode; 
		PreparedStatement ps_check = con.prepareStatement(query);
     	ResultSet rs_check = ps_check.executeQuery();
     	while(rs_check.next()){
	%>
	<tr>
		<td><%=rs_check.getString("hsnCode") %></td>
		<td><%=rs_check.getString("desc1") %></td> 
	</tr>
<%   	  
     }
			
			%>
		</table>
	</span>
</body>
</html>