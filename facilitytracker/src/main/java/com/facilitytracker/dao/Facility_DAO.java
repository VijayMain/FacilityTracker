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

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.Facility_VO;

public class Facility_DAO {

	public void facility_Upload(HttpSession session, Facility_VO vo,
			HttpServletResponse response) {
		try {
			PreparedStatement ps_check = null;
			ResultSet rs_check = null;
			boolean flag = false;
			Connection con = Connection_Util.getLocalUserConnection();
			ArrayList emailList = new ArrayList();
			String host = "", user = "", pass = "", from = "", smtpPort = "", query = "", prioritySet = "", assignedCompany = "", assignedDept = "";
			int uid = Integer.parseInt(session.getAttribute("uid").toString()), maxId = 0, comp_id = Integer
					.parseInt(session.getAttribute("comp_id").toString());
			String deptName = session.getAttribute("deptName").toString(), username = session
					.getAttribute("username").toString(), email_id = session
					.getAttribute("email_id").toString();
			emailList.add(email_id);
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm"); 
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
			date = simpleDateFormat.parse(dt.toString() + " "
					+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			// *******************************************************************************************************************************************************************

			ps_check = con
					.prepareStatement("insert into facility_req_tbl(requester_id,requester_comp_id,assigned_comp_id,facility_for,status_id,assigned_dept_id,priority,"
							+ "issue_found,attach_img_name,attach_image,attach_doc_name,attach_document,problem_date,sys_date,enable,changedby,changed_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_check.setInt(1, uid);
			ps_check.setInt(2, comp_id);
			ps_check.setInt(3, vo.getCompany());
			ps_check.setInt(4, vo.getFacility_for());
			ps_check.setInt(5, 1);
			ps_check.setInt(6, vo.getResp_dept());
			ps_check.setInt(7, vo.getPriority());
			ps_check.setString(8, vo.getIssue());
			ps_check.setString(9, vo.getFile_imageName());
			ps_check.setBlob(10, vo.getFile_image());
			ps_check.setString(11, vo.getFile_docName());
			ps_check.setBlob(12, vo.getFile_doc());
			ps_check.setTimestamp(13, timeStamp);
			ps_check.setTimestamp(14, timeStamp);
			ps_check.setInt(15, 1);
			ps_check.setInt(16, uid);
			ps_check.setTimestamp(17, timeStamp);

			int up = ps_check.executeUpdate();

			if (up > 0) {
				ps_check = con
						.prepareStatement("SELECT max(id) as id FROM facility_req_tbl");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					maxId = rs_check.getInt("id");
				}

				ps_check = con
						.prepareStatement("SELECT Company_Name FROM user_tbl_company where Company_Id="
								+ vo.getCompany());
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					assignedCompany = rs_check.getString("Company_Name");
				}

				ps_check = con
						.prepareStatement("SELECT Department FROM user_tbl_dept where dept_id="
								+ vo.getResp_dept());
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					assignedDept = rs_check.getString("Department");
				}

				ps_check = con.prepareStatement("select U_Email from user_tbl where Enable_id=1 and Dept_Id=" + vo.getResp_dept());
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					emailList.add(rs_check.getString("U_Email"));
				}
				/**********************************************************************************************************/
				ps_check = con.prepareStatement("select mail_id from facility_req_tbl_mailer where enable=1 and mail_for='new'");
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					emailList.add(rs_check.getString("mail_id"));
				}
				/**********************************************************************************************************/
				String[] recipients = new String[emailList.size()];
				for (int e = 0; e < emailList.size(); e++) {
					recipients[e] = emailList.get(e).toString();
				}

				ps_check = con
						.prepareStatement("select * from facility_tbl_priority where id="
								+ vo.getPriority());
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					prioritySet = rs_check.getString("name");
				}

				query = "select * from domain_config where enable=1";
				ps_check = con.prepareStatement(query);
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					host = rs_check.getString("hostName");
					user = rs_check.getString("userName");
					pass = rs_check.getString("pass");
					from = rs_check.getString("mailFrom");
					smtpPort = rs_check.getString("smtpPort");
				}

				String subject = "Facility Management New Request Received : "
						+ prioritySet;
				boolean sessionDebug = false;

				Properties props = System.getProperties();
				props.put("mail.host", host);
				props.put("mail.transport.protocol", "smtp");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.port", smtpPort);

				Session mailSession = Session.getDefaultInstance(props, null);
				mailSession.setDebug(sessionDebug);
				Message msg = new MimeMessage(mailSession);
				msg.setFrom(new InternetAddress(from));
				InternetAddress[] addressTo = new InternetAddress[recipients.length];

				for (int p = 0; p < recipients.length; p++) {
					addressTo[p] = new InternetAddress(recipients[p]);
				}

				msg.setRecipients(Message.RecipientType.TO, addressTo);

				msg.setSubject(subject);
				msg.setSentDate(new Date());

				StringBuilder sb = new StringBuilder();

				sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Facility Management !!! ***</b>");
				sb.append("<p>New Facility Requirement is received : </P>");

				sb.append("<table border='1' width='100%'>"
						+ "<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid;border-color: #729ea5;text-align: center;'>"
						+ "<th>Issue Statement</th>" + "<th>Requester</th>"
						+ "<th>Assigned Company</th>"
						+ "<th>Assigned Dept.</th>"
						+ "<th>Registered Date</th>" + "<th>Priority</th>"
						+ "<th>Status</th>" + "</tr>");

				ps_check = con
						.prepareStatement("SELECT * FROM facility_req_tbl where id="
								+ maxId);
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
					sb.append("<tr>"
							+ "<td style='text-align: left;'>"
							+ rs_check.getString("issue_found")
							+ "</td>"
							+ "<td style='text-align: left;'>"
							+ username
							+ "</td>"
							+ "<td style='text-align: left;'>"
							+ assignedCompany
							+ "</td>"
							+ "<td style='text-align: left;'>"
							+ assignedDept
							+ "</td>"
							+ "<td style='text-align: left;'>"
							+ mailDateFormat.format(rs_check
									.getTimestamp("sys_date")) + "</td>"
							+ "<td style='text-align: left;'>" + prioritySet
							+ "</td>"
							+ "<td style='text-align: left;'>New</td>"
							+ "</tr>");
					flag = true;
				}
				sb.append("</table>");

				sb.append("<p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
						+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
						+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
						+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
						+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
						+ "</font></p>");

				BodyPart messageBodyPart = new MimeBodyPart();
				messageBodyPart.setContent(sb.toString(), "Text/html");
				if (flag = true) {
					msg.setContent(sb.toString(), "text/html");
					Transport transport = mailSession.getTransport("smtp");
					transport.connect(host, user, pass);
					transport.sendMessage(msg, msg.getAllRecipients());
					transport.close();
					response.sendRedirect("Home.jsp?success='Well done...! New Request is successfully registered...'");
				} else {
					response.sendRedirect("Home.jsp?success='Something went wrong...! Please check the data...'");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**********************************************************************************************************************************/
	/******************************************************** Action On Request *******************************************************/
	/**********************************************************************************************************************************/

	public void facility_ActionUpload(HttpSession session, Facility_VO vo,
			HttpServletResponse response) {
		try {
			PreparedStatement ps_check = null,ps_check1=null,ps_check2=null;
			ResultSet rs_check = null,rs_check1=null,rs_check2=null;
			boolean flag = false;
			Connection con = Connection_Util.getLocalUserConnection();
			ArrayList emailList = new ArrayList();
			String host = "", user = "", pass = "", from = "",status ="", attend_By="", req_by="", smtpPort = "", query = "",  assignedCompany = "",dept_assgn="",prioritySet="";
			int assignedComp=0,assignedDept=0, cnt=1;
			
			int uid = Integer.parseInt(session.getAttribute("uid").toString()), maxId = 0, comp_id = Integer
					.parseInt(session.getAttribute("comp_id").toString());
			String deptName = session.getAttribute("deptName").toString(), username = "", 
					email_id = session.getAttribute("email_id").toString();
			emailList.add(email_id);
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
			
			ps_check1 = con.prepareStatement("select * from user_tbl where U_Id="+vo.getAttended_by());
			rs_check1 = ps_check1.executeQuery();
			while(rs_check1.next()){
				assignedComp = rs_check1.getInt("Company_Id");
				assignedDept = rs_check1.getInt("Dept_Id");
				attend_By=rs_check1.getString("U_Name");
			}
			
			
			ps_check = con.prepareStatement("SELECT max(Solution_count) as id FROM facility_req_tbl_rel where fm_id="+vo.getFm_ID());
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				maxId = rs_check.getInt("id");
			}
			maxId++;
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			date = simpleDateFormat.parse(dt.toString() + " "+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			
			// *******************************************************************************************************************************************************************
			ps_check = con.prepareStatement("insert into facility_req_tbl_rel(fm_id,status_id,solution_given,attach_img_name,attach_image,attach_doc_name,attach_document,attendedby_Uid,updated_by,attended_comp_id,attendeddept_id,attended_date,sys_date,next_followup,enable,changedby,changed_date,Solution_count)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_check.setInt(1,vo.getFm_ID());
			ps_check.setInt(2,vo.getStatus_id());
			ps_check.setString(3,vo.getSolution()); 
			ps_check.setString(4, vo.getFile_imageName());
			ps_check.setBlob(5, vo.getFile_image());
			ps_check.setString(6, vo.getFile_docName());
			ps_check.setBlob(7, vo.getFile_doc()); 
			  ps_check.setInt(8,vo.getAttended_by()); 
			  ps_check.setInt(9,uid);
			  ps_check.setInt(10,assignedComp) ;
			  ps_check.setInt(11,assignedDept);
			  ps_check.setTimestamp(12,timeStamp); 
			  ps_check.setTimestamp(13,timeStamp);
			  ps_check.setInt(14,vo.getFollowup()); 
			  ps_check.setInt(15,1);
			  ps_check.setInt(16,uid); 
			  ps_check.setTimestamp(17,timeStamp);
			  ps_check.setInt(18,maxId);
			  
			  int up = ps_check.executeUpdate();
			 
			  ps_check=con.prepareStatement("update facility_req_tbl set status_id=?,changedby=?,changed_date=? where id="+vo.getFm_ID());
			  ps_check.setInt(1, vo.getStatus_id());
			  ps_check.setInt(2, uid);
			  ps_check.setTimestamp(3, timeStamp);
			  up=ps_check.executeUpdate();
			  

			if (up > 0) {
				ps_check = con.prepareStatement("SELECT * FROM facility_req_tbl where id="+vo.getFm_ID());
				rs_check = ps_check.executeQuery();
				while (rs_check.next()) {
 
					ps_check1 = con.prepareStatement("select * from user_tbl where U_Id="+rs_check.getInt("requester_id"));
					rs_check1 = ps_check1.executeQuery();
					while(rs_check1.next()){ 
						req_by=rs_check1.getString("U_Name");
					}
					
				ps_check1 = con.prepareStatement("SELECT Department FROM user_tbl_dept where dept_id="
								+ rs_check.getInt("assigned_dept_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					dept_assgn= rs_check1.getString("Department");
				}
				
				ps_check1 = con.prepareStatement("SELECT Company_Name FROM user_tbl_company where Company_Id="
						+ rs_check.getInt("assigned_comp_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
						assignedCompany= rs_check1.getString("Company_Name");
				}
				

				ps_check1 = con.prepareStatement("select * from status_tbl where Status_Id=" + rs_check.getInt("status_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					status = rs_check1.getString("Status");
				}
				
				ps_check1 = con.prepareStatement("select * from facility_tbl_priority where id=" + rs_check.getInt("priority"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					prioritySet = rs_check1.getString("name");
				}
				
				
				ps_check1 = con.prepareStatement("SELECT distinct(U_Email) as U_Email FROM user_tbl where Enable_id=1 and Dept_Id=" + rs_check.getInt("assigned_dept_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					emailList.add(rs_check1.getString("U_Email"));
				}
				
				/**********************************************************************************************************/
				ps_check1 = con.prepareStatement("select mail_id from facility_req_tbl_mailer where enable=1 and mail_for='new'");
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					emailList.add(rs_check1.getString("mail_id"));
				}
				/**********************************************************************************************************/
				
				
				String[] recipients = new String[emailList.size()];
				for (int e = 0; e < emailList.size(); e++) {
					recipients[e] = emailList.get(e).toString();
				}
 
				query = "select * from domain_config where enable=1";
				ps_check1 = con.prepareStatement(query);
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					host = rs_check1.getString("hostName");
					user = rs_check1.getString("userName");
					pass = rs_check1.getString("pass");
					from = rs_check1.getString("mailFrom");
					smtpPort = rs_check1.getString("smtpPort");
				}

				String subject = "Facility Management Action Taken on T. No : " + vo.getFm_ID();
				boolean sessionDebug = false;

				Properties props = System.getProperties();
				props.put("mail.host", host);
				props.put("mail.transport.protocol", "smtp");
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.port", smtpPort);

				Session mailSession = Session.getDefaultInstance(props, null);
				mailSession.setDebug(sessionDebug);
				Message msg = new MimeMessage(mailSession);
				msg.setFrom(new InternetAddress(from));
				InternetAddress[] addressTo = new InternetAddress[recipients.length];

				for (int p = 0; p < recipients.length; p++) {
					addressTo[p] = new InternetAddress(recipients[p]);
				}

				msg.setRecipients(Message.RecipientType.TO, addressTo);

				msg.setSubject(subject);
				msg.setSentDate(new Date());

				StringBuilder sb = new StringBuilder();

				sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Facility Management !!! ***</b>");
				sb.append("<p>Solution Given on Facility Requirement : </P>");

				sb.append("<table border='1' width='100%'>"
						+ "<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid;border-color: #729ea5;text-align: center;'>"
						+ "<th>Issue Statement</th>"
						+ "<th>Requester</th>"
						+ "<th>Assigned Company</th>"
						+ "<th>Assigned Dept.</th>"
						+ "<th>Registered Date</th><th>Priority</th>"
						+ "<th>Status</th></tr>"); 
					sb.append("<tr> <td style='text-align: left;'>"
							+ rs_check.getString("issue_found")
							+ "</td> <td style='text-align: left;'>"
							+ req_by
							+ "</td> <td style='text-align: left;'>"
							+ assignedCompany
							+ "</td> <td style='text-align: left;'>"
							+ dept_assgn
							+ "</td> <td style='text-align: left;'>"
							+ mailDateFormat.format(rs_check.getTimestamp("sys_date")) 
							+ "</td> <td style='text-align: left;'>" + prioritySet
							+ "</td> <td style='text-align: left;'>"+status+"</td>"
							+ "</tr></table>");
					
					sb.append("<table border='1' width='100%'>"
							+ "<tr style='font-size: 12px; background-color: #85f57f; border-width: 1px; padding: 8px; border-style: solid;border-color: #729ea5;text-align: center;'>" + 
							"<th>Solution Given</th>" + 
							"<th>Solution Given By</th>" + 
							"<th>Status</th>" + 
							"<th>Extra Days Required</th>" + 
							"<th>Solution Date</th>" +   
							"</tr>");
					
					ps_check1 = con.prepareStatement("SELECT * FROM facility_req_tbl_rel where enable=1 and fm_id=" + vo.getFm_ID() +" order by Solution_count");
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()) {  
						ps_check2 = con.prepareStatement("select * from user_tbl where U_Id="+rs_check1.getInt("attendedby_Uid"));
						rs_check2 = ps_check2.executeQuery();
						while(rs_check2.next()){
							attend_By = rs_check2.getString("U_Name");
						}
						ps_check2 = con.prepareStatement("select * from status_tbl where Status_Id=" + rs_check1.getInt("status_id"));
						rs_check2 = ps_check2.executeQuery();
						while (rs_check2.next()) {
							status = rs_check2.getString("Status");
						}
					sb.append("<tr><td><strong> "+cnt+" </strong> "+rs_check1.getString("solution_given")+"</td>" + 
							"<td>"+attend_By+"</td>" + 
							"<td>"+status+"</td>" + 
							"<td>"+rs_check1.getString("next_followup")+"</td>" + 
							"<td>"+mailDateFormat.format(rs_check1.getTimestamp("attended_date")) +"</td>" +  
							"</tr>");
					cnt++;
					flag = true;
				}
				sb.append("</table><p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
						+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
						+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
						+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
						+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
						+ "</font></p>");

				BodyPart messageBodyPart = new MimeBodyPart();
				messageBodyPart.setContent(sb.toString(), "Text/html");
				if (flag = true) {
					msg.setContent(sb.toString(), "text/html");
					Transport transport = mailSession.getTransport("smtp");
					transport.connect(host, user, pass);
					transport.sendMessage(msg, msg.getAllRecipients());
					transport.close();
					response.sendRedirect("Action_Resp.jsp?success='Solution is successfully registered...'&hid="+vo.getFm_ID());
				} else {
					response.sendRedirect("Action_Resp.jsp?success='Something went wrong...!'&hid="+vo.getFm_ID());
				}
				
				
			}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void getReport(Facility_VO vo, HttpSession session,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			PreparedStatement ps_check = null,ps_check1=null,ps_check2=null;
			SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
			ResultSet rs_check = null,rs_check1=null,rs_check2=null;
			ArrayList queryList = new ArrayList();
			boolean flag = false;
			Connection con = Connection_Util.getLocalUserConnection();
			
			String comp="", priority="", facility="", resp_dept="";
			
			if(vo.getCompany()==6){
				comp = "";
			}else{
				comp = " and assigned_comp_id="+vo.getCompany();
			}
			
			if(vo.getPriority()==0){
				priority="";
			}else{
				priority = " and priority="+vo.getPriority();
			}
			
			if(vo.getFacility_for()==0){
				facility = "";
			}else{
				facility = " and facility_for=" + vo.getFacility_for();
			}
			
			if(vo.getResp_dept()==0){
				resp_dept = "";
			}else {
				resp_dept =" and assigned_dept_id="+vo.getResp_dept();
			}
			
			String query = "SELECT * FROM facility_req_tbl where enable=1 and problem_date between '" + vo.getFromDate()+ "' and  '" + vo.getToDate() + "' " + comp + priority + facility + resp_dept;
			queryList.add(query);
			
			

			
			
			ArrayList alistFile = new ArrayList();
			File folder = new File("C:/reportxls");
			File[] listOfFiles = folder.listFiles();
			String listname = "";

			int val = listOfFiles.length + 1;
			String fileName = "C:/reportxls/facility"+val+".xls";
			File exlFile = new File(fileName);
			queryList.add(fileName);
			
			
			WritableWorkbook writableWorkbook = Workbook.createWorkbook(exlFile); 


			Colour bckcolor = Colour.TURQUOISE;
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

			WritableCellFormat cellFormatWrap = new WritableCellFormat();
			cellFormatWrap.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
			font.setColour(Colour.BLACK); 
			cellFormatWrap.setFont(font);
			cellFormatWrap.setAlignment(Alignment.RIGHT); 
			cellFormatWrap.setWrap(true);

			WritableCellFormat cellleftformat = new WritableCellFormat(); 
			cellleftformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
			font.setColour(Colour.BLACK); 
			cellleftformat.setFont(font); 	
			cellleftformat.setAlignment(Alignment.LEFT);

			WritableSheet writableSheet = writableWorkbook.createSheet("FM Requests", 0);
			writableSheet.setColumnView(0, 5);
			writableSheet.setColumnView(1, 40);
			writableSheet.setColumnView(2, 20);
			writableSheet.setColumnView(3, 20);
			writableSheet.setColumnView(4, 20);
			writableSheet.setColumnView(5, 20);
			writableSheet.setColumnView(6, 25);
			writableSheet.setColumnView(7, 25);
			writableSheet.setColumnView(8, 15); 

			Label label0 = new Label(0, 0, "T. No",cellFormat);
			Label label1 = new Label(1, 0, "Issue Statement",cellFormat);
			Label label2 = new Label(2, 0, "Facility",cellFormat);
			Label label3 = new Label(3, 0, "Requester",cellFormat);
			Label label4 = new Label(4, 0, "Assigned Company",cellFormat);
			Label label5 = new Label(5, 0, "Assigned Dept.",cellFormat);
			Label label6 = new Label(6, 0, "Registered Date",cellFormat);
			Label label7 = new Label(7, 0, "Priority",cellFormat); 
			Label label8 = new Label(8, 0, "Status",cellFormat); 

			// Add the created Cells to the sheet
			writableSheet.addCell(label0);
			writableSheet.addCell(label1);
			writableSheet.addCell(label2);
			writableSheet.addCell(label3);
			writableSheet.addCell(label4);
			writableSheet.addCell(label5);
			writableSheet.addCell(label6);
			writableSheet.addCell(label7); 
			writableSheet.addCell(label8); 

			WritableSheet writableSheet1 = writableWorkbook.createSheet("Solutions", 1);
			writableSheet1.setColumnView(0, 10);
			writableSheet1.setColumnView(1, 10);
			writableSheet1.setColumnView(2, 40);
			writableSheet1.setColumnView(3, 30);
			writableSheet1.setColumnView(4, 20);
			writableSheet1.setColumnView(5, 10);
			writableSheet1.setColumnView(6, 30);
			 
			Label act1 = new Label(0, 0, "T.No",cellFormat);
			Label act2 = new Label(1, 0, "Sol.No",cellFormat);
			Label act3 = new Label(2, 0, "Solution Given",cellFormat);
			Label act4 = new Label(3, 0, "Sol Given By",cellFormat);
			Label act5 = new Label(4, 0, "Status",cellFormat);
			Label act6 = new Label(5, 0, "Extra Days Requested",cellFormat);
			Label act7 = new Label(6, 0, "Solution Date",cellFormat);

			// Add the created Cells to the sheet
			writableSheet1.addCell(act1);
			writableSheet1.addCell(act2);
			writableSheet1.addCell(act3);
			writableSheet1.addCell(act4);
			writableSheet1.addCell(act5);
			writableSheet1.addCell(act6);
			writableSheet1.addCell(act7);
			

			int r=1,s=1;
			ps_check = con.prepareStatement(query);
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				
				Label tNO = new Label(0, r, String.valueOf(rs_check.getInt("id")),cellRIghtformat);
				writableSheet.addCell(tNO);
				
				Label issue_found = new Label(1, r, rs_check.getString("issue_found"),cellleftformat);
				writableSheet.addCell(issue_found);
				  
				ps_check1 = con.prepareStatement("select * from facility_tbl where id="+rs_check.getInt("facility_for"));
				rs_check1 = ps_check1.executeQuery();
				while(rs_check1.next()){ 
					Label fac_for = new Label(2, r, rs_check1.getString("name"),cellleftformat);
					writableSheet.addCell(fac_for);
				} 
				
				
				ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" + rs_check.getInt("requester_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					Label uName = new Label(3, r, rs_check1.getString("U_Name"),cellleftformat);
					writableSheet.addCell(uName);
				}
				
				ps_check1 = con.prepareStatement("select Company_Name from user_tbl_company where Company_Id=" + rs_check.getInt("assigned_comp_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					Label labComp = new Label(4, r, rs_check1.getString("Company_Name"),cellleftformat);
					writableSheet.addCell(labComp);
				}
				
				ps_check1 = con.prepareStatement("select Department from user_tbl_dept where dept_id=" + rs_check.getInt("assigned_dept_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					Label labdept = new Label(5, r, rs_check1.getString("Department"),cellleftformat);
					writableSheet.addCell(labdept);
				}
				
				Label problem_date = new Label(6, r, mailDateFormat.format(rs_check.getTimestamp("problem_date")),cellleftformat);
				writableSheet.addCell(problem_date);
				 
				ps_check1 = con.prepareStatement("select name from facility_tbl_priority where id=" + rs_check.getInt("priority"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					Label labname = new Label(7, r, rs_check1.getString("name"),cellleftformat);
					writableSheet.addCell(labname);
				}
				
				ps_check1 = con.prepareStatement("select Status from status_tbl where Status_Id=" + rs_check.getInt("status_id"));
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
					Label labstatus = new Label(8, r, rs_check1.getString("Status"),cellleftformat);
					writableSheet.addCell(labstatus);
				}
		/************************************************************************************************************************************/			
				ps_check1 = con.prepareStatement("select * from facility_req_tbl_rel where fm_id=" + rs_check.getInt("id") +" order by Solution_count desc");
				rs_check1 = ps_check1.executeQuery();
				while (rs_check1.next()) {
		
				Label labtNO = new Label(0, s, rs_check1.getString("fm_id"),cellRIghtformat);
				writableSheet1.addCell(labtNO);
				
				Label labSolNO = new Label(1, s, rs_check1.getString("id"),cellRIghtformat);
				writableSheet1.addCell(labSolNO);
				
				Label solution_given = new Label(2, s, rs_check1.getString("solution_given"),cellleftformat);
				writableSheet1.addCell(solution_given);
				
				ps_check1 = con.prepareStatement("select U_Name from user_tbl where U_Id=" + rs_check1.getInt("attendedby_Uid"));
				rs_check2 = ps_check1.executeQuery();
				while (rs_check2.next()) {
					Label labSU_Name = new Label(3, s, rs_check2.getString("U_Name"),cellleftformat);
					writableSheet1.addCell(labSU_Name);
				}
				
				ps_check1 = con.prepareStatement("select Status from status_tbl where Status_Id=" + rs_check1.getInt("status_id"));
				rs_check2 = ps_check1.executeQuery();
				while (rs_check2.next()) {
					Label labstatus = new Label(4,s, rs_check2.getString("Status"),cellleftformat);
					writableSheet1.addCell(labstatus);
				}
				
				Number labextra = new Number(5, s, rs_check1.getInt("next_followup"),cellRIghtformat);
				writableSheet1.addCell(labextra);
				
				Label labSolDate = new Label(6, s, mailDateFormat.format(rs_check1.getTimestamp("attended_date")),cellRIghtformat);
				writableSheet1.addCell(labSolDate);
		/************************************************************************************************************************************/
				s++;
				}
				r++; 
			} 
			rs_check.close(); 


			writableWorkbook.write();
			writableWorkbook.close();
			//************************************************************************************************************************
			//************************************************ File Output Ligic *****************************************************
			//************************************************************************************************************************
			 
			RequestDispatcher rd = request.getRequestDispatcher("/Reports.jsp");
			request.setAttribute("queryList", queryList);  
			rd.forward(request, response);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**********************************************************************************************************************************/
	/**********************************************************************************************************************************/
}
