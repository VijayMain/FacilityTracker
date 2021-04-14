<%@page import="java.lang.reflect.Array"%>
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
<title>MSG Send</title>
</head>
<body>
	<%
	boolean flag =false;
	try{
	Connection con = Connection_Util.getConnectionMaster();
	Connection conLocal = Connection_Util.getLocalUserConnection();
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");  
	PreparedStatement ps_mst=null, ps_local=null,ps_check2=null,ps_check1=null,ps_check=null,ps_check3=null;			       
	ResultSet rs_mst=null, rs_local=null,rs_check2=null,rs_check1=null,rs_check3=null;
	int up=0, sNo=1; 
	boolean hsn_avail=false;
	SendMail_DAO sendMail = new SendMail_DAO();
	java.util.Date date = null;
	java.sql.Timestamp timeStamp = null;
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	String username = session.getAttribute("username").toString();
	String emailUser = session.getAttribute("email_id").toString();
	java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
	java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
	timeStamp = new java.sql.Timestamp(date.getTime());
	int id = Integer.valueOf(request.getParameter("id"));
	String sendMsg = request.getParameter("sendMsg").replaceAll("'","");
	int select = Integer.valueOf(request.getParameter("select"));
	
	long millis=System.currentTimeMillis();
    java.sql.Date todaysdate=new java.sql.Date(millis);
	
	if(select==2 && sendMsg==""){
		sendMsg = "Done By "+username;
	}
	
	int qty=1;
	if(request.getParameter("qty")!=null){
		qty = Integer.valueOf(request.getParameter("qty"));  
		 
		 if(select==2){
			String matName = request.getParameter("matName"); 
			// System.out.println("Mat Name = " + matName);
			String status_id="",status="";
			int stage_no=0;
			ps_mst = con.prepareStatement("select * from approval_config where stage_code='DONE' and enable=1");
			rs_mst = ps_mst.executeQuery();
			while(rs_mst.next()){
				status_id=rs_mst.getString("stage_code");
				status=rs_mst.getString("remark");
				stage_no=rs_mst.getInt("stage");
			}
// --------------------------------------------------------------------------------------------------------------------------------------
ps_check1 = con.prepareStatement("select * from tran_SAPmaster_create where id="+id);
rs_check1 = ps_check1.executeQuery();
while (rs_check1.next()) {
ps_check = con.prepareStatement("insert into rel_SAPmaster_create_history (newMaster_id,plant,materialType,materialName,uom,materialGroup,location_id,storageLocation,plant_toExtend,price,contactNo,hsn_code,reason,status_id,status,qty,created_by,created_date,enable,changed_by,changed_date,stage_no,fileupload_id,filename,attachment,material_code,log_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
ps_check.setInt(1,id);
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
int upme = ps_check.executeUpdate();
}
// --------------------------------------------------------------------------------------------------------------------------------------
		 	ps_mst = con.prepareStatement("update tran_SAPmaster_create set material_code=?,status_id=?,status=?,stage_no=?  where id="+id);
			ps_mst.setString(1, matName);
			ps_mst.setString(2, status_id);
			ps_mst.setString(3, status);
			ps_mst.setInt(4, stage_no);
			
			up = ps_mst.executeUpdate();
			
			if(up>0){
				ps_mst = con.prepareStatement("select * from tran_SAPmaster_create where id="+id);
				rs_mst = ps_mst.executeQuery();
				while(rs_mst.next()){
					ps_check2 = con.prepareStatement("insert into rel_SAPmaster_mm60 "+
							"(plant,material,material_description,material_type,created_by,last_change,added_by,created_date ,changed_by ,changed_date,enable) values(?,?,?,?,?,?,?,?,?,?,?)");
					ps_check2.setString(1, rs_mst.getString("plant"));
					ps_check2.setString(2, rs_mst.getString("material_code"));
					ps_check2.setString(3, rs_mst.getString("materialName"));
					ps_check2.setString(4, rs_mst.getString("materialType"));
					ps_check2.setString(5, "HO_ACC1");
					ps_check2.setDate(6, rs_mst.getDate("created_date"));
					ps_check2.setInt(7,uid);
					ps_check2.setTimestamp(8, rs_mst.getTimestamp("changed_date"));
					ps_check2.setInt(9,uid); 
					ps_check2.setTimestamp(10, rs_mst.getTimestamp("changed_date")); 
					ps_check2.setInt(11, 1);
					up = ps_check2.executeUpdate();
				}
			}
			
			
			
			
			if(request.getParameterValues("myArray")!=null){
		   String[] accData = request.getParameterValues("myArray");
		   for(int i=0; i<accData.length; i++){
			   // System.out.println("Account Assignment Code : " + accData[i]); 
			   ps_mst = con.prepareStatement("insert into rel_SAPmaster_acc_regCode "+
					   " (newMaster_id,asset_code,created_by,created_date,changed_by,changed_date ,enable) values(?,?,?,?,?,?,?)");
			   ps_mst.setInt(1, id);
			   ps_mst.setString(2,accData[i].toString());
			   ps_mst.setInt(3, uid);
			   ps_mst.setDate(4, todaysdate);
			   ps_mst.setInt(5, uid);
			   ps_mst.setTimestamp(6, timeStamp);
			   ps_mst.setInt(7, 1);
			   
			   up=ps_mst.executeUpdate();
		   }
			}
			select=0;
		 } 
	}
	
	String status = "",plant ="", pendingAt="";
	int count = 0, stage=0, created_by=0;
	
	PreparedStatement ps_getMaster = con.prepareStatement("SELECT * FROM tran_SAPmaster_create where id="+id);
	ResultSet rs_getMaster = ps_getMaster.executeQuery();
	while(rs_getMaster.next()){
		status = rs_getMaster.getString("status_id");
		stage = rs_getMaster.getInt("stage_no");
		plant = rs_getMaster.getString("plant");
		created_by = rs_getMaster.getInt("created_by");
	
	//	System.out.println("status = " + status + " = " + stage + " = " + plant + " = " + created_by + " = " + select);
		 
		 if(select!=1){
			 ps_mst = con.prepareStatement("SELECT * FROM approval_config WHERE enable=1 and stage="+select);
			 rs_mst = ps_mst.executeQuery();
			 while(rs_mst.next()){
				 status = rs_mst.getString("stage_code");
			 }
			  
			 
			 ps_mst = con.prepareStatement("SELECT distinct(statDisplay) stat FROM rel_SAPmaster_releaseStrategy where stageNo="+select+" and enable=1");
			 rs_mst = ps_mst.executeQuery();
			 while (rs_mst.next()) {
			    	pendingAt = rs_mst.getString("stat");
			 }
			 
			 if(select==4){
				 pendingAt = status + " by " + username + " " + sendMsg;
				  
				 ps_mst = con.prepareStatement("update tran_SAPmaster_create set status_id=?,status=?,stage_no=?,changed_by=?,changed_date=? where id="+id);
				 ps_mst.setString(1, status);
				 ps_mst.setString(2, pendingAt);
				 ps_mst.setInt(3, select);
				 ps_mst.setInt(4, uid);
				 ps_mst.setTimestamp(5, timeStamp);
				 int it=ps_mst.executeUpdate();
			 }
			 
			  
				 if(request.getParameter("qty")==null){
				// --------------------------------------------------------------------------------------------------------------------------------------
ps_check1 = con.prepareStatement("select * from tran_SAPmaster_create where id="+id);
rs_check1 = ps_check1.executeQuery();
while (rs_check1.next()) { 
ps_check = con.prepareStatement("insert into rel_SAPmaster_create_history (newMaster_id,plant,materialType,materialName,uom,materialGroup,location_id,storageLocation,plant_toExtend,price,contactNo,hsn_code,reason,status_id,status,qty,created_by,created_date,enable,changed_by,changed_date,stage_no,fileupload_id,filename,attachment,material_code,log_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
ps_check.setInt(1,id);
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
				// --------------------------------------------------------------------------------------------------------------------------------------
			String hsn_no = request.getParameter("hsn_no"); 
			String sql_update =  ""; 
				if(hsn_no.length()<=8 && hsn_no.length()!=0){
				ps_check3 = con.prepareStatement("select * from rel_SAPmaster_HSN where enable=1 and hsnCode='"+hsn_no+"'");
				rs_check3 = ps_check3.executeQuery();
				if(rs_check3.next()){
					
				sql_update = "update tran_SAPmaster_create set status_id=?,status=?,stage_no=?,changed_by=?,changed_date=?,hsn_code=? where id="+id;
				 ps_mst = con.prepareStatement(sql_update);
				 ps_mst.setString(1, status);
				 ps_mst.setString(2, pendingAt);
				 ps_mst.setInt(3, select);
				 ps_mst.setInt(4, uid);
				 ps_mst.setTimestamp(5, timeStamp); 
				 ps_mst.setString(6, hsn_no); 
				 int mst = ps_mst.executeUpdate();
				 
				}else{
					hsn_avail=true;
				}
			}else{
				sql_update = "update tran_SAPmaster_create set status_id=?,status=?,stage_no=?,changed_by=?,changed_date=? where id="+id;
				 ps_mst = con.prepareStatement(sql_update);
				 ps_mst.setString(1, status);
				 ps_mst.setString(2, pendingAt);
				 ps_mst.setInt(3, select);
				 ps_mst.setInt(4, uid);
				 ps_mst.setTimestamp(5, timeStamp);
				   
				 int mst = ps_mst.executeUpdate();
			}
			
			 }
		 } 
	if(hsn_avail==false){
	PreparedStatement ps_getData = con.prepareStatement("SELECT max(count) as count FROM rel_SAPmaster_release where newMaster_id="+id);
	ResultSet rs_getData = ps_getData.executeQuery();
	while(rs_getData.next()){
		count = rs_getData.getInt("count");
	}
	count++;
	
	ps_check =con.prepareStatement("insert into rel_SAPmaster_release "+ 
			"(newMaster_id,u_id,userName,reply_msg,status,count,created_by,created_date,enable) values (?,?,?,?,?,?,?,?,?)");
	ps_check.setInt(1, id);
	ps_check.setInt(2, uid);
	ps_check.setString(3, username);
	ps_check.setString(4, sendMsg);
	ps_check.setString(5, status);
	ps_check.setInt(6, count);
	ps_check.setInt(7, uid);
	ps_check.setTimestamp(8, timeStamp);
	ps_check.setInt(9, 1);
	
	up = ps_check.executeUpdate();
 	if(up>0){
 		String mat_group="", logBy=""; 
 	// ----------------------------------------------------------------------------------------------------------------------------------------------------------
 	// ------------------------------------------------------------------- Mail Configutation -------------------------------------------------------------------
 	// ----------------------------------------------------------------------------------------------------------------------------------------------------------
  		ps_local = conLocal.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_getMaster.getInt("created_by"));
		rs_local = ps_local.executeQuery();
		while(rs_local.next()){
			logBy = rs_local.getString("u_name");
		}
 	
 	String subject = "Notification Received : " + rs_getMaster.getString("materialName") + " with Status " + status;
 	
 	// System.out.println("stage = " + stage + " plant = " + plant + " = " + subject);
 	
 	ArrayList emailList = new ArrayList();
 	emailList.add(emailUser);
	ps_check = con.prepareStatement("SELECT email FROM rel_SAPmaster_releaseStrategy where enable=1 and stageNo >0 and stageNo<="+stage+" and plant='"+plant+"'");
	ResultSet rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		emailList.add(rs_check.getString("email"));
	}
	
	ps_check = conLocal.prepareStatement("SELECT U_Email FROM user_tbl where u_id="+created_by);
	rs_check = ps_check.executeQuery();
	while (rs_check.next()) {
		emailList.add(rs_check.getString("U_Email"));		
	}
 
String plantExtend = rs_getMaster.getString("plant_toExtend");
plantExtend = plantExtend.replaceAll(",,,,,,", ",");
plantExtend = plantExtend.replaceAll(",,,,,", ",");
plantExtend = plantExtend.replaceAll(",,,,", ",");
plantExtend = plantExtend.replaceAll(",,,", ",");
plantExtend = plantExtend.replaceAll(",,", ","); 
// *******************************************************************************************************************************************************************
String location="", location_code="";
ps_check1 = con.prepareStatement("SELECT id,code,descr FROM master_data where  tablekey='storage_loc' and enable=1 and plant='"+plant+"' and code='" +rs_getMaster.getString("location_id")+"'");
rs_check1 = ps_check1.executeQuery();
while (rs_check1.next()) {
	location = rs_check1.getString("descr");
	location_code = rs_check1.getString("code");
}
 

ps_check = con.prepareStatement("SELECT descr  FROM master_data where tablekey='matGroup' and plant='' and enable=1 and code="+rs_getMaster.getString("materialGroup"));
rs_check = ps_check.executeQuery();
while (rs_check.next()) {
	mat_group=rs_check.getString("descr");
}

	
StringBuilder sb = new StringBuilder();
sb.append("<b style='color: #0D265E;font-size: 9px;'>*** This is an automatically generated email from Master Creation System !!! ***</b>");
 
sb.append("<p>This is notification message for the Material Creation in SAP for...!!!</P>");	 

//----------------------------------------------------------------------------------------------------------------		
if(rs_getMaster.getString("material_code")!=null){
sb.append("<table border='1' width='100%'>");

sb.append("<tr style='background-color: #efff40;font-size:18px; color: black; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5;'>"+
"<th colspan='2'>Material Code Created in SAP: "+rs_getMaster.getString("material_code")+"</th></tr>");

ps_check2 = con.prepareStatement("SELECT * FROM rel_SAPmaster_acc_regCode where enable=1 and newMaster_id="+id);
rs_check2 = ps_check2.executeQuery();
if(rs_check2.next()){
sb.append("<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'><th>S.No</th><th>Account Register Code</th></tr>"); 
ps_check = con.prepareStatement("SELECT * FROM rel_SAPmaster_acc_regCode where enable=1 and newMaster_id="+id +" order by id desc");
rs_check = ps_check.executeQuery();
while(rs_check.next()){
	sb.append("<tr style='font-size: 12px; border-width: 1px; padding: 2px; border-style: solid; border-color: #666666;'>"+
		"<td align='center'>"+ sNo +"</td>"+
		"<td align='left'>"+rs_check.getString("asset_code") +"</td>"+
		"</tr>");
	sNo++;
}
}
sb.append("</table>");			
}
// ----------------------------------------------------------------------------------------------------------------		
		
		
		
		
sb.append("<table border='1' width='100%'><tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
"<th>Plant</th>"+
"<th>Material Type</th>"+
"<th>Material Name</th>"+
"<th>Qty</th>"+
/* "<th>Location Used</th>"+ */
"<th>UOM</th>"+
"<th>Material Group</th>"+
"<th>Required In</th>"+
"<th>Amount</th>"+
"<th>Contact</th>"+
"<th>HSN NO</th>"+
"<th>Reason</th>"+
"<th>Received Date</th>"+
"</tr>"); 
	
sb.append("<tr style='font-size: 12px; border-width: 1px; padding: 2px; border-style: solid; border-color: #666666;'>"+
"<td align='right'>"+plant+"</td>"+
"<td>"+rs_getMaster.getString("materialType")+"</td>"+
"<td>"+rs_getMaster.getString("materialName")+"</td>"+
"<td align='right'>"+rs_getMaster.getInt("qty") +"</td>"+
/* "<td>"+rs_getMaster.getString("location_id") +"</td>"+   */ 
"<td>"+rs_getMaster.getString("uom")+"</td>"+
"<td>"+mat_group+"</td>"+
"<td>"+plantExtend+"</td>"+
"<td align='right'>"+rs_getMaster.getString("price")+"</td>"+
"<td align='right'>"+ "<b>"+ logBy +"</b><br>"+rs_getMaster.getString("contactNo")+"</td>"+
"<td align='right'>"+rs_getMaster.getString("hsn_code")+"</td>"+
"<td>"+rs_getMaster.getString("reason")+"</td>"+
"<td align='left'>"+format.format(rs_getMaster.getDate("created_date")) +"</td>"+
"</tr>"); 
sb.append("</table>");

sb.append("<table border='1' width='100%'>"+ 
		"<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'>"+
		"<th>Msg No</th>"+ 
		"<th>Processed By</th>"+ 
		"<th>Message Received</th>"+ 
		"<th>Status</th>"+ 
		"<th>Date Received</th>"+ 
		"</tr>"); 
ps_check = con.prepareStatement("SELECT * FROM  rel_SAPmaster_release where newMaster_id="+id +" and enable=1 order by id desc");
rs_check = ps_check.executeQuery();
while(rs_check.next()){ 
	sb.append("<tr style='font-size: 12px; border-width: 1px; padding: 2px; border-style: solid; border-color: #666666;'>"+
		"<td align='right'>"+rs_check.getInt("id") +"</td>"+
		"<td align='left'>"+rs_check.getString("userName") +"</td>"+ 
		"<td align='left'>"+rs_check.getString("reply_msg") +"</td>"+
		"<td align='left'>"+rs_check.getString("status") +"</td>"+
		"<td align='left'>"+format.format(rs_check.getDate("created_date")) +"</td>"+
		"</tr>");
} 
sb.append("</table>");










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
	}
 	if(flag==true && hsn_avail==false){
 	%>
 	<span id="sendMsgBack<%=id%>">
 	<textarea rows="1" cols="10" name="sendMsg<%=id %>" class="form-control" onkeypress="return checkQuote();" id="sendMsg<%=id %>" style="font-size: 9px;font-weight: bold;color: black;">Sent</textarea>
 	</span>
 	<%
 	}else{
 	%>
 	<span id="sendMsgBack<%=id%>">
 	<textarea rows="1" cols="10" name="sendMsg<%=id %>" class="form-control" onkeypress="return checkQuote();" id="sendMsg<%=id %>" style="font-size: 9px;font-weight: bold;color: black;">Error Occurred ! Check Provided details...!
 	</textarea>
 	</span>
 	<%		
 	}
 	} 
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>