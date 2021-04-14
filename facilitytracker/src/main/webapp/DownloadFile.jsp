<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<html>
<head>
<title>Download File</title>
</head>
<body>
<%
		try {  
			 	String filePath = request.getParameter("filepath");
			    File downloadFile = new File(filePath);
			    FileInputStream inStream = new FileInputStream(downloadFile);
			      
			    // obtains ServletContext
			    ServletContext context = getServletContext();
			     
			    // gets MIME type of the file
			    String mimeType = context.getMimeType(filePath);
			    if (mimeType == null) {        
			        // set to binary type if MIME mapping not found
			        mimeType = "application/octet-stream";
			    }
			    //System.out.println("MIME type: " + mimeType);
			     
			    // modifies response
			    response.setContentType(mimeType);
			    response.setContentLength((int) downloadFile.length());
			    
			    //forces download
			    String headerKey = "Content-Disposition";
			    String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
			    response.setHeader(headerKey, headerValue);
			     
			     //obtains response's output stream
			    OutputStream outStream = response.getOutputStream();
			     
			    byte[] buffer = new byte[4096];
			    int bytesRead = -1;
			     
			    while ((bytesRead = inStream.read(buffer)) != -1) {
			        outStream.write(buffer, 0, bytesRead);
			    }
			     
			    outStream.close();  
			    inStream.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
</body>
</html>