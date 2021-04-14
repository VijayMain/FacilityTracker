package com.facilitytracker.dao;

import java.io.File;
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
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.Properties;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.StockTaking_VO;

public class MasterData_DAO {

	public void attach_File(HttpServletResponse response, StockTaking_VO bean,
			HttpSession session) {
		try {
			 int ct=0,up=0,val = 0;
			 int uid = Integer.valueOf(session.getAttribute("uid").toString());
				Connection con = Connection_Util.getConnectionMaster();
				PreparedStatement ps_check1 = null, ps_check = null,ps_user=null;
				ResultSet rs_check = null;
				String success="Upload Success", statusNop = "Upload having issues";
				// *******************************************************************************************************************************************************************
				java.util.Date date = null;
				java.sql.Timestamp timeStamp = null;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
				java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
				timeStamp = new java.sql.Timestamp(date.getTime());

				// *******************************************************************************************************************************************************************
				ps_check = con.prepareStatement("insert into rel_SAPmaster_fileUpload "
		+ "(filename,attachment,contact_no,reason,created_by,created_date,changed_by,changed_date,enable) values(?,?,?,?,?,?,?,?,?)");
		ps_check.setString(1, bean.getFileName());
		ps_check.setBlob(2, bean.getFile_blob());
		ps_check.setString(3, bean.getContact());
		ps_check.setString(4, bean.getReason());
		ps_check.setInt(5, uid);
		ps_check.setTimestamp(6, timeStamp);
		ps_check.setInt(7, uid);
		ps_check.setTimestamp(8, timeStamp);
		ps_check.setInt(9, 1);
		up = ps_check.executeUpdate();
		if(up>0){
			PreparedStatement ps_ct = con.prepareStatement("select MAX(id) as maxid from rel_SAPmaster_fileUpload");
			ResultSet rs_ct = ps_ct.executeQuery();
			while (rs_ct.next()) {
				ct = rs_ct.getInt("maxid");
			}		
			
			PreparedStatement ps_blb = con.prepareStatement("select * from rel_SAPmaster_fileUpload where id=" + ct);
			ResultSet rs_blb = ps_blb.executeQuery();
			while (rs_blb.next()) {
				Blob blob = rs_blb.getBlob("attachment");
				InputStream in = blob.getBinaryStream();
				ArrayList alistFile = new ArrayList();
				
				File folder = new File("C:/reportxls");
				File[] listOfFiles = folder.listFiles();
				String listname = "";
				val = listOfFiles.length + 1;
				
				File exlFile = new File("C:/reportxls/MasterBulkMM60" + val + ".xls");
				OutputStream out = new FileOutputStream(exlFile);
				byte[] buff = new byte[4096]; // how much of the blob to
												// read/write at a time
				int len = 0;
				while ((len = in.read(buff)) != -1) {
					out.write(buff, 0, len);
				}
			}
// *******************************************************************************************************************************************************************	
			String EXCEL_FILE_LOCATION = "C://reportxls/MasterBulkMM60" + val + ".xls";
			
			Workbook wrk1 = Workbook.getWorkbook(new File(EXCEL_FILE_LOCATION));
			
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy");				
  			/* ____________________________________________________________________________________________________ */
			Sheet sheet1 = wrk1.getSheet(0);
			int rows = sheet1.getRows();
			int cols = sheet1.getColumns(); 
			int cnt = 0;
					for (int i = 1; i < rows; i++) {
						Cell plant = sheet1.getCell(0, i);
						Cell material = sheet1.getCell(1, i);
						Cell material_description = sheet1.getCell(2, i);
						Cell uom = sheet1.getCell(3, i);
						Cell material_type = sheet1.getCell(4, i);
						Cell price = sheet1.getCell(5, i);
						Cell currency = sheet1.getCell(6, i);
						Cell price_control = sheet1.getCell(7, i);
						Cell valuation_class = sheet1.getCell(8, i);
						Cell price_unit = sheet1.getCell(9, i);
						Cell material_group = sheet1.getCell(10, i);
						Cell purchasing_group = sheet1.getCell(11, i);
						Cell abc_indicator = sheet1.getCell(12, i);
						Cell mrp_type = sheet1.getCell(13, i);
						Cell created_by = sheet1.getCell(14, i);
						Cell last_change = sheet1.getCell(15, i);
						Cell valuation_type = sheet1.getCell(16, i);


						String str_plant=plant.getContents();
						String str_material=material.getContents();
						String str_material_description=material_description.getContents();
						String str_uom=uom.getContents();
						String str_material_type=material_type.getContents();
						String str_price=price.getContents();
						String str_currency=currency.getContents();
						String str_price_control=price_control.getContents();
						String str_valuation_class=valuation_class.getContents();
						String str_price_unit=price_unit.getContents();
						String str_material_group=material_group.getContents();
						String str_purchasing_group=purchasing_group.getContents();
						String str_abc_indicator=abc_indicator.getContents();
						String str_mrp_type=mrp_type.getContents();
						String str_created_by=created_by.getContents();
						String str_last_change=last_change.getContents();
						String str_valuation_type=valuation_type.getContents();

						str_material_description = str_material_description.replaceAll("\"", "");
						str_material_description = str_material_description.replaceAll("\'", "");
						

						java.sql.Date sql_lastChange_Date =null;
						if(str_last_change!=""){
							// System.out.println("str_date_done " + str_date_done);
							str_last_change = str_last_change.replace("/", "-");
							java.util.Date date_performed = sdf1.parse(str_last_change);
							sql_lastChange_Date = new java.sql.Date(date_performed.getTime()); 
						}
		if(!str_material_description.equalsIgnoreCase(".")){
		
		ps_check  = con.prepareStatement("select * from rel_SAPmaster_mm60 where plant ='"+str_plant+"' and material ='"+str_material+"' and enable=1");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			//System.out.println("Already Available = " + str_material + " = = = " + sql_lastChange_Date);
		}else{
			// System.err.println("In Loop = " + str_material + " = = = " + sql_lastChange_Date);
			ps_check1 = con.prepareStatement("insert into rel_SAPmaster_mm60 (plant,material,material_description,base_unit_of_measure,material_type,price,currency,"
					+ "price_control,valuation_class,price_unit,material_group,purchasing_group,abc_indicator,mrp_type,created_by,last_change,valuation_type,added_by,"
					+ "created_date,changed_by,changed_date,enable) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_check1.setString(1, str_plant);
			ps_check1.setString(2, str_material);
			ps_check1.setString(3, str_material_description);
			ps_check1.setString(4, str_uom);
			ps_check1.setString(5, str_material_type);
			ps_check1.setString(6, str_price);
			ps_check1.setString(7, str_currency);
			ps_check1.setString(8, str_price_control);
			ps_check1.setString(9, str_valuation_class);
			ps_check1.setString(10, str_price_unit);
			ps_check1.setString(11, str_material_group);
			ps_check1.setString(12, str_purchasing_group);
			ps_check1.setString(13, str_abc_indicator);
			ps_check1.setString(14, str_mrp_type);
			ps_check1.setString(15, str_created_by);
			ps_check1.setDate(16, sql_lastChange_Date);
			ps_check1.setString(17, str_valuation_type);
			ps_check1.setInt(18, uid);
			ps_check1.setTimestamp(19,timeStamp);
			ps_check1.setInt(20, uid);
			ps_check1.setTimestamp(21, timeStamp);
			ps_check1.setInt(22, 1);
			up = ps_check1.executeUpdate(); 
					}
				}
			}
			if(up>0){
				response.sendRedirect("Master_Data_Upload.jsp?success="+success);
			}else{
				response.sendRedirect("Master_Data_Upload.jsp?statusNop="+statusNop);				
			}
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	
	
	public void attachBulkMaster_File(HttpServletRequest request, HttpServletResponse response,
			StockTaking_VO bean, HttpSession session) {
		try {
			 int ct=0,up=0,val = 0,fileUpload=0;
			 int uid = Integer.valueOf(session.getAttribute("uid").toString());
			 String emailUser = session.getAttribute("email_id").toString();
				Connection con = Connection_Util.getConnectionMaster();
				PreparedStatement ps_check1 = null, ps_check = null,ps_user=null,ps_check2 = null,ps_check3=null;
				ResultSet rs_check = null,rs_check1 = null,rs_check2 = null,rs_check3=null;
				String success="Upload Success...", statusNop = "Upload having issues";
				boolean flag=false;
				// *******************************************************************************************************************************************************************
				java.util.Date date = null;
				java.sql.Timestamp timeStamp = null;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
				java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
				timeStamp = new java.sql.Timestamp(date.getTime());
				// *******************************************************************************************************************************************************************
				ps_check = con.prepareStatement("insert into rel_SAPmaster_fileUpload "
		+ "(filename,attachment,contact_no,reason,created_by,created_date,changed_by,changed_date,enable) values(?,?,?,?,?,?,?,?,?)");
		ps_check.setString(1, bean.getFileName());
		ps_check.setBlob(2, bean.getFile_blob());
		ps_check.setString(3, bean.getContact());
		ps_check.setString(4, bean.getReason());
		ps_check.setInt(5, uid);
		ps_check.setTimestamp(6, timeStamp);
		ps_check.setInt(7, uid);
		ps_check.setTimestamp(8, timeStamp);
		ps_check.setInt(9, 1);
		up = ps_check.executeUpdate();
		if(up>0){
			PreparedStatement ps_ct = con.prepareStatement("select MAX(id) as maxid from rel_SAPmaster_fileUpload");
			ResultSet rs_ct = ps_ct.executeQuery();
			while (rs_ct.next()) {
				ct = rs_ct.getInt("maxid");
			}		
			
			PreparedStatement ps_blb = con.prepareStatement("select * from rel_SAPmaster_fileUpload where id=" + ct);
			ResultSet rs_blb = ps_blb.executeQuery();
			while (rs_blb.next()) {
				Blob blob = rs_blb.getBlob("attachment");
				InputStream in = blob.getBinaryStream();
				ArrayList alistFile = new ArrayList();
				
				File folder = new File("C:/reportxls");
				File[] listOfFiles = folder.listFiles();
				String listname = "";
				val = listOfFiles.length + 1;
				
				File exlFile = new File("C:/reportxls/MasterBulkUpload" + val + ".xls");
				OutputStream out = new FileOutputStream(exlFile);
				byte[] buff = new byte[4096]; 	// How much of the blob to
												// Read/write at a time
				int len = 0;
				while ((len = in.read(buff)) != -1) {
					out.write(buff, 0, len);
				}
			}
//*******************************************************************************************************************************************************************	
			String EXCEL_FILE_LOCATION = "C://reportxls/MasterBulkUpload" + val + ".xls"; 
			Workbook wrk1 = Workbook.getWorkbook(new File(EXCEL_FILE_LOCATION)); 
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy");				
 			/* ____________________________________________________________________________________________________ */
			Sheet sheet1 = wrk1.getSheet(0);
			int rows = sheet1.getRows();
			
			  
			int cols = sheet1.getColumns();
			int cnt = 0;
			ArrayList errorList = new ArrayList();
			ArrayList errorFinalList = new ArrayList();
			ArrayList uploadedMaster = new ArrayList();
			ArrayList plantMaster = new ArrayList();
			SendMail_DAO sendMail = new SendMail_DAO();
			
			if(rows>=11){
				
					for (int i = 1; i < rows; i++) {
						Cell sNo = sheet1.getCell(0, i);
						Cell plant = sheet1.getCell(1, i);
						Cell matType = sheet1.getCell(2, i);
						Cell matName = sheet1.getCell(3, i);
						Cell qty = sheet1.getCell(4, i);
						Cell storage_loc = sheet1.getCell(5, i);
						Cell uom = sheet1.getCell(6, i);
						Cell matGroup = sheet1.getCell(7, i);
						Cell rate = sheet1.getCell(8, i);
						Cell contactNo = sheet1.getCell(9, i);
						Cell hsnNo = sheet1.getCell(10, i);
						Cell reason = sheet1.getCell(11, i);  
						
						 String str_sNo=sNo.getContents();
						 String str_plant=plant.getContents();
						 String str_matType=matType.getContents();
						 String str_matName=matName.getContents();
						 String str_qty=qty.getContents(); 
						 String str_storage_loc=storage_loc.getContents(); 
						 String str_uom=uom.getContents();
						 String str_matGroup=matGroup.getContents(); 
						 String str_rate=rate.getContents();
						 String str_contactNo=contactNo.getContents();
						 String str_hsnNo=hsnNo.getContents();
						 String str_reason=reason.getContents();
						
						str_matType = str_matType.replaceAll("\"", "");
						str_matType = str_matType.replaceAll("\'", "");
						str_matType = str_matType.toUpperCase(); 
						
						str_matName = str_matName.replaceAll("\"", "");
						str_matName = str_matName.replaceAll("\'", "");
						str_matName = str_matName.toUpperCase();
						
						str_qty = str_qty.replaceAll("\"", "");
						str_qty = str_qty.replaceAll("\'", "");   
						
						str_storage_loc = str_storage_loc.replaceAll("\"", "");
						str_storage_loc = str_storage_loc.replaceAll("\'", "");
						str_storage_loc = str_storage_loc.toUpperCase();
						
						str_uom = str_uom.replaceAll("\"", "");
						str_uom = str_uom.replaceAll("\'", "");
						str_uom = str_uom.toUpperCase();
						
						str_matGroup = str_matGroup.replaceAll("\"", "");
						str_matGroup = str_matGroup.replaceAll("\'", "");
						
						str_rate = str_rate.replaceAll("\"", "");
						str_rate = str_rate.replaceAll("\'", "");
						
						str_contactNo = str_contactNo.replaceAll("\"", "");
						str_contactNo = str_contactNo.replaceAll("\'", "");
						
						str_hsnNo = str_hsnNo.replaceAll("\"", "");
						str_hsnNo = str_hsnNo.replaceAll("\'", "");
						
						str_reason = str_reason.replaceAll("\"", "");
						str_reason = str_reason.replaceAll("\'", "");
						str_reason = str_reason.toUpperCase();
						 
						String str_strLocation_Descr="";
						
		// Material Name Logic Here
		if(!str_matName.equalsIgnoreCase("") || !str_matName.equalsIgnoreCase(null)){
		ps_check  = con.prepareStatement("select * from tran_SAPmaster_create where enable=1 and stage_no in (1,2,3) and  materialType='"+str_matType+"' and materialName='"+str_matName+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			errorList.add(str_sNo + " " + str_matName + " Already Available...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Already Available...!!!");  
			//System.out.println("mat name 1 = = " + str_matName);
		}
		
		ps_check  = con.prepareStatement("select * from rel_SAPmaster_mm60 where enable=1 and material_type='"+str_matType+"' and material_description='"+str_matName+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			errorList.add(str_sNo + " " + str_matName + " Already Available...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Already Available...!!!");  
			//System.out.println("mat name 1 = = " + str_matName);
		} 
		
		
		}else{ 
			errorList.add(str_sNo + " " + str_matName + " Blank Data...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Blank Data...!!!");
		}
		
		
		if(str_matName.length()>40){
			errorList.add(str_sNo + " " + str_matName + " Material Length Exceeded..max 40 Required..!");    // ..........Length is not valid
			errorFinalList.add(str_sNo + " " + str_matName + " Material Length Exceeded..max 40 Required..!");
		}
		
		
		
		
		/// Storage location Logic Here
		ps_check  = con.prepareStatement("SELECT id,code,descr FROM master_data where  tablekey='storage_loc' and enable=1 and plant='"+str_plant+"' and code='"+str_storage_loc+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			str_strLocation_Descr = rs_check.getString("descr");
			//  All OK...
		}else{
			errorList.add(str_sNo + " " + str_matName + " Storage Location Error ...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Storage Location Error ...!!!");
		}
 
		/// Plant Logic Here
		
		ps_check  = con.prepareStatement("SELECT  id,code,descr  FROM master_data where tablekey='plant' and plant='' and enable=1 and code='"+str_plant+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
		//  All OK...
		}else{
			errorList.add(str_sNo + " " + str_matName + " Plant Data Error ...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Plant Data Error ...!!!");
		}
		
		/// Material Type Logic Here
		
		ps_check  = con.prepareStatement("SELECT id,mat_type,mat_typeDescr FROM stocktaking_mattype where enable=1 and mat_type='"+str_matType+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			//  All OK...
		}else{
			errorList.add(str_sNo + " " + str_matName + " Material Type Data Error ...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Material Type Data Error ...!!!");
		}
		
		
		
		/// Qty Logic Here 
		if(str_qty.equalsIgnoreCase("") || str_qty.equalsIgnoreCase(null)){
			str_qty="1";
		}
		
		/// UOM Logic Here
		
		ps_check  = con.prepareStatement("SELECT id,code,descr  FROM master_data where tablekey='baseUOM' and enable=1 and code='"+str_uom+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			//  All OK...
		}else{
			errorList.add(str_sNo + " " + str_matName + " Unit Of Measure Data Error ...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Unit Of Measure Data Error ...!!!"); 
		}				
		
		/// Material Group Logic Here
		
		ps_check  = con.prepareStatement("SELECT  id,code,descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code='"+str_matGroup+"'");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			//  All OK...
		}else{
			errorList.add(str_sNo + " " + str_matName + " Material Group Data Error ...!!!");    // ...........Error Occurred Here
			errorFinalList.add(str_sNo + " " + str_matName + " Material Group Data Error ...!!!"); 
		}
		
		/// Rate Logic Here 
		
		if(str_rate.equalsIgnoreCase("") || str_rate.equalsIgnoreCase(null)){
			errorList.add(str_sNo + " " + str_matName + " Material Amount Data Error ...!!!");
			errorFinalList.add(str_sNo + " " + str_matName + " Material Amount Data Error ...!!!"); 
		}
		
		/// Contact No Logic Here 
		
		if(str_contactNo.equalsIgnoreCase("") || str_contactNo.equalsIgnoreCase(null)){
			errorList.add(str_sNo + " " + str_matName + " Contact Number Data Error ...!!!");
			errorFinalList.add(str_sNo + " " + str_matName + " Contact Number Data Error ...!!!");
		}
		
		/// HSN No Logic Here 
		if(str_hsnNo.length()<=8 && str_hsnNo.length()!=0){
			ps_check3 = con.prepareStatement("select * from rel_SAPmaster_HSN where enable=1 and hsnCode='"+str_hsnNo+"'");
			rs_check3 = ps_check3.executeQuery();
			if(rs_check3.next()){
			}else{
				errorList.add(str_sNo + " " + str_matName + " HSN Data Error ...!!!");
				errorFinalList.add(str_sNo + " " + str_matName + " HSN Data Error ...!!!"); 
			}
		}
		 
		
		/// Reason Logic Here  
		if(str_reason.equalsIgnoreCase("") || str_reason.equalsIgnoreCase(null)){
			errorList.add(str_sNo + " " + str_matName + " Reason Data Error ...!!!");
			errorFinalList.add(str_sNo + " " + str_matName + " Reason Data Error ...!!!");
		}
		 
		//System.out.println("errorList = " + errorList);
		if(errorList.size()<=0){
			String pendingAt="";
			ps_check1 = con.prepareStatement("SELECT distinct(statDisplay) stat FROM rel_SAPmaster_releaseStrategy where stageNo=1 and enable=1");
			rs_check1 =ps_check1.executeQuery();
			while (rs_check1.next()) {
			pendingAt = rs_check1.getString("stat");
			}
			// System.err.println("In Loop = " + str_material + " = = = " + sql_lastChange_Date);
			ps_check1 = con.prepareStatement("insert into tran_SAPmaster_create"
			 		+ "(plant,materialType,materialName,uom,materialGroup,storageLocation,plant_toExtend,price,contactNo,hsn_code,reason,status,"
			 		+ "qty,created_by,created_date,enable,changed_by,changed_date,stage_no,location_id,fileupload_id,status_id,log_date) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			 
			ps_check1.setString(1, str_plant);
			ps_check1.setString(2, str_matType);
			ps_check1.setString(3, str_matName);
			ps_check1.setString(4, str_uom);
			ps_check1.setString(5, str_matGroup);
			ps_check1.setString(6, str_storage_loc);
			ps_check1.setString(7, str_plant);
			ps_check1.setString(8, str_rate);
			ps_check1.setString(9, str_contactNo);
			ps_check1.setString(10, str_hsnNo);
			ps_check1.setString(11, str_reason);
			ps_check1.setString(12, pendingAt);
			ps_check1.setString(13, str_qty); 
			ps_check1.setInt(14, uid);
			ps_check1.setTimestamp(15,timeStamp);
			ps_check1.setInt(16, 1);
			ps_check1.setInt(17, uid);
			ps_check1.setTimestamp(18, timeStamp);
			ps_check1.setInt(19, 1);
			ps_check1.setString(20, str_storage_loc);
			ps_check1.setInt(21, ct);
			ps_check1.setString(22, "CRTD");
			ps_check1.setTimestamp(23, timeStamp);
			
			fileUpload =ps_check1.executeUpdate();
			
			
			plantMaster.add(str_plant);
			ps_check  = con.prepareStatement("select MAX(id) as id from tran_SAPmaster_create");
			rs_check = ps_check.executeQuery();
			while(rs_check.next()) {
				uploadedMaster.add(String.valueOf(rs_check.getInt("id")));
			}
			errorList.clear();
		}
			errorList.clear(); 
		}		
		}else{
			errorFinalList.add("Bulk Upload File used with More than 10 Material Codes Only..!!!");
		}
					
		
			if(uploadedMaster.size()>0){
				String subject = "Bulk Upload facility used for New Material Master Creation in SAP";
				
			// ---------------------------------------------------------------------------------------------------------------------------
				ArrayList emailList = new ArrayList();
				 LinkedHashSet hashSet = new LinkedHashSet(plantMaster);
			     ArrayList plantData = new ArrayList(hashSet);
			      
			    for(int i=0;i<plantData.size();i++){ 
				ps_check = con.prepareStatement("SELECT email FROM rel_SAPmaster_releaseStrategy where enable=1 and stageNo=1 and plant='"+plantData.get(i).toString()+"'");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					emailList.add(rs_check.getString("email"));
				}
			    }
				
				emailList.add(emailUser);
				
				StringBuilder sb = new StringBuilder();
				
				sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Master Creation System !!! ***</b>");
			    sb.append("<p>New Material Master updated using Bulk Upload Facility...!!!</P>");	 
				sb.append("<table border='1' width='100%'>"+ 
	"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
		"<th>Plant</th>"+
		"<th>Material Type</th>"+
		"<th>Material Name</th>"+
		"<th>Qty</th>"+ 
		"<th>UOM</th>"+
		"<th>Material Group</th>"+
		"<th>Required In</th>"+
		"<th>Amount</th>"+
		"<th>Contact No</th>"+
		"<th>HSN NO</th>"+
		"<th>Reason</th>"+
		"</tr>"); 
			for(int i=0;i<uploadedMaster.size();i++){	
				ps_check  = con.prepareStatement("select * from tran_SAPmaster_create where id="+ Integer.valueOf(uploadedMaster.get(i).toString()));
				rs_check = ps_check.executeQuery();
				while(rs_check.next()) {
					String mat_group="";
					ps_check1 = con.prepareStatement("SELECT descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code="+rs_check.getString("materialGroup"));
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()) {
						mat_group=rs_check1.getString("descr");
					}
	sb.append("<tr style='font-size: 12px; border-width: 1px; padding: 2px; border-style: solid; border-color: #666666;'>"+
		"<td align='right'>"+rs_check.getString("plant")+"</td>"+
		"<td>"+rs_check.getString("materialType")+"</td>"+
		"<td>"+rs_check.getString("materialName")+"</td>"+
		"<td align='right'>"+rs_check.getString("qty")+"</td>"+ 
		"<td>"+rs_check.getString("uom")+"</td>"+
		"<td>"+mat_group+"</td>"+
		"<td>"+rs_check.getString("plant_toExtend")+"</td>"+
		"<td align='right'>"+rs_check.getString("price")+"</td>"+
		"<td align='right'>"+rs_check.getString("contactNo")+"</td>"+
		"<td align='right'>"+rs_check.getString("hsn_code")+"</td>"+
		"<td>"+rs_check.getString("reason")+"</td>"+
		"</tr>"); 
				}
			}
				sb.append("</table>"
						+ "<p><b>For more details ,</b> "
						+ "<a href='http://192.168.0.7/facilitytracker/'>Click Here (In House)</a>,"
						+ "  <a href='http://157.119.206.42/facilitytracker/'>Click Here (Outside Mutha Group)</a></p>" 
						+ "<p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
						+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
						+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
						+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
						+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
						+ "</font></p>"); 
				
				flag = sendMail.senMail(emailList,subject,sb);	
				
		// ---------------------------------------------------------------------------------------------------------------------------		
			}
			 
		if(fileUpload>0 && flag==true){ 
			/*response.sendRedirect("Master_Create_BulkUpload.jsp?success="+success);	*/
			RequestDispatcher rd = request.getRequestDispatcher("/Master_Create_BulkUpload.jsp");
			request.setAttribute("logData", errorFinalList);
			rd.forward(request, response);	
		}else{
			RequestDispatcher rd = request.getRequestDispatcher("/Master_Create_BulkUpload.jsp");
			request.setAttribute("logData", errorFinalList);
			rd.forward(request, response);		
		}
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	
	
	
	
	
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	
	public void add_newMaterial(HttpServletResponse response, StockTaking_VO vo, HttpSession session) {
		 try {
			 int ct=0,up=0,val = 0;
			 SendMail_DAO sendMail = new SendMail_DAO();
			 boolean flag=false;
			 int uid = Integer.valueOf(session.getAttribute("uid").toString());
			 String emailUser = session.getAttribute("email_id").toString();
				Connection con = Connection_Util.getConnectionMaster();
				Connection conlocal = Connection_Util.getLocalUserConnection();
				PreparedStatement ps_check1 = null, ps_check = null,ps_user=null, ps_check2 = null;
				ResultSet rs_check = null, rs_check1 = null, rs_check2 = null;
				String success="Success", statusNop = "Issue Occurred", location="",location_code="";
				String subject = "";
				// *******************************************************************************************************************************************************************
				java.util.Date date = null;
				java.sql.Timestamp timeStamp = null;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
				java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
				timeStamp = new java.sql.Timestamp(date.getTime());
				
				long millis=System.currentTimeMillis();
			    java.sql.Date todaysdate=new java.sql.Date(millis);
			    
			    String plantExtend = vo.getPlant1010() + "," + vo.getPlant1020() + "," + vo.getPlant1030() + "," + vo.getPlant1050() + "," + vo.getPlant2010() + "," + vo.getPlant2020() + "," + vo.getPlant3010();
			    plantExtend = plantExtend.replaceAll(",,,,,,", ",");
			    plantExtend = plantExtend.replaceAll(",,,,,", ",");
			    plantExtend = plantExtend.replaceAll(",,,,", ",");
			    plantExtend = plantExtend.replaceAll(",,,", ",");
			    plantExtend = plantExtend.replaceAll(",,", ","); 
				// *******************************************************************************************************************************************************************
				
			    ps_check1 = con.prepareStatement("SELECT id,code,descr FROM master_data where  tablekey='storage_loc' and enable=1 and plant='"+vo.getPlant()+"' and code='" +vo.getLocation()+"'");
			    rs_check1 = ps_check1.executeQuery();
			    while (rs_check1.next()) {
					location = rs_check1.getString("descr");
					location_code = rs_check1.getString("code");
				}
			    
			    String pendingAt="";
			    ps_check1 = con.prepareStatement("SELECT distinct(statDisplay) stat FROM rel_SAPmaster_releaseStrategy where stageNo=1 and enable=1");
			    rs_check1 = ps_check1.executeQuery();
			    while (rs_check1.next()) {
			    	pendingAt = rs_check1.getString("stat");
				}
			    
				String query = "", query_ins="";
				 
				if(vo.getEditid()==0){
					subject = "New Material : "+vo.getMat_name() +" required in SAP";
				// =============================================================================================================
				// ============================================== New Material Create ==========================================
				if(vo.getFileName()!=""){
					query = "insert into tran_SAPmaster_create"
							+ "(plant,materialType,materialName,uom,materialGroup,storageLocation,plant_toExtend,price,contactNo,hsn_code,reason,status,"
							+ "qty,created_by,created_date,enable,changed_by,changed_date,stage_no,location_id,fileupload_id,filename,attachment,status_id,log_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				}else{
					query = "insert into tran_SAPmaster_create"
							+ "(plant,materialType,materialName,uom,materialGroup,storageLocation,plant_toExtend,price,contactNo,hsn_code,reason,status,"
							+ "qty,created_by,created_date,enable,changed_by,changed_date,stage_no,location_id,fileupload_id,status_id,log_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				}				
				ps_check = con.prepareStatement(query);
				ps_check.setString(1, vo.getPlant());
				ps_check.setString(2, vo.getMat_type());
				ps_check.setString(3, vo.getMat_name());
				ps_check.setString(4, vo.getUom());
				ps_check.setString(5, vo.getMat_group());
				ps_check.setString(6, location);
				ps_check.setString(7, plantExtend);
				ps_check.setString(8, vo.getRate());
				ps_check.setString(9, vo.getContact());
				ps_check.setString(10, vo.getHsn_no());
				ps_check.setString(11, vo.getReason()); 
				ps_check.setString(12, pendingAt);				
				ps_check.setInt(13, vo.getQty()); 
				ps_check.setInt(14, uid);
				ps_check.setDate(15, todaysdate);
				ps_check.setInt(16, 1);				
				ps_check.setInt(17, uid);
				ps_check.setTimestamp(18, timeStamp); 
				ps_check.setInt(19, 1);				
				ps_check.setString(20, location_code);  	
				ps_check.setInt(21, 0);
				
				if(vo.getFileName()!=""){
				ps_check.setString(22, vo.getFileName());
				ps_check.setBlob(23, vo.getFile_blob());
				ps_check.setString(24, "CRTD");
				ps_check.setTimestamp(25, timeStamp); 
				}else{
					ps_check.setString(22, "CRTD");
					ps_check.setTimestamp(23, timeStamp); 
				}
				// =============================================================================================================
				// ============================================= Edit Material Create ==========================================
				}else{
					ps_check1 = con.prepareStatement("select * from tran_SAPmaster_create where id="+vo.getEditid());
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()) {
						query_ins = "insert into rel_SAPmaster_create_history"
								+ "(newMaster_id,plant,materialType,materialName,uom,materialGroup,location_id,storageLocation,plant_toExtend,price,contactNo,hsn_code,reason,status_id,status,qty,created_by,created_date,enable,changed_by,changed_date,stage_no,fileupload_id,filename,attachment,material_code,log_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
					
						ps_check = con.prepareStatement(query_ins);
						ps_check.setInt(1,vo.getEditid());
						ps_check.setString(2,rs_check1.getString("plant"));
						ps_check.setString(3,rs_check1.getString("materialType"));
						ps_check.setString(4,rs_check1.getString("materialName"));
						ps_check.setString(5,rs_check1.getString("uom"));
						ps_check.setString(6,rs_check1.getString("materialGroup"));
						ps_check.setString(7,rs_check1.getString("location_id"));
						ps_check.setString(8,rs_check1.getString("storageLocation"));
						ps_check.setString(9,rs_check1.getString("plant_toExtend"));
						ps_check.setString(10,rs_check1.getString("price"));
						ps_check.setString(11,rs_check1.getString("contactNo"));
						ps_check.setString(12,rs_check1.getString("hsn_code"));
						ps_check.setString(13,rs_check1.getString("reason"));
						ps_check.setString(14,rs_check1.getString("status_id"));
						ps_check.setString(15,rs_check1.getString("status"));
						ps_check.setInt(16,rs_check1.getInt("qty"));
						ps_check.setInt(17,rs_check1.getInt("created_by"));
						ps_check.setDate(18,rs_check1.getDate("created_date"));
						ps_check.setInt(19,rs_check1.getInt("enable"));
						ps_check.setInt(20,rs_check1.getInt("changed_by"));
						ps_check.setTimestamp(21,rs_check1.getTimestamp("changed_date"));
						ps_check.setInt(22,rs_check1.getInt("stage_no"));
						ps_check.setInt(23,rs_check1.getInt("fileupload_id"));
						ps_check.setString(24,rs_check1.getString("filename"));
						ps_check.setBlob(25,rs_check1.getBlob("attachment"));
						ps_check.setString(26,rs_check1.getString("material_code"));
						ps_check.setTimestamp(27,rs_check1.getTimestamp("log_date")); 
					//System.out.println(vo.getEditid() + "upload = = " + vo.getHsn_no() + "  = = " + rs_check1.getString("hsn_code"));
					   int upme = ps_check.executeUpdate();
					}
				
					
					
					subject = "Corrections Updated in New Material : "+vo.getMat_name() +" required in SAP";
					if(vo.getFileName()!=""){
						query = "update tran_SAPmaster_create set "
								+ "plant=?,materialType=?,materialName=?,uom=?,materialGroup=?,storageLocation=?,plant_toExtend=?,price=?,contactNo=?,hsn_code=?,reason=?,"
								+ "qty=?,changed_by=?,changed_date=?,location_id=?,filename=?,attachment=? where id="+vo.getEditid();
					}else{
						query = "update tran_SAPmaster_create set "
								+ "plant=?,materialType=?,materialName=?,uom=?,materialGroup=?,storageLocation=?,plant_toExtend=?,price=?,contactNo=?,hsn_code=?,reason=?,"
								+ "qty=?,changed_by=?,changed_date=?,location_id=? where id="+vo.getEditid();
					}
					
					ps_check = con.prepareStatement(query);
					ps_check.setString(1, vo.getPlant());
					ps_check.setString(2, vo.getMat_type());
					ps_check.setString(3, vo.getMat_name());
					ps_check.setString(4, vo.getUom());
					ps_check.setString(5, vo.getMat_group());
					ps_check.setString(6, location);
					ps_check.setString(7, plantExtend);
					ps_check.setString(8, vo.getRate());
					ps_check.setString(9, vo.getContact());
					ps_check.setString(10, vo.getHsn_no());
					ps_check.setString(11, vo.getReason()); 
					ps_check.setInt(12, vo.getQty()); 
					ps_check.setInt(13, uid);
					ps_check.setTimestamp(14, timeStamp); 
					ps_check.setString(15, location_code);  
					
					if(vo.getFileName()!=""){
					ps_check.setString(16, vo.getFileName());
					ps_check.setBlob(17, vo.getFile_blob());
					}
					
					
					
				}
				//System.out.println(query + " = = " + subject);
				// =============================================================================================================
				// =============================================================================================================
				
				
				ct = ps_check.executeUpdate();
				
				String mat_group="";
				ps_check = con.prepareStatement("SELECT descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code="+vo.getMat_group());
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					mat_group=rs_check.getString("descr");
				}
				
				if(ct>0){
					/**********************************************************************************************************/
					/**********************************************************************************************************/
					ArrayList emailList = new ArrayList();
					ps_check = con.prepareStatement("SELECT email FROM rel_SAPmaster_releaseStrategy where enable=1 and stageNo=1 and plant='"+vo.getPlant()+"'");
					rs_check = ps_check.executeQuery();
					while (rs_check.next()) {
						emailList.add(rs_check.getString("email"));
					}
					
					if(vo.getAppr()==1){
						ps_check = con.prepareStatement("select created_by from tran_SAPmaster_create where id="+vo.getEditid());
						rs_check = ps_check.executeQuery();
						while (rs_check.next()) {
							ps_check1 = conlocal.prepareStatement("SELECT U_Email FROM user_tbl where u_id="+rs_check.getInt("created_by"));
							rs_check1 = ps_check1.executeQuery();
							while (rs_check1.next()) {
								emailList.add(rs_check1.getString("U_Email"));		
							}
						}
					}
					
					emailList.add(emailUser);
					
					StringBuilder sb = new StringBuilder();
					
					sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Master Creation System !!! ***</b>");
					if(vo.getEditid()==0){
						sb.append("<p>New Material Master Request is received : </P>");
					}else{
						sb.append("<p>New Material Master updated with corrections...!!!</P>");	
					}
					sb.append("<table border='1' width='100%'>"+ 
		"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
			"<th>Plant</th>"+
			"<th>Material Type</th>"+
			"<th>Material Name</th>"+
			"<th>Qty</th>"+
			/*"<th>Location Used</th>"+*/
			"<th>UOM</th>"+
			"<th>Material Group</th>"+
			"<th>Required In</th>"+
			"<th>Amount</th>"+
			"<th>Contact No</th>"+
			"<th>HSN NO</th>"+
			"<th>Reason</th>"+
			"</tr>"); 
					
		sb.append("<tr style='font-size: 12px; border-width: 1px; padding: 2px; border-style: solid; border-color: #666666;'>"+
			"<td align='right'>"+vo.getPlant()+"</td>"+
			"<td>"+vo.getMat_type()+"</td>"+
			"<td>"+vo.getMat_name()+"</td>"+
			"<td align='right'>"+vo.getQty()+"</td>"+
			/*"<td>"+vo.getLocation()+"</td>"+*/
			"<td>"+vo.getUom()+"</td>"+
			"<td>"+mat_group+"</td>"+
			"<td>"+plantExtend+"</td>"+
			"<td align='right'>"+vo.getRate()+"</td>"+
			"<td align='right'>"+vo.getContact()+"</td>"+
			"<td align='right'>"+vo.getHsn_no()+"</td>"+
			"<td>"+vo.getReason()+"</td>"+
			"</tr>"); 
					sb.append("</table>"
							+ "<p><b>For more details ,</b> "
							+ "<a href='http://192.168.0.7/facilitytracker/'>Click Here (In House)</a>,"
							+ "  <a href='http://157.119.206.42/facilitytracker/'>Click Here (Outside Mutha Group)</a></p>" 
							+ "<p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
							+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
							+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
							+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
							+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
							+ "</font></p>"); 
					flag = sendMail.senMail(emailList,subject,sb);
					/**********************************************************************************************************/
			if(flag==true && vo.getEditid()==0 && vo.getAppr()==0){
				response.sendRedirect("Master_Create.jsp?success='Success'&appr="+vo.getAppr());
			}else if(flag==true && vo.getEditid()!=0 && vo.getAppr()==0) {
				response.sendRedirect("Master_Home.jsp?success='Success'&appr="+vo.getAppr());
			}else if(flag==false && vo.getEditid()==0 && vo.getAppr()==0){
				response.sendRedirect("Master_Create.jsp?statusNop='Issue Occurred...'&appr="+vo.getAppr());
			}else if(flag==false && vo.getEditid()!=0 && vo.getAppr()==0) {
				response.sendRedirect("Master_Home.jsp?statusNop='Issue Occurred...'&appr="+vo.getAppr());
				
			}else if(flag==true && vo.getEditid()!=0 && vo.getAppr()==1) {
				response.sendRedirect("Master_Approval.jsp?success='Success'&appr="+vo.getAppr());
			}else if(flag==false && vo.getEditid()!=0 && vo.getAppr()==1) {
				response.sendRedirect("Master_Approval.jsp?statusNop='Issue Occurred...'&appr="+vo.getAppr());
			}
			else if(flag==true && vo.getEditid()!=0 && vo.getAppr()==2) {
					response.sendRedirect("Master_Generate.jsp?success='Success'");
			}else if(flag==false && vo.getEditid()!=0 && vo.getAppr()==2) {
					response.sendRedirect("Master_Generate.jsp?statusNop='Issue Occurred...'");
			}
					
			}else if(vo.getEditid()==0){
						response.sendRedirect("Master_Create.jsp?success='Success'&appr="+vo.getAppr());
			}else {
						response.sendRedirect("Master_Home.jsp?success='Success'&appr="+vo.getAppr());
			} 
				
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ HSN Bulk Upload +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

	public void attachHSN_File(HttpServletResponse response, StockTaking_VO bean, HttpSession session) {
		try {
			 int ct=0,up=0,val = 0;
			 int uid = Integer.valueOf(session.getAttribute("uid").toString());
				Connection con = Connection_Util.getConnectionMaster();
				PreparedStatement ps_check1 = null, ps_check = null,ps_user=null;
				ResultSet rs_check = null;
				String success="Upload Success", statusNop = "Upload having issues";
				// *******************************************************************************************************************************************************************
				java.util.Date date = null;
				java.sql.Timestamp timeStamp = null;
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
				java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
				timeStamp = new java.sql.Timestamp(date.getTime());

				// *******************************************************************************************************************************************************************
				ps_check = con.prepareStatement("insert into rel_SAPmaster_fileUpload "
		+ "(filename,attachment,contact_no,reason,created_by,created_date,changed_by,changed_date,enable) values(?,?,?,?,?,?,?,?,?)");
		ps_check.setString(1, bean.getFileName());
		ps_check.setBlob(2, bean.getFile_blob());
		ps_check.setString(3, bean.getContact());
		ps_check.setString(4, " HSN Sheet " + bean.getReason());
		ps_check.setInt(5, uid);
		ps_check.setTimestamp(6, timeStamp);
		ps_check.setInt(7, uid);
		ps_check.setTimestamp(8, timeStamp);
		ps_check.setInt(9, 1);
		up = ps_check.executeUpdate();
		if(up>0){
			PreparedStatement ps_ct = con.prepareStatement("select MAX(id) as maxid from rel_SAPmaster_fileUpload");
			ResultSet rs_ct = ps_ct.executeQuery();
			while (rs_ct.next()) {
				ct = rs_ct.getInt("maxid");
			}		
			
			PreparedStatement ps_blb = con.prepareStatement("select * from rel_SAPmaster_fileUpload where id=" + ct);
			ResultSet rs_blb = ps_blb.executeQuery();
			while (rs_blb.next()) {
				Blob blob = rs_blb.getBlob("attachment");
				InputStream in = blob.getBinaryStream();
				ArrayList alistFile = new ArrayList();
				
				File folder = new File("C:/reportxls");
				File[] listOfFiles = folder.listFiles();
				String listname = "";
				val = listOfFiles.length + 1;
				
				File exlFile = new File("C:/reportxls/MasterBulkHSN" + val + ".xls");
				OutputStream out = new FileOutputStream(exlFile);
				byte[] buff = new byte[4096]; // how much of the blob to
												// read/write at a time
				int len = 0;
				while ((len = in.read(buff)) != -1) {
					out.write(buff, 0, len);
				}
			}
// *******************************************************************************************************************************************************************	
			String EXCEL_FILE_LOCATION = "C://reportxls/MasterBulkHSN" + val + ".xls";
			
			Workbook wrk1 = Workbook.getWorkbook(new File(EXCEL_FILE_LOCATION));
			
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy");				
  			/* ____________________________________________________________________________________________________ */
			Sheet sheet1 = wrk1.getSheet(0);
			int rows = sheet1.getRows();
			int cols = sheet1.getColumns(); 
			int cnt = 0;
					for (int i = 1; i < rows; i++) {
						Cell client = sheet1.getCell(0, i);
						Cell countryCode = sheet1.getCell(1, i);
						Cell hsnCode = sheet1.getCell(2, i);
						Cell desc1 = sheet1.getCell(3, i);
						Cell desc2 = sheet1.getCell(4, i);
						Cell desc3 = sheet1.getCell(5, i);
						Cell desc4 = sheet1.getCell(6, i);
						Cell desc5 = sheet1.getCell(7, i); 


						String str_client=client.getContents();
						String str_countryCode=countryCode.getContents();
						String str_hsnCode=hsnCode.getContents();
						String str_desc1=desc1.getContents();
						String str_desc2=desc2.getContents();
						String str_desc3=desc3.getContents();
						String str_desc4=desc4.getContents();
						String str_desc5=desc5.getContents(); 

						str_client = str_client.replaceAll("\"", "");
						str_client = str_client.replaceAll("\'", "");
						
						str_countryCode = str_countryCode.replaceAll("\"", "");
						str_countryCode = str_countryCode.replaceAll("\'", "");
						
						str_hsnCode = str_hsnCode.replaceAll("\"", "");
						str_hsnCode = str_hsnCode.replaceAll("\'", "");
						
						str_desc1 = str_desc1.replaceAll("\"", "");
						str_desc1 = str_desc1.replaceAll("\'", "");
						
						str_desc2 = str_desc2.replaceAll("\"", "");
						str_desc2 = str_desc2.replaceAll("\'", "");
						
						str_desc3 = str_desc3.replaceAll("\"", "");
						str_desc3 = str_desc3.replaceAll("\'", "");
						
						str_desc4 = str_desc4.replaceAll("\"", "");
						str_desc4 = str_desc4.replaceAll("\'", "");
						
						str_desc5 = str_desc5.replaceAll("\"", "");
						str_desc5 = str_desc5.replaceAll("\'", "");
						
						 
		if(!str_desc1.equalsIgnoreCase("")){
		//System.out.println(" str_countryCode " + str_countryCode);
		ps_check  = con.prepareStatement("select * from rel_SAPmaster_HSN where hsnCode ='"+str_hsnCode+"' and enable=1");
		rs_check = ps_check.executeQuery();
		if (rs_check.next()) {
			//System.out.println("Already Available = " + str_material + " = = = " + sql_lastChange_Date);
		}else{
			// System.err.println("In Loop = " + str_material + " = = = " + sql_lastChange_Date);
			ps_check1 = con.prepareStatement("insert into rel_SAPmaster_HSN"
					+ "(client,countryCode,hsnCode,desc1,desc2,desc3,desc4,desc5,created_date,created_by,changed_date,changed_by,enable) values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_check1.setString(1, str_client);
			ps_check1.setString(2, str_countryCode);
			ps_check1.setString(3, str_hsnCode);
			ps_check1.setString(4, str_desc1);
			ps_check1.setString(5, str_desc2);
			ps_check1.setString(6, str_desc3);
			ps_check1.setString(7, str_desc4);
			ps_check1.setString(8, str_desc5);
			ps_check1.setTimestamp(9, timeStamp);
			ps_check1.setInt(10, uid);
			ps_check1.setTimestamp(11, timeStamp);
			ps_check1.setInt(12, uid);
			ps_check1.setInt(13, 1);
			up = ps_check1.executeUpdate(); 
					}
				}
			}
			if(up>0){
				response.sendRedirect("Master_Data_UploadHSN.jsp?success="+success);
			}else{
				response.sendRedirect("Master_Data_UploadHSN.jsp?statusNop="+statusNop);				
			}
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	} 
	
}
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
