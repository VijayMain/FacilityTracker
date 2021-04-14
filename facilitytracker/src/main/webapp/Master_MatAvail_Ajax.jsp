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
 	String str = request.getParameter("q");
%> 
<div  id="already_avail" style="height : 650px;overflow : scroll;">
					<table class="tftable">
							<tr style="font-size: 12px; background-color: #acc8cc; font-weight: bold; text-align: center;"> 
								<td>Material Descr.</td>
								<td>Plant</td>
								<td>Division</td>
								<td>Material No</td>
							</tr>
							<!-- <tr style="font-size: 10px;">
								<td style="text-align: Center">Material No</td>
								<td>Material Descr.</td>
								<td style="text-align: right">Plant</td>
									<td style="text-align: right">Division</td>
						</tr> -->		
	<%
	if(str!=""){
		String location="";
		Connection con_master = Connection_Util.getConnectionMaster();
		PreparedStatement ps_search = con_master.prepareStatement("select * from sap_mastertran where  mat_name like '%" + str + "%'");
		ResultSet rs_search = ps_search.executeQuery();
		while(rs_search.next()){ 
	%>
						<tr style="font-size: 9px;"> 
								<td><%=rs_search.getString("mat_name") %></td>
								<td style="text-align: right"><%=rs_search.getString("plant") %></td>
									<td style="text-align: right"><%=rs_search.getString("division") %></td>
									<td style="text-align: Center"><%=rs_search.getString("material_no") %> </td>
						</tr>
	<%		
		}
	%>
		</table>	
	<%	
	con_master.close();
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
</div>
</body>
</html>