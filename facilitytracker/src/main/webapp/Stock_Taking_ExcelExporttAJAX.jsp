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
	String fileNM="";
	if(excel==0){
		fileNM = "SAP Excel Import File";
%>
<span id="excelExp">  
<%	  
	}else{
		fileNM = "SAP Excel Import File [Extra Sheet]";
%>
<span id="excelExp_Extra"> 
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
	    Label label1=new Label(0,  0, "Plant",cellFormat); writableSheet.addCell(label1); 
	    Label label2=new Label(1,  0, "Storage Loc.",cellFormat); writableSheet.addCell(label2); 
	    Label label3=new Label(2,  0, "Physical Inventory Doc.",cellFormat); writableSheet.addCell(label3); 
	    Label label4=new Label(3,  0, "Fiscal Year",cellFormat); writableSheet.addCell(label4); 
	    Label label5=new Label(4,  0, "Count Date",cellFormat); writableSheet.addCell(label5); 
	    Label label6=new Label(5,  0, "Item",cellFormat); writableSheet.addCell(label6); 
	    Label label7=new Label(6,  0, "MaterialNo.",cellFormat); writableSheet.addCell(label7); 
	    Label label8=new Label(7,  0, "Entry Qty.",cellFormat); writableSheet.addCell(label8); 
	    Label label9=new Label(8,  0, "Zero Count",cellFormat); writableSheet.addCell(label9); 
	    Label label10=new Label(9,  0, "Serial No.",cellFormat); writableSheet.addCell(label10); 
	    Label label11=new Label(10,  0, "Posting Date",cellFormat); writableSheet.addCell(label11); 
	    Label label12=new Label(11,  0, "Reason",cellFormat); writableSheet.addCell(label12); 
	    Label label13=new Label(12,  0, "Batch No.",cellFormat); writableSheet.addCell(label13); 

		
	    //***********************************************************************************************************************************
	
	   // System.out.println(data_entryPLant+" = " +  fiscal_year + " = " + storage_location  + "  = "  + " = " + stockType);
	    String zerocnt="",query_name = "";
	    
	    if(excel==0){
	    query_name = "select * from stocktaking_summary where Plant='"+data_entryPLant+"' and fiscal_year='"+
				String.valueOf(fiscal_year)+"' and storage_loc='"+storage_location+"' and stocktype_id="+stockType+" and enable=1 order by physical_inv_doc,  CAST(item_no AS int)";
	    }else{
	    	query_name = "select * from stocktaking_summary_extra where Plant='"+data_entryPLant+"' and fiscal_year='"+
					String.valueOf(fiscal_year)+"' and storage_loc='"+storage_location+"' and stocktype_id="+stockType+" and enable=1 order by physical_inv_doc, CAST(item_no AS int)";	
	    }
	    
	    ps_check = con.prepareStatement(query_name);
		rs_check = ps_check.executeQuery();
		while(rs_check.next()){
		
		if(rs_check.getString("entry_qty").equalsIgnoreCase("0")){
			zerocnt="X";
		}
		
		Label Plantdb =new Label(col, row, rs_check.getString("Plant"),cellleftformat);writableSheet.addCell(Plantdb);col++;
		Label storage_locdb =new Label(col, row, rs_check.getString("storage_loc"),cellleftformat);writableSheet.addCell(storage_locdb);col++;
		Label physical_inv_docdb =new Label(col, row, rs_check.getString("physical_inv_doc"),cellleftformat);writableSheet.addCell(physical_inv_docdb);col++;
		Label fiscal_yeardb =new Label(col, row, rs_check.getString("fiscal_year"),cellleftformat);writableSheet.addCell(fiscal_yeardb);col++;
		Label countdatedb =new Label(col, row, rs_check.getString("countdate"),cellleftformat);writableSheet.addCell(countdatedb);col++;
		Label item_nodb =new Label(col, row, rs_check.getString("item_no"),cellleftformat);writableSheet.addCell(item_nodb);col++;
		Label material_nodb =new Label(col, row, rs_check.getString("material_no"),cellleftformat);writableSheet.addCell(material_nodb);col++;
		Label entry_qtydb =new Label(col, row, rs_check.getString("entry_qty"),cellleftformat);writableSheet.addCell(entry_qtydb);col++; 
		Label zero_cntdb =new Label(col, row, zerocnt,cellleftformat);writableSheet.addCell(zero_cntdb);col++; 
		Label serial_nodb =new Label(col, row, rs_check.getString("serial_no"),cellleftformat);writableSheet.addCell(serial_nodb);col++;
		Label posting_datedb =new Label(col, row,"31.03.2021",cellleftformat);writableSheet.addCell(posting_datedb);col++;
		Label Reasondb =new Label(col, row, rs_check.getString("Reason"),cellleftformat);writableSheet.addCell(Reasondb);col++;
		Label batch_nodb =new Label(col, row, rs_check.getString("batch_no"),cellleftformat);writableSheet.addCell(batch_nodb);col++;
 
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