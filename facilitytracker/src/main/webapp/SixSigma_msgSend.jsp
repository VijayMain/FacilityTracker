<%@page import="com.facilitytracker.dao.SendMail_DAO"%>
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
		Connection con_master = Connection_Util.getConnectionMaster();
		Connection con = Connection_Util.getLocalUserConnection();
		int id = Integer.valueOf(request.getParameter("id"));
		String sendMsg = request.getParameter("sendMsg"), plant="", emailPlant="", problem="";
		int select = Integer.valueOf(request.getParameter("select"));
		int up=0, max_msg=0;
		int uid = Integer.valueOf(session.getAttribute("uid").toString());
		String username = session.getAttribute("username").toString();
		String emailUser = session.getAttribute("email_id").toString();
		String changedbyUser="";
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
		SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
		
		date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
		timeStamp = new java.sql.Timestamp(date.getTime());
		long millis=System.currentTimeMillis();
	    java.sql.Date todaysdate=new java.sql.Date(millis); 
		// *******************************************************************************************************************************************************************
		SendMail_DAO sendMail =new SendMail_DAO();
		PreparedStatement ps_check1=null,ps_check=null,ps_check2=null,ps_data=null,ps_data1=null;
		ResultSet rs_check1=null,rs_check=null,rs_check2=null,rs_data=null,rs_data1=null;
		String pLead="";
		ps_check1 = con_master.prepareStatement("select * from tran_pt_problem where id="+id);
	    rs_check1 = ps_check1.executeQuery();
	    while(rs_check1.next()){
	    	plant = rs_check1.getString("plant");
	    	problem = rs_check1.getString("problem_descr");
	   		changedbyUser = rs_check1.getString("changed_byName");
	    	// ------------------------------------------------------------------------------------------------------------------------------------
	    	// ------------------------------------------------------------ Approval 3 ------------------------------------------------------------
	    	if(select==3){
	    		ps_check = con_master.prepareStatement("insert into tran_pt_problem_hist(problem_id,plant,dept_id,problem_descr,"+
	    				" product_code,product_codeDescr,type_product_code,project_lead,typeProject,approval_id,phase_id,created_by,"+
	    				" created_byName,log_date,changed_by,changed_byName,changed_date,tran_date,enable,project_leadName) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
	    		ps_check.setInt(1, rs_check1.getInt("id"));
	    		ps_check.setString(2, rs_check1.getString("plant"));
	    		ps_check.setInt(3, rs_check1.getInt("dept_id"));
	    		ps_check.setString(4, rs_check1.getString("problem_descr"));
	    		ps_check.setInt(5, rs_check1.getInt("product_code"));
	    		ps_check.setString(6, rs_check1.getString("product_codeDescr"));
	    		ps_check.setString(7, rs_check1.getString("type_product_code"));
	    		ps_check.setInt(8, rs_check1.getInt("project_lead"));   
	    		ps_check.setInt(9, rs_check1.getInt("typeProject"));
	    		ps_check.setInt(10, rs_check1.getInt("approval_id"));
	    		ps_check.setInt(11, rs_check1.getInt("phase_id"));
	    		ps_check.setInt(12, rs_check1.getInt("created_by"));
	    		ps_check.setString(13, rs_check1.getString("created_byName"));
	    		ps_check.setTimestamp(14, rs_check1.getTimestamp("log_date"));
	    		ps_check.setInt(15, rs_check1.getInt("changed_by"));
	    		ps_check.setString(16, rs_check1.getString("changed_byName"));
	    		ps_check.setTimestamp(17, rs_check1.getTimestamp("changed_date"));
	    		ps_check.setDate(18, rs_check1.getDate("tran_date"));
	    		ps_check.setInt(19, rs_check1.getInt("enable"));
	    		ps_check.setString(20, rs_check1.getString("project_leadName")); 
				up = ps_check.executeUpdate();
				
				if(up>0){
					String query = "";
					if(request.getParameter("prj_lead")!=""){
					query = "update tran_pt_problem set problem_descr=?,type_product_code=?,typeProject=?,dept_id=?,changed_by=?,changed_byName=?,changed_date=?,project_lead=?,project_leadName=? where id="+id;
					}else{
					query = "update tran_pt_problem set problem_descr=?,type_product_code=?,typeProject=?,dept_id=?,changed_by=?,changed_byName=?,changed_date=? where id="+id;
					}
					ps_check = con_master.prepareStatement(query);
					ps_check.setString(1, request.getParameter("problem"));		
					ps_check.setString(2, request.getParameter("product_name"));
					ps_check.setInt(3, Integer.valueOf(request.getParameter("typeProject")));
					ps_check.setInt(4, Integer.valueOf(request.getParameter("dept"))); 
					ps_check.setInt(5, uid);
		    		ps_check.setString(6, username);
		    		ps_check.setTimestamp(7, timeStamp);
					
					if(request.getParameter("prj_lead")!=""){
			    		
			    		ps_data = con.prepareStatement("select U_Name from user_tbl where u_id="+Integer.valueOf(request.getParameter("prj_lead")));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							pLead = rs_data.getString("U_Name");
						}
						ps_check.setInt(8, Integer.valueOf(request.getParameter("prj_lead")));
						ps_check.setString(9, pLead);
			   	   } 
					up = ps_check.executeUpdate(); 
				}
				if(up>0){
					ps_data1 = con_master.prepareStatement("select * from rel_pt_releaseMaster where enable=1 and app_uid="+uid+" and plant='"+plant+"'");
					rs_data1 = ps_data1.executeQuery();
					if(rs_data1.next()){
					ps_data = con_master.prepareStatement("insert into rel_pt_releaseStrategies "+
							" (problem_id,relMaster_id,email,approval_id,reason,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?,?)");
					ps_data.setInt(1, id);
					ps_data.setInt(2, rs_data1.getInt("id"));
					ps_data.setString(3, rs_data1.getString("appUser_email"));
					ps_data.setInt(4, select);
					ps_data.setString(5, sendMsg);
					ps_data.setInt(6, 1);
					ps_data.setInt(7, uid); 
					ps_data.setTimestamp(8, timeStamp); 
					ps_data.setInt(9, uid);
					ps_data.setTimestamp(10, timeStamp); 
					up = ps_data.executeUpdate();
					}
					ps_data1 = con_master.prepareStatement("select * from rel_pt_releaseStrategies where enable=1 and problem_id="+id+" and  relMaster_id= "+
							" (select id from rel_pt_releaseMaster where enable=1 and  plant='"+plant+"' and app_uid="+uid+" and "+
							" seq_no=(select MAX(seq_no) as seqNo from rel_pt_releaseMaster where enable=1 and app_uid="+uid+" and plant='"+plant+"'))");
					rs_data1 = ps_data1.executeQuery();
					if(rs_data1.next()){
						ps_data = con_master.prepareStatement("update tran_pt_problem set approval_id=?,phase_id=?,approval_date=? where id="+id);
						ps_data.setInt(1, select);
						ps_data.setInt(2, 2);
						ps_data.setDate(3, todaysdate);
						up = ps_data.executeUpdate();
					}
					
				}
				// ------------------------------------------------------------------------------------------------------------------------------------
		    	// ----------------------------------------------------------------Delete 2 ------------------------------------------------------------		
	    	}else if(select==2){
	    		ps_check = con_master.prepareStatement("update tran_pt_problem set delete_reason=?,changed_by=?,changed_byName=?,changed_date=?,approval_id=?,enable=? where id="+rs_check1.getInt("id")); 
	    		ps_check.setString(1, sendMsg);
	    		ps_check.setInt(2, uid);
	    		ps_check.setString(3, username);
	    		ps_check.setTimestamp(4, timeStamp); 
	    		ps_check.setInt(5, 2);
	    		ps_check.setInt(6, 0);
	    		up=ps_check.executeUpdate();
	    		
	    		ps_data1 = con_master.prepareStatement("select * from rel_pt_releaseMaster where enable=1 and app_uid="+uid+" and plant='"+plant+"'");
				rs_data1 = ps_data1.executeQuery();
				if(rs_data1.next()){
				ps_data = con_master.prepareStatement("insert into rel_pt_releaseStrategies "+
						" (problem_id,relMaster_id,email,approval_id,reason,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?,?)");
				ps_data.setInt(1, id);
				ps_data.setInt(2, rs_data1.getInt("id"));
				ps_data.setString(3, rs_data1.getString("appUser_email"));
				ps_data.setInt(4, select);
				ps_data.setString(5, sendMsg);
				ps_data.setInt(6, 1);
				ps_data.setInt(7, uid); 
				ps_data.setTimestamp(8, timeStamp); 
				ps_data.setInt(9, uid);
				ps_data.setTimestamp(10, timeStamp); 
				up = ps_data.executeUpdate();
				}
	    		
	    		// ------------------------------------------------------------------------------------------------------------------------------------
		    	// ----------------------------------------------------------------- Message 1 --------------------------------------------------------	
	    	}else if(select==1){
	    		ps_check2 = con_master.prepareStatement("select max(seq_no) as seq_no from rel_pt_messgeLog where problem_id="+id);
	    		rs_check2 =ps_check2.executeQuery();
	    		while(rs_check2.next()){
	    			max_msg = rs_check2.getInt("seq_no");
	    		}
	    		max_msg++;
	    		ps_check=con_master.prepareStatement("insert into rel_pt_messgeLog(problem_id,u_id,user_name,msg_data,seq_no,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?,?)");
	    		ps_check.setInt(1, id);
	    		ps_check.setInt(2, uid);
	    		ps_check.setString(3, username);
	    		ps_check.setString(4, sendMsg);
	    		ps_check.setInt(5, max_msg);
	    		ps_check.setInt(6, 1);
	    		ps_check.setInt(7, uid);
	    		ps_check.setTimestamp(8, timeStamp); 
	    		ps_check.setInt(9, uid);
	    		ps_check.setTimestamp(10, timeStamp);
	    		up = ps_check.executeUpdate();
	    		
	    		// ------------------------------------------------------------------------------------------------------------------------------------
		    	// ----------------------------------------------------------------- Edit Data --------------------------------------------------------	
	    	}else if(select==9){
	    		ps_check = con_master.prepareStatement("insert into tran_pt_problem_hist(problem_id,plant,dept_id,problem_descr,"+
	    				" product_code,product_codeDescr,type_product_code,project_lead,typeProject,approval_id,phase_id,created_by,"+
	    				" created_byName,log_date,changed_by,changed_byName,changed_date,tran_date,enable,project_leadName) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
	    		ps_check.setInt(1, rs_check1.getInt("id"));
	    		ps_check.setString(2, rs_check1.getString("plant"));
	    		ps_check.setInt(3, rs_check1.getInt("dept_id"));
	    		ps_check.setString(4, rs_check1.getString("problem_descr"));
	    		ps_check.setInt(5, rs_check1.getInt("product_code"));
	    		ps_check.setString(6, rs_check1.getString("product_codeDescr"));
	    		ps_check.setString(7, rs_check1.getString("type_product_code"));
	    		ps_check.setInt(8, rs_check1.getInt("project_lead"));   
	    		ps_check.setInt(9, rs_check1.getInt("typeProject"));
	    		ps_check.setInt(10, rs_check1.getInt("approval_id"));
	    		ps_check.setInt(11, rs_check1.getInt("phase_id"));
	    		ps_check.setInt(12, rs_check1.getInt("created_by"));
	    		ps_check.setString(13, rs_check1.getString("created_byName"));
	    		ps_check.setTimestamp(14, rs_check1.getTimestamp("log_date"));
	    		ps_check.setInt(15, rs_check1.getInt("changed_by"));
	    		ps_check.setString(16, rs_check1.getString("changed_byName"));
	    		ps_check.setTimestamp(17, rs_check1.getTimestamp("changed_date"));
	    		ps_check.setDate(18, rs_check1.getDate("tran_date"));
	    		ps_check.setInt(19, rs_check1.getInt("enable"));
	    		ps_check.setString(20, rs_check1.getString("project_leadName")); 
				up = ps_check.executeUpdate();
				
				if(up>0){
					String query = ""; 
					query = "update tran_pt_problem set problem_descr=?,type_product_code=?,typeProject=?,dept_id=?,changed_by=?,changed_byName=?,changed_date=? where id="+id;
					 ps_check = con_master.prepareStatement(query);
					ps_check.setString(1, request.getParameter("problem"));		
					ps_check.setString(2, request.getParameter("product_name"));
					ps_check.setInt(3, Integer.valueOf(request.getParameter("typeProject")));
					ps_check.setInt(4, Integer.valueOf(request.getParameter("dept"))); 
					ps_check.setInt(5, uid);
		    		ps_check.setString(6, username);
		    		ps_check.setTimestamp(7, timeStamp);
					 
					up = ps_check.executeUpdate(); 
				}
	    	}
	    	// ------------------------------------------------------------------------------------------------------------------------------------
	    	// ------------------------------------------------------------------------------------------------------------------------------------
	    }
if(up>0){
	 ps_check = con.prepareStatement("select Company_Name from user_tbl_company where enable=1 and plant='"+plant+"'");
     rs_check = ps_check.executeQuery();
     while (rs_check.next()) {
		 emailPlant = rs_check.getString("Company_Name");
	 }
 
	String subject = ""; 
	if(select==2){
		subject = "Problem Deleted - " + problem + " @ " + plant + " - " + emailPlant;
	}else if(select==1){
		subject = "Notification Message: " + problem + " @ " + plant + " - " + emailPlant;
	}else if(select==3){
		subject = "Approval Received : " + problem + " @ " + plant + " - " + emailPlant;
	}else if(select==9){
		subject = "Project Edited by "+changedbyUser+" : " + problem + " @ " + plant + " - " + emailPlant;
	}
	// ---------------------------------------------------------------------------------------------------------------------------
		ArrayList emailList = new ArrayList(); 
		ps_check = con_master.prepareStatement("select appUser_email from rel_pt_releaseMaster where enable=1 and plant='" + plant + "'");
		rs_check = ps_check.executeQuery();
		while (rs_check.next()) {
			emailList.add(rs_check.getString("appUser_email"));
		}
		
		ps_check = con_master.prepareStatement("select appUser_email from rel_pt_teamSelect where enable=1 and problem_id="+id);
		rs_check = ps_check.executeQuery();
		while (rs_check.next()) {
			emailList.add(rs_check.getString("appUser_email"));
		}
		
		ps_check = con_master.prepareStatement("select email from rel_pt_reviewer where enable=1");
		rs_check = ps_check.executeQuery();
		while (rs_check.next()) {
			emailList.add(rs_check.getString("email"));
		}
		
		ps_check = con_master.prepareStatement("select project_lead from tran_pt_problem where enable=1 and id="+id);
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
		ps_check = con_master.prepareStatement("select * from tran_pt_problem where id="+id);
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
		
		sb.append("</table>");
		
		if(select==2){
		sb.append("<p><b style='color: #330B73;font-family: Arial;'>Project Rejected By : </b> " + username);
		sb.append("<p><b style='color: #330B73;font-family: Arial;'>Reject Reason : </b> " + rs_check.getString("delete_reason"));	
		}
		
		if(select==3){
			sb.append("<p><b style='color: #330B73;font-family: Arial;'>Project Approved By : </b> " + username);
			sb.append("<p><b style='color: #330B73;font-family: Arial;'>Project Lead is : </b> " + pLead);	
		}
		}
		
		if(select==1){
		sb.append("<table border='1' width='100%'><tr style='font-size: 12px; background-color: #fbffd4; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
				"<th colspan='4'>Message No </th></tr>"+
				"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
				"<th>Message No </th><th>Sent By</th><th>Message</th><th>Sent Date</th></tr>");
		
		ps_data = con_master.prepareStatement("select * from rel_pt_messgeLog where problem_id="+id + " order by seq_no desc");
		rs_data = ps_data.executeQuery();
		while(rs_data.next()){
		sb.append("<tr style='font-size: 11px;'>"+
				"<td style='text-align: right;width: 40px;'>"+rs_data.getInt("seq_no")+"</td>"+
				"<td>"+rs_data.getString("user_name")+"</td>"+
				"<td>"+rs_data.getString("msg_data")+"</td>"+
				"<td>"+format.format(rs_data.getDate("changed_date"))+"</td>"+
				"</tr>");
		}
		sb.append("</table>");
		}
		
		sb.append("</table><p><b>For more details ,</b> "
				+ "<a href='http://192.168.0.7/facilitytracker/'>Click Here (In House)</a>,"
				+ "  <a href='http://157.119.206.42/facilitytracker/'>Click Here (Outside Mutha Group)</a></p>" 
				+ "<p><b style='color: #330B73;font-family: Arial;'>Thanks & Regards </b></P><p style='font-family: Arial;'>IT | Software Development | Mutha Group Satara </p><p>"
				+ "<b style='font-family: Arial;'>Disclaimer :</b></p> <p><font face='Arial' size='1'>"
				+ "<b style='color: #49454F;'>The information transmitted, including attachments, is intended only for the person(s) or entity to which"
				+ "it is addressed and may contain confidential and/or privileged material. Any review, retransmission, dissemination or other use of, or taking of any action in reliance upon this information by persons"
				+ "or entities other than the intended recipient is prohibited. If you received this in error, please contact the sender and destroy any copies of this information.</b>"
				+ "</font></p>"); 
		
		flag = sendMail.senMail(emailList,subject,sb);	
	
%>
<span id="sendMsgBack<%=id%>">
	<textarea  class="form-control" onkeypress="return checkQuote();" style="color: black;font-size: 10px;" rows="1" cols="5" id="sendMsg<%=id%>" name="sendMsg<%=id%>">Sent</textarea>
</span>
<%
}else{
%>
<span id="sendMsgBack<%=id%>">
	<textarea  class="form-control" onkeypress="return checkQuote();" style="color: black;font-size: 10px;" rows="1" cols="5" id="sendMsg<%=id%>" name="sendMsg<%=id%>">Error..!</textarea>
</span>
<%	    	
}
}catch(Exception e){
	e.printStackTrace();
} 
%>
</body>
</html>