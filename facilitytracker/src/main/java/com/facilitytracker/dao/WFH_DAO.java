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
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
 


import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.WFH_VO;

public class WFH_DAO {

	public void attach_File(HttpServletResponse response, WFH_VO vo,
			HttpSession session) {
		try {
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;

			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()
					.getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
					"yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			date = simpleDateFormat.parse(dt.toString() + " "
					+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			int up = 0;
			// *******************************************************************************************************************************************************************
			if (vo.getFileName().equalsIgnoreCase("")) {
				ps_user = con.prepareStatement("update user_tbl set sap_id=?,changed_by=?,changed_date=?,phone_no=?,U_Email=? where U_Id=" + uid);
				ps_user.setString(1, vo.getSapCode());
				ps_user.setInt(2, uid);
				ps_user.setTimestamp(3, timeStamp);
				ps_user.setString(4, vo.getContact());
				ps_user.setString(5, vo.getEmail());

				up = ps_user.executeUpdate();
			} else {
				ps_user = con.prepareStatement("update user_tbl set sap_id=?,changed_by=?,changed_date=?,user_photoName=?,user_photo=?,phone_no=?,U_Email=? where U_Id=" + uid);
				ps_user.setString(1, vo.getSapCode());
				ps_user.setInt(2, uid);
				ps_user.setTimestamp(3, timeStamp);
				ps_user.setString(4, vo.getFileName());
				ps_user.setBlob(5, vo.getFile_blob());
				ps_user.setString(6, vo.getContact());
				ps_user.setString(7, vo.getEmail());

				up = ps_user.executeUpdate();
			} 
			if (up > 0) {
				 
				 String dataPart = vo.getTot_part();
				 String partList[] = dataPart.split(","); 
				  
				 LinkedHashSet<String> distPart = new LinkedHashSet<String>(Arrays.asList(partList));
			        
			     //create array from the LinkedHashSet
			     String[] participants = distPart.toArray(new String[ distPart.size() ]);
				  
				  for(int i=0; i< participants.length; i++){
				  	if(uid!=Integer.valueOf(participants[i].toString())){
					  
				  	ps_user = con_master.prepareStatement("insert into rel_userReportingManager"
				  	 	+ "(u_id,u_SAP_id,approver_id,enable_id,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?)");
						ps_user.setInt(1, uid);
						ps_user.setString(2, vo.getSapCode());
						ps_user.setInt(3, Integer.valueOf(participants[i].toString()));
						ps_user.setInt(4, 1); 
						ps_user.setInt(5, uid);
						ps_user.setTimestamp(6, timeStamp);
						ps_user.setInt(7, uid);
						ps_user.setTimestamp(8, timeStamp); 
						
						up=ps_user.executeUpdate();
				  	}	 
				  	}
				
				response.sendRedirect("Home.jsp");
			}else{
				String statusNop = "Upload Fail";
				response.sendRedirect("Home.jsp?statusNop="+statusNop);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int regDWM_Task(WFH_VO vo, HttpSession session) {
		int up = 0,up1 = 0, maxId = 0;
		try {
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getConnectionMaster();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
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
			 
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date trandate = sdf1.parse(vo.getTran_date());
			java.sql.Date sqltranDate = new java.sql.Date(trandate.getTime());

			// *******************************************************************************************************************************************************************
			ps_user = con	.prepareStatement("insert into tran_dwm_tasks(u_id,task_title,task_description,time_elapsed,enable_id,registered_by,sys_date,changed_by,changed_date,tran_date) values(?,?,?,?,?,?,?,?,?,?)");
			ps_user.setInt(1, uid);
			ps_user.setString(2, vo.getDwm_title());
			ps_user.setString(3, vo.getDwm_task_desc());
			ps_user.setString(4, vo.getTime_required());
			ps_user.setInt(5, 1);
			ps_user.setInt(6, uid);
			ps_user.setTimestamp(7, timeStamp);
			ps_user.setInt(8, uid);
			ps_user.setTimestamp(9, timeStamp);
			ps_user.setDate(10, sqltranDate);
			up = ps_user.executeUpdate();		
			
			
			if (up > 0) {
				ps_check = con.prepareStatement("SELECT max(id) as id FROM tran_dwm_tasks");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					maxId = rs_check.getInt("id");
				}
				
				ps_user = con.prepareStatement("insert into rel_dwm_approvers(dwm_id,u_id,registered_by,sys_date,changed_by,changed_date,enable_id) values(?,?,?,?,?,?,?)");
				ps_user.setInt(1, maxId);
				ps_user.setInt(2, vo.getTaskAssigned_By());
				ps_user.setInt(3, uid);
				ps_user.setTimestamp(4, timeStamp);
				ps_user.setInt(5, uid);
				ps_user.setTimestamp(6, timeStamp);
				ps_user.setInt(7, 1);
				
				up1=ps_user.executeUpdate();
				
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return maxId;
	}

	public boolean attachDWM_File(WFH_VO vo, HttpSession session) {
		boolean flag = false;
		int up = 0,up1 = 0, maxId = 0;
		try { 
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getConnectionMaster();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
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
			ps_user = con.prepareStatement("insert into rel_dwm_tasks_Attach(dwm_id,file_name,attachment,registered_by,sys_date,changed_by,changed_date,enable_id) values(?,?,?,?,?,?,?,?)");
			ps_user.setInt(1, vo.getDwm_id());
			ps_user.setString(2, vo.getFileName());
			ps_user.setBlob(3, vo.getFile_blob());
			ps_user.setInt(4, uid);
			ps_user.setTimestamp(5, timeStamp);
			ps_user.setInt(6, uid);
			ps_user.setTimestamp(7, timeStamp);
			ps_user.setInt(8, 1);
			
			up = ps_user.executeUpdate();
			
			if(up>0){
				flag=true;
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	public int regWFHProject(WFH_VO vo, HttpSession session) {
		int up = 0,up1 = 0, maxId = 0;
		String email="";
		try {
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getConnectionMaster();
			Connection conLocal = Connection_Util.getLocalUserConnection();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
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
			ps_user = con	.prepareStatement("insert into tran_wfh_project"
					+ "(project_title,project_description,remark,status_id,enable_id,registered_by,sys_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?)");
			ps_user.setString(1, vo.getPrj_title());
			ps_user.setString(2, vo.getPrj_desc());
			ps_user.setString(3, vo.getRemark_project());
			ps_user.setInt(4, 1);
			ps_user.setInt(5, 1);
			ps_user.setInt(6, uid);
			ps_user.setTimestamp(7, timeStamp);
			ps_user.setInt(8, uid);
			ps_user.setTimestamp(9, timeStamp);

			up = ps_user.executeUpdate();		
			
			
			if (up > 0) {
				ps_check = con.prepareStatement("SELECT max(id) as id FROM tran_wfh_project");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					maxId = rs_check.getInt("id");
				}
				
				ps_user = con.prepareStatement("insert into rel_project_approvers(project_id,u_id,registered_by,sys_date,changed_by,changed_date,enable_id) values(?,?,?,?,?,?,?)");
				ps_user.setInt(1, maxId);
				ps_user.setInt(2, uid);
				ps_user.setInt(3, uid);
				ps_user.setTimestamp(4, timeStamp);
				ps_user.setInt(5, uid);
				ps_user.setTimestamp(6, timeStamp);
				ps_user.setInt(7, 1); 
				up1=ps_user.executeUpdate();
				 
				  String dataPart = vo.getTot_part();
				  String partList[] = dataPart.split(","); 
				  
				  LinkedHashSet<String> distPart = new LinkedHashSet<String>(Arrays.asList(partList));
			        
			        //create array from the LinkedHashSet
			        String[] participants = distPart.toArray(new String[ distPart.size() ]);
				  
				  for(int i=0; i< participants.length; i++){
				  	ps_check = conLocal.prepareStatement("SELECT U_Email FROM user_tbl where U_Id="+Integer.valueOf(participants[i].toString()));
					rs_check = ps_check.executeQuery();
						while (rs_check.next()) {
							email = rs_check.getString("U_Email");
						}
				  	ps_user = con.prepareStatement("insert into rel_wfh_project_assignUsers"
				  	 	+ "(project_id,u_id,email_id,enable_id,registered_by,sys_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?)");
						ps_user.setInt(1, maxId);
						ps_user.setInt(2, Integer.valueOf(participants[i].toString()));
						ps_user.setString(3, email);
						ps_user.setInt(4, 1); 
						ps_user.setInt(5, uid);
						ps_user.setTimestamp(6, timeStamp);
						ps_user.setInt(7, uid);
						ps_user.setTimestamp(8, timeStamp); 
						
						up1=ps_user.executeUpdate();
						
						email="";
				  	}
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return maxId;
	}

	public boolean attachProject_File(WFH_VO vo, HttpSession session) {
		boolean flag = false;
		int up = 0,up1 = 0, maxId = 0;
		try { 
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getConnectionMaster();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
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
			ps_user = con.prepareStatement("insert into rel_wfh_project_Attach"
			+ "(project_id,file_name,attachment,registered_by,sys_date,changed_by,changed_date,enable_id) values(?,?,?,?,?,?,?,?)");
			ps_user.setInt(1, vo.getPrj_id());
			ps_user.setString(2, vo.getFileName());
			ps_user.setBlob(3, vo.getFile_blob());
			ps_user.setInt(4, uid);
			ps_user.setTimestamp(5, timeStamp);
			ps_user.setInt(6, uid);
			ps_user.setTimestamp(7, timeStamp);
			ps_user.setInt(8, 1);
			
			up = ps_user.executeUpdate();
			
			if(up>0){
				flag=true;
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public int regProject_Task(WFH_VO vo, HttpSession session) {
		int up = 0,up1 = 0, maxId = 0;
		try {
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getConnectionMaster();
			
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
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
			int count=0;
			ps_check = con.prepareStatement("SELECT counter FROM tran_wfh_project_task where project_id="+vo.getPrj_id()+" and enable_id=1");
			rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					count = rs_check.getInt("counter");
				}
			count++;
			
			ps_user = con	.prepareStatement("insert into tran_wfh_project_task"
		+ "(project_id,u_id,task_performed,remark,time_spent_mins,status_id,counter,enable_id,"
		+ "registered_by,sys_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_user.setInt(1, vo.getPrj_id());
			ps_user.setInt(2, uid);
			ps_user.setString(3, vo.getPrj_title());
			ps_user.setString(4, vo.getPrj_desc());
			ps_user.setString(5, vo.getTime_required());
			ps_user.setInt(6, vo.getStatus());
			ps_user.setInt(7, count);
			ps_user.setInt(8, 1); 
			ps_user.setInt(9, uid);
			ps_user.setTimestamp(10, timeStamp);
			ps_user.setInt(11, uid);
			ps_user.setTimestamp(12, timeStamp);

			up = ps_user.executeUpdate();
						
			if (up > 0) {
				ps_check = con.prepareStatement("SELECT max(id) as id FROM tran_wfh_project_task");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					maxId = rs_check.getInt("id");
				}  
			}
			vo.setMaxId(maxId);
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return maxId;
	}

	public boolean attachPrj_Task_File(WFH_VO vo, HttpSession session) {
		boolean flag = false;
		int up = 0,up1 = 0, maxId = 0;
		try { 
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con = Connection_Util.getConnectionMaster();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
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
			ps_user = con.prepareStatement("insert into rel_wfh_project_task_attach"
			+ "(project_id,projectTask_id,file_name,attachment,registered_by,sys_date,changed_by,changed_date,enable_id) values(?,?,?,?,?,?,?,?,?)");
			ps_user.setInt(1, vo.getPrj_id());
			ps_user.setInt(2, vo.getMaxId());
			ps_user.setString(3, vo.getFileName());
			ps_user.setBlob(4, vo.getFile_blob());
			ps_user.setInt(5, uid);
			ps_user.setTimestamp(6, timeStamp);
			ps_user.setInt(7, uid);
			ps_user.setTimestamp(8, timeStamp);
			ps_user.setInt(9, 1); 
			
			up = ps_user.executeUpdate();
			
			if(up>0){
				flag=true;
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------
	public void bulk_UploadDWM(WFH_VO bean, HttpServletResponse response, HttpSession session) {
		 try {
			 int ct=0,up=0,up1=0,val = 0,upload=0,rwCnt=1,loopcls=0,maxId=0,chk=0;
			 int uid = Integer.valueOf(session.getAttribute("uid").toString());
				Connection con = Connection_Util.getConnectionMaster();
				PreparedStatement ps_check1 = null, ps_check = null,ps_user=null;
				ResultSet rs_check1 = null, rs_check = null;
				String status="Upload Success";
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
	//------------------------------------------------------------------------------------------------------------------------------------
		ps_check = con.prepareStatement("insert into wfh_bulkupload"
						+ "(filename,attachment,file_type,sys_date,created_by,changed_by,changed_date,enable_id,approver_selected)values(?,?,?,?,?,?,?,?,?)");
		ps_check.setString(1, bean.getFileName());
		ps_check.setBlob(2, bean.getFile_blob());
		ps_check.setString(3, "DWM_upload");
		ps_check.setTimestamp(4, timeStamp);
		ps_check.setInt(5, uid);
		ps_check.setInt(6, uid);
		ps_check.setTimestamp(7, timeStamp);
		ps_check.setInt(8, 1);
		ps_check.setInt(9, bean.getTaskApprover());		
		up = ps_check.executeUpdate();
		if(up>0){
			PreparedStatement ps_ct = con.prepareStatement("select MAX(id) as maxid from wfh_bulkupload");
			ResultSet rs_ct = ps_ct.executeQuery();
			while (rs_ct.next()) {
				ct = rs_ct.getInt("maxid");
			}		
			
			PreparedStatement ps_blb = con.prepareStatement("select * from wfh_bulkupload where id=" + ct);
			ResultSet rs_blb = ps_blb.executeQuery();
			while (rs_blb.next()) {
				Blob blob = rs_blb.getBlob("attachment");
				InputStream in = blob.getBinaryStream();
				ArrayList alistFile = new ArrayList();
				
				File folder = new File("C:/reportxls");
				File[] listOfFiles = folder.listFiles();
				String listname = "";
				val = listOfFiles.length + 1;
				
				File exlFile = new File("C:/reportxls/wfh_dwm" + val + ".xls");
				OutputStream out = new FileOutputStream(exlFile);
				byte[] buff = new byte[4096]; // how much of the blob to
												// read/write at a time
				int len = 0;
				while ((len = in.read(buff)) != -1) {
					out.write(buff, 0, len);
				}
			}	
// *******************************************************************************************************************************************************************	
			String EXCEL_FILE_LOCATION = "C://reportxls/wfh_dwm" + val + ".xls";
			
			Workbook wrk1 = Workbook.getWorkbook(new File(EXCEL_FILE_LOCATION));
			
			SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy");				
  			/* ____________________________________________________________________________________________________ */
			Sheet sheet1 = wrk1.getSheet(0);
			int rows = sheet1.getRows();
			int cols = sheet1.getColumns(); 
			int cnt = 0; 
					for (int i = 1; i < rows; i++) {
						Cell task_performed=sheet1.getCell(1, i);
						Cell task_details=sheet1.getCell(2, i);
						Cell timespent=sheet1.getCell(3, i);
						Cell date_done=sheet1.getCell(4, i); 
						  
						String str_task_performed=task_performed.getContents();
						String str_task_details=task_details.getContents();
						String str_timespent=timespent.getContents();
						String str_date_done=date_done.getContents();
						
						java.sql.Date sql_tran_Date =null;
						if(str_date_done!=""){
							// System.out.println("str_date_done " + str_date_done);
							str_date_done = str_date_done.replace("/", "-");
							java.util.Date date_performed = sdf1.parse(str_date_done);
							sql_tran_Date = new java.sql.Date(date_performed.getTime()); 
						}
	// -----------------------------------------------------------------------------------------------------------------------------
				
						if(str_task_performed!="" && str_timespent!="0" && str_timespent!="" && sql_tran_Date!=null && str_timespent!=""){
						  
						if(Integer.valueOf(str_timespent)!=0){					
							str_task_performed = str_task_performed.replaceAll("\"", "");
							str_task_performed = str_task_performed.replaceAll("\'", "");							
							str_task_details = str_task_details.replaceAll("\"", "");
							str_task_details = str_task_details.replaceAll("\'", "");
							
							
							
							
							
							
							
							
							
							
						ps_user = con.prepareStatement("insert into tran_dwm_tasks(u_id,task_title,task_description,time_elapsed,enable_id,registered_by,sys_date,changed_by,changed_date,tran_date) values(?,?,?,?,?,?,?,?,?,?)");
						ps_user.setInt(1, uid);
						ps_user.setString(2, str_task_performed);
						ps_user.setString(3, str_task_details);
						ps_user.setString(4, str_timespent);
						ps_user.setInt(5, 1);
						ps_user.setInt(6, uid);
						ps_user.setTimestamp(7, timeStamp);
						ps_user.setInt(8, uid);
						ps_user.setTimestamp(9, timeStamp);
						ps_user.setDate(10, sql_tran_Date);
						chk = ps_user.executeUpdate();		
						
						
						if (chk > 0) {
							ps_check = con.prepareStatement("SELECT max(id) as id FROM tran_dwm_tasks");
							rs_check = ps_check.executeQuery();
							while (rs_check.next()) {
								maxId = rs_check.getInt("id");
							}
							
							ps_user = con.prepareStatement("insert into rel_dwm_approvers(dwm_id,u_id,registered_by,sys_date,changed_by,changed_date,enable_id) values(?,?,?,?,?,?,?)");
							ps_user.setInt(1, maxId);
							ps_user.setInt(2, bean.getTaskApprover());
							ps_user.setInt(3, uid);
							ps_user.setTimestamp(4, timeStamp);
							ps_user.setInt(5, uid);
							ps_user.setTimestamp(6, timeStamp);
							ps_user.setInt(7, 1);
							
							up1=ps_user.executeUpdate(); 
						} 
						
						
						
						
						
						
						
						
						
						
						
						
						}else{
							status ="File Uploaded with Errors..";
						}
						}else{
							status ="File Uploaded with Errors..";
						}
	// -----------------------------------------------------------------------------------------------------------------------------  
						sql_tran_Date =null;  
					} 
			response.sendRedirect("WFH_BulkUpload.jsp?status="+status);
		}else{
			response.sendRedirect("WFH_BulkUpload.jsp?statusNop=Upload Fail");
		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	} 
}
