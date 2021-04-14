package com.facilitytracker.dao;
 
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;  
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.NumberToTextConverter;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook; 

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.StockTaking_VO;

public class StockTaking_DAO {

	public void attach_File(HttpServletResponse response, StockTaking_VO vo,
			HttpSession session) {
		try {
			// *******************************************************************************************************************************************************************
						java.util.Date date = null;
						java.sql.Timestamp timeStamp = null;
						Calendar calendar = Calendar.getInstance();
						calendar.setTime(new Date());
						java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
						java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
						SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
						SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						date = simpleDateFormat.parse(dt.toString() + " " + sqlTime.toString());
						timeStamp = new java.sql.Timestamp(date.getTime()); 
			// *******************************************************************************************************************************************************************
						Connection con = Connection_Util.getConnectionMaster();
						int uid = Integer.parseInt(session.getAttribute("uid").toString());
						String uname = session.getAttribute("username").toString(), plantdesc="", storeLocdesc="", stocktype="",matTypeDescr="";
						int ct=0,up=0,val = 0,upload=0,rwCnt=1,loopcls=0;
						boolean flagAvail=false;
			// *******************************************************************************************************************************************************************
						PreparedStatement ps_check=null,ps_upload = null, ps_plant=null;
						ResultSet rs_check=null,rs_upload = null,rs_plant=null;
						
						ps_check = con.prepareStatement("SELECT *  FROM stocktaking_stocktype where enable=1 and id="+vo.getStock_typeID());
						rs_check = ps_check.executeQuery();
					    while(rs_check.next()){
					    	stocktype = rs_check.getString("stock_type");
					    } 
						
						ps_plant = con.prepareStatement("SELECT  shortname FROM stocktaking_company where plant='"+vo.getComp_id()+"'");
						rs_plant = ps_plant.executeQuery();
						while (rs_plant.next()) {
							plantdesc = vo.getComp_id() + " - " + rs_plant.getString("shortname");
						}
						
						ps_plant = con.prepareStatement("SELECT * from stocktaking_storageLocation where storage_location='"+vo.getImportfor()+"'");
						rs_plant = ps_plant.executeQuery();
						while (rs_plant.next()) {
							storeLocdesc = rs_plant.getString("storage_location") + " - " + rs_plant.getString("storage_locationDesc");
						}
						
						ps_plant = con.prepareStatement("SELECT * from stocktaking_attachments where enable=1 and fiscal_year='"+vo.getFiscal_year()+"' and  plant='"+vo.getComp_id()+"' and storage_loc='" +vo.getImportfor()+"' and stocktype_desc='"+stocktype+"'");
						rs_plant = ps_plant.executeQuery();
						while (rs_plant.next()) {
						flagAvail =true;
						}
						
						if(flagAvail==true){
						String msg="Provided Plant " +vo.getComp_id() + " and Storage Location " + vo.getImportfor() +" is already imported..!!";
							response.sendRedirect("Stock_Taking.jsp?error="+msg); 
							
						}else{
						
						ps_check = con.prepareStatement("insert into stocktaking_attachments "
								+ "(filename,attachment,created_by,sys_date,update_date,updated_by,plant,storage_loc,enable,fiscal_year,stocktype_desc) values(?,?,?,?,?,?,?,?,?,?,?)");
						ps_check.setString(1, vo.getFileName());
						ps_check.setBlob(2, vo.getFile_blob());
						ps_check.setInt(3, uid);
						ps_check.setTimestamp(4, timeStamp);
						ps_check.setTimestamp(5, timeStamp);
						ps_check.setInt(6, uid);
						ps_check.setString(7, vo.getComp_id());
						ps_check.setString(8, vo.getImportfor());
						ps_check.setInt(9, 1);
						ps_check.setInt(10, vo.getFiscal_year());
						ps_check.setString(11, stocktype);
						
						up = ps_check.executeUpdate();
		 
		 // *******************************************************************************************************************************************************************	
						PreparedStatement ps_ct = con.prepareStatement("select MAX(id) as maxid from stocktaking_attachments");
						ResultSet rs_ct = ps_ct.executeQuery();
						while (rs_ct.next()) {
							ct = rs_ct.getInt("maxid");
						}	
		
						PreparedStatement ps_blb = con.prepareStatement("select * from stocktaking_attachments where id=" + ct);
						ResultSet rs_blb = ps_blb.executeQuery();
						while (rs_blb.next()) {
							Blob blob = rs_blb.getBlob("attachment");
							InputStream in = blob.getBinaryStream();
							ArrayList alistFile = new ArrayList();
							
							File folder = new File("C:/reportxls");
							File[] listOfFiles = folder.listFiles();
							String listname = "";
							val = listOfFiles.length + 1;
							
							File exlFile = new File("C:/reportxls/stockTaking" + val + ".xlsx");
							OutputStream out = new FileOutputStream(exlFile);
							byte[] buff = new byte[4096]; // how much of the blob to
															// read/write at a time
							int len = 0;
							while ((len = in.read(buff)) != -1) {
								out.write(buff, 0, len);
							}
						}	
		// *******************************************************************************************************************************************************************	
						String EXCEL_FILE_LOCATION = "C://reportxls/stockTaking" + val + ".xlsx";
						
						File myFile = new File(EXCEL_FILE_LOCATION);
						FileInputStream fis = new FileInputStream(myFile);
						int i=0;
						ArrayList rowValue = new ArrayList();
						for(int c=0;c<16;c++){
							rowValue.add("");
						}

						// Finds the workbook instance for XLSX file
						XSSFWorkbook myWorkBook = new XSSFWorkbook (fis);

						// Return first sheet from the XLSX workbook
						XSSFSheet mySheet = myWorkBook.getSheetAt(0);

						// Get iterator to all the rows in current sheet
						Iterator<Row> rowIterator = mySheet.iterator();

						// Traversing over each row of XLSX file
						while (rowIterator.hasNext()) {
						    Row row = rowIterator.next();
						 
						    Iterator<Cell> cellIterator = row.cellIterator();
						    
						    
						    
						    while (cellIterator.hasNext()) {
						    	if(loopcls==0){ 
								    loopcls++;
								    break;
								  }
						    	
						    	
						        Cell cell = cellIterator.next();
						        if(i==16){ 
						        	i=0;
						        }else{
						        
						        switch (cell.getCellType()) {
						        case Cell.CELL_TYPE_STRING: 
						        	rowValue.set(i, cell.getStringCellValue().toString());  
						        	i++;
						        	break;
						        case Cell.CELL_TYPE_NUMERIC: 
						        	 String str = NumberToTextConverter.toText(cell.getNumericCellValue());
						        	 rowValue.set(i,str); 
						        	 i++;
						        	break;  
						        case Cell.CELL_TYPE_BOOLEAN: 
						        	rowValue.set(i,String.valueOf(cell.getBooleanCellValue()));
						        	i++;
						        	break;
						        default :        	   
						        }
						        }
						    } 
						    
						    // ******************************************************************************************
						    // ******************************** Coding Here ***********************************************
						    // ******************************************************************************************
						   if(loopcls==1){
							   loopcls++;
						   }else{	   
						    ps_upload = con.prepareStatement("insert into  stocktaking_summary"
									+ "(Plant,storage_loc,physical_inv_doc,fiscal_year,countdate,"
									+ "item_no,material_no,material_desc,uom,mat_type,entry_qty,"
									+ "zero_cnt,serial_no,posting_date,Reason,batch_no,import_no,enable,"
									+ "sys_date,created_by,updated_by,update_date,sno,Plant_desc,storage_loc_desc,"
									+ "stocktype_desc,mattype_desc,stocktype_id)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
						    
						    for(int k=0;k<16;k++){
							ps_upload.setString(k+1, rowValue.get(k).toString());					    
						    }
						    ps_check = con.prepareStatement("SELECT *  FROM stocktaking_mattype where enable=1 and mat_type='"+rowValue.get(9).toString()+"'");
							rs_check = ps_check.executeQuery();
						    while(rs_check.next()){
						    	matTypeDescr = rs_check.getString("mat_typeDescr");
						    }
						    
						    ps_upload.setString(17, String.valueOf(ct));
							ps_upload.setInt(18, 1);
							ps_upload.setTimestamp(19, timeStamp);
							ps_upload.setInt(20, uid);
							ps_upload.setInt(21, uid);
							ps_upload.setTimestamp(22, timeStamp); 
							ps_upload.setString(23, String.valueOf(rwCnt));
						    ps_upload.setString(24, plantdesc);
						    ps_upload.setString(25, storeLocdesc);
							ps_upload.setString(26, stocktype);
							ps_upload.setString(27, matTypeDescr);
							ps_upload.setInt(28, vo.getStock_typeID());
						   
						    
						    
							upload = ps_upload.executeUpdate(); 
						//  System.out.println(rowValue + "  =   " + rowValue.size() + "***************************************************************");
						    rowValue.clear();
						    for(int j=0;j<16;j++){
						    	rowValue.add("");
						    }
						    i=0;
						    rwCnt++;
						   }
						  
						}
						
						if(upload>0){
							
							String path =  vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_"+ val + ".pdf";
							String p4= "A4"+ vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_"+  val + ".pdf";	
							String p=  "A3_"+vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_" + val + ".pdf";
							String p1= "A4_"+ vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_"+  val + ".pdf";
							
							Map parameters = new HashMap();
							parameters.put("plant", vo.getComp_id());
							parameters.put("storageLoc", vo.getImportfor());			
							parameters.put("fiscal_year", vo.getFiscal_year());
							parameters.put("stocktype", stocktype);
							 
					         
					     	JasperReport jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Stock_Taking.jrxml"); 
							JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
							JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+path);
							
							
							
							jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Extra_A4.jrxml"); 
							jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
							JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+p1);
							
							jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Extra_A3.jrxml"); 
							jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
							JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+p);
							
							jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Stock_Taking_A4.jrxml"); 
							jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
							JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+p4); 
					          
							response.sendRedirect("Stock_Taking_log.jsp?path="+path+"&comp="+vo.getComp_id()+"&fiscal="+vo.getFiscal_year()+"&str="+vo.getImportfor() + "&ct="+ct+ "&p3="+p + "&p4="+p1+ "&a4="+p4+"&st="+stocktype); 
						}else{
							response.sendRedirect("Stock_Taking.jsp?error='Something wend wrong..! Please recheck.'"); 
						}
					}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
