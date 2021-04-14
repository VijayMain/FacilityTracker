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
<span id="varSpec">
 <%
 try{			       
		Connection conMater = Connection_Util.getConnectionMaster();
		int variable = Integer.valueOf(request.getParameter("variable")); 
		PreparedStatement ps_data = null;
		ResultSet rs_data=null;   
PreparedStatement ps_check = conMater.prepareStatement("select id from rel_pt_masterData where id="+variable+" and master_name like 'Variable'");
ResultSet rs_check = ps_check.executeQuery();
if(rs_check.next()){
%>
 <textarea class="form-control" name="specification" id="specification" rows="1" cols="30" onkeypress="return checkQuote();" style="color: black;font-size: 12px;" required></textarea> 
<%	
}else{
%>
<textarea class="form-control" name="specification" id="specification" rows="1" cols="30" onkeypress="return checkQuote();" style="color: black;font-size: 12px;" readonly="readonly"></textarea>
<%
}
}catch(Exception e){
	e.printStackTrace();
} 
%>   
	</span>
</body>
</html>