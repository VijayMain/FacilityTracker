<%@page import="java.text.SimpleDateFormat"%>
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
	// "SixSigma_DashAjax.jsp?plant=" + plant + "&typeProject=" + typeProject + "&problem=" + problem + "&phaseSelect=" + phaseSelect
	String typeProject = "";
	String plant = "";
	String problem = "";
	String phaseSelect = "";
	int uid_data = Integer.valueOf(session.getAttribute("uid").toString());
	if(request.getParameter("typeProject")!=""){
		typeProject = " and typeProject=" + Integer.valueOf(request.getParameter("typeProject")) + " ";
	}
	if(request.getParameter("plant")!=""){
		plant = " and plant='" + request.getParameter("plant") +"' ";
	}
	if(request.getParameter("problem")!=""){
		problem = " and problem_descr like '%" + request.getParameter("problem") + "%' ";
	}
	if(request.getParameter("phaseSelect")!=""){
		phaseSelect = " and phase_id=" + request.getParameter("phaseSelect") + " ";
	}
	Connection con_master = Connection_Util.getConnectionMaster();
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
	
	 boolean checkFlag=false;
	  String newQuery="";
	  	PreparedStatement ps_user = con_master.prepareStatement("select id from rel_pt_releaseMaster where enable=1 and app_uid="+uid_data);
		ResultSet rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			checkFlag=true;
		}
		ps_user = con_master.prepareStatement("select id from rel_pt_reviewer where enable=1 and u_id="+uid_data);
		rs_user = ps_user.executeQuery();
		while(rs_user.next()){
			checkFlag=true;
		}
%>
	<span id="dash_Data">
			<table class="gridtable" width="100%">
					<tr style="background-color: #dedede;color: black;"> 
						<th>No</th>
						<th>Plant</th>
						<th>Problem Description</th>
						<th>Product</th>
						<th>Product Other Name</th>
						<th>Type of Project</th> 
						<th>Department</th> 
						<th>Project Lead</th> 
						<th>Log Date</th>  
						<th>Phase</th> 
						<th>Message</th>
						<th>Decision</th>
					</tr> 
					<%
					String deptsearchTerm = "",matCode="",phase="",redirect="",approval="",searchTerm="";
					PreparedStatement ps_data=null,ps_check=null;
					int company_id=0;
					ResultSet rs_data=null,rs_check=null;
					String defineQuery ="";
					 
					if(checkFlag==true){ 
						defineQuery = "select * from tran_pt_problem where enable=1 " + typeProject  +  plant +  problem +  phaseSelect;
					}else{
						defineQuery = "select * from tran_pt_problem where enable=1 and project_lead=" + uid_data + typeProject  +  plant +  problem +  phaseSelect; 						 
					}
					
					ps_check = con_master.prepareStatement(defineQuery);
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						deptsearchTerm = "";matCode="";phase="";approval="";searchTerm="";
						ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("dept_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							deptsearchTerm = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("select material from rel_SAPmaster_mm60 where id="+rs_check.getInt("product_code"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							matCode = rs_data.getString("material");
						} 
						ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("typeProject"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							searchTerm = rs_data.getString("master_name");
						}
						ps_data = con_master.prepareStatement("select approval_Type from approval_type where id="+rs_check.getInt("approval_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							approval = rs_data.getString("approval_Type");
						} 
						ps_data = con_master.prepareStatement("select redirect,phase from rel_pt_phase where id="+rs_check.getInt("phase_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							phase = rs_data.getString("phase");
							redirect = rs_data.getString("redirect");
						}
					%>
					<tr>
						<td align="right"><%=rs_check.getInt("id") %></td>
						<td align="right"><%=rs_check.getString("plant") %></td>
						<td><%=rs_check.getString("problem_descr") %></td>
						<td><b><%=matCode %></b><br><%=rs_check.getString("product_codeDescr") %></td>
						<td><%=rs_check.getString("type_product_code") %></td>
						<td><%=searchTerm %></td>
						<td><%=deptsearchTerm %></td>
						<td><strong><%=rs_check.getString("project_leadName") %></strong><br>[Creator: <%=rs_check.getString("created_byName")%>]</td>
						<td><%=format.format(rs_check.getDate("tran_date")) %></td>
						<td><%=phase %></td>
				<td> 
	<span id="sendMsgBack<%=rs_check.getInt("id")%>">
	<textarea class="form-control" placeholder="Message For Team ..." onkeypress="return checkQuote();" style="color: black !important;font-size: 10px;" rows="1" cols="3" id="sendMsg<%=rs_check.getInt("id")%>" name="sendMsg<%=rs_check.getInt("id")%>"></textarea>
	</span>	
				</td>
<td align="center" style="width: 100px;">
<a href="<%=redirect %>?problem_id=<%=rs_check.getInt("id")%>" style="color: black;" title="Click for Details"><img alt="#" src="img/update.png" style="height: 20px;"> </a>
<img src="img/send.png" title="Send Message" style="cursor: pointer;"  onclick="sendMessage(<%=rs_check.getInt("id") %>); return false;" id="msgSend<%=rs_check.getInt("id") %>">
</td>
				</tr>
					<%
					}
					%>
			</table> 
	</span>
	<%	
	con_master.close(); 
}catch(Exception e){
	e.printStackTrace();
}
%> 
</body>
</html>