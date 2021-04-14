package com.facilitytracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date; 

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.SixSigma_ProblemVO;

public class SixSigma_ProblemDAO {

	public void problemRegistration(SixSigma_ProblemVO vo,
			HttpServletResponse response, HttpSession session) {
		// **********************************************************************************************************************
		// **********************************************************************************************************************
		try {
			boolean flag=false;
			SendMail_DAO sendMail=new SendMail_DAO();
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString();
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
			
			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis=System.currentTimeMillis();
		    java.sql.Date todaysdate=new java.sql.Date(millis); 
			// *******************************************************************************************************************************************************************
			String materialDescr="";
			PreparedStatement ps_check=null,ps_check1=null,ps_data=null;
			ResultSet rs_check=null,rs_check1=null,rs_data=null;
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			String status="Already Available..!";
			
			/*ps_check = con_master.prepareStatement("select * from tran_pt_problem where enable=1 and plant='"+
			vo.getPlant()+"' and dept_id="+ vo.getDept()+ " and problem_descr='"+vo.getProduct_descr()
			+"' and product_code='"+vo.getSearch_product()+"'");
			rs_check = ps_check.executeQuery();
			if (rs_check.next()) {
				response.sendRedirect("SixSigma_NewProject.jsp?statusNop="+status);
			}else{*/
				
				ps_check1 = con_master.prepareStatement("SELECT material_description FROM rel_SAPmaster_mm60 where id="+vo.getMtCode());
			    rs_check1 = ps_check1.executeQuery();
			     while(rs_check1.next()){
			    	 materialDescr = rs_check1.getString("material_description");
			     } 
			     
			     ps_check = con_master.prepareStatement("insert into  tran_pt_problem"
			    		 + "(plant,dept_id,problem_descr,"
			    		 + "product_code,product_codeDescr,type_product_code,"
			    		 + "created_by,created_byName,log_date,changed_by,changed_byName,changed_date,tran_date,enable,typeProject,phase_id,approval_id)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
				ps_check.setString(1, 	vo.getPlant());
				ps_check.setInt(2, 	vo.getDept());
				ps_check.setString(3, 	vo.getProblem()); 
				ps_check.setInt(4, 	vo.getMtCode()); 
				ps_check.setString(5, materialDescr);
				ps_check.setString(6, 	vo.getProduct_descr()); 
				ps_check.setInt(7, 	uid);
				ps_check.setString(8, uname); 
				ps_check.setTimestamp(9, 	timeStamp);
				ps_check.setInt(10, 	uid);
				ps_check.setString(11, uname); 
				ps_check.setTimestamp(12, 	timeStamp);
				ps_check.setDate(13, 	todaysdate);
				ps_check.setInt(14, 	1);
				ps_check.setInt(15, vo.getTypeProject());
				ps_check.setInt(16, 	1);
				ps_check.setInt(17, 	1);
				int up = ps_check.executeUpdate();
				
				if(up>0){
					status = "Success...";
					int tran_id=0;
					String emailPlant="";
					ps_check1 = con_master.prepareStatement("select Max(id) as id from tran_pt_problem");
				    rs_check1 = ps_check1.executeQuery();
				     while(rs_check1.next()){
				    	 tran_id = rs_check1.getInt("id");
				     }
				     
				     ps_check1 = con.prepareStatement("select Company_Name from user_tbl_company where enable=1 and plant='"+vo.getPlant()+"'");
				     rs_check1 = ps_check1.executeQuery();
				     while (rs_check1.next()) { 
						 emailPlant = rs_check1.getString("Company_Name");
					 }
					
					String subject = "New Problem - "+vo.getProblem() + " @ " + vo.getPlant() + " - " + emailPlant;
					
					// ---------------------------------------------------------------------------------------------------------------------------
						ArrayList emailList = new ArrayList();
					       
						ps_check = con_master.prepareStatement("select appUser_email from rel_pt_releaseMaster where enable=1 and plant='"+vo.getPlant()+"' and seq_no=1");
						rs_check = ps_check.executeQuery();
						while (rs_check.next()) {
							emailList.add(rs_check.getString("appUser_email"));
						} 
						
						ps_check = con_master.prepareStatement("select appUser_email from rel_pt_teamSelect where enable=1 and problem_id="+tran_id);
						rs_check = ps_check.executeQuery();
						while (rs_check.next()) {
							emailList.add(rs_check.getString("appUser_email"));
						}
						ps_check = con_master.prepareStatement("select email from rel_pt_reviewer where enable=1");
						rs_check = ps_check.executeQuery();
						while (rs_check.next()) {
							emailList.add(rs_check.getString("email"));
						}
						ps_check = con_master.prepareStatement("select project_lead from tran_pt_problem where enable=1 and id="+tran_id);
						rs_check = ps_check.executeQuery();
						while (rs_check.next()) {
							ps_data = con.prepareStatement("SELECT u_email FROM user_tbl where u_id="+rs_check.getInt("project_lead"));
						    rs_data = ps_data.executeQuery();
						    while (rs_data.next()) {
						    	emailList.add(rs_data.getString("u_email"));
							 }
						}
						emailList.add(emailUser);
						
						
						StringBuilder sb = new StringBuilder();
						
						sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Six Sigma Portal !!! ***</b>"); 
						sb.append("<table border='1' width='100%'>"+
								"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
								"<th>No</th><th>Plant</th><th>Problem Description</th><th>Product Code</th><th>Product Description</th><th>Input Product Description</th><th>Type of Project</th><th>Logged by</th><th>Logged Date</th><th>Department</th></tr>"); 
					 
						String dept = "",typeProject="",matCode="";
						ps_check = con_master.prepareStatement("select * from tran_pt_problem where enable=1 and id="+tran_id);
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("dept_id"));
							rs_data = ps_data.executeQuery();
							while(rs_data.next()){
								dept = rs_data.getString("master_name");
							}
							ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("typeProject"));
							rs_data = ps_data.executeQuery();
							while(rs_data.next()){
								typeProject = rs_data.getString("master_name");
							}
							ps_data = con_master.prepareStatement("select material from rel_SAPmaster_mm60 where id="+rs_check.getInt("product_code"));
							rs_data = ps_data.executeQuery();
							while(rs_data.next()){
								matCode = rs_data.getString("material");
							}
						sb.append("<tr  style='font-size: 11px;'><td style='text-align: right;'>"+rs_check.getInt("id")+"</td><td>"+rs_check.getString("plant")+"</td><td>"+rs_check.getString("problem_descr")+"</td>"+
							"<td>"+matCode +"</td><td>"+rs_check.getString("product_codeDescr") +"</td><td>"+rs_check.getString("type_product_code") +"</td><td>"+typeProject+"</td><td>"+rs_check.getString("created_byName")+"</td><td>"+format.format(rs_check.getDate("tran_date")) +"</td><td>"+dept+"</td></tr>");
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
					 
					response.sendRedirect("SixSigma_NewProject.jsp?success="+status);
				}else{
					response.sendRedirect("SixSigma_NewProject.jsp?statusNop="+status);
				} 
			/*}*/
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// **********************************************************************************************************************
}