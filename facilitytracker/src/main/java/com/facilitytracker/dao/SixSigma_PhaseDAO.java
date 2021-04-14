package com.facilitytracker.dao;
 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormatSymbols;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.SixSigma_ProblemVO;

public class SixSigma_PhaseDAO {

	public void phaseDataUpdate(SixSigma_ProblemVO vo,
			HttpServletResponse response, HttpSession session) {
		try {
			String status="";
			boolean flag=false;
			SendMail_DAO sendMail=new SendMail_DAO();
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString();
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
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
			String emailPlant="";
		    PreparedStatement ps_check=null,ps_check1=null,ps_data=null;
		    ResultSet rs_check=null,rs_check1=null,rs_data=null;
		    
		    ps_check = con_master.prepareStatement("insert into rel_pt_definePhase(problem_id,classProject,impactInternalCust,impactExtcustomer,dataAnalysis,"
		    		+ " crossFunctionalRating,expectedSaving,baselinePPM,baselinePPM_target,baseline,baseline_target,projectScore,enable,created_by,created_date,"
		    		+ " changed_by,changed_date,rateDefine) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		    ps_check.setInt(1, vo.getProblem_id());
		    ps_check.setInt(2, vo.getClassProject());
		    ps_check.setInt(3, vo.getImpact_intCust());
		    ps_check.setInt(4, vo.getImpact_extCust());
		    ps_check.setInt(5, vo.getDataAnalysis());
		    ps_check.setInt(6, vo.getCrossfun_rate());
		    ps_check.setFloat(7, vo.getExp_Saving());
		    ps_check.setFloat(8, vo.getBaselinePPM());
		    ps_check.setFloat(9, vo.getTargetPPM());
		    ps_check.setString(10, vo.getBaseline());
		    ps_check.setString(11, vo.getTarget_baseline());
		    ps_check.setFloat(12, vo.getProject_score());
		    ps_check.setInt(13, 1);
		    ps_check.setInt(14, uid);
		    ps_check.setTimestamp(15, timeStamp);
		    ps_check.setInt(16, uid);
		    ps_check.setTimestamp(17, timeStamp);
		    ps_check.setString(18, vo.getRateDefine());
		    int up = ps_check.executeUpdate();
		    
		    if(up>0){
		    	
		    	ArrayList emailList = new ArrayList(); 
		    	String subject = "";
					StringBuilder sb = new StringBuilder();
					
					sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Six Sigma Portal !!! ***</b>"); 
					sb.append("<table border='1' width='100%'>"+
							"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
							"<th>No</th><th>Plant</th><th>Problem Description</th><th>Product Code</th><th>Product Description</th><th>Input Product Description</th><th>Type of Project</th><th>Logged by</th><th>Logged Date</th><th>Department</th></tr>"); 
				 
					String dept = "",typeProject="",matCode="";
					ps_check = con_master.prepareStatement("select * from tran_pt_problem where enable=1 and id="+vo.getProblem_id());
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
				
						// ---------------------------------------------------------------------------------------------------------------------------
				    	 ps_check1 = con.prepareStatement("select Company_Name from user_tbl_company where enable=1 and plant='"+rs_check.getString("plant")+"'");
					     rs_check1 = ps_check1.executeQuery();
					     while (rs_check1.next()) {
							 emailPlant = rs_check1.getString("Company_Name");
						 } 
							   
							ps_check1 = con_master.prepareStatement("select appUser_email from rel_pt_releaseMaster where enable=1 and plant='"+rs_check.getString("plant")+"' and seq_no=1");
							rs_check1 = ps_check1.executeQuery();
							while (rs_check1.next()) {
								emailList.add(rs_check1.getString("appUser_email"));
							}
							
							
							ps_data = con_master.prepareStatement("select appUser_email from rel_pt_teamSelect where enable=1 and problem_id="+vo.getProblem_id());
							rs_data = ps_data.executeQuery();
							while (rs_data.next()) {
								emailList.add(rs_data.getString("appUser_email"));
							}
							
							ps_data = con_master.prepareStatement("select email from rel_pt_reviewer where enable=1");
							rs_data = ps_data.executeQuery();
							while (rs_data.next()) {
								emailList.add(rs_data.getString("email"));
							}
							 
								ps_data = con.prepareStatement("SELECT u_email FROM user_tbl where u_id="+rs_check.getInt("project_lead"));
							    rs_data = ps_data.executeQuery();
							    while (rs_data.next()) {
							    	emailList.add(rs_data.getString("u_email"));
								 }
						// --------------------------------------------------------------------------------------------------------------------------
						
						
							subject = "DEFINE - Changes Received : " + rs_check.getString("problem_descr") + " @ " + rs_check.getString("plant") + " - " + emailPlant;
						
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
					sb.append("<tr  style='font-size: 11px; padding: 8px;'><td style='text-align: right;'>"+rs_check.getInt("id")+"</td><td>"+rs_check.getString("plant")+"</td><td>"+rs_check.getString("problem_descr")+"</td>"+
						"<td>"+matCode +"</td><td>"+rs_check.getString("product_codeDescr") +"</td><td>"+rs_check.getString("type_product_code") +"</td><td>"+typeProject+"</td><td>"+rs_check.getString("created_byName")+"</td><td>"+format.format(rs_check.getDate("tran_date")) +"</td><td>"+dept+"</td></tr>");
					}
					
					String classProject="",impactIntCust="",impactExtcustomer="",dataAnalysis="",crossFunctionalRating="";
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 and searchTerm='classProject' and id="+vo.getClassProject());
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						classProject = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactInternalCust'");
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						impactIntCust = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactExtcustomer'");
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						impactExtcustomer = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData where enable=1 and searchTerm='dataAnalysis'");
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						dataAnalysis = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 AND searchTerm='crossFunctionalRating'");
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						crossFunctionalRating = rs_data.getString("master_name");
					}
					
					sb.append("</table><table border='1' width='100%'>"+
								"<tr style='border-width: 1px;border-style: solid; border-color: #729ea5;'>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Classification of Project</th>"+
								"<td style='text-align: left;'>"+classProject+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Impact on Internal Customer</th>"+
								"<td  style='text-align: left;'>"+impactIntCust+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Impact on External Customer</th>"+
								"<td colspan='3'  style='text-align: left;'>"+impactExtcustomer+"</td>  </tr>  <tr>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Data Oriented Analysis</th>"+
								"<td>"+dataAnalysis+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Cross Functional Rating</th>"+
								"<td>"+crossFunctionalRating+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Expected Savings Rupees in Lakhs</th>"+
								"<td colspan='3'  style='text-align: right;'>"+vo.getExp_Saving()+"</td>"+
								"</tr><tr>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Baseline in PPM</th>"+
								"<td  style='text-align: right;'>"+vo.getBaselinePPM()+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Target</th>"+
								" <td style='text-align: right;'>"+vo.getTargetPPM()+"</td>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Project Score</th>"+
								"<td colspan='3' style='text-align: right;'>"+vo.getProject_score()+"</td> </tr>"+
								"<tr> <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Baseline</th>"+
								"<td>"+vo.getBaseline()+"</td>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Target</th>"+
								"<td>"+vo.getTarget_baseline()+"</td>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Project Rating</th>"+
								" <td colspan='3'>"+vo.getRateDefine()+"</td> </tr>");
					
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
					
					if(flag==true){
						status = "Success";
						response.sendRedirect("SixSigma_Define_Charter.jsp?success="+status+"&problem_id="+vo.getProblem_id());
					}else{
						status = "Issue Occurred";
						response.sendRedirect("SixSigma_Define_Charter.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
					} 
					
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
/// ***************************************************************************************************************
/// *********************************************** Select Team Members *******************************************
	public void defineTeam_Members(SixSigma_ProblemVO vo,
			HttpServletResponse response, HttpSession session) {
		try {
			String status=""; 
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString();
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
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
		    int up =0;
		    PreparedStatement ps_check=null,ps_check1=null,ps_data=null;
		    ResultSet rs_check=null,rs_check1=null,rs_data=null;
		    
		    ps_check = con_master.prepareStatement("select * from rel_pt_teamSelect where enable=1 and u_id="+vo.getTeam_user()+" and problem_id="+vo.getProblem_id());
		    rs_check = ps_check.executeQuery();
		    if(rs_check.next()) {
			
			}else{
				ps_data = con.prepareStatement("SELECT * FROM user_tbl where u_id="+vo.getTeam_user());
				rs_data = ps_data.executeQuery();
				while(rs_data.next()){
				
				ps_check1 = con_master.prepareStatement("insert into rel_pt_teamSelect(problem_id,u_id,user_name,dept_id,app_role,appUser_email,enable,created_by,created_date,changed_by,changed_date)values(?,?,?,?,?,?,?,?,?,?,?)");
				ps_check1.setInt(1, vo.getProblem_id());
				ps_check1.setInt(2, vo.getTeam_user());
				ps_check1.setString(3, rs_data.getString("u_name"));
				ps_check1.setInt(4, rs_data.getInt("Dept_Id"));
				ps_check1.setString(5, "Team Member");
				ps_check1.setString(6, rs_data.getString("U_Email"));
				ps_check1.setInt(7, 1);
				ps_check1.setInt(8, uid);
				ps_check1.setTimestamp(9, timeStamp);
				ps_check1.setInt(10, uid);
				ps_check1.setTimestamp(11, timeStamp);
				
				up =  ps_check1.executeUpdate();
				}
			}
		    if(up>0){ 
		    	status = "Team Member Added...";
		    	if(vo.getPhaseID()==2){
				response.sendRedirect("SixSigma_Define_Charter.jsp?success="+status+"&problem_id="+vo.getProblem_id());
		    	}
		    	if(vo.getPhaseID()==3){
					response.sendRedirect("SixSigma_Measure_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());
			    }
		    	if(vo.getPhaseID()==4){
					response.sendRedirect("SixSigma_Analyze_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());
			    }
		    	if(vo.getPhaseID()==5){
					response.sendRedirect("SixSigma_Improve_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());
			    }
		    	if(vo.getPhaseID()==6){
					response.sendRedirect("SixSigma_Control_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());
			    }
			}else{
				status = "Already Available";
				if(vo.getPhaseID()==2){
				response.sendRedirect("SixSigma_Define_Charter.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
				}
				if(vo.getPhaseID()==3){
					response.sendRedirect("SixSigma_Measure_Data.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
				}
				if(vo.getPhaseID()==4){
					response.sendRedirect("SixSigma_Analyze_Data.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
				}
				if(vo.getPhaseID()==5){
					response.sendRedirect("SixSigma_Improve_Data.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
				}
				if(vo.getPhaseID()==6){
					response.sendRedirect("SixSigma_Control_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());
			    }
			}	
		    
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
/// ***************************************************************************************************************
/// ******************************************** Input Phase Timeline Data ****************************************	

	public void phaseValueUpdate(SixSigma_ProblemVO vo, HttpServletResponse response, HttpSession session) {
		try {
			String status="";
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString();
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			
			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis=System.currentTimeMillis();
		    java.sql.Date todaysdate=new java.sql.Date(millis);
		    // *******************************************************************************************************************************************************************
		    int up =0;
		    String define_days ="",phaseName="";
	    	int phasedays=0,plan_score=0,sqNo=0;
		    java.sql.Date sqlApproval =null, sqlparsedDay =null;
		    PreparedStatement ps_check=null,ps_check1=null,ps_data=null;
		    ResultSet rs_check=null,rs_check1=null,rs_data=null;
		    Calendar c = Calendar.getInstance();
		    
		    if(vo.getNamePhase()==2){
	        Date parsed = format.parse(vo.getApproval_date());
	        sqlApproval = new java.sql.Date(parsed.getTime()); 
	    	c.setTime(sqlApproval); // Now use Approval date.
		    }else{
		    	int old_Phase=vo.getNamePhase()-1;
		    	PreparedStatement ps_sql = con_master.prepareStatement("select * from rel_pt_dateTimeline where phase_id="+old_Phase+" and problem_id="+vo.getProblem_id()+" and enable=1");
		    	ResultSet rs_sql = ps_sql.executeQuery();
		    	while(rs_sql.next()){
		    		sqlApproval = rs_sql.getDate("plan_endDate");  // SQL ENd Date 
		    	}
		    	c.setTime(sqlApproval); // Now use Approval date.
		    }
	    	
	    	// System.out.println("pahse = " + vo.getNamePhase());
	        PreparedStatement ps_sql = con_master.prepareStatement("select * from rel_pt_phase where id="+vo.getNamePhase());
	    	ResultSet rs_sql = ps_sql.executeQuery();
	    	while(rs_sql.next()){
	    		/*if(rs_sql.getInt("seqNo")==2){*/
	    		/// Define Days 
	    		sqNo = rs_sql.getInt("seqNo");
	    		phaseName = rs_sql.getString("phase"); 
	    		phasedays = rs_sql.getInt("plan_days");				/// Plan Days
	    		plan_score =rs_sql.getInt("plan_score");			/// Plan Score 
	    		
	    		c.add(Calendar.DATE, rs_sql.getInt("plan_days")); 
				define_days = format.format(c.getTime());  
				Date parsed_day = format.parse(define_days);
				sqlparsedDay = new java.sql.Date(parsed_day.getTime());  // SQL ENd Date
		        
				// System.out.println(sqlparsedDay+ " = pahse = " + vo.getNamePhase());
		        
		      //  System.out.println(vo.getNamePhase()+" and problem_id="+vo.getProblem_id() + "Basic  mail score match = " + plan_score+ " = " + vo.getInput_value());
		        
		        ps_check = con_master.prepareStatement("select * from rel_pt_dateTimeline where enable=1 and phase_id="+vo.getNamePhase()+" and problem_id="+vo.getProblem_id());
		        rs_check = ps_check.executeQuery();
		        if(rs_check.next()){
		        	//System.out.println(vo.getNamePhase()+" and problem_id="+vo.getProblem_id() + "Basic  mail score match = " + plan_score+ " = " + vo.getInput_value());
		        // *****************************************************************************************************************
		           int newPhase =0;
		        	ps_check1 = con_master.prepareStatement("update rel_pt_dateTimeline set phase_id=?,act_endDate=?,actual_score=?,changed_by=?,changed_date=?,total_score=? where enable=1 and phase_id="+vo.getNamePhase()+" and problem_id="+vo.getProblem_id());
		        	if(plan_score==vo.getInput_value()){
		        		ps_check1.setInt(1, vo.getNamePhase());
		        		ps_check1.setDate(2, todaysdate);
			        }else{
			        	ps_check1.setInt(1, vo.getNamePhase());
			        	ps_check1.setDate(2, null);
			        }
		        	ps_check1.setInt(3, vo.getInput_value());
		        	ps_check1.setInt(4, uid);
			        ps_check1.setTimestamp(5, timeStamp);
			        ps_check1.setInt(6, vo.getLogScore());
			        
			        up = ps_check1.executeUpdate();
			        
			        
			        //***************************************************************************************************************************************
			        //******************************************************* Score Match Send Mail **********************************************************
			       //System.out.println("before mail score match = " + plan_score+ " = " + vo.getInput_value());
			        if(plan_score==vo.getInput_value()){
			        boolean flag=false;
			        newPhase=vo.getNamePhase()+1;
			        SendMail_DAO sendMail =new SendMail_DAO();
			        ps_check1 = con_master.prepareStatement("update tran_pt_problem set phase_id=?,changed_by=?,changed_date=? where id="+vo.getProblem_id());
		        	ps_check1.setInt(1, newPhase);
		        	ps_check1.setInt(2, uid); 
			        ps_check1.setTimestamp(3, timeStamp);
			        up = ps_check1.executeUpdate();
			        
			        ps_check1 = con_master.prepareStatement("select * from rel_pt_dateTimeline where enable=1 and phase_id="+vo.getNamePhase()+" and problem_id="+vo.getProblem_id());
			        rs_check1 = ps_check1.executeQuery();
			        if(rs_check1.next()){
			        	
			        	
			        	//System.out.println(vo.getProblem_id()+ "in mail score match = " + plan_score+ " = " + vo.getInput_value());
			        	
			        	
			        ps_check1 = con_master.prepareStatement("insert into rel_pt_dateTimeline_hist(problem_id,phase_id,plan_days,plan_score,actual_score,plan_startDate,plan_endDate,"
			        		+ "act_startDate,act_endDate,enable,created_by,created_date,changed_by,changed_date,timeline_id,total_score) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			        ps_check1.setInt(1, rs_check1.getInt("problem_id"));
			        ps_check1.setInt(2, rs_check1.getInt("phase_id"));
			        ps_check1.setInt(3, rs_check1.getInt("plan_days"));
			        ps_check1.setInt(4, rs_check1.getInt("plan_score"));
			        ps_check1.setInt(5, rs_check1.getInt("actual_score"));
			        ps_check1.setDate(6, rs_check1.getDate("plan_startDate"));
			        ps_check1.setDate(7, rs_check1.getDate("plan_endDate"));
			        ps_check1.setDate(8, rs_check1.getDate("act_startDate"));
			        ps_check1.setDate(9, rs_check1.getDate("act_endDate"));
			        ps_check1.setInt(10, rs_check1.getInt("enable"));
			        ps_check1.setInt(11, rs_check1.getInt("created_by"));
			        ps_check1.setTimestamp(12, rs_check1.getTimestamp("created_date"));
			        ps_check1.setInt(13, rs_check1.getInt("changed_by"));
			        ps_check1.setTimestamp(14, rs_check1.getTimestamp("changed_date"));
			        ps_check1.setInt(15, rs_check1.getInt("id"));
			        ps_check1.setInt(16, rs_check1.getInt("total_score"));
			        up = ps_check1.executeUpdate();
			        }
			      // ********************************** Email Send Logic After Stage Completion ****************************************************
			        ArrayList emailList = new ArrayList(); 
			    	String subject = "",emailPlant="";
						StringBuilder sb = new StringBuilder();
						
						sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Six Sigma Portal !!! ***</b>"); 
						sb.append("<table border='1' width='100%'>"+
								"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
								"<th>No</th><th>Plant</th><th>Problem Description</th><th>Product Code</th><th>Product Description</th><th>Input Product Description</th><th>Type of Project</th><th>Logged by</th><th>Logged Date</th><th>Department</th></tr>"); 
					 
						String dept = "",typeProject="",matCode="";
						ps_check = con_master.prepareStatement("select * from tran_pt_problem where enable=1 and id="+vo.getProblem_id());
						rs_check = ps_check.executeQuery();
						while(rs_check.next()){
							// ---------------------------------------------------------------------------------------------------------------------------
					    	 ps_check1 = con.prepareStatement("select Company_Name from user_tbl_company where enable=1 and plant='"+rs_check.getString("plant")+"'");
						     rs_check1 = ps_check1.executeQuery();
						     while (rs_check1.next()) {
								 emailPlant = rs_check1.getString("Company_Name");
							 }
								   
								ps_check1 = con_master.prepareStatement("select appUser_email from rel_pt_releaseMaster where enable=1 and plant='"+rs_check.getString("plant")+"' and seq_no=1");
								rs_check1 = ps_check1.executeQuery();
								while (rs_check1.next()) {
									emailList.add(rs_check1.getString("appUser_email"));
								}
								
								ps_check1 = con_master.prepareStatement("select appUser_email from rel_pt_teamSelect where enable=1 and problem_id="+rs_check.getInt("id"));
								rs_check1 = ps_check1.executeQuery();
								while (rs_check1.next()) {
									emailList.add(rs_check1.getString("appUser_email"));
								}
							// --------------------------------------------------------------------------------------------------------------------------
							
							
							subject = phaseName + " - Stage Completed : " + rs_check.getString("problem_descr") + " @ " + rs_check.getString("plant") + " - " + emailPlant;
							
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
						sb.append("<tr  style='font-size: 11px; padding: 8px;'><td style='text-align: right;'>"+rs_check.getInt("id")+"</td><td>"+rs_check.getString("plant")+"</td><td>"+rs_check.getString("problem_descr")+"</td>"+
							"<td>"+matCode +"</td><td>"+rs_check.getString("product_codeDescr") +"</td><td>"+rs_check.getString("type_product_code") +"</td><td>"+typeProject+"</td><td>"+rs_check.getString("created_byName")+"</td><td>"+format.format(rs_check.getDate("tran_date")) +"</td><td>"+dept+"</td></tr>");
						}
						
						
						String classProject="",impactIntCust="",impactExtcustomer="",dataAnalysis="",crossFunctionalRating="";
						
						ps_check1 = con_master.prepareStatement("select * from rel_pt_definePhase where enable=1 and problem_id=" + vo.getProblem_id());
						rs_check1 = ps_check1.executeQuery();
						while (rs_check1.next()) {
							// vo.getExp_Saving()     	vo.getBaselinePPM()    	vo.getTargetPPM()
							// vo.getProject_score()   	vo.getBaseline()   		vo.getTarget_baseline()    vo.getRateDefine()
						vo.setExp_Saving(rs_check1.getFloat("expectedSaving"));
						vo.setBaselinePPM(rs_check1.getFloat("baselinePPM"));
						vo.setTargetPPM(rs_check1.getFloat("baselinePPM_target"));
						vo.setProject_score(rs_check1.getFloat("projectScore"));
						vo.setBaseline(rs_check1.getString("baseline"));
						vo.setTarget_baseline(rs_check1.getString("baseline_target"));
						vo.setRateDefine(rs_check1.getString("rateDefine"));
						
						ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 and searchTerm='classProject' and id="+rs_check1.getInt("classProject"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							classProject = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactInternalCust' and id="+rs_check1.getInt("impactInternalCust"));
						rs_data = ps_data.executeQuery();
						while (rs_data.next()) {
							impactIntCust = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactExtcustomer' and id="+rs_check1.getInt("impactExtcustomer"));
						rs_data = ps_data.executeQuery();
						while (rs_data.next()) {
							impactExtcustomer = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData where enable=1 and searchTerm='dataAnalysis' and id="+rs_check1.getInt("dataAnalysis"));
						rs_data = ps_data.executeQuery();
						while (rs_data.next()) {
							dataAnalysis = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 AND searchTerm='crossFunctionalRating' and id="+rs_check1.getInt("crossFunctionalRating"));
						rs_data = ps_data.executeQuery();
						while (rs_data.next()) {
							crossFunctionalRating = rs_data.getString("master_name");
						}
						}
						sb.append("</table><table border='1' width='100%'>"+
									"<tr style='border-width: 1px;border-style: solid; border-color: #729ea5;'>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Classification of Project</th>"+
									"<td style='text-align: left;'>"+classProject+"</td>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Impact on Internal Customer</th>"+
									"<td  style='text-align: left;'>"+impactIntCust+"</td>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Impact on External Customer</th>"+
									"<td colspan='3'  style='text-align: left;'>"+impactExtcustomer+"</td>  </tr>  <tr>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Data Oriented Analysis</th>"+
									"<td>"+dataAnalysis+"</td>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Cross Functional Rating</th>"+
									"<td>"+crossFunctionalRating+"</td>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Expected Savings Rupees in Lakhs</th>"+
									"<td colspan='3'  style='text-align: right;'>"+vo.getExp_Saving()+"</td>"+
									"</tr><tr>"+
									" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Baseline in PPM</th>"+
									"<td  style='text-align: right;'>"+vo.getBaselinePPM()+"</td>"+
									"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Target</th>"+
									" <td style='text-align: right;'>"+vo.getTargetPPM()+"</td>"+
									" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Project Score</th>"+
									"<td colspan='3' style='text-align: right;'>"+vo.getProject_score()+"</td> </tr>"+
									"<tr> <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Baseline</th>"+
									"<td>"+vo.getBaseline()+"</td>"+
									" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Target</th>"+
									"<td>"+vo.getTarget_baseline()+"</td>"+
									" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Project Rating</th>"+
									" <td colspan='3'>"+vo.getRateDefine()+"</td> </tr></table>");
						 
						sb.append("<p><b style='color: #330B73;font-family: Arial;'>* * * * Define Stage Completed by : </b> " + uname + " * * * *");	
						
						sb.append("<p><b>For more details ,</b> "
								+ "<a href='http://192.168.0.7/facilitytracker/'>Click Here (In House)</a>,"
								+ "  <a href='http://157.119.206.42/facilitytracker/'>Click Here (Outside Mutha Group)</a></p>" 
								+ "<p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
								+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
								+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
								+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
								+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
								+ "</font></p>"); 
						
						flag = sendMail.senMail(emailList,subject,sb);	
						
					// ****************************************************************************************************************
			        }else{
			        	ps_check1 = con_master.prepareStatement("select * from rel_pt_dateTimeline where enable=1 and phase_id="+vo.getNamePhase()+" and problem_id="+vo.getProblem_id());
				        rs_check1 = ps_check1.executeQuery();
				        if(rs_check1.next()){
				        ps_check1 = con_master.prepareStatement("insert into rel_pt_dateTimeline_hist(problem_id,phase_id,plan_days,plan_score,actual_score,plan_startDate,plan_endDate,"
				        		+ "act_startDate,act_endDate,enable,created_by,created_date,changed_by,changed_date,timeline_id,total_score) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
				        ps_check1.setInt(1, rs_check1.getInt("problem_id"));
				        ps_check1.setInt(2, rs_check1.getInt("phase_id"));
				        ps_check1.setInt(3, rs_check1.getInt("plan_days"));
				        ps_check1.setInt(4, rs_check1.getInt("plan_score"));
				        ps_check1.setInt(5, rs_check1.getInt("actual_score"));
				        ps_check1.setDate(6, rs_check1.getDate("plan_startDate"));
				        ps_check1.setDate(7, rs_check1.getDate("plan_endDate"));
				        ps_check1.setDate(8, rs_check1.getDate("act_startDate"));
				        ps_check1.setDate(9, rs_check1.getDate("act_endDate"));
				        ps_check1.setInt(10, rs_check1.getInt("enable"));
				        ps_check1.setInt(11, rs_check1.getInt("created_by"));
				        ps_check1.setTimestamp(12, rs_check1.getTimestamp("created_date"));
				        ps_check1.setInt(13, rs_check1.getInt("changed_by"));
				        ps_check1.setTimestamp(14, rs_check1.getTimestamp("changed_date"));
				        ps_check1.setInt(15, rs_check1.getInt("id"));
				        ps_check1.setInt(16, rs_check1.getInt("total_score"));
				        up = ps_check1.executeUpdate();
			        }
			      //***************************************************************************************************************************************
			      //***************************************************************************************************************************************
			      //***************************************************************************************************************************************
			         
			        }  
			        
			        /*
			        }else{
			        	up=0;
			        }*/
		        // ****************************************************************************************************************	
		        }else{
		        boolean flag=false; 
		        SendMail_DAO sendMail =new SendMail_DAO();
		        // First time line entry	
		        // System.out.println(sqlApproval +" = " + sqlparsedDay);
		        ps_check1 = con_master.prepareStatement("insert into rel_pt_dateTimeline(problem_id,phase_id,plan_days,plan_score,actual_score,plan_startDate,plan_endDate,"
		        		+ "act_startDate,act_endDate,enable,created_by,created_date,changed_by,changed_date,total_score) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		        ps_check1.setInt(1, vo.getProblem_id());
		        ps_check1.setInt(2, vo.getNamePhase());
		        ps_check1.setInt(3, phasedays);
		        ps_check1.setInt(4, plan_score);
		        ps_check1.setInt(5, vo.getInput_value());
		        ps_check1.setDate(6, sqlApproval);
		        ps_check1.setDate(7, sqlparsedDay);
		        ps_check1.setDate(8, todaysdate);
		        
		        if(plan_score==vo.getInput_value()){
		        	ps_check1.setDate(9, todaysdate);
	        	}else{
	        		ps_check1.setDate(9, null);
	        	}
		        ps_check1.setInt(10, 1);
		        ps_check1.setInt(11, uid);
		        ps_check1.setTimestamp(12, timeStamp);
		        ps_check1.setInt(13, uid);
		        ps_check1.setTimestamp(14, timeStamp);
		        ps_check1.setInt(15, vo.getLogScore());
		        
		        up = ps_check1.executeUpdate();
		        
		        if(plan_score==vo.getInput_value()){
		        int newPhaseUpdate=vo.getNamePhase()+1;
		        ps_check1 = con_master.prepareStatement("update tran_pt_problem set phase_id=?,changed_by=?,changed_date=? where id="+vo.getProblem_id());
	        	ps_check1.setInt(1, newPhaseUpdate);
	        	ps_check1.setInt(2, uid); 
		        ps_check1.setTimestamp(3, timeStamp);
		        up = ps_check1.executeUpdate();
		        }
		        // ****************************************************************************************************************
		        
		        ps_check1 = con_master.prepareStatement("select * from rel_pt_dateTimeline where enable=1 and phase_id="+vo.getNamePhase()+" and problem_id="+vo.getProblem_id());
		        rs_check1 = ps_check1.executeQuery();
		        if(rs_check1.next()){
		        ps_check1 = con_master.prepareStatement("insert into rel_pt_dateTimeline_hist(problem_id,phase_id,plan_days,plan_score,actual_score,plan_startDate,plan_endDate,"
		        		+ "act_startDate,act_endDate,enable,created_by,created_date,changed_by,changed_date,timeline_id,total_score) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		        ps_check1.setInt(1, rs_check1.getInt("problem_id"));
		        ps_check1.setInt(2, rs_check1.getInt("phase_id"));
		        ps_check1.setInt(3, rs_check1.getInt("plan_days"));
		        ps_check1.setInt(4, rs_check1.getInt("plan_score"));
		        ps_check1.setInt(5, rs_check1.getInt("actual_score"));
		        ps_check1.setDate(6, rs_check1.getDate("plan_startDate"));
		        ps_check1.setDate(7, rs_check1.getDate("plan_endDate"));
		        ps_check1.setDate(8, rs_check1.getDate("act_startDate"));
		        ps_check1.setDate(9, rs_check1.getDate("act_endDate"));
		        ps_check1.setInt(10, rs_check1.getInt("enable"));
		        ps_check1.setInt(11, rs_check1.getInt("created_by"));
		        ps_check1.setTimestamp(12, rs_check1.getTimestamp("created_date"));
		        ps_check1.setInt(13, rs_check1.getInt("changed_by"));
		        ps_check1.setTimestamp(14, rs_check1.getTimestamp("changed_date"));
		        ps_check1.setInt(15, rs_check1.getInt("id"));
		        ps_check1.setInt(16, rs_check1.getInt("total_score"));
		        up = ps_check1.executeUpdate();
		        }
		        
		        
		        
		        
		        
		        
		        
		     // ********************************** Email Send Logic After Stage Completion ****************************************************
		        if(plan_score==vo.getInput_value()){
		        ArrayList emailList = new ArrayList(); 
		    	String subject = "",emailPlant="";
					StringBuilder sb = new StringBuilder();
					
					sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Six Sigma Portal !!! ***</b>"); 
					sb.append("<table border='1' width='100%'>"+
							"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
							"<th>No</th><th>Plant</th><th>Problem Description</th><th>Product Code</th><th>Product Description</th><th>Input Product Description</th><th>Type of Project</th><th>Logged by</th><th>Logged Date</th><th>Department</th></tr>"); 
				 
					String dept = "",typeProject="",matCode="";
					ps_check = con_master.prepareStatement("select * from tran_pt_problem where enable=1 and id="+vo.getProblem_id());
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						// ---------------------------------------------------------------------------------------------------------------------------
				    	 ps_check1 = con.prepareStatement("select Company_Name from user_tbl_company where enable=1 and plant='"+rs_check.getString("plant")+"'");
					     rs_check1 = ps_check1.executeQuery();
					     while (rs_check1.next()) {
							 emailPlant = rs_check1.getString("Company_Name");
						 }
							   
							ps_check1 = con_master.prepareStatement("select appUser_email from rel_pt_releaseMaster where enable=1 and plant='"+rs_check.getString("plant")+"' and seq_no=1");
							rs_check1 = ps_check1.executeQuery();
							while (rs_check1.next()) {
								emailList.add(rs_check1.getString("appUser_email"));
							}
							
							ps_check1 = con_master.prepareStatement("select appUser_email from rel_pt_teamSelect where enable=1 and problem_id="+rs_check.getInt("id"));
							rs_check1 = ps_check1.executeQuery();
							while (rs_check1.next()) {
								emailList.add(rs_check1.getString("appUser_email"));
							}
							
							ps_check1 = con_master.prepareStatement("select email from rel_pt_reviewer where enable=1");
							rs_check1 = ps_check1.executeQuery();
							while (rs_check1.next()) {
								emailList.add(rs_check1.getString("email"));
							}
							
							ps_check1 = con_master.prepareStatement("select project_lead from tran_pt_problem where enable=1 and id="+rs_check.getInt("id"));
							rs_check1 = ps_check1.executeQuery();
							while (rs_check1.next()) {
								ps_data = con.prepareStatement("SELECT u_email FROM user_tbl where u_id="+rs_check.getInt("project_lead"));
							    rs_data = ps_data.executeQuery();
							    while (rs_data.next()) {
							    	emailList.add(rs_data.getString("u_email"));
								 } 
							}
						// --------------------------------------------------------------------------------------------------------------------------
						
						
						subject = phaseName + " - Stage Completed : " + rs_check.getString("problem_descr") + " @ " + rs_check.getString("plant") + " - " + emailPlant;
						
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
					sb.append("<tr  style='font-size: 11px; padding: 8px;'><td style='text-align: right;'>"+rs_check.getInt("id")+"</td><td>"+rs_check.getString("plant")+"</td><td>"+rs_check.getString("problem_descr")+"</td>"+
						"<td>"+matCode +"</td><td>"+rs_check.getString("product_codeDescr") +"</td><td>"+rs_check.getString("type_product_code") +"</td><td>"+typeProject+"</td><td>"+rs_check.getString("created_byName")+"</td><td>"+format.format(rs_check.getDate("tran_date")) +"</td><td>"+dept+"</td></tr>");
					}
					
					
					String classProject="",impactIntCust="",impactExtcustomer="",dataAnalysis="",crossFunctionalRating="";
					
					ps_check1 = con_master.prepareStatement("select * from rel_pt_definePhase where enable=1 and problem_id=" + vo.getProblem_id());
					rs_check1 = ps_check1.executeQuery();
					while (rs_check1.next()) {
						// vo.getExp_Saving()     	vo.getBaselinePPM()    	vo.getTargetPPM()
						// vo.getProject_score()   	vo.getBaseline()   		vo.getTarget_baseline()    vo.getRateDefine()
					vo.setExp_Saving(rs_check1.getFloat("expectedSaving"));
					vo.setBaselinePPM(rs_check1.getFloat("baselinePPM"));
					vo.setTargetPPM(rs_check1.getFloat("baselinePPM_target"));
					vo.setProject_score(rs_check1.getFloat("projectScore"));
					vo.setBaseline(rs_check1.getString("baseline"));
					vo.setTarget_baseline(rs_check1.getString("baseline_target"));
					vo.setRateDefine(rs_check1.getString("rateDefine"));
					
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 and searchTerm='classProject' and id="+rs_check1.getInt("classProject"));
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						classProject = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactInternalCust' and id="+rs_check1.getInt("impactInternalCust"));
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						impactIntCust = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactExtcustomer' and id="+rs_check1.getInt("impactExtcustomer"));
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						impactExtcustomer = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT master_name FROM rel_pt_masterData where enable=1 and searchTerm='dataAnalysis' and id="+rs_check1.getInt("dataAnalysis"));
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						dataAnalysis = rs_data.getString("master_name");
					}
					ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 AND searchTerm='crossFunctionalRating' and id="+rs_check1.getInt("crossFunctionalRating"));
					rs_data = ps_data.executeQuery();
					while (rs_data.next()) {
						crossFunctionalRating = rs_data.getString("master_name");
					}
					}
					sb.append("</table><table border='1' width='100%'>"+
								"<tr style='border-width: 1px;border-style: solid; border-color: #729ea5;'>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Classification of Project</th>"+
								"<td style='text-align: left;'>"+classProject+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Impact on Internal Customer</th>"+
								"<td  style='text-align: left;'>"+impactIntCust+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Impact on External Customer</th>"+
								"<td colspan='3'  style='text-align: left;'>"+impactExtcustomer+"</td>  </tr>  <tr>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Data Oriented Analysis</th>"+
								"<td>"+dataAnalysis+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Cross Functional Rating</th>"+
								"<td>"+crossFunctionalRating+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Expected Savings Rupees in Lakhs</th>"+
								"<td colspan='3'  style='text-align: right;'>"+vo.getExp_Saving()+"</td>"+
								"</tr><tr>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Baseline in PPM</th>"+
								"<td  style='text-align: right;'>"+vo.getBaselinePPM()+"</td>"+
								"<th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Target</th>"+
								" <td style='text-align: right;'>"+vo.getTargetPPM()+"</td>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Project Score</th>"+
								"<td colspan='3' style='text-align: right;'>"+vo.getProject_score()+"</td> </tr>"+
								"<tr> <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Baseline</th>"+
								"<td>"+vo.getBaseline()+"</td>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Target</th>"+
								"<td>"+vo.getTarget_baseline()+"</td>"+
								" <th style='font-size: 11px; background-color: #acc8cc; border-width: 1px;border-style: solid; border-color: #729ea5; text-align: left;'>Project Rating</th>"+
								" <td colspan='3'>"+vo.getRateDefine()+"</td> </tr></table>");
					 
					sb.append("<p><b style='color: #330B73;font-family: Arial;'>* * * * Define Stage Completed by : </b> " + uname + " * * * *");	
					
					sb.append("<p><b>For more details ,</b> "
							+ "<a href='http://192.168.0.7/facilitytracker/'>Click Here (In House)</a>,"
							+ "  <a href='http://157.119.206.42/facilitytracker/'>Click Here (Outside Mutha Group)</a></p>" 
							+ "<p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
							+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
							+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
							+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
							+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
							+ "</font></p>");  
					flag = sendMail.senMail(emailList,subject,sb);	
		        	} 
					// ********************************** Email Send Logic After Stage Completion ****************************************************
		        }
	    	  }
		    if(up>0){
		    	status = "Score uploaded successfully";
		    	if(sqNo==2){
		    		response.sendRedirect("SixSigma_Define_Charter.jsp?success="+status+"&problem_id="+vo.getProblem_id());
		    	}else if(sqNo==3){
		    		response.sendRedirect("SixSigma_Measure_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==4){
		    		response.sendRedirect("SixSigma_Analyze_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==5){
		    		response.sendRedirect("SixSigma_Improve_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==6){
		    		response.sendRedirect("SixSigma_Control_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==7){
		    		response.sendRedirect("SixSigma_Result_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}
			}else{
				status = "Issue Occurred...!";
				if(sqNo==2){
		    		response.sendRedirect("SixSigma_Define_Charter.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
		    	}else if(sqNo==3){
		    		response.sendRedirect("SixSigma_Measure_Data.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==4){
		    		response.sendRedirect("SixSigma_Analyze_Data.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==5){
		    		response.sendRedirect("SixSigma_Improve_Data.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==6){
		    		response.sendRedirect("SixSigma_Control_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}else if(sqNo==7){
		    		response.sendRedirect("SixSigma_Result_Data.jsp?success="+status+"&problem_id="+vo.getProblem_id());	
		    	}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
/// ***************************************************************************************************************
/// ***************************************************************************************************************

	public void resultUpload(SixSigma_ProblemVO vo,
			HttpServletResponse response, HttpSession session) {
		try {
			boolean flag = false;
			// SendMail_DAO sendMail = new SendMail_DAO();
			int up=1;
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString(), status = "";
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
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
			DecimalFormat digit = new DecimalFormat("##");
			SimpleDateFormat sqlFormat = new SimpleDateFormat("yyyy-MM-dd");

			date = simpleDateFormat.parse(dt.toString() + " " + sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis = System.currentTimeMillis();
			java.sql.Date todaysdate = new java.sql.Date(millis); 
			// *******************************************************************************************************************************************************************
			java.util.Date date_end = sqlFormat.parse(vo.getControlDate());
			java.sql.Date sqlControlDate = new java.sql.Date(date_end.getTime());
			
			String[] months = new DateFormatSymbols().getMonths();
		  	Calendar calSustain = Calendar.getInstance();
		  	calSustain.setTime(sqlControlDate);
		  	int month = calSustain.get(Calendar.MONTH);
		  	int day = calSustain.get(Calendar.DAY_OF_MONTH);
		  	int year = calSustain.get(Calendar.YEAR);
		  	String monthYear = months[month].toString() + " " + String.valueOf(year);
			// *******************************************************************************************************************************************************************
			
			PreparedStatement ps_data = con_master.prepareStatement("insert into rel_pt_resultPhase"
					+ "(problem_id,phase_id,month_no,year_no,month_year,basline_rejectionPPM,targetted_rejectionPPM,actual_achieved_PPM,"
					+ "plan_savingRs,actual_savingRs,enable,created_by,created_date,changed_by,changed_date)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_data.setInt(1, vo.getProblem_id());
			ps_data.setInt(2, vo.getPhaseID());
			ps_data.setInt(3, month);
			ps_data.setInt(4, year);
			ps_data.setString(5, monthYear);
			ps_data.setInt(6, vo.getBasline_rejectionPPM());
			ps_data.setInt(7, vo.getTargetted_rejectionPPM());
			ps_data.setDouble(8, vo.getActualPPMAcieved());
			ps_data.setDouble(9, vo.getExpectedSaving());
			ps_data.setDouble(10, vo.getActualSaving());
			ps_data.setInt(11, 1);
			ps_data.setInt(12, uid); 
			ps_data.setTimestamp(13, timeStamp);
			ps_data.setInt(14, uid);
			ps_data.setTimestamp(15, timeStamp);
			
			up = ps_data.executeUpdate(); 
			
			if (up > 0) {
				if(vo.getPhaseID()!=9){
				int newPhase = vo.getPhaseID()+2; 
				ps_data = con_master.prepareStatement("update tran_pt_problem set phase_id=?,changed_by=?,changed_date=? where id="+vo.getProblem_id());
				ps_data.setInt(1, newPhase);
				ps_data.setInt(2, uid); 
				ps_data.setTimestamp(3, timeStamp);
		        up = ps_data.executeUpdate();
				}
				status = "Data upload success";
				if(vo.getPhaseID()==7){
					response.sendRedirect("SixSigma_Result_Data.jsp?success="+ status + "&problem_id=" + vo.getProblem_id());
		    	}else if(vo.getPhaseID()==9){
		    		response.sendRedirect("SixSigma_Sustain_Data.jsp?success="+ status + "&problem_id=" + vo.getProblem_id());
		    	}
			} else {
				status = "Issue Occurred...!";
				if(vo.getPhaseID()==7){
					response.sendRedirect("SixSigma_Result_Data.jsp?success="+ status + "&problem_id=" + vo.getProblem_id());
		    	}else if(vo.getPhaseID()==9){
		    		response.sendRedirect("SixSigma_Sustain_Data.jsp?success="+ status + "&problem_id=" + vo.getProblem_id());
		    	}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}