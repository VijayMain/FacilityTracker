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
<span id="materialSearch">
 <%
 try{			      
		Connection con = Connection_Util.getConnectionMaster();
		String plant = request.getParameter("plant");
		String probSearch = request.getParameter("probSearch");
		PreparedStatement ps_data = null;
		ResultSet rs_data=null; 
 %>
             <table class="gridtable" width="100%"> 
					<tr style="background-color: #dedede;color: black;"> 
						<th>No</th>
						<th>Plant</th>
						<th>Problem Description</th>
						<th>Product Code</th>
						<th>Product Description</th>
						<th>Type of Project</th> 
						<th>Department</th>
						<th>User</th>
						<th>Phase</th> 
					</tr> 
<% 
String dept = "",typeProject="",matCode="",phase_name="";
PreparedStatement ps_check = con.prepareStatement("select * from tran_pt_problem where enable=1 and plant='"+plant+"' and problem_descr like '%"+probSearch+"%'");
ResultSet rs_check = ps_check.executeQuery();
while(rs_check.next()){ 
	ps_data = con.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("dept_id"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		dept = rs_data.getString("master_name");
	}
	ps_data = con.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("typeProject"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		typeProject = rs_data.getString("master_name");
	}
	ps_data = con.prepareStatement("select material from rel_SAPmaster_mm60 where id="+rs_check.getInt("product_code"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		matCode = rs_data.getString("material");
	}
	ps_data = con.prepareStatement("select phase from rel_pt_phase where seqNo="+rs_check.getInt("phase_id"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		phase_name = rs_data.getString("phase");
	}
%>
<tr>
	<td><%=rs_check.getInt("id") %></td>
	<td><%=rs_check.getString("plant") %></td>
	<td><%=rs_check.getString("problem_descr") %></td>
	<td><%=matCode %></td>
	<td><%=rs_check.getString("product_codeDescr") %></td>
	<td><%=typeProject%></td>
	<td><%=dept %></td>	
	<td><%=rs_check.getString("created_byName") %></td>
	<td><%=phase_name %></td>	
</tr>
<% 
}
}catch(Exception e){
	e.printStackTrace();
} 
%>  
 
			</table>
	</span>
</body>
</html>