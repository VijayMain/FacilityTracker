<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Part Image View</title>
</head>
<body>
	<%
	OutputStream oImage=null;
	String name = null;
		try {
			final int BUFFER_SIZE = 8096; 
			Connection con = Connection_Util.getLocalUserConnection();
			int nameId = Integer.parseInt(request.getParameter("field")); 
			PreparedStatement ps = con.prepareStatement("select * from user_tbl where U_Id=" + nameId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) { 
				byte barray[] = rs.getBytes("user_photo");
		        response.setContentType("image/gif");
		        oImage=response.getOutputStream();
		        oImage.write(barray);
		        oImage.flush();
		        oImage.close(); 
				} 
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			oImage.flush();
	        oImage.close();
		}
	%>


</body>
</html>