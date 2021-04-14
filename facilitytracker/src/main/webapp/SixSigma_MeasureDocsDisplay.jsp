<%@page import="com.facilitytracker.connectionUtil.Connection_Util"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%> 
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Display 2D Image</title>
</head>
<body>
	<%
	InputStream inputStream =null;
	OutputStream outStream = null;
		try {
			final int BUFFER_SIZE = 8096;
System.out.println("in loop");
			Connection con = Connection_Util.getConnectionMaster();
			int id = Integer.parseInt(request.getParameter("field"));
			String cond = request.getParameter("cond"); 
			String attachName="",attachment="",query="";
			
			if(cond.equalsIgnoreCase("abnormal_equipmentCond")){
				attachName="abnormal_eqCond_fileName";
				attachment="abnormal_eqCond_attach";
				query = "select * from rel_pt_measurePhase where id=" + id;
			}
			if(cond.equalsIgnoreCase("abnormal_processParameters")){
				attachName="abnormal_processPara_filename";
				attachment="abnormal_processPara_attach";
				query = "select * from rel_pt_measurePhase where id=" + id;
			}
			if(cond.equalsIgnoreCase("rejection_trnd6Month")){
				attachName="rejection_trnd6Month_fileName";
				attachment="rejection_trnd6Month_attach";
				query = "select * from rel_pt_measurePhase where id=" + id;
			}
			if(cond.equalsIgnoreCase("concentration_chart")){
				attachName="concentration_chart_filename";
				attachment="concentration_chart_attach";
				query = "select * from rel_pt_measurePhase where id=" + id;
			}
			if(cond.equalsIgnoreCase("measureVariation_studyreq")){
				attachName="measureVar_studyreq_filename";
				attachment="measureVar_studyreq_attach";
				query = "select * from rel_pt_measurePhase where id=" + id;
			}
			if(cond.equalsIgnoreCase("tools_pinpointing")){
				attachName="file_name";
				attachment="attachment";
				query = "select * from rel_pt_analyzePhase_SSV where id=" + id;
			}
			
			if(cond.equalsIgnoreCase("controlAttach")){
				attachName="control_filename";
				attachment="controlFile_attach";
				query = "select * from rel_pt_controlPhase_Causes where id=" + id;
			}
			
			
			
			
			PreparedStatement ps = con.prepareStatement(query);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) { 
				Blob blob = rs.getBlob(attachment);
				inputStream = blob.getBinaryStream();
				int filelength = inputStream.available();
				//System.out.println("File length = " + filelength);
				ServletContext context = getServletContext();

				String mimeType = context.getMimeType(rs.getString(attachName));
				if (mimeType == null) {
					mimeType = "application/octet-stream";
				}

				response.setContentType(mimeType);
				response.setContentLength(filelength);
				String headerKey = "Content-Disposition";
				String headerValue = String.format("attachment; filename=\"%s\"",rs.getString(attachName));
				response.setHeader(headerKey, headerValue);

				outStream = response.getOutputStream();

				byte[] buffer = new byte[BUFFER_SIZE];
				int bytesRead = -1;

				while ((bytesRead = inputStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, bytesRead);
				}

				inputStream.close();
				outStream.close();
				outStream.flush();
			} else {
				response.getWriter().println("File not found for the id: "	+ request.getParameter("field"));
			} 
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>

</body>
</html>