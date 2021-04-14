<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%> 
<%@page import="java.util.Calendar"%>
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
<title>Define and Charter</title>
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.min.css" rel="stylesheet" />
  <link href="css/daterangepicker.css" rel="stylesheet" />
  <link href="css/bootstrap-datepicker.css" rel="stylesheet" />
  <link href="css/bootstrap-colorpicker.css" rel="stylesheet" />
  <!-- date picker -->
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'dd-MM-yyyy'});
</script>            
  <!-- color picker -->
  
  <!-- full calendar css-->
  <link href="assets/fullcalendar/fullcalendar/bootstrap-fullcalendar.css" rel="stylesheet" />
  <link href="assets/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" />
  <!-- easy pie chart-->
  <link href="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen" />
  <!-- owl carousel -->
  <link rel="stylesheet" href="css/owl.carousel.css" type="text/css">
  <link href="css/jquery-jvectormap-1.2.2.css" rel="stylesheet">
  <!-- Custom styles -->
  <link rel="stylesheet" href="css/fullcalendar.css">
  <link href="css/widgets.css" rel="stylesheet">
  <link href="css/style.css" rel="stylesheet">
  <link href="css/style-responsive.css" rel="stylesheet" />
  <link href="css/xcharts.min.css" rel=" stylesheet">
  <link href="css/jquery-ui-1.10.4.min.css" rel="stylesheet"> 
  <script type="text/javascript">
  function decision_call(val) {
	  var retVal = confirm("Are you sure to delete...?"); 
      if( retVal == true ) {
      alert("You Pressed OK!");
    	var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();  
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");   
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("deleteMember"+val).innerHTML = xmlhttp.responseText; 
				}
			};  
			xmlhttp.open("POST", "SixSigma_RemoveMembers.jsp?id=" + val, true);  
			xmlhttp.send();    
	      } else {
	    	  alert("You Pressed Cancel!");
	    	  return false;
	      }
	};
	 
	  function checkQuote() {
			if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
				event.keyCode = 0;
				return false;
			}
		}
	
	function validatenumerics(key) {
		
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
		
		//getting key code of pressed key
		var keycode = (key.which) ? key.which : key.keyCode;
		//comparing pressed keycodes	 
		if (keycode > 31 && (keycode < 48 || keycode > 57) && keycode != 46 && keycode != 37 && keycode != 38 && keycode != 39 && keycode != 40) {
		    alert("Only allow numeric Data entry");
		    return false;
		}else 
		{
			return true;
		};
		}	
	function numericEvent(val,input) {
		var logAvail =  document.getElementById('logActSCR').value;
		var sum=0;
		if (val<input || input==0) {
		   document.getElementById('input_value').value = '';
		   document.getElementById('logScore').value = logAvail;
		   alert("Wrong Input");
		}else{ 
			sum = input;
			document.getElementById('logScore').value = sum;
		}
	}
	
	function Get_ScoreDetails() {
		var classProject = document.getElementById('classProject').value;  
		var nature = document.getElementById('nature').value;  
		var impact_extCust = document.getElementById('impact_extCust').value;  
		var impact_intCust = document.getElementById('impact_intCust').value; 
		var dataAnalysis = document.getElementById('dataAnalysis').value; 
		var crossfun_rate = document.getElementById('crossfun_rate').value; 
		var exp_Saving = document.getElementById('exp_Saving').value; 
		var baselinePPM = document.getElementById('baselinePPM').value;  
		
		 var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();  
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");   
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("scoreajax").innerHTML = xmlhttp.responseText;  
					Get_RatingDetails(document.getElementById("myHid").value);
				}
			};
		 	xmlhttp.open("POST", "SixSigma_Define_scoreAJ.jsp?classProject=" + classProject + "&nature=" + nature + "&impact_extCust=" + impact_extCust + "&impact_intCust=" + impact_intCust
		 			+ "&dataAnalysis=" + dataAnalysis + "&crossfun_rate=" + crossfun_rate + "&exp_Saving=" + exp_Saving + "&baselinePPM=" + baselinePPM, true);  
			xmlhttp.send(); 
		}
	function Get_RatingDetails(val) {
		 var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();  
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");   
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("rateAjax").innerHTML = xmlhttp.responseText;  
				}
			};
		 	xmlhttp.open("POST", "SixSigma_Define_scoreAJ.jsp?rating=" + val, true);  
			xmlhttp.send(); 
	}
	
	function sendMessage(val) {
		 var sendMsg = document.getElementById('sendMsg');  
		 var msgTeam = document.getElementById('msgTeam');
		 
		 if(sendMsg.value!=""){
			 sendMsg.readOnly = true;
			 msgTeam.style.display = "none"; 
			 
		   var xmlhttp;
			if (window.XMLHttpRequest) {
				// code for IE7+, Firefox, Chrome, Opera, Safari
				xmlhttp = new XMLHttpRequest();  
			} else {
				// code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange = function() {
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
					document.getElementById("sendMsgBack").innerHTML = xmlhttp.responseText; 
				}
			};
		 	xmlhttp.open("POST", "SixSigma_msgSendtoTeam.jsp?id=" + val + "&sendMsg=" + sendMsg.value + "&select=1", true);  
			xmlhttp.send(); 
		}else{
			alert("Message For Team...?");
		}
	}
	// ********************************************************************************************************************************************************************
	// ******************************************************************** Review Data ***********************************************************************************
 		function saveReview(probID,phaseID) {
 		var logTodaysDate = document.getElementById("logTodaysDate").value;
		var reviewDate = document.getElementById("dp4").value;
		var actionDetails = document.getElementById('actionDetails').value;  
		var statusAction = document.getElementById('statusAction').value;  
		var teamMember = document.getElementById('teamMember').value; 
		var targetDate = document.getElementById('dp2').value; 
		/* var completeDate = document.getElementById('dp3').value;  */
		var reasonPlan = document.getElementById('reasonPlan').value; 
		var findings = document.getElementById('findings').value;
		
		if(reviewDate!=null && reviewDate!="" &&
			actionDetails!=null && actionDetails!="" &&
				statusAction!=null && statusAction!="" &&
				teamMember!=null && teamMember!="" &&
				targetDate!=null && targetDate!=""){
			
			 	var xmlhttp;
				if (window.XMLHttpRequest) {
					// code for IE7+, Firefox, Chrome, Opera, Safari
					xmlhttp = new XMLHttpRequest();  
				} else {
					// code for IE6, IE5
					xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
				xmlhttp.onreadystatechange = function() {
					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
						document.getElementById("reviewProblem").innerHTML = xmlhttp.responseText;  
						document.getElementById('teamMember').selectedIndex = 0;  
						document.getElementById('statusAction').selectedIndex = 0;
						document.getElementById('actionDetails').value='';
						document.getElementById('reasonPlan').value='';
						document.getElementById('findings').value='';
						document.getElementById("dp4").value=logTodaysDate;  
						document.getElementById('dp2').value=''; 
						/* document.getElementById('dp3').value='';  */
						
					}
				};
			  	xmlhttp.open("POST", "SixSigma_ReviewAction.jsp?probID="+probID +"&phaseID="+  phaseID  +"&reviewDate="+ reviewDate +"&actionDetails="+ 
			  			actionDetails +"&statusAction="+  statusAction +"&teamMember="+  teamMember  +"&targetDate="+  targetDate  +"&reasonPlan="+   reasonPlan   +"&findings="+ findings, true);  
				xmlhttp.send();
				
		}else{
			alert("Review Date,Action Details,Status,Responsibility,Target Date fields are Mandatory...!!!");
		}
		}
	// ********************************************************************************************************************************************************************
		function updateReview(probID,phaseID,idReview) {	           
			var statusAction = document.getElementById('statusAction_rev'+idReview).value;
			var reasonPlan = document.getElementById('reasonPlan_rev'+idReview).value;
			var findings = document.getElementById('findings_rev'+idReview).value;
			
			var pen_button_rev = document.getElementById('pen_button_rev'+idReview);
			
			if(statusAction!=null && statusAction!=""){
				pen_button_rev.style.display = "none";
				
				 	var xmlhttp;
					if (window.XMLHttpRequest) {
						// code for IE7+, Firefox, Chrome, Opera, Safari
						xmlhttp = new XMLHttpRequest();
					} else {
						// code for IE6, IE5
						xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
					}
					xmlhttp.onreadystatechange = function() {
						if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
							document.getElementById("updateRv"+idReview).innerHTML = xmlhttp.responseText; 
						}
					};
				  	xmlhttp.open("POST", "SixSigma_ReviewActionAJAX.jsp?probID="+probID +"&phaseID="+  phaseID +"&statusAction="+  statusAction 
				  			+"&reasonPlan="+   reasonPlan   +"&findings="+ findings +"&idReview="+ idReview , true);  
					xmlhttp.send();
			}else{
				alert("Status is Mandatory..!!!");
			}
		}
	// ********************************************************************************************************************************************************************
</script>
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

<body style="color: black;">
<%
try{
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0;
	int inputValue=0;
	String act_defDate="",act_endDate="";
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	boolean availFlag=false ;
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	PreparedStatement ps_check = null, ps_check1=null,ps_local=null;
	ResultSet rs_check = null,rs_check1=null,rs_local=null; 
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
	java.util.Date date2cmp;
	Calendar calobj = Calendar.getInstance();
	String todays_date = format2.format(calobj.getTime());
	date2cmp = format2.parse(todays_date);
	int problem_id = Integer.valueOf(request.getParameter("problem_id"));
	
	long millis=System.currentTimeMillis();
    java.sql.Date todays_Sqldate=new java.sql.Date(millis);
    String tod = df.format(todays_Sqldate); 
	/* date1cmp = sdf2.parse(october_date);
	diff = Math.abs(date2cmp.getTime() - date1cmp.getTime()) / (1000 * 60 * 60 * 24); */
/*-------------------------------------------------------------------------------------------------------------------*/ 
%> 
<!-- container section start -->
<section id="container" class="">
<!---------------------------------------------------------------  Include Header ---------------------------------------------------------------------------------------->
<%@include file="Header.jsp" %>
<!---------------------------------------------------------------  Include Sidebar ---------------------------------------------------------------------------------------->
<%@include file="Sidebar.jsp" %>		
<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->	
<!--main content start-->
    <section id="main-content">
      <section class="wrapper">
        <!--overview start-->
        <div class="row"> 
        <%
        String define = "define_charter";
        %>
       <!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> --> 
        
        <jsp:include page="SixSigma_Header.jsp" > 
  		<jsp:param name="define" value="<%=define %>" />
		</jsp:include>
        
        </div> 
<!-- ********************************************************************************************************************* -->
<div> 
<input type="hidden" id="logTodaysDate" value="<%=tod%>">
<%
String deptsearchTerm = "",searchTerm="",matCode="",phase="",approval="",plantDetails="",projectLeadName="";
int company_id=0, projectLead_id=0,phaseSubmit=0;
PreparedStatement ps_data=null,ps_data2=null,ps_data1=null;
ResultSet rs_data=null,rs_data2=null,rs_data1=null;
Date approveDate=null;
ps_check = con_master.prepareStatement("select * from tran_pt_problem where id="+problem_id);
rs_check = ps_check.executeQuery();
while(rs_check.next()){
	projectLeadName = rs_check.getString("project_leadName");
	projectLead_id = rs_check.getInt("project_lead");
	approveDate = rs_check.getDate("approval_date");
	phaseSubmit = rs_check.getInt("phase_id");
	ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("dept_id"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		deptsearchTerm = rs_data.getString("master_name");
	}
	ps_data = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+rs_check.getInt("typeProject"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		searchTerm = rs_data.getString("master_name");
	}
	ps_data = con_master.prepareStatement("select material from rel_SAPmaster_mm60 where id="+rs_check.getInt("product_code"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		matCode = rs_data.getString("material");
	} 
	ps_data = con_master.prepareStatement("select approval_Type from approval_type where id="+rs_check.getInt("approval_id"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		approval = rs_data.getString("approval_Type");
	}
	if(rs_check.getInt("approval_id")!=1){
		approval = approval + " by " + rs_check.getString("changed_byName");
	}
	ps_data = con_master.prepareStatement("select phase from rel_pt_phase where id="+rs_check.getInt("phase_id"));
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		phase = rs_data.getString("phase");
	}
	ps_data = con.prepareStatement("SELECT company_id,Company_Name FROM user_tbl_company where plant='"+rs_check.getString("plant")+"'");
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		company_id=rs_data.getInt("company_id");
		plantDetails = rs_check.getString("plant") +" - "+ rs_data.getString("Company_Name");
	}
	// **********************************************************************************************************************
	
%>
<!-- ================================================================================================================================== -->
<!-- ========================================================= Header ================================================================= --> 
<%
String classProject="",impactIntCust="",impactExtcustomer="",dataAnalysis="",crossFunctionalRating="",baseline="",baseline_target="",rateDefine="";
float expectedSaving=0,baselinePPM=0,baselinePPM_target=0,projectScore=0;
boolean flagAvail=false;
ps_check1 = con_master.prepareStatement("select * from rel_pt_definePhase where enable=1 and problem_id="+problem_id);
rs_check1 = ps_check1.executeQuery();
while(rs_check1.next()){
	
	expectedSaving= rs_check1.getFloat("expectedSaving");
	baselinePPM= rs_check1.getFloat("baselinePPM");
	baselinePPM_target= rs_check1.getFloat("baselinePPM_target");
	projectScore= rs_check1.getFloat("projectScore");
	rateDefine= rs_check1.getString("rateDefine");
	baseline=rs_check1.getString("baseline");;
	baseline_target=rs_check1.getString("baseline_target");;
	
	flagAvail=true;
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
%>
<form action="SixSigma_defineControl" method="post" onsubmit="submit.disabled = true; return true;">
<input type="hidden" name="prob_id" id="prob_id" value="<%=problem_id%>">
<table class="gridtable" width="100%">
  <tr>
  	<td align="center" style="background-color: #e2ef77;width: 80px;">
  	<%
  	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_definePhase where enable=1 and problem_id="+problem_id);
	rs_data = ps_data.executeQuery();
	if(rs_data.next()){
  	%>
  <strong>Updated</strong><!-- <input type="submit" disabled="disabled" class="btn-primary" name="submit" id="submit" value=" SAVE  " style="font-weight: bold;height: 20px !important;"> -->
  	<%
	}else{
	%>
	<input type="submit" class="btn-primary" name="submit" id="submit" value=" SAVE  " style="font-weight: bold;height: 20px !important;">
	<%	
	}
  	%>
  	</td>
    <td align="center" style="font-size: 12px;font-weight: bold;background-color: #a59eff">DEFINE - Project Definition and Charter</td>
      <%
  		if(request.getParameter("success")!=null){
		%>  
		<td align="center" style="font-size: 12px;font-weight: bold;background-color: #06a415;color: white;">
		<a href="SixSigma_Define_Charter.jsp?problem_id=<%=problem_id%>" style="color: white;"><%=request.getParameter("success") %></a>
		</td> 
        <%
		}if(request.getParameter("statusNop")!=null){
		%> 
		<td align="center" style="font-size: 12px;font-weight: bold;background-color: #a41206;color: white;">
		<a href="SixSigma_Define_Charter.jsp?problem_id=<%=problem_id%>"  style="color: white;"><%=request.getParameter("statusNop") %></a>
		</td>  
	    <%
		}
		%> 
    <td align="center" style="background-color: #c35b02;color: white;font-weight: bold;width: 100px;">No <%= problem_id%></td>
    <td align="center" style="background-color: #18124d;color: white;font-weight: bold;width: 150px;"><%=plantDetails%></td> 
    <!-- <td align="center" style="background-color: red;font-weight: bold;color: white;width: 130px;">LOW IMPACT</td> -->
  </tr>
</table>
<!-- ================================================================================================================================== -->
<!-- ===================================================== Project Details ============================================================ -->
<%
if(flagAvail==false){
%>
<table class="gridtable" width="100%"> 
  <tr> 
    <th>Problem Title</th>
    <td colspan="7"><%=rs_check.getString("problem_descr").toUpperCase() %></td> 
  </tr>
  <tr>
    <th>Product Code</th>
    <td><%= matCode %></td>
    <th>Product Description</th>
    <td colspan="5"><%=rs_check.getString("product_codeDescr").toUpperCase() %></td> 
  </tr>
  <tr>
    <th>Project Type</th>
    <td><%=searchTerm.toUpperCase() %>
    <input type="hidden" id="nature" value="<%=rs_check.getInt("typeProject") %>">
    </td> 
    <th>Department</th>
    <td><%=deptsearchTerm.toUpperCase() %></td>
    <th>Problem Registered By</th>
    <td colspan="3"><%=rs_check.getString("created_byName") %></td>
  </tr>
  <tr>
    <th>Classification of Project</th>
    <td>
	<%
	float score=0;
	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 and searchTerm='classProject'");
	rs_data = ps_data.executeQuery();
    %>
	<select name="classProject" id="classProject" onchange ="Get_ScoreDetails()" class="form-control" style="font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<option value=""> - - Select - - </option>
	<%
	while(rs_data.next()){
		score = rs_data.getFloat("weightage") * rs_data.getFloat("ratingScore");
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%>
	</select>
	</td>
    <th>Impact on Internal Customer</th>
    <td>
    <% 
	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactInternalCust'");
	rs_data = ps_data.executeQuery();
    %>
	<select name="impact_intCust" id="impact_intCust" onchange ="Get_ScoreDetails()"  class="form-control" style="font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<option value=""> - - Select - - </option>
	<%
	while(rs_data.next()){
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%>
	</select>
    </td>
    <th>Impact on External Customer</th>
    <td colspan="3">
	<% 
	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 AND searchTerm='impactExtcustomer'");
	rs_data = ps_data.executeQuery();
    %>
	<select name="impact_extCust" id="impact_extCust" onchange ="Get_ScoreDetails()"  class="form-control" style="font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<option value=""> - - Select - - </option>
	<%
	while(rs_data.next()){
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%>
	</select>
	</td>
  </tr>
  <tr>
    <th>Data Oriented Analysis</th>
    <td>
	<%
	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData where enable=1 and searchTerm='dataAnalysis'");
	rs_data = ps_data.executeQuery();
    %>
	<select name="dataAnalysis" id="dataAnalysis" onchange ="Get_ScoreDetails()"  class="form-control" style="font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<option value=""> - - Select - - </option>
	<%
	while(rs_data.next()){
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%>
	</select>
	</td>
    <th>Cross Functional Rating</th>
    <td>
	<% 
	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_masterData WHERE enable=1 AND searchTerm='crossFunctionalRating'");
	rs_data = ps_data.executeQuery();
    %>
	<select name="crossfun_rate" id="crossfun_rate" onchange ="Get_ScoreDetails()"  class="form-control" style="font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<option value=""> - - Select - - </option>
	<%
	while(rs_data.next()){
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%>
	</select>
	</td>
    <th>Expected Savings Rupees in Lakhs</th>
    <td colspan="3"><input type="text" onkeypress="return validatenumerics(event);" onkeyup ="Get_ScoreDetails()"  name="exp_Saving" id="exp_Saving" class="form-control" style="height: 23px !important;width: 150px;color: black;" required></td>
  </tr>  
  <tr>
    <th>Baseline in PPM</th>
    <td>
    <%
    if(searchTerm.toUpperCase().equalsIgnoreCase("Problem Solving")){
    %>
    <input type="text" name="baselinePPM" id="baselinePPM" onkeyup ="Get_ScoreDetails()" onkeypress="return validatenumerics(event);" class="form-control" style="height: 23px !important;width: 150px;color: black;" required>
    <%
    }else{
    %>
    	<input type="text" name="baselinePPM" id="baselinePPM" readonly="readonly" onkeyup ="Get_ScoreDetails()" onkeypress="return validatenumerics(event);" class="form-control" style="height: 23px !important;width: 150px;color: black;">
   	<%
    }
    %>
    </td>
    <th>Target</th>
    <td>
     <%
    if(searchTerm.toUpperCase().equalsIgnoreCase("Problem Solving")){
    %>
    <input type="text" name="targetPPM" id="targetPPM" onkeypress="return validatenumerics(event);" class="form-control" style="height: 23px !important;width: 150px;color: black;" required>
     <%
    }else{
    %>
    <input type="text" name="targetPPM" id="targetPPM" readonly="readonly" onkeypress="return validatenumerics(event);" class="form-control" style="height: 23px !important;width: 150px;color: black;">
    <%
    }
    %>
    </td>
    <th>Project Score</th>
    <td colspan="3">
    <span id="scoreajax">
    <input type="hidden" id="myHid" name="myHid" value="0">
    </span></td>
  </tr>
  <tr>
    <th>Baseline</th>
    <td>
    <%
    if(!searchTerm.toUpperCase().equalsIgnoreCase("Problem Solving")){
    %>
    <input type="text" name="baseline"  id="baseline" onkeypress="return checkQuote();" class="form-control" style="height: 23px !important;width: 150px;color: black;" required>
    <%
    }else{
    %>
    <input type="text" name="baseline" readonly="readonly"  id="baseline" onkeypress="return checkQuote();" class="form-control" style="height: 23px !important;width: 150px;color: black;">
    <%	
    }
    %>
    </td>
    <th>Target</th>
    <td>
    <%
    if(!searchTerm.toUpperCase().equalsIgnoreCase("Problem Solving")){
    %>
    <input type="text" name="target_baseline" id="target_baseline" onkeypress="return checkQuote();" class="form-control" style="height: 23px !important;width: 150px;color: black;" required>
    <%
    }else{
    %>
    <input type="text" name="target_baseline" readonly="readonly" id="target_baseline" onkeypress="return checkQuote();" class="form-control" style="height: 23px !important;width: 150px;color: black;">
    <%	
    }
    %>
    </td>
    <th>Project Rating</th>
    <td colspan="3">
    <span id="rateAjax">
    <input type="hidden" id="rateDefine" name="rateDefine">
    </span>
    </td>
  </tr>
</table>
<%
}else{
%>
<table class="gridtable" width="100%"> 
  <tr> 
    <th>Problem Title</th>
    <td colspan="7"><%=rs_check.getString("problem_descr").toUpperCase() %></td> 
  </tr>
  <tr>
    <th>Product Code</th>
    <td><%= matCode %></td>
    <th>Product Description</th>
    <td colspan="5"><%=rs_check.getString("product_codeDescr").toUpperCase() %></td> 
  </tr>
  <tr>
    <th>Project Type</th>
    <td><%=searchTerm.toUpperCase() %>
    <input type="hidden" id="nature" value="<%=rs_check.getInt("typeProject") %>">
    </td> 
    <th>Department</th>
    <td><%=deptsearchTerm.toUpperCase() %></td>
    <th>Problem Registered By</th>
    <td colspan="3"><%=rs_check.getString("created_byName") %></td>
  </tr>
  <tr>
    <th>Classification of Project</th>
    <td><%=classProject %> </td>
    <th>Impact on Internal Customer</th>
    <td><%=impactIntCust %> </td>
    <th>Impact on External Customer</th>
    <td colspan="3"><%=impactExtcustomer %> </td>
  </tr>
  <tr>
    <th>Data Oriented Analysis</th>
    <td> <%=dataAnalysis %></td>
    <th>Cross Functional Rating</th>
    <td><%=crossFunctionalRating %> </td>
    <th>Expected Savings Rupees in Lakhs</th>
    <td colspan="3"><%=expectedSaving %></td>
  </tr>  
  <tr>
    <th>Baseline in PPM</th>
    <td><%=baselinePPM %> </td>
    <th>Target</th>
    <td><%=baselinePPM_target %></td>
    <th>Project Score</th>
    <td colspan="3"><%=projectScore %> </td>
  </tr>
  <tr>
    <th>Baseline</th>
    <td><%=baseline %></td>
    <th>Target</th>
    <td><%=baseline_target %></td>
    <th>Project Rating</th>
     <%-- <%=rateDefine %>  --%>  
    <%
    float impact=0;
	String impactText = "";
	ps_data = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and searchTerm='actualProjectScore' and "+projectScore+" between min and max");
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		impact = rs_data.getFloat("weightage");
		impactText = rs_data.getString("master_name");
	}
				if(impact==0){
			%>
			<td colspan="3" style="font-size: 12px;color: white;background-color: red;">
			<strong><%=impactText %></strong>
			</td>
			<%		
				}else if(impact==1){
			%>
			<td style="font-size: 12px;color: black; background-color: yellow;">
			<strong><%=impactText %></strong>	
			</td>
			<%			
				}else if(impact==2){
			%>
			<td style="font-size: 12px;color: white; background-color: green;">
			<strong><%=impactText %></strong>		
			</td>
			<%		
				}
			%>
			<input type="hidden" id="rateDefine" name="rateDefine" value="<%=impactText%>">
			<%
			 }
			 %> 
  </tr>
</table>
<%	
}
%>
</form>
<!-- ================================================================================================================================== -->
<!-- ================================================================================================================================== -->
<%
//************************************* Date Logic *********************************************************************
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	Calendar c = Calendar.getInstance();
	c.setTime(approveDate); // Now use Approval date. 
	String define_days ="",measure_days ="",analyze_days ="",improve_days ="",control_days ="";
	int define_lbl =0,measure_lbl =0,analyze_lbl =0,improve_lbl =0,control_lbl =0,phaseID=0;
	float sumScore=0;
	PreparedStatement ps_sql = con_master.prepareStatement("select * from rel_pt_phase where enable=1 and seqNo between 2 and 6");
	ResultSet rs_sql = ps_sql.executeQuery();
	while(rs_sql.next()){
		if(rs_sql.getInt("seqNo")==2){
			phaseID=rs_sql.getInt("seqNo");
			c.add(Calendar.DATE, rs_sql.getInt("plan_days")); 
			define_days = sdf.format(c.getTime()); 
			define_lbl = rs_sql.getInt("plan_score");
		}
		if(rs_sql.getInt("seqNo")==3){
			c.add(Calendar.DATE, rs_sql.getInt("plan_days")); 
			measure_days = sdf.format(c.getTime()); 
			measure_lbl=rs_sql.getInt("plan_score");
		}
		if(rs_sql.getInt("seqNo")==4){
			c.add(Calendar.DATE, rs_sql.getInt("plan_days")); 
			analyze_days = sdf.format(c.getTime()); 
			analyze_lbl = rs_sql.getInt("plan_score"); 
		}
		if(rs_sql.getInt("seqNo")==5){
			c.add(Calendar.DATE, rs_sql.getInt("plan_days")); 
			improve_days = sdf.format(c.getTime()); 
			improve_lbl = rs_sql.getInt("plan_score"); 
		}
		if(rs_sql.getInt("seqNo")==6){
			c.add(Calendar.DATE, rs_sql.getInt("plan_days")); 
			control_days = sdf.format(c.getTime()); 
			control_lbl = rs_sql.getInt("plan_score"); 
		}
	}
	//**********************************************************************************************************************
%>



<!-- ================================================================================================================================== -->
<!-- ======================================================= Project Timeline ========================================================= -->
<div style="width: 55%;overflow: scroll;float: left;">
<!-- ******************************************************************************************************************** -->




<!-- ******************************************* Attach Documents ******************************************************* -->
<!-- Modal -->
<div class="modal fade" id="myModal_attach<%=problem_id %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-body" style="height: 300px;overflow: scroll;">
<%
ps_data = con_master.prepareStatement("select id from rel_pt_definePhase_Attach where enable=1 and problem_id="+problem_id);
rs_data = ps_data.executeQuery();
if(!rs_data.next()){
%> 
<form action="SixSigma_Attach_defineControl" method="post" enctype="multipart/form-data" onsubmit="submit.disabled = true; return true;">
<input type="hidden" name="def_probID" id="def_probID" value="<%=problem_id%>">
<input type="hidden" name="namePhase" id="namePhase" value="<%=phaseID%>">
<table class="gridtable" width="100%">
<tr>
 <th colspan="4" style="background-color: #0062b8;color: white;text-align: center;font-size: 12px;">Attach Documents for DEFINE - Project Definition and Charter</th>
</tr>
<tr style="background-color: #8eb1ca;color: white;">
 <th>Select Attachment</th>
 <th>Save</th>
</tr>
<tr>
 <td>
 <input type="file" name="file_attach" id="file_attach" class="form-control" style="color: black;" required>
 </td>
 <td>
 <input type="submit" class="btn-primary" name="submit" id="submit" value=" SAVE " style="font-weight: bold;height: 20px !important;">
 </td>
</tr>
</table> 
</form>      
<%
}else{
%>
<table class="gridtable" width="100%">
<tr>
 <th colspan="4" style="background-color: #0062b8;color: white;text-align: center;font-size: 12px;">Attach Documents for DEFINE - Project Definition and Charter</th>
</tr>
<tr style="background-color: #8eb1ca;color: white;">
 <th>Attachment</th>
 <th>Uploaded By</th>
 <th>Upload Date</th> 
</tr>
<%
ps_sql = con_master.prepareStatement("select * from rel_pt_definePhase_Attach where enable=1 and problem_id="+problem_id);
rs_sql = ps_sql.executeQuery();
while(rs_sql.next()){
%>
<tr>
<td style="height: 35px;font-size: 18px;"><a href="SixSigma_Define_Attach.jsp?id=<%=rs_sql.getInt("id")%>"><strong><%=rs_sql.getString("define_attach_name") %></strong></a></td>
<td><%=rs_sql.getString("created_byName") %></td>
<td><%=sdf.format(rs_sql.getDate("created_date"))%></td>
</tr>
<%
}
%>  
</table>
<%	
}
%>    
    </div>
    </div>
    </div>
    </div>
                     




<form action="SixSigma_Timeline_Control" method="post" onsubmit="submit.disabled = true; return true;">
<input type="hidden" name="def_probID" id="def_probID" value="<%=problem_id%>">
<input type="hidden" name="namePhase" id="namePhase" value="<%=phaseID%>">
<input type="hidden" name="approval_date" id="approval_date" value="<%=approveDate%>">

<table class="gridtable" width="100%">
  <tr align="center">
    <td colspan="2" style="font-size: 14px;font-weight: bold;background-color: #a59eff">Project Timeline &#8628;</td>
<!-- ******************************************************************************************************************** -->
<!-- ************************************* Modal Review and Action planning ********************************************* --> 

<!-- ===================================================================================================================  -->
<!-- =========================================== Attach Define Documents ===============================================  -->
<td style="font-size: 12px;font-weight: bold;background-color: #e6eaff;width: 50px;">
<a data-toggle="modal" href="#myModal_attach<%=problem_id%>" style="color: black;">
<img src="img/attach.png" title="Attach Define and charter Reference Document" style="cursor: pointer;height: 25px;">
</a>
</td>
<!-- ===================================================================================================================  -->
<!-- ===================================================================================================================  --> 
<td style="font-size: 12px;font-weight: bold;background-color: #e6eaff;width: 50px;">
<a data-toggle="modal" href="#myModalPlanning<%=problem_id%>" style="color: black;">
<img src="img/flowProject.png" title="Review and Action planning" style="cursor: pointer;height: 25px;">
</a>


<!-- ******************************************************************************************************************** -->
<!-- ******************************************* Review and Action planning ************************************************* -->
    <!-- Modal -->
    <div class="modal fade" id="myModalPlanning<%=problem_id %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-body" style="height: 500px;overflow: scroll;">
<%
boolean flag=false;
ps_data = con_master.prepareStatement("select id from rel_pt_reviewer where enable=1 and u_id="+uid);
rs_data = ps_data.executeQuery();
if(rs_data.next()){
	flag=true;
%>                      
<table class="gridtable" width="100%">
<tr>
 <th colspan="9" style="background-color: #0062b8;color: white;text-align: center;font-size: 12px;">Review and Action planning</th>
</tr>
<tr align="center" style="background-color: #8eb1ca;color: white;">
 <th>Review Date</th>
 <th>Action Details</th>
 <th>Status</th>
 <th>Responsibility</th>
 <th>Target Date</th>
 <!-- <th>Completion Date </th> -->
 <th>Reason for Planning action</th>
 <th>Findings</th>
 <th>Save</th>
</tr>
<tr>
 <td align="center">
 <span class="input-append date" id="dpYears" data-date-format="dd-mm-yyyy" data-date-viewmode="years">
   <input class="form-control" id="dp4" name="reviewDate" value="<%=tod %>" size="16" type="text" onkeypress="return checkQuote();" style="color: black;width: 150px;font-size: 12px;">
   <span class="add-on" style="visibility: hidden;margin: 5px;"><i class="icon-calendar"></i></span>
 </span>
 </td>
 <td align="center">
 	<textarea rows="2" cols="20" name="actionDetails" id="actionDetails" class="form-control" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"></textarea>
 </td>
 <td align="center">  
	<select class="form-control" id="statusAction" name="statusAction"  style="color: black;font-size: 12px;">
		<option value=""> - - - - Select - - - - </option>
		<%
		ps_sql = con_master.prepareStatement("SELECT id,master_name from rel_pt_masterData where enable=1 and searchTerm='actionStatus'");
		rs_sql = ps_sql.executeQuery();
		while(rs_sql.next()){
		%>
		<option value="<%=rs_sql.getInt("id")%>"><%=rs_sql.getString("master_name") %></option>
		<%
		}
		%> 
	</select>
 </td>
 <td>
	<select class="form-control" id="teamMember" name="teamMember"  style="color: black;font-size: 12px;">
		<option value=""> - - - Select - - - -</option> 
		<%
		ps_sql = con_master.prepareStatement("select u_id,user_name from rel_pt_teamSelect where problem_id="+problem_id);
		rs_sql = ps_sql.executeQuery();
		while(rs_sql.next()){
		%>
		<option value="<%=rs_sql.getInt("u_id")%>"><%=rs_sql.getString("user_name") %></option>
		<%
		}
		%>
		<option value="<%= projectLead_id %>"><%= projectLeadName %></option>
	</select>
 </td>
 <td align="center">
 <span class="input-append date" id="dpYears" data-date-format="dd-mm-yyyy" data-date-viewmode="years">
   <input class="form-control" id="dp2" name="targetDate"  size="16" type="text" onkeypress="return checkQuote();" style="color: black;width: 150px;font-size: 12px;">
   <span class="add-on" style="visibility: hidden;margin: 5px;"><i class="icon-calendar"></i></span>
 </span>
 
 </td>
 <!-- <td align="center"> 
 <span class="input-append date" id="dpYears" data-date-format="dd-mm-yyyy" data-date-viewmode="years">
   <input class="form-control" id="dp3" name="completeDate" size="16" type="text" onkeypress="return checkQuote();" style="color: black;width: 150px;font-size: 12px;">
   <span class="add-on" style="visibility: hidden;margin: 5px;"><i class="icon-calendar"></i></span>
 </span>
 </td> -->
 <td align="center">
	<textarea rows="2" cols="20" class="form-control" name="reasonPlan" id="reasonPlan" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"></textarea>	
 </td>
 <td align="center">
 <textarea rows="2" cols="20" class="form-control" name="findings" id="findings" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"></textarea>
 </td>
 <td align="center">
 <img alt="#" src="img/save.png" style="cursor: pointer;" onclick="javascript:saveReview('<%=problem_id%>','<%=phaseID%>')"> 
 </td>
</tr>
</table>
<%} %>
<br>
<!-- -------------------------------------------------------------------------------------------------------------------------- -->
<!-- ------------------------------------------- Review Problem History ------------------------------------------------------- -->
<span id="reviewProblem">
<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="11" align="center" style="font-size: 12px;font-weight: bold;background-color: #0062b8;color: white;">Review and Action planning Data</td>
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
 <th>Action</th>
</tr>
  <%
  String respUser=""; 
  ps_check = con_master.prepareStatement("select rel_pt_review.resp_uid as resp_uid ,rel_pt_review.id as id,rel_pt_review.completion_date as completion_date, "+
		" rel_pt_review.reason as reason, rel_pt_review.findings as findings, "+
		" rel_pt_review.target_date as target_date, rel_pt_phase.phase as phase "+
		" ,rel_pt_review.review_date as review_date,rel_pt_review.action_details as action_details,rel_pt_masterData.master_name "+ 
		" as master_name from rel_pt_review inner join rel_pt_masterData on "+
		" rel_pt_review.action_status_id=rel_pt_masterData.id inner join rel_pt_phase on "+
  " rel_pt_phase.seqNo=rel_pt_review.phase_id where rel_pt_phase.enable=1 and rel_pt_masterData.enable=1 and rel_pt_review.enable=1 and rel_pt_review.problem_id="+problem_id+"  order by rel_pt_review.id desc");
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
    <td><%=sdf.format(rs_check.getDate("review_date"))%></td>
    <td><%=rs_check.getString("action_details") %></td>
    <td>
    <select class="form-control" id="statusAction_rev<%=rs_check.getInt("id")%>" name="statusAction_rev<%=rs_check.getInt("id")%>"  style="color: black;font-size: 10px;"> 
		<%
		ps_sql = con_master.prepareStatement("SELECT id,master_name from rel_pt_masterData where enable=1 and searchTerm='actionStatus' and master_name='"+rs_check.getString("master_name")+"' union all "+
				" SELECT id,master_name from rel_pt_masterData where enable=1 and searchTerm='actionStatus' and master_name!='"+rs_check.getString("master_name")+"'");
		rs_sql = ps_sql.executeQuery();
		while(rs_sql.next()){
		%>
		<option value="<%=rs_sql.getInt("id")%>"><%=rs_sql.getString("master_name") %></option>
		<%
		}
		%> 
	</select>  
    </td>
    <td><%=respUser %></td>
    <td><%=sdf.format(rs_check.getDate("target_date"))%></td>
    <td>
    <%
    if(rs_check.getString("completion_date")!=null){ 
    %>
    <%=sdf.format(rs_check.getDate("completion_date"))%>
    <%
    }
    %>
    </td>
    <td>
    <textarea rows="2" cols="15" class="form-control" name="reasonPlan_rev<%=rs_check.getInt("id")%>" id="reasonPlan_rev<%=rs_check.getInt("id")%>" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"><%=rs_check.getString("reason") %></textarea>
    </td>
    <td>
    <textarea rows="2" cols="15" class="form-control" name="findings_rev<%=rs_check.getInt("id")%>" id="findings_rev<%=rs_check.getInt("id")%>" onkeypress="return checkQuote();" style="color: black;font-size: 12px;"><%=rs_check.getString("findings") %></textarea>
    </td>
    <td align="center">
   	<span id="updateRv<%=rs_check.getInt("id")%>">
   	<% 
	ps_sql = con_master.prepareStatement("SELECT * from rel_pt_masterData where enable=1 and searchTerm='actionStatus' and master_name='"+rs_check.getString("master_name")+"'");
	rs_sql = ps_sql.executeQuery();
	while(rs_sql.next()){
		if(rs_sql.getString("master_name").equalsIgnoreCase("Inprocess")){
   	%>
   	 <img alt="#" src="img/pencil.png" id="pen_button_rev<%=rs_check.getInt("id")%>" name="pen_button_rev<%=rs_check.getInt("id")%>" style="cursor: pointer;" onclick="javascript:updateReview('<%=problem_id%>','<%=phaseID%>','<%=rs_check.getInt("id")%>')">
   	 <%
		}
   		}
   	 %>
   	</span>
   	<!-- ------------------------------------------------------------------------------------------------------------------------ -->
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
						<th colspan='6'>Changes History </th>
					  </tr> 
					  <tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5;'> 
						<th>R.No</th><th>Status</th><th>Reason</th><th>Findings</th><th>Changed By</th><th>Changed Date</th>
					  </tr>
                        <%
                       	ps_data = con_master.prepareStatement("select rel_pt_review_hist.id as id,rel_pt_masterData.master_name as master_name, "+
                       			" rel_pt_review_hist.reason as reason,"+
                       			" rel_pt_review_hist.changed_by as changed_by,rel_pt_review_hist.changed_date as changed_date ,rel_pt_review_hist.findings as findings  from rel_pt_review_hist inner join rel_pt_masterData on "+
                        		" rel_pt_review_hist.action_status_id=rel_pt_masterData.id where rel_pt_review_hist.enable=1 and rel_pt_review_hist.review_id=" + rs_check.getInt("id") + 
                        		" order by rel_pt_review_hist.id desc");
                		rs_data = ps_data.executeQuery();
                		while(rs_data.next()){
                		%>
                		<tr style="font-size: 11px;">
                			<td style="text-align: right;width: 40px;"><%=rs_data.getInt("id") %></td>
                			<td><%=rs_data.getString("master_name")%></td> 
                			<td><%=rs_data.getString("reason")%></td>
                			<td><%=rs_data.getString("findings")%></td> 
    						<td>
    						<%
    						ps_data1 = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_data.getInt("changed_by"));
    						rs_data1 = ps_data1.executeQuery();
    						while(rs_data1.next()){ 
    						%>
    						<%=rs_data1.getString("u_name") %>
    						<%
    						}
    						%>
    						</td>
    						<td>
    						<%  
    							if(rs_data.getString("changed_date")!=null){ 
    						%>
    						<%=df.format(rs_data.getDate("changed_date"))%>
    						<%
    							}
    						%>
    						</td>
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
    <!-- ------------------------------------------------------------------------------------------------------------------------ -->
    <!-- ------------------------------------------------------------------------------------------------------------------------ -->		
   	</td>
  </tr>
  <%
  }
  %>
</table>
</span>
<!-- -------------------------------------------------------------------------------------------------------------------------- -->
<!-- -------------------------------------------------------------------------------------------------------------------------- -->
                      </div>
                    </div>
                  </div>
                </div>
    		<!-- modal -->  
</td> 
<!-- ******************************************************************************************************************** -->
  
<!-- ************************************************************************************************************************ -->
<!-- ******************************************* Modal History Timeline ***************************************************** -->    
<td style="font-size: 12px;font-weight: bold;background-color: #e6eaff;width: 50px;"> 
<a data-toggle="modal" href="#myModaltimeline<%=problem_id%>" style="color: black;">
<img src="img/LogHere.png" title="History" style="cursor: pointer;height: 25px;">
</a> 
    
    <!-- ******************************************************************************************************************** -->
    <!-- ******************************************* Modal History Timeline ************************************************* -->
    		<!-- Modal -->
                <div class="modal fade" id="myModaltimeline<%=problem_id %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content"> 
                    <div class="modal-body"> 
                      
                	<div style="width: 20%;float: left;">
				<table class="gridtable" width="100%"> 
                    <tr style='font-size: 12px; background-color: #fbffd4; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th colspan='4' align="center">Timeline Score History</th></tr> 
						<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th>No</th> 
						<th>Review Date</th>
						<th>Actual Total Score</th> 
					</tr> 
					<%
					int cnt=0;
					ps_data2 = con_master.prepareStatement("select max(actual_score) as sumScore,CAST(changed_date AS DATE) as dateLog,phase_id from rel_pt_dateTimeline_hist where enable=1 and problem_id="+problem_id+"  group by CAST(changed_date AS DATE),phase_id");
 					rs_data2 = ps_data2.executeQuery();
 					while(rs_data2.next()){
 						cnt++;
					%>
					<tr>
						<td align="right"><%=cnt %></td>
						<td><%=sdf.format(rs_data2.getDate("dateLog")) %></td>
						<td align="center"><%=rs_data2.getInt("sumScore") %></td>		
					</tr> 
					<%
 					}
					%>
					</table>
					</div>
                    <div style="width: 80%;float: right;">
                     <table class="gridtable" width="100%"> 
                      <tr style='font-size: 12px; background-color: #fbffd4; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th colspan='11' align="center">Timeline Score Details</th></tr> 
						<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th>ID No</th>
						<th>Phase</th>
						<th>Plan Days</th>
						<th>Plan Score</th>
						<th>Actual Score</th>
						<th>Plan Start</th>
						<th>Plan End</th> 
						<th>Actual Start</th>
						<th>Actual End</th> 						
						<th>Given By</th>
						<th>Given Date</th>
						</tr>
                        <%
                        String app_user="";
                        ps_data = con_master.prepareStatement("select * from rel_pt_dateTimeline_hist where problem_id="+problem_id + " order by created_date desc");
                		rs_data = ps_data.executeQuery();
                		while(rs_data.next()){
                			ps_data2 = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+rs_data.getInt("created_by"));
            				rs_data2 = ps_data2.executeQuery();
            				while(rs_data2.next()){
            					app_user = rs_data2.getString("u_name");
            				}
                		%>
                		<tr style="font-size: 11px;">
                			 <td align="right"><%=rs_data.getInt("id") %></td>
                			 <td align="left">
                			 <%
                			 	ps_data2 = con_master.prepareStatement("select * from rel_pt_phase where seqNo="+rs_data.getInt("phase_id"));
             					rs_data2 = ps_data2.executeQuery();
             					while(rs_data2.next()){
             				 %>
                			 	<%=rs_data2.getString("phase")%>
                			 <%
                				}
                			 %>
                			 </td>
                			 <td align="right"><%=rs_data.getInt("plan_days") %></td>
                			 <td align="right"><%=rs_data.getInt("plan_score") %></td>
                			 <td align="right"><%=rs_data.getInt("actual_score") %></td>
                			 <td><%= sdf.format(rs_data.getDate("plan_startDate")) %></td>
                			 <td><%= sdf.format(rs_data.getDate("plan_endDate")) %></td>
                			 <td><%= sdf.format(rs_data.getDate("act_startDate")) %></td>
                			 <td><% if(rs_data.getDate("act_endDate")!=null){ %><%= sdf.format(rs_data.getDate("act_endDate")) %><%} %></td>
                			 <td><%=app_user %></td>
                			 <td><%= sdf.format(rs_data.getDate("created_date")) %></td>
                		</tr>
                		<%		
                		}
                        %>
                        </table> 
                    
                    </div>	


                      </div>
                    </div>
                  </div>
                </div>
    		<!-- modal -->
    </td>
    <!-- ******************************************************************************************************************** --> 
    
    
    
  </tr>
  </table>
  <table class="gridtable" width="100%">
  <tr align="center"> 
    <td style="background-color: #e2ef77">
    <%
    ps_data = con_master.prepareStatement("select id from rel_pt_reviewer where enable=1 and u_id="+uid);
	rs_data = ps_data.executeQuery();
	if(rs_data.next()){
    if(phaseSubmit==phaseID){
    %>
    <input type="submit" class="btn-primary" name="submit" id="submit" value=" SAVE " style="font-weight: bold;height: 20px !important;">
    <%
    }else{
    %>
    <strong>Done</strong>
    <%
    }
	}else{
	%>
	<strong title="no access" style="cursor: pointer;">- -</strong>
	<%		
	}
    %>
    </td>
    <td colspan="2" align="center" style="background-color: #093256;color:white;font-size:12px;font-weight: bold;">Score</td>
    <td colspan="2" align="center" style="background-color: #093256;color:white;font-size:12px;font-weight: bold;">Plan</td>
    <td colspan="2" align="center" style="background-color: #093256;color:white;font-size:12px;font-weight: bold;">Actual</td>
  </tr>
  <tr>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Phase</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Plan</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Actual</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Start date</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">End date</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">Start date</td>
    <td align="center" style="background-color: #093256;color:white; font-weight: bold;">End date</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Define</td>
    <td align="right"><%= define_lbl %></td>
    <td align="center">
    <% 
    int logScore=0;
    ps_data = con_master.prepareStatement("select actual_score from rel_pt_dateTimeline where enable=1 and phase_id=2 and problem_id="+problem_id);
	rs_data = ps_data.executeQuery();
	if(rs_data.next()){
		logScore = rs_data.getInt("actual_score");
	} 
	%>
	<input type="hidden" name="logActSCR" id="logActSCR" value="<%=logScore%>">
	<%
    ps_check1 = con_master.prepareStatement("select id from rel_pt_definePhase where enable=1 and problem_id="+problem_id);
    rs_check1 = ps_check1.executeQuery();
    if(rs_check1.next()){
    	ps_data = con_master.prepareStatement("select actual_score,act_startDate,act_endDate from rel_pt_dateTimeline where enable=1 and (phase_id=2 or phase_id=3) and problem_id="+problem_id);
    	rs_data = ps_data.executeQuery();
    	if(rs_data.next()){
    		act_defDate = sdf.format(rs_data.getDate("act_startDate"));
    		if(rs_data.getDate("act_endDate")!=null){
    		act_endDate = sdf.format(rs_data.getDate("act_endDate"));
    		}
    		inputValue = rs_data.getInt("actual_score");
   	%>
    	    <input type="text" name="input_value" id="input_value" value="<%=inputValue %>" onkeypress="return validatenumerics(event);" onkeyup="numericEvent(<%= define_lbl %>,this.value)" maxlength="3" minlength="1" class="form-control" style="height: 23px !important;width: 60px;color: black;font-weight: bold;text-align: right;" required>
    	    <%		
    	}else{
	    	
    	ps_data = con_master.prepareStatement("select id from rel_pt_reviewer where enable=1 and u_id="+uid);
		rs_data = ps_data.executeQuery();
		if(rs_data.next()){
		    %>
		    <input type="text" name="input_value" id="input_value"  onkeypress="return validatenumerics(event);" onkeyup="numericEvent(<%= define_lbl %>,this.value)" maxlength="3" minlength="1" class="form-control" style="height: 23px !important;width: 60px;color: black;font-weight: bold;text-align: right;" required>
		    <%
			}
   		 }
    	}
    %>
    </td>
    <td align="right"><%=sdf.format(approveDate) %></td>
    <td align="right"><%=define_days %></td>
    <td align="right"><%=act_defDate %></td>
    <td align="right"><%=act_endDate %></td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Measure</td>
    <td align="right"><%=measure_lbl %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=define_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=measure_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Analyze</td>
    <td align="right"><%=analyze_lbl %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=measure_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=analyze_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Improve</td>
    <td align="right"><%=improve_lbl %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=analyze_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=improve_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Control</td>
    <td align="right"><%=control_lbl %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=improve_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right"><%=control_days %></td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
    <td style="background-color: #e8e8e8;color: black;" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td style="font-weight: bold;font-size: 12px;">Total</td>
    <td align="right">100</td>
    <td align="right">
   <input type="text" name="logScore" id="logScore" class="form-control" value="<%=logScore %>" readonly="readonly" style="height: 23px !important;width: 60px;color: black;font-weight: bold;text-align: right;"> 
    </td>
    <td colspan="4">&nbsp;</td> 
  </tr>
</table>
</form>
<!-- ================================================================================================================================== -->
<!-- ================================================================================================================================== -->
</div>
<div style="width: 44%;float: right;">
<!-- ================================================================================================================================== -->
<!-- ===================================================== Select Team Members ======================================================== -->
<form action="SixSigma_DefineTeam_Control" method="post" onsubmit="submit.disabled = true; return true;">

<input type="hidden" name="hid_problemID" id="hid_problemID" value="<%=problem_id%>">
<input type="hidden" name="hid_namePhase" id="hid_namePhase" value="<%=phaseID%>">
<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="2" style="font-size: 12px;font-weight: bold;background-color: #a59eff;" align="center">Select Team Members</td>
  </tr>
  <tr>
    <td> 
    <select name="team_user" id="team_user" class="form-control" style="font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
   	 			 <option value="">- - Select - -</option>
   					<%
					ps_data = con.prepareStatement("SELECT u_id,u_name,company_id FROM user_tbl where enable_id=1 and company_id="+company_id + " and u_id !="+projectLead_id+" order by u_name");
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						ps_data2 = con.prepareStatement("SELECT company_name FROM user_tbl_company where company_id="+rs_data.getInt("company_id"));
						rs_data2 = ps_data2.executeQuery();
						while(rs_data2.next()){
   					%>
   					<option value="<%=rs_data.getString("u_id") %>"> <%= rs_data.getString("u_name").toUpperCase() %> - <%=rs_data2.getString("company_name") %> </option>
    				<%
   						}
					}
					ps_data = con.prepareStatement("SELECT u_id,u_name,company_id FROM user_tbl where enable_id=1 and company_id!="+company_id + " order by company_id");
					rs_data = ps_data.executeQuery();
					while(rs_data.next()){
						ps_data2 = con.prepareStatement("SELECT company_name FROM user_tbl_company where company_id="+rs_data.getInt("company_id"));
						rs_data2 = ps_data2.executeQuery();
						while(rs_data2.next()){
   					%>
   					<option value="<%=rs_data.getString("u_id") %>"> <%= rs_data.getString("u_name").toUpperCase() %> - <%=rs_data2.getString("company_name") %> </option>
    				<%
   						}
					}
    				%>
    				</select>
	</td>
    <td align="center" style="background-color: #e2ef77">
    <input type="submit" class="btn-primary" name="submit" id="submit" value=" ADD  " style="font-weight: bold;height: 20px !important;">
    </td>
  </tr>
  </table>
</form>
    <%
  	String sapID="",emaillead="",contactlead="", memberName="",department="";
  	ps_data = con.prepareStatement("SELECT user_tbl.u_name,user_tbl.sap_id,user_tbl.u_email,user_tbl.phone_no,user_tbl_dept.Department FROM user_tbl inner join "+
  			" user_tbl_dept on user_tbl.dept_id=user_tbl_dept.dept_id where user_tbl.enable_id=1 and user_tbl.u_id="+projectLead_id);
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		sapID = rs_data.getString("sap_id");
		emaillead = rs_data.getString("u_email");
		department = rs_data.getString("Department");
	}
  	%>
  <table class="gridtable" width="100%">
  <tr>
    <th style="background-color: #0a0628;font-size: 11px !important;color: white;">PROJECT LEAD : <%=projectLeadName %></th>
    <th style="color: black;">
	<span id="sendMsgBack">
	<textarea class="form-control" placeholder="Message For Team ..." onkeypress="return checkQuote();" style="color: black !important;font-size: 10px;" rows="1" cols="5" id="sendMsg" name="sendMsg"></textarea>
	</span>
	</th>
	<th style="font-size: 11px !important;color: white;" align="right">
	<img src="img/send.png" title="Send Message" style="cursor: pointer;"  onclick="sendMessage(<%=problem_id %>)" id="msgTeam">
	<a data-toggle="modal" href="#myModalCall<%=problem_id%>">
		<img src="img/LogHere.png" title="History" style="cursor: pointer;">
	</a>
	<!-- Modal -->
                <div class="modal fade" id="myModalCall<%=problem_id %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content"> 
                      <div class="modal-body"> 
                      <table class="gridtable" width="100%"> 
                      <tr style='font-size: 12px; background-color: #fbffd4; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th colspan='4'>Message History</th></tr> 
						<tr style='font-size: 12px; background-color: #acc8cc; border-width: 1px; padding: 8px; border-style: solid; border-color: #729ea5; text-align: center;'> 
						<th>Message No </th><th>Sent By</th><th>Message</th><th>Sent Date</th></tr>
                        <%
                        ps_data = con_master.prepareStatement("select * from rel_pt_messgeLog where problem_id="+problem_id + " order by seq_no desc");
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
	</th>
  </tr>
  </table>
  <div style="overflow: scroll;height: 150px;">
  <table class="gridtable" width="100%"> 
  <tr>
    <th colspan="2">Employee &amp; ID</th> 
    <th>Email</th>
    <th>Department</th>   
  </tr>
  <tr>
    <td colspan="2" title="Project Lead" style="background-color: #f7ffa9;color: black;"><%=projectLeadName %> - <%=sapID %></td> 
    <td title="Project Lead"><%=emaillead %></td>
    <td title="Project Lead"><%=department %></td> 
 </tr>
   <%
    sapID="";emaillead="";memberName="";department="";
    
   	ps_data = con_master.prepareStatement("SELECT * FROM rel_pt_teamSelect where problem_id="+problem_id + " order by enable desc");
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		ps_data2 = con.prepareStatement("SELECT user_tbl.u_name,user_tbl.sap_id,user_tbl.u_email,user_tbl.phone_no,user_tbl_dept.Department FROM user_tbl inner join user_tbl_dept on user_tbl.dept_id=user_tbl_dept.dept_id where user_tbl.enable_id=1 and user_tbl.u_id="+rs_data.getInt("u_id"));
		rs_data2 = ps_data2.executeQuery();
		while(rs_data2.next()){
			memberName = rs_data2.getString("u_name"); 
			sapID = rs_data2.getString("sap_id");
			emaillead = rs_data2.getString("u_email");
			department = rs_data2.getString("Department");
		}
		if(rs_data.getInt("enable")==1){
   %>
  <tr>
    <td align="center">
    <span id="deleteMember<%=rs_data.getInt("id") %>">
    <img src="img/close.png" title="Remove Member" style="cursor: pointer;" onclick="decision_call(<%=rs_data.getInt("id") %>); return false;" id="remove">
    </span>
    </td> 
    <td><%=memberName %> - <%=sapID %></td> 
    <td><%=emaillead %></td>
    <td><%=department %></td> 
  </tr>
  <%
		}else{
  %>
  <tr>
    <td style="background-color: red;color: white;text-decoration: line-through;" align="center">Removed</td> 
    <td style="text-decoration: line-through;"><%=memberName %> - <%=sapID %></td> 
    <td style="text-decoration: line-through;"><%=emaillead %></td>
    <td style="text-decoration: line-through;"><%=department %></td> 
  </tr>
  <%			
		}
	}
  %>
  
</table>
</div>
  <!-- ================================================================================================================================== -->
  <!-- ================================================================================================================================== -->
</div>

<!-- 
  ==================================================================================================================================
  =================================================== History Data =================================================================
<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="8" align="center" style="font-size: 12px;font-weight: bold;background-color: #a59eff">Score History Data</td>
  </tr>
  <tr>
    <th>History No</th>
    <th>Define</th>
    <th>Measure</th>
    <th>Analyze</th>
    <th>Improve</th>
    <th>Control</th>
    <th>Total</th>
    <th>History Date</th>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table> -->
   <!-- ================================================================================================================================== -->
  <!-- ================================================================================================================================== -->
</div> 
</section> 
</section>
    
 <!---------------------------------------------------------------------------------- User Profile Screen Ends ----------------------------------------------------------------------->                
	<% 
	}catch(Exception e){
		e.printStackTrace();
	}
    %>
    
     
    <!--main content end-->
  </section>
  <!-- container section start -->

  <!-- javascripts -->
  <script src="js/jquery.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="js/jquery.scrollTo.min.js"></script>
  <script src="js/jquery.nicescroll.js" type="text/javascript"></script>

  <!-- jquery ui -->
  <script src="js/jquery-ui-1.9.2.custom.min.js"></script>

  <!--custom checkbox & radio-->
  <script type="text/javascript" src="js/ga.js"></script>
  <!--custom switch-->
  <script src="js/bootstrap-switch.js"></script>
  <!--custom tagsinput-->
  <script src="js/jquery.tagsinput.js"></script>

  <!-- colorpicker -->

  <!-- bootstrap-wysiwyg -->
  <script src="js/jquery.hotkeys.js"></script>
  <script src="js/bootstrap-wysiwyg.js"></script>
  <script src="js/bootstrap-wysiwyg-custom.js"></script>
  <script src="js/moment.js"></script>
  <script src="js/bootstrap-colorpicker.js"></script>
  <script src="js/daterangepicker.js"></script>
  <script src="js/bootstrap-datepicker.js"></script>
  <!-- ck editor -->
  <script type="text/javascript" src="assets/ckeditor/ckeditor.js"></script>
  <!-- custom form component script for this page-->
  <script src="js/form-component.js"></script>
  <!-- custome script for all page -->
  <script src="js/scripts.js"></script>
    <script>
      //knob
      $(function() {
        $(".knob").knob({
          'draw': function() {
            $(this.i).val(this.cv + '%')
          }
        })
      });

      //carousel
      $(document).ready(function() {
        $("#owl-slider").owlCarousel({
          navigation: true,
          slideSpeed: 300,
          paginationSpeed: 400,
          singleItem: true

        });
      });

      //custom select box

      $(function() {
        $('select.styled').customSelect();
      });

      /* ---------- Map ---------- */
      $(function() {
        $('#map').vectorMap({
          map: 'world_mill_en',
          series: {
            regions: [{
              values: gdpData,
              scale: ['#000', '#000'],
              normalizeFunction: 'polynomial'
            }]
          },
          backgroundColor: '#eef3f7',
          onLabelShow: function(e, el, code) {
            el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
          }
        });
      });
    </script>

</body>
</html>