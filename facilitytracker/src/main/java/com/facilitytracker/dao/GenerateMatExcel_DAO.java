package com.facilitytracker.dao;
 
import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.StockTaking_VO;

public class GenerateMatExcel_DAO {

	public void generateExcel(StockTaking_VO vo, HttpServletResponse response,
			ArrayList idList, ServletContext context) {
		try {
			/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar=Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());

			java.sql.Time sqlTime=new java.sql.Time(calendar.getTime().getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			date = simpleDateFormat.parse(dt.toString()+" "+sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			
				int totalColumns=0,up=0;
				
				Connection con = Connection_Util.getLocalUserConnection();
				Connection con_master = Connection_Util.getConnectionMaster();
				
				PreparedStatement ps_check = null, ps_check1 = null;
				ResultSet rs_check = null, rs_check1 = null;
				/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
																				 Excel Configuration Start    
				 -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/ 
				
				int row=1,col=0;
				ArrayList alistFile = new ArrayList(); 
				
				
				File folder = new File("C:/reportxls");
				File[] listOfFiles = folder.listFiles();
				String listname = "";
				
			 	int val = listOfFiles.length + 1;
				
				File exlFile = new File("C:/reportxls/MasterTemplate"+val+".xls");
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
			    Label label = new Label(0, 0, "Sr.No",cellFormat);
			    writableSheet.addCell(label); 
			    
			    ArrayList<String> tempHead = new ArrayList<String>();
			    ps_check = con_master.prepareStatement("select * from sap_mastertemplate where enable=1 order by position");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()){
					tempHead.add(rs_check.getString("tableColumn"));
					Label label1 = new Label(rs_check.getInt("position"), 0, rs_check.getString("tempHeader_name"),cellFormat);
				    writableSheet.addCell(label1); 
				}
				
			    //***********************************************************************************************************************************
				int sno=0;
				String salesOrg="",division="",accCatGroup="",purGroup="",valClass ="",priceControl="",priceUnit="",movingPrice="";
				for(int i=0;i<idList.size();i++){
				sno++;
				Label column1 = new Label(col, row, String.valueOf(sno),cellRIghtformat);
	 			writableSheet.addCell(column1);
	 			col++;
	 			// -----------------------------------------------------------------------------------------------------------------------------------
	 			//------------------------------------------------------------------------------------------------------------------------------------
	 			ps_check = con_master.prepareStatement("select * from tran_SAPmaster_create where id=" + Integer.valueOf(idList.get(i).toString()));
				rs_check = ps_check.executeQuery();
				while (rs_check.next()){
					
					ps_check1 = con_master.prepareStatement("SELECT  code FROM master_data where tablekey like 'sales_org' and enable=1 and  plant='"+rs_check.getString("plant")+"'");
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()){
						salesOrg = rs_check1.getString("code");
					}
					
					ps_check1 = con_master.prepareStatement("select code from master_data where tablekey='purchase_Group' and enable=1 and plant='"+rs_check.getString("plant")+"'");
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()){
						purGroup = rs_check1.getString("code");
					}
					
					ps_check1 = con_master.prepareStatement("select code from master_data where tablekey like  'valueation_class' and enable=1 and plant='"+rs_check.getString("materialType")+"'");
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()){
						valClass = rs_check1.getString("code");
					}
					
					if(rs_check.getString("materialType").equalsIgnoreCase("UNBW") || rs_check.getString("materialType").equalsIgnoreCase("ZAST")){
						priceControl="";
						movingPrice="";
						priceUnit="";
					}else{
						priceControl="V";
						movingPrice=rs_check.getString("price");
						priceUnit="1";
					}
					
					if(purGroup==""){
						purGroup="002";
					}
					
					if(rs_check.getString("materialType").equalsIgnoreCase("ZAST")){
						division="06";
						accCatGroup="04";
					}else{
						division="07";
						accCatGroup="02";
					}
					
	 			for(int e=0;e<tempHead.size();e++){
	 				switch (e) {
	 				case 1 : Label exlClm1 =new Label(col, row, String.valueOf("M"),cellleftformat);writableSheet.addCell(exlClm1);col++;break;
	 				case 2 : Label exlClm2 =new Label(col, row, rs_check.getString("materialType"),cellleftformat);writableSheet.addCell(exlClm2);col++;break;
	 				case 3 : Label exlClm3 =new Label(col, row, rs_check.getString("plant"),cellleftformat);writableSheet.addCell(exlClm3);col++;break;
	 				case 4 : Label exlClm4 =new Label(col, row, rs_check.getString("location_id"),cellleftformat);writableSheet.addCell(exlClm4);col++;break;
	 				case 5 : Label exlClm5 =new Label(col, row, salesOrg,cellleftformat);writableSheet.addCell(exlClm5);col++;break;
	 				case 6 : Label exlClm6 =new Label(col, row, "03",cellleftformat);writableSheet.addCell(exlClm6);col++;break;
	 				case 7 : Label exlClm7 =new Label(col, row, rs_check.getString("materialName") ,cellleftformat);writableSheet.addCell(exlClm7);col++;break;
	 				case 8 : Label exlClm8 =new Label(col, row, rs_check.getString("uom"),cellleftformat);writableSheet.addCell(exlClm8);col++;break;
	 				case 9 : Label exlClm9 =new Label(col, row, rs_check.getString("materialGroup"),cellleftformat);writableSheet.addCell(exlClm9);col++;break;
	 				case 14 : Label exlClm10 =new Label(col, row, String.valueOf("KG"),cellleftformat);writableSheet.addCell(exlClm10);col++;break;
	 				case 17 : Label exlClm11 =new Label(col, row, division,cellleftformat);writableSheet.addCell(exlClm11);col++;break;
	 				
	 				case 18 : Label exlClm12 =new Label(col, row, "0",cellleftformat);writableSheet.addCell(exlClm12);col++;break;
	 				case 19 : Label exlClm13 =new Label(col, row, "0",cellleftformat);writableSheet.addCell(exlClm13);col++;break;
	 				case 20 : Label exlClm14 =new Label(col, row, "0",cellleftformat);writableSheet.addCell(exlClm14);col++;break;	 				
	 				case 21 : Label exlClmtcs =new Label(col, row, "0",cellleftformat);writableSheet.addCell(exlClmtcs);col++;break;
	 				case 22 : Label exlClm15 =new Label(col, row, "0",cellleftformat);writableSheet.addCell(exlClm15);col++;break;
	 				
	 				case 24 : Label exlClm16 =new Label(col, row, accCatGroup,cellleftformat);writableSheet.addCell(exlClm16);col++;break;
	 				case 25 : Label exlClm17 =new Label(col, row, "NORM",cellleftformat);writableSheet.addCell(exlClm17);col++;break;
	 				case 26 : Label exlClm18 =new Label(col, row, "NORM",cellleftformat);writableSheet.addCell(exlClm18);col++;break;
	 				case 29 : Label exlClm19 =new Label(col, row, "02",cellleftformat);writableSheet.addCell(exlClm19);col++;break;
	 				case 30 : Label exlClm20 =new Label(col, row, "0001",cellleftformat);writableSheet.addCell(exlClm20);col++;break;
	 				case 31 : Label exlClm21 =new Label(col, row, "0003",cellleftformat);writableSheet.addCell(exlClm21);col++;break;
	 				case 32 : Label exlClm22 =new Label(col, row, rs_check.getString("plant"),cellleftformat);writableSheet.addCell(exlClm22);col++;break;
	 				case 33 : Label exlClm23 =new Label(col, row, purGroup,cellleftformat);writableSheet.addCell(exlClm23);col++;break;
	 				case 35 : Label exlClm24 =new Label(col, row, "1",cellleftformat);writableSheet.addCell(exlClm24);col++;break;
	 				case 38 : Label exlClm25 =new Label(col, row, "ND",cellleftformat);writableSheet.addCell(exlClm25);col++;break;
	 				case 46 : Label exlClm26 =new Label(col, row, "X",cellleftformat);writableSheet.addCell(exlClm26);col++;break;
	 				case 49	: Label exlclm48 = new Label(col, row, "1",cellleftformat);writableSheet.addCell(exlclm48);col++;break;
	 				case 53 : Label exlClm27 =new Label(col, row, "000",cellleftformat);writableSheet.addCell(exlClm27);col++;break;
	 				case 58 : Label exlClm28 =new Label(col, row, rs_check.getString("hsn_code"),cellleftformat);writableSheet.addCell(exlClm28);col++;break;
	 				case 67 : Label exlClm29 =new Label(col, row, "X",cellleftformat);writableSheet.addCell(exlClm29);col++;break;
	 				case 68 : Label exlClm30 =new Label(col, row, "1",cellleftformat);writableSheet.addCell(exlClm30);col++;break;
	 				case 73 : Label exlClm31 =new Label(col, row, valClass,cellleftformat);writableSheet.addCell(exlClm31);col++;break;
	 				case 74 : Label exlClm32 =new Label(col, row, priceControl,cellleftformat);writableSheet.addCell(exlClm32);col++;break;
	 				case 75 : Label exlClm33 =new Label(col, row, priceUnit,cellleftformat);writableSheet.addCell(exlClm33);col++;break;
	 				case 77 : Label exlClm34 =new Label(col, row, movingPrice,cellleftformat);writableSheet.addCell(exlClm34);col++;break;
	 				default : Label exlClm35 =new Label(col, row, "",cellleftformat);writableSheet.addCell(exlClm35);col++;break; 
	 				}
	 			}
	 			salesOrg="";division="";accCatGroup="";purGroup="";valClass ="";priceUnit="";
				}
				// ------------------------------------------------------------------------------------------------------------------------------------
	 			//------------------------------------------------------------------------------------------------------------------------------------
				row++;
				col=0;
				}
			  		// Write and close the workbook
			    	writableWorkbook.write();
			    	writableWorkbook.close();
			  //***********************************************************************************************************************************
			    	String filePath = "C:/reportxls/MasterTemplate"+val+".xls"; 
			    	  File downloadFile = new File(filePath);
			    	  FileInputStream inStream = new FileInputStream(downloadFile);
			    	  
			    	  //ServletContext context = getServletContext();
			    	   
			    	  // gets MIME type of the file
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
			    	  response.sendRedirect("Master_Generate.jsp?filepath="+filePath); 
			    	//***********************************************************************************************************************************
			    	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}