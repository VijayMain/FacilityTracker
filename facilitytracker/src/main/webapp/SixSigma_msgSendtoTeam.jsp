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
		ps_check = con_master.prepareStatement("select * from tran_pt_problem where id="+id);
	    rs_check = ps_check.executeQuery();
	    while(rs_check.next()){
	    	plant = rs_check.getString("plant");
	    	problem = rs_check.getString("problem_descr");
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
	    } 
	 ps_check = con.prepareStatement("select Company_Name from user_tbl_company where enable=1 and plant='"+plant+"'");
     rs_check = ps_check.executeQuery();
     while (rs_check.next()) {
		 emailPlant = rs_check.getString("Company_Name");
	 }
  
     String subject = "Notification Message: " + problem + " @ " + plant + " - " + emailPlant;	
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
%>  
	<span id="sendMsgBack">
	<textarea class="form-control" onkeypress="return checkQuote();" style="color: black !important;font-size: 10px;" rows="1" cols="5" id="sendMsg" name="sendMsg">Sent</textarea>
	</span>
<%
if(flag==false){
%>
<span id="sendMsgBack">
	<textarea class="form-control" onkeypress="return checkQuote();" style="color: black !important;font-size: 10px;" rows="1" cols="5" id="sendMsg" name="sendMsg">Error Found..!!!</textarea>
</span>
<%	    	
}
}catch(Exception e){
	e.printStackTrace();
} 
%>
</body>
</html>