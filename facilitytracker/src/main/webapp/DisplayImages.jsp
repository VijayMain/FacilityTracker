<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Part Image View</title>
</head>
<body>
	<%
	OutputStream oImage=null;
	String name = null;
		try {
			final int BUFFER_SIZE = 8096;

			Connection con = Connection_Util.getLocalUserConnection();
			int id = Integer.parseInt(request.getParameter("field"));
			 
			PreparedStatement ps = con.prepareStatement("select * from facility_req_tbl where id="	+ id);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				byte barray[] = rs.getBytes("attach_image");
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