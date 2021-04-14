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
<span id="reviewProblem">
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
			String reviewDate = request.getParameter("reviewDate");
			String actionDetails = request.getParameter("actionDetails"); 
			
			actionDetails = actionDetails.replaceAll("\"", "");
			actionDetails = actionDetails.replaceAll("\'", "");
			
			int statusAction = Integer.valueOf(request.getParameter("statusAction")); 
			int teamMember = Integer.valueOf(request.getParameter("teamMember")); 
			String targetDate = request.getParameter("targetDate"); 
			/* String completeDate = request.getParameter("completeDate"); */
			String reasonPlan = request.getParameter("reasonPlan");
			
			reasonPlan = reasonPlan.replaceAll("\"", "");
			reasonPlan = reasonPlan.replaceAll("\'", "");
			
			String findings = request.getParameter("findings");
			
			findings = findings.replaceAll("\"", "");
			findings = findings.replaceAll("\'", "");
			
			PreparedStatement ps_check = null, ps_data=null, ps_data1=null, ps_data2=null;
			ResultSet rs_check=null, rs_data=null, rs_data1=null, rs_data2=null;
			
			int act_score=0,planScore=0;
			ps_data = con_master.prepareStatement("select * from rel_pt_dateTimeline where problem_id="+probID+" and phase_id="+phaseID);
			rs_data = ps_data.executeQuery();
			while(rs_data.next()){
				act_score=rs_data.getInt("actual_score");
				planScore=rs_data.getInt("plan_score");
			}
			
			// Review Date
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
			
			ps_data1 = con_master.prepareStatement("select * from rel_pt_masterData where id="+statusAction+" and master_name=(select master_name from rel_pt_masterData where searchTerm='actionStatus' and  master_name='Completed')");
			rs_data1 = ps_data1.executeQuery();
			if(rs_data1.next()){ 
				myquery = "insert into rel_pt_review"+
						"(problem_id,phase_id,plan_score,act_score,review_date,action_details,action_status_id,resp_uid,target_date,"+
						" reason,findings,enable,created_by,created_date,changed_by,changed_date,completion_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				flag_query = true;
			}else{  
				myquery = "insert into rel_pt_review"+
					"(problem_id,phase_id,plan_score,act_score,review_date,action_details,action_status_id,resp_uid,target_date,"+
					" reason,findings,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			}
			ps_check = con_master.prepareStatement(myquery);
			ps_check.setInt(1, probID);
			ps_check.setInt(2, phaseID);
			ps_check.setInt(3, planScore);
			ps_check.setInt(4, act_score);
			ps_check.setDate(5, vo.getReviewDate());
			ps_check.setString(6, actionDetails);
			ps_check.setInt(7, statusAction);
			ps_check.setInt(8, teamMember);
			ps_check.setDate(9, vo.getTargetDate());
			ps_check.setString(10, reasonPlan);
			ps_check.setString(11, findings);
			ps_check.setInt(12, 1);
			ps_check.setInt(13, uid);
			ps_check.setTimestamp(14, timeStamp);
			ps_check.setInt(15, uid);
			ps_check.setTimestamp(16, timeStamp);
			
			if(flag_query==true){
			ps_check.setDate(17, todaysdate);
			}
		int up = ps_check.executeUpdate(); 
		if(up>0){
		%>
         <strong style="color: green;">Success</strong> 
        <%
		}else{
		%> 
	    <strong style="color: red;">Error Occurred</strong> 
	    <%
		}
		%>	 
<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="12" align="center" style="font-size: 12px;font-weight: bold;background-color: #0062b8;color: white;">Review and Action planning Data</td>
  </tr>
<tr align="center" style="background-color: #8eb1ca;color: white;">
 <th>Id</th>
 <th>Phase</th> 
 <th>Review Date</th>
 <th>Action Details</th>
 <th>Status</th>
 <th>Responsibility</th>
 <th>Target Date</th>
 <th>Completion Date </th>
 <th>Reason for Planning action</th>
 <th>Findings</th> 
  <th>Edit</th> 
</tr>
  <%
  String respUser="";
  ps_check = con_master.prepareStatement("select rel_pt_review.resp_uid as resp_uid ,rel_pt_review.id as id,rel_pt_review.completion_date as completion_date, "+
			" rel_pt_review.reason as reason, rel_pt_review.findings as findings, "+
			" rel_pt_review.target_date as target_date, rel_pt_phase.phase as phase "+
			" ,rel_pt_review.review_date as review_date,rel_pt_review.action_details as action_details,rel_pt_masterData.master_name "+ 
			" as master_name from rel_pt_review inner join rel_pt_masterData on "+
			" rel_pt_review.action_status_id=rel_pt_masterData.id inner join rel_pt_phase on "+
	  " rel_pt_phase.seqNo=rel_pt_review.phase_id where rel_pt_phase.enable=1 and rel_pt_masterData.enable=1 and rel_pt_review.enable=1 and rel_pt_review.problem_id="+probID+"  order by rel_pt_review.id desc");
  rs_check = ps_check.executeQuery();
  while(rs_check.next()){
	  		ps_data = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_check.getInt("resp_uid"));
			rs_data = ps_data.executeQuery();
		while(rs_data.next()){
			respUser = rs_data.getString("u_name");
		}
  %>
  <tr>
    <td align="right"><%=rs_check.getInt("id") %></td>
    <td align="left"><%=rs_check.getString("phase")%></td>
    <td><%=df.format(rs_check.getDate("review_date"))%></td>
    <td><%=rs_check.getString("action_details") %></td>
    <td>
   <select class="form-control" id="statusAction_rev<%=rs_check.getInt("id")%>" name="statusAction_rev<%=rs_check.getInt("id")%>"  style="color: black;font-size: 12px;"> 
		<% 
		ps_data1 = con_master.prepareStatement("SELECT id,master_name from rel_pt_masterData where enable=1 and searchTerm='actionStatus' and master_name='"+rs_check.getString("master_name")+"' union all "+
				" SELECT id,master_name from rel_pt_masterData where enable=1 and searchTerm='actionStatus' and master_name!='"+rs_check.getString("master_name")+"'");
		rs_data1 = ps_data1.executeQuery();
		while(rs_data1.next()){
		%>
		<option value="<%=rs_data1.getInt("id")%>"><%=rs_data1.getString("master_name") %></option>
		<%
		}
		%> 
	</select> 
    </td>
    <td><%=respUser %></td>
    <td><%=df.format(rs_check.getDate("target_date"))%></td>
    <td>
    <%  
    if(rs_check.getString("completion_date")!=null){ 
    %>
    <%=df.format(rs_check.getDate("completion_date"))%>
    <%
    }
    %>
    </td>
    <td>
    <textarea rows="2" cols="20" class="form-control" name="reasonPlan_rev<%=rs_check.getInt("id")%>" id="reasonPlan_rev<%=rs_check.getInt("id")%>" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"> <%=rs_check.getString("reason") %></textarea>
    </td>
    <td>
    <textarea rows="2" cols="20" class="form-control" name="findings_rev<%=rs_check.getInt("id")%>" id="findings_rev<%=rs_check.getInt("id")%>" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"><%=rs_check.getString("findings") %></textarea>
   	</td>
   	<td> 
   	<span id="updateRv<%=rs_check.getInt("id")%>">
   	<% 
   	ps_data2 = con_master.prepareStatement("SELECT * from rel_pt_masterData where enable=1 and searchTerm='actionStatus' and master_name='"+rs_check.getString("master_name")+"'");
	rs_data2 = ps_data2.executeQuery();
	while(rs_data2.next()){
		if(rs_data2.getString("master_name").equalsIgnoreCase("Inprocess")){
   	%>
   	 <img alt="#" src="img/pencil.png" id="pen_button_rev<%=rs_check.getInt("id")%>" name="pen_button_rev<%=rs_check.getInt("id")%>" style="cursor: pointer;" onclick="javascript:updateReview('<%=probID%>','<%=phaseID%>','<%=rs_check.getInt("id")%>')">
   	 <%
		}
   		}
   	 %>
   	</span>
   	<!-- -------------------------------------------------- Modal For History Review Data --------------------------------------- -->
<a data-toggle="modal" href="#myModalCall<%=rs_check.getInt("id")%>">
<img src="img/LogHere.png" title="History" style="cursor: pointer;" id="log22<%=rs_check.getInt("id") %>">
</a>
			<!-- Modal -->
                <div class="modal fade" id="myModalCall<%=rs_check.getInt("id") %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content"> 
                      <div class="modal-body"> 
                      <table class="gridtable" width="100%"> 
                      <tr style='font-size: 12px; background-color: #fbffd4; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th colspan='4'>Message History</th></tr> 
						<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th>Message No </th><th>Sent By</th><th>Message</th><th>Sent Date</th></tr>
                        <%
                        ps_data = con_master.prepareStatement("select * from rel_pt_messgeLog where problem_id="+rs_check.getInt("id") + " order by seq_no desc");
                		rs_data = ps_data.executeQuery();
                		while(rs_data.next()){
                		%>
                		<tr style="font-size: 11px;">
                			<td style="text-align: right;width: 40px;"><%=rs_data.getInt("seq_no") %></td>
                			<td><%=rs_data.getString("user_name")%></td> 
                			<td><%=rs_data.getString("msg_data")%></td>
                			<td><%=format.format(rs_data.getDate("changed_date")) %></td>
                		</tr>
                		<%		
                		}
                        %>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
    		<!-- modal -->
   	</td>
  </tr>
  <%
  }
  %>
</table>
</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>  
</body>
</html>