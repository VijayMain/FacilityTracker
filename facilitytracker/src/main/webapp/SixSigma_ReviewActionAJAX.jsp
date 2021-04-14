<%@page import="com.facilitytracker.vo.SixSigma_ProblemVO"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.DateFormat"%> 
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
<style type="text/css">
table.gridtable {
	font-family: verdana, arial, sans-serif; 
	color: black;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}

table.gridtable th {
	font-size: 11px;
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: #666666; 
	color: black;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 11px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
	/* font-weight: bold; */
}
</style>
</head>
<body> 

 <%
 try{
		Connection con_master = Connection_Util.getConnectionMaster();
		Connection con = Connection_Util.getLocalUserConnection();
		boolean flag=false; 
		int uid = Integer.valueOf(session.getAttribute("uid").toString());
		String emailUser = session.getAttribute("email_id").toString();
		String uname = session.getAttribute("username").toString();
		SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
		// *******************************************************************************************************************************************************************
		java.util.Date date = null;
		java.sql.Timestamp timeStamp = null;
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new java.util.Date());
		java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
		java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
		DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		
		date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
		timeStamp = new java.sql.Timestamp(date.getTime());
		long millis=System.currentTimeMillis();
	    java.sql.Date todaysdate=new java.sql.Date(millis); 
	    String tod = df.format(todaysdate); 
		// *******************************************************************************************************************************************************************
			// ?probID="+probID +"&phaseID="+  phaseID  +"&reviewDate="+ reviewDate +"&actionDetails="+ 
		  	// actionDetails +"&statusAction="+  statusAction +"&teamMember="+  teamMember  +"&targetDate="+  targetDate   +"&completeDate="+  
		    // completeDate   +"&reasonPlan="+   reasonPlan   +"&findings="+ findings
			int probID = Integer.valueOf(request.getParameter("probID"));
			int phaseID = Integer.valueOf(request.getParameter("phaseID"));
			int idReview  = Integer.valueOf(request.getParameter("idReview"));
			
			int statusAction = Integer.valueOf(request.getParameter("statusAction"));  
			String reasonPlan = request.getParameter("reasonPlan");
			 
			reasonPlan = reasonPlan.replaceAll("\"", "");
			reasonPlan = reasonPlan.replaceAll("\'", "");
			
			String findings = request.getParameter("findings");
			
			findings = findings.replaceAll("\"", "");
			findings = findings.replaceAll("\'", "");
			
			
			
			PreparedStatement ps_check = null, ps_data=null, ps_data1=null;
			ResultSet rs_check=null, rs_data=null, rs_data1=null;
			
			int act_score=0,planScore=0;
			ps_data = con_master.prepareStatement("select * from rel_pt_dateTimeline where problem_id="+probID+" and phase_id="+phaseID);
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				act_score=rs_data.getInt("actual_score");
				planScore=rs_data.getInt("plan_score");
			}
			
			/* 
			Review Date
			java.util.Date dttype = df.parse(reviewDate);
			java.sql.Date sqlDt = new java.sql.Date(dttype.getTime());
			vo.setReviewDate(sqlDt);
			
			// Target Date
			dttype = df.parse(targetDate);
			sqlDt = new java.sql.Date(dttype.getTime());
			vo.setTargetDate(sqlDt);
			
			// Complete Date
			/* dttype = df.parse(completeDate);
			sqlDt = new java.sql.Date(dttype.getTime());
			vo.setCompleteDate(sqlDt); */
			
			String myquery = "";
			boolean flag_query= false;
			int up=0;
			// History for Review ------------------------------------------------------------------------------------------------------
			ps_data1 = con_master.prepareStatement("select * from rel_pt_review where id="+idReview);
			rs_data1 = ps_data1.executeQuery();
			while(rs_data1.next()){
			myquery = "insert into rel_pt_review_hist"+
					" (review_id,problem_id,phase_id,action_status_id,completion_date,reason,findings,enable,created_by,created_date,changed_by,changed_date) "+
					" values(?,?,?,?,?,?,?,?,?,?,?,?)";
			ps_check = con_master.prepareStatement(myquery);
			ps_check.setInt(1, rs_data1.getInt("id"));
			ps_check.setInt(2, rs_data1.getInt("problem_id"));
			ps_check.setInt(3, rs_data1.getInt("phase_id"));
			ps_check.setInt(4, rs_data1.getInt("action_status_id"));
			ps_check.setTimestamp(5, rs_data1.getTimestamp("completion_date")); 
			ps_check.setString(6, rs_data1.getString("reason"));
			ps_check.setString(7, rs_data1.getString("findings"));
			ps_check.setInt(8, rs_data1.getInt("enable"));
			ps_check.setInt(9, rs_data1.getInt("created_by"));
			ps_check.setTimestamp(10, rs_data1.getTimestamp("created_date"));
			ps_check.setInt(11, rs_data1.getInt("created_by"));
			ps_check.setTimestamp(12, rs_data1.getTimestamp("created_date")); 
			up = ps_check.executeUpdate(); 
			}
		// History for Review End --------------------------------------------------------------------------------------------------
			  
			ps_data1 = con_master.prepareStatement("select * from rel_pt_masterData where id="+statusAction+" and master_name=(select master_name from rel_pt_masterData where searchTerm='actionStatus' and  master_name='Completed')");
			rs_data1 = ps_data1.executeQuery();
			if(rs_data1.next()){
				myquery = "update rel_pt_review set action_status_id=?,reason=?,findings=?,changed_by=?,changed_date=?,completion_date=? where id ="+idReview;
				flag_query = true;
			}else{
				myquery = "update rel_pt_review set action_status_id=?,reason=?,findings=?,changed_by=?,changed_date=? where id ="+idReview;
			}
			ps_check = con_master.prepareStatement(myquery);
			ps_check.setInt(1, statusAction); 
			ps_check.setString(2, reasonPlan);
			ps_check.setString(3, findings); 
			ps_check.setInt(4, uid);
			ps_check.setTimestamp(5, timeStamp); 
			 
			
			if(flag_query==true){
			ps_check.setDate(6, todaysdate);
			}
		up = ps_check.executeUpdate();  
	%>
		<span id="updateRv<%=idReview%>">		
	<%
		if(up>0){
		%>
        <img src="img/check.png"/>
        <%
		}else{
		%> 
	    <strong style="color: red;">Error !!!</strong> 
	    <%
		}
		%>
</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>  
</body>
</html>