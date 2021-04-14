<%@page import="java.io.FileInputStream"%>
<%@page import="jxl.write.Label"%>
<%@page import="jxl.format.BorderLineStyle"%>
<%@page import="jxl.write.Border"%>
<%@page import="jxl.format.Alignment"%>
<%@page import="jxl.write.WritableCellFormat"%>
<%@page import="jxl.Workbook"%>
<%@page import="jxl.write.WritableSheet"%>
<%@page import="jxl.write.WritableFont"%>
<%@page import="jxl.format.Colour"%>
<%@page import="jxl.write.WritableWorkbook"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
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
	int store_loc = Integer.valueOf(request.getParameter("store_loc")); 
	int stockType = Integer.valueOf(request.getParameter("stockType"));
	//String mat_type = request.getParameter("mat_type"); 
	String fiscal_year = request.getParameter("fiscal_year");
	String data_entryPLant = request.getParameter("data_entryPLant");
	int excel = Integer.valueOf(request.getParameter("excel")); 
	String phy_location = request.getParameter("phy_location"); 
	
	String fileNM="";
	if(excel==0){
		fileNM = "Data Punch File";
%>
<span id="getcheckUpload">  
<%	  
	}else{
		fileNM = "Data Punch File [Extra]";
%>
<span id="getcheckUpload_Extra"> 
<%		
	}
		int totalColumns=0,up=0; 
		Connection con = Connection_Util.getConnectionMaster();
		
		PreparedStatement ps_check = null, ps_check1 = null;
		ResultSet rs_check = null, rs_check1 = null;
		
		String storage_location="",stockTypeSTring = "";
		ps_check = con.prepareStatement("select storage_location from stocktaking_storageLocation where id="+store_loc);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			storage_location=rs_check.getString("storage_location");
		}
		ps_check = con.prepareStatement("select stock_type from stocktaking_stocktype where id="+stockType);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			stockTypeSTring=rs_check.getString("stock_type");
		}
		
		/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
																		 Excel Configuration Start    
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/ 
		
		int row=1,col=0;
		ArrayList alistFile = new ArrayList(); 
		
		File folder = new File("C:/reportxls");
		File[] listOfFiles = folder.listFiles();
		String listname = "";
		
	 	int val = listOfFiles.length + 1;
		
		File exlFile = new File("C:/reportxls/INV_"+data_entryPLant+storage_location+stockTypeSTring+val+".xls");
	    WritableWorkbook writableWorkbook = Workbook.createWorkbook(exlFile); 
	    WritableSheet writableSheet = writableWorkbook.createSheet("Sheet1", 0);
	    
	    Colour bckcolor = Colour.GRAY_25;
	    WritableFont font = new WritableFont(WritableFont.ARIAL);
	    font.setColour(Colour.BLACK); 
	    
	    WritableFont fontbold = new WritableFont(WritableFont.ARIAL);
	    fontbold.setColour(Colour.BLACK);
	    fontbold.setBoldStyle(WritableFont.BOLD);
	    
	    WritableCellFormat cellFormat = new WritableCellFormat();
	    cellFormat.setBackground(bckcolor);
	    cellFormat.setAlignment(Alignment.CENTRE);
	    cellFormat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK); 
	    cellFormat.setFont(fontbold);
	    
	    WritableCellFormat cellRIghtformat = new WritableCellFormat(); 
	    cellRIghtformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
	    font.setColour(Colour.BLACK); 
	    cellRIghtformat.setFont(font);
	    cellRIghtformat.setAlignment(Alignment.RIGHT);
	    
	    WritableCellFormat cellleftformat = new WritableCellFormat(); 
	    cellleftformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
	    font.setColour(Colour.BLACK); 
	    cellleftformat.setFont(font); 				
	    cellleftformat.setAlignment(Alignment.LEFT);
	        
	    /*writableSheet.mergeCells(0, 0, 10, 0);
	    Label labelName = new Label(0, 0,  "Overdue Vendor Payment of ",cellFormat);
	    writableSheet.addCell(labelName);
	    
	    for (int i = 0; i <= totalColumns; i++) {
	    writableSheet.setColumnView(i, 15);
	    }*/
	    if(excel==0){ 
	    Label label=new Label(0,  0, "S.No",cellFormat); writableSheet.addCell(label);
	    Label label7=new Label(1,  0, "Material No",cellFormat); writableSheet.addCell(label7);
	    Label label10=new Label(2,  0, "Material Descr",cellFormat); writableSheet.addCell(label10);
	    Label label16=new Label(3,  0, "Material Type",cellFormat); writableSheet.addCell(label16);
	    Label label1=new Label(4,  0, "Plant",cellFormat); writableSheet.addCell(label1);
	    Label label8=new Label(5,  0, "Entry Qty",cellFormat); writableSheet.addCell(label8);
	    Label label9=new Label(6,  0, "Tag No",cellFormat); writableSheet.addCell(label9); 
	    Label label13=new Label(7,  0, "Batch No.",cellFormat); writableSheet.addCell(label13); 
	    }else{ 
	 	    Label label7=new Label(0,  0, "Material No",cellFormat); writableSheet.addCell(label7);
	 	    Label label10=new Label(1,  0, "Material Descr",cellFormat); writableSheet.addCell(label10);
	 	    Label label16=new Label(2,  0, "Material Type",cellFormat); writableSheet.addCell(label16);
	 	    Label label1=new Label(3,  0, "Plant",cellFormat); writableSheet.addCell(label1);
	 	    Label label8=new Label(4,  0, "Entry Qty",cellFormat); writableSheet.addCell(label8);
	 	    Label label9=new Label(5,  0, "Tag No",cellFormat); writableSheet.addCell(label9); 
	 	    Label label13=new Label(6,  0, "Batch No.",cellFormat); writableSheet.addCell(label13); 
	    }
		
	    //***********************************************************************************************************************************
	
	   // System.out.println(data_entryPLant+" = " +  fiscal_year + " = " + storage_location  + "  = "  + " = " + stockType);
	    String zerocnt="",query_name = "", matCode="",matDescr="",MatTye="",query_summary = "";
	    
	    if(excel==0){
	    query_name = "select fiscal_year,plant,sno,stock_summary_id,batchNo,entry_qty,tag_no,id from stocktaking_count where enable=1 and loc_audit_id_sub="+phy_location+" and stock_summary_id in ( "+
				" select id from stocktaking_summary where enable=1 and fiscal_year='"+String.valueOf(fiscal_year)+"' and Plant='"+data_entryPLant+"' "+
				" and enable=1 and stocktype_id="+stockType+"  and storage_loc='"+storage_location+"') order by stock_summary_id,sno desc";	
	    	
	 	}else{
	 	query_name = "select fiscal_year,plant,extra_summary_id,batchNo,entry_qty,tag_no,id from stocktaking_count_extra where enable=1 and loc_audit_id_sub="+phy_location+" and extra_summary_id in ( "+
				" select id from stocktaking_summary_extra where enable=1 and fiscal_year='"+String.valueOf(fiscal_year)+"' and Plant='"+data_entryPLant+"' "+
				" and enable=1 and stocktype_id="+stockType+"  and storage_loc='"+storage_location+"') order by extra_summary_id desc";	
	 	}
	    
	    ps_check = con.prepareStatement(query_name);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
			
			
			if(excel==0){ 
				query_summary = "select material_no,material_desc,mat_type from stocktaking_summary where id="+rs_check.getInt("stock_summary_id");     	
			}else{
				query_summary = "select material_no,material_desc,mat_type from stocktaking_summary_extra where id="+rs_check.getInt("extra_summary_id");  
			}	
			
			ps_check1 = con.prepareStatement(query_summary);
			rs_check1 = ps_check1.executeQuery();
			while(rs_check1.next()){
				matCode=rs_check1.getString("material_no");
				matDescr=rs_check1.getString("material_desc");
				MatTye=rs_check1.getString("mat_type");
			}
		
		if(rs_check.getString("entry_qty").equalsIgnoreCase("0")){
			zerocnt="X";
		}
		
		if(excel==0){ 
		Label s_no =new Label(col, row, rs_check.getString("sno"),cellleftformat);writableSheet.addCell(s_no);col++; 
		}
		Label matCodecheck =new Label(col, row, matCode,cellleftformat);writableSheet.addCell(matCodecheck);col++; 
		Label matDescrcheck =new Label(col, row, matDescr,cellleftformat);writableSheet.addCell(matDescrcheck);col++;		
		Label MatTyecheck =new Label(col, row, MatTye,cellleftformat);writableSheet.addCell(MatTyecheck);col++; 
		Label plantcheck =new Label(col, row, rs_check.getString("plant"),cellleftformat);writableSheet.addCell(plantcheck);col++; 
		Label entryQtycheck =new Label(col, row, rs_check.getString("entry_qty"),cellleftformat);writableSheet.addCell(entryQtycheck);col++; 
		Label tagQtycheck =new Label(col, row, rs_check.getString("tag_no"),cellleftformat);writableSheet.addCell(tagQtycheck);col++; 
		Label batch_nodb =new Label(col, row, rs_check.getString("batchNo"),cellleftformat);writableSheet.addCell(batch_nodb);col++;
		
		// ------------------------------------------------------------------------------------------------------------------------------------
		//------------------------------------------------------------------------------------------------------------------------------------
		row++;
		col=0;
		zerocnt="";
	}	 
	  		// Write and close the workbook
	    	writableWorkbook.write();
	    	writableWorkbook.close();
	  //***********************************************************************************************************************************
	    	String filePath = "C:/reportxls/INV_"+data_entryPLant+storage_location+stockTypeSTring+val+".xls";
	    	
	    	/* 
	  		  File downloadFile = new File(filePath);
	    	  FileInputStream inStream = new FileInputStream(downloadFile);
	    	  
	    	  //ServletContext context = getServletContext();
	    	   
	    	  // gets MIME type of the file
	    	  ServletContext context=null;
	    	  String mimeType = context.getMimeType(filePath);
	    	  if (mimeType == null) {        
	    	      // set to binary type if MIME mapping not found
	    	      mimeType = "application/octet-stream";
	    	  }
	    	    
	    	  // modifies response
	    	  response.setContentType(mimeType);
	    	  response.setContentLength((int) downloadFile.length()); 
	    	  // forces download
	    	  String headerKey = "Content-Disposition";
	    	  String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
	    	  response.setHeader(headerKey, headerValue); 
	    	  inStream.close(); 
	    	  con.close(); 
	    	   
	    	  // __________________________________________________________________________________________________________________________
	    	  response.sendRedirect("Master_Generate.jsp?filepath="+filePath);  */
	
	 %>
<a href="DownloadFile.jsp?filepath=<%=filePath %>" class="button"><b style="font-size: 12px;background-color: yellow;"><%=fileNM %></b></a>	 
</span>
<% 
}catch(Exception e){
	e.printStackTrace();
}
%>

</body>
</html>