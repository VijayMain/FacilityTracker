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
<span id="getLoc">
<%
try{
	String plant = request.getParameter("plant"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));   
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;
%>
   <select name="store_loc" id="store_loc" class="form-control" onchange="getphysical_Location(this.value)" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - - Select - - -</option>
	 	<%
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_storageLocation where enable=1 and plant='"+plant+"'");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("id") %>"><%=rs_check.getString("storage_location") %> - <%=rs_check.getString("storage_locationDesc") %></option>
        <%
        }
        %>
	</select>             
<%	
}catch(Exception e){
	e.printStackTrace();
}
%>
</span>
</body>
</html>