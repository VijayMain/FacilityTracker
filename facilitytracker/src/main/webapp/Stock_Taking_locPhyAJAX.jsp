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
	String plant = request.getParameter("data_entryPLant"); 
	int fiscal = Integer.valueOf(request.getParameter("fiscal"));    
	int store_loc = Integer.valueOf(request.getParameter("store_loc")); 
	 
	Connection con = Connection_Util.getConnectionMaster();
	PreparedStatement ps_check = null;
	ResultSet rs_check = null;
%>
 		<select name="phy_location" id="phy_location" onchange="getphy_audit(this.value)" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - - Select - - - </option>
	 	<%
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_loc_auditors_sub where enable=1 and plant='"+plant+"' and fiscal_year="+fiscal+" and stock_loc_id="+store_loc);
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("id")%>"><%=rs_check.getString("sub_locationName") %></option>
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