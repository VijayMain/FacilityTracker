<%@page import="java.util.ArrayList"%>
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
	Connection conUtil = Connection_Util.getLocalUserConnection();
	Connection con = Connection_Util.getConnectionMaster();
	String status = "";
	String plant = request.getParameter("plant");   
	 if(plant!=""){ 
 %>
  <span id="ext_ajax"> 
		<%
		PreparedStatement ps_plant = conUtil.prepareStatement("SELECT plant,seq FROM user_tbl_company where enable=1 and plant !='All' order by seq");
        ResultSet rs_plant = ps_plant.executeQuery();
        while(rs_plant.next()){
         if(rs_plant.getString("plant").equalsIgnoreCase(plant)){
        %>	 
        	 <input type="checkbox" name="plant<%=rs_plant.getString("plant") %>" value="<%=rs_plant.getString("plant") %>"  checked="checked" onclick="return false">&nbsp;<%=rs_plant.getString("plant") %>&nbsp;	 
        <%
         }else{
       	%>	 
        	 <input type="checkbox" name="plant<%=rs_plant.getString("plant") %>" value="<%=rs_plant.getString("plant") %>">&nbsp;<%=rs_plant.getString("plant") %>&nbsp;	 
        <%	 
         }
        } 
		%>
 </span>
 <%   			 
     }else{
 			PreparedStatement ps_plant = conUtil.prepareStatement("SELECT plant,seq FROM user_tbl_company where enable=1 and plant !='All' order by seq");
            ResultSet rs_plant = ps_plant.executeQuery();
            while(rs_plant.next()){
             %>       
            <input type="checkbox" name="plant<%=rs_plant.getString("plant") %>" value="1010">&nbsp;<%=rs_plant.getString("plant") %>&nbsp;
             <%
             }   
     }
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>