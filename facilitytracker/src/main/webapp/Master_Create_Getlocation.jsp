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
	Connection con = Connection_Util.getConnectionMaster();
	String status = "";
	String plant = request.getParameter("plant");  
	 if(plant!="" && !plant.equalsIgnoreCase("1050")){
 %>
 <span id="loc_ajax"> 
 <select name="location" id="location" class="form-control m-bot15" style="color: black;" required>
      <option value=""> - - - - Select - - - -  </option>
         <%
             PreparedStatement ps_check = con.prepareStatement("SELECT id,code,descr FROM master_data where  tablekey='storage_loc' and enable=1 and plant='" + plant + "'");
             ResultSet rs_check = ps_check.executeQuery();
             while(rs_check.next()){
          %>
       <option value="<%=rs_check.getString("code") %>"><%=rs_check.getString("code") %> - - <%=rs_check.getString("descr") %></option>
          <%
          
               }
          %>
 </select>
  </span>
 <%		 
    	}else if(plant.equalsIgnoreCase("1050")){
  %>
  <input type="text" name="location" id="location" maxlength="6" class="form-control m-bot15" style="color: black;" readonly="readonly">
 <%  	
    	}else{	
 %>
  <span id="loc_ajax">
  <input type="text" onkeyup="this.value=this.value.replace(/[^\d]/,'')"  name="location" id="location"   class="form-control m-bot15" style="color: black;" readonly="readonly">
  </span>
 <%   			 
     }
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>