<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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
<span id="ssvMeasure">
 <%
 try{		      
	 int uid = Integer.valueOf(session.getAttribute("uid").toString());
		String emailUser = session.getAttribute("email_id").toString();
		String uname = session.getAttribute("username").toString(),status="";
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

		date = simpleDateFormat.parse(dt.toString() + " " + sqlTime.toString());
		timeStamp = new java.sql.Timestamp(date.getTime());
		long millis = System.currentTimeMillis();
		java.sql.Date todaysdate = new java.sql.Date(millis);
		// *******************************************************************************************************************************************************************
		
		int probID = Integer.valueOf(request.getParameter("probID"));
		int phaseID = Integer.valueOf(request.getParameter("phaseID"));
		int ssv_variation = Integer.valueOf(request.getParameter("ssv_variation"));
		int ssv_measure = Integer.valueOf(request.getParameter("ssv_measure"));
		String ssv_text = request.getParameter("ssv_text"); 
		
		
		PreparedStatement ps_data = null,ps_data1 = null;
		ResultSet rs_data=null,rs_data1=null;   
		
		int sr_no=0;
		ps_data = con_master.prepareStatement("select MAX(seq_no) as seq_no from rel_pt_measurePhase_SSV where enable=1 and phase_id="+phaseID+" and problem_id="+probID);
		rs_data = ps_data.executeQuery();
		while(rs_data.next()){
			sr_no = rs_data.getInt("seq_no");
		}
		sr_no++;
		
ps_data = con_master.prepareStatement("insert into rel_pt_measurePhase_SSV "+ 
		"(problem_id,phase_id,variation_source,measure_id,var_design,seq_no,enable,created_by,created_date,changed_by,changed_date)values(?,?,?,?,?,?,?,?,?,?,?)");
ps_data.setInt(1, probID);
ps_data.setInt(2, phaseID);
ps_data.setString(3, ssv_text);
ps_data.setInt(4, ssv_measure);
ps_data.setInt(5, ssv_variation);
ps_data.setInt(6, sr_no);
ps_data.setInt(7, 1);
ps_data.setInt(8, uid);
ps_data.setTimestamp(9, timeStamp);
ps_data.setInt(10, uid);
ps_data.setTimestamp(11, timeStamp); 

int up=ps_data.executeUpdate();

if(up>0){
%>    
<table class="gridtable" width="100%">
  <tr>
    <th colspan="3">Added List of Suspected Sources of Variation (SSV's)</th>
  </tr>
  <tr>
    <th style="background-color: #0b2f50;color: white;">Description</th>
    <th style="background-color: #0b2f50;color: white;">Measurable/Not Measurable</th>
    <th style="background-color: #0b2f50;color: white;">Variation/Design</th>
  </tr> 
  <%
  String master_name="",var_design="";
  ps_data = con_master.prepareStatement("select * from rel_pt_measurePhase_SSV where enable=1 and phase_id="+phaseID+" and problem_id="+probID+" order by seq_no desc");
  rs_data = ps_data.executeQuery();
  while(rs_data.next()){
	  
	  ps_data1 = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_data.getInt("measure_id"));
	  rs_data1 = ps_data1.executeQuery();
	  while(rs_data1.next()){
		  master_name = rs_data1.getString("master_name");
	  }
	  ps_data1 = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_data.getInt("var_design"));
	  rs_data1 = ps_data1.executeQuery();
	  while(rs_data1.next()){
		  var_design = rs_data1.getString("master_name");
	  }
  %>
  <tr>
  <td style="font-size: 12px;color: black;"><%=rs_data.getString("variation_source") %></td>
  <td style="font-size: 12px;color: black;"><%=master_name %></td>
  <td style="font-size: 12px;color: black;"><%=var_design %></td>
  </tr>
  <%
  }
  %>
</table> 
<%
}else{
%>
<strong style="background-color: red;">Fail..!</strong>
<%	
}
}catch(Exception e){
	e.printStackTrace();
} 
%>   
	</span>
</body>
</html>