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
<title>Problems</title>
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
  <!--external css-->
  <!-- font icon -->
  <link href="css/elegant-icons-style.css" rel="stylesheet" />
  <link href="css/font-awesome.min.css" rel="stylesheet" />
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
  
  window.onload = function() {
		const product_descr = document.getElementById('product_descr'); 	
		const problem = document.getElementById('problem');
		const search_product = document.getElementById('search_product');
		
		product_descr.onpaste = function(e) {
		   e.preventDefault();
	 	};
	 	problem.onpaste = function(e) {
			   e.preventDefault();
		};
		search_product.onpaste = function(e) {
			   e.preventDefault();
		};
	};
  
  function checkQuote() {
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
		}
	}
  
	function GetmatDetails(val) {
		 var plant = document.getElementById("plant"); 
		
		 if(plant.value!="" && val!=""){
			var xmlhttp1;
			if (window.XMLHttpRequest) {
				xmlhttp1 = new XMLHttpRequest();
			} else { 
				xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP");
			} 
			xmlhttp1.onreadystatechange = function() {
				if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
					document.getElementById("materialSearch").innerHTML = xmlhttp1.responseText; 
				}
			}; 
			xmlhttp1.open("POST", "SixSigma_ProductSearch.jsp?plant=" + plant.value + "&matSearch=" + val, true); 
			xmlhttp1.send();
		 }else{
			 alert("Plant and Product is not Valid...!");
		 }
	};
	
	
	function GetavailProblems(val) {
		 var plant = document.getElementById("plant"); 
		
		 if(plant.value!="" && val!=""){
				var xmlhttp1;
				if (window.XMLHttpRequest) {
					xmlhttp1 = new XMLHttpRequest();
				} else { 
					xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP");
				} 
				xmlhttp1.onreadystatechange = function() {
					if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
						document.getElementById("materialSearch").innerHTML = xmlhttp1.responseText; 
					}
				}; 
			xmlhttp1.open("POST", "SixSigma_ProblemAvail.jsp?plant=" + plant.value + "&probSearch=" + val, true); 
			xmlhttp1.send();
		 }else{
			 alert("Plant and Product is not Valid...!");
		 }
	};
	
	function adopt_ProductCode(val) {
			var xmlhttp1;
			if (window.XMLHttpRequest) {
				xmlhttp1 = new XMLHttpRequest();
			} else { 
				xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP");
			} 
			xmlhttp1.onreadystatechange = function() {
				if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
					document.getElementById("adoptprodCode").innerHTML = xmlhttp1.responseText;  
					document.getElementById("adoptproduct").innerHTML = xmlhttp1.responseText;  
				}
			}; 
			xmlhttp1.open("POST", "SixSigma_Productadopt.jsp?matCode=" + val, true); 
			xmlhttp1.send(); 
	}; 
	
	
	
	
	
	
   
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
					document.getElementById("delete_record"+val).innerHTML = xmlhttp.responseText; 
				}
			};  
			xmlhttp.open("POST", "Master_DeleteReq.jsp?id=" + val, true);  
			xmlhttp.send();    
	      } else {
	    	  alert("You Pressed Cancel!");
	    	  return false;
	      }
	};
	
	function sendMessage(val,code) {
		 var msg = document.getElementById('msg'+val);
		 var sendMsg = document.getElementById('sendMsg'+val);
		 var reject = document.getElementById('reject'+val);
		
		 var problem = document.getElementById('problem'+val);
		 var product_name = document.getElementById('product_name'+val);
		 var typeProject = document.getElementById('typeProject'+val);
		 var dept = document.getElementById('dept'+val);
		 var edit = document.getElementById('edit'+val);
		 
		 if((sendMsg.value!="" || code==9)  &&  problem.value!="" && product_name.value && typeProject.value!="" && dept.value!=""){
		 sendMsg.readOnly = true;
		 msg.style.display = "none";
		 if(code==9){
			 edit.style.display = "none";
			 reject.style.display = "none";
		 }
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
					document.getElementById("sendMsgBack"+val).innerHTML = xmlhttp.responseText; 
				}
			};
		// 	xmlhttp.open("POST", "SixSigma_msgSend.jsp?id=" + val + "&sendMsg=" + sendMsg.value + "&select=" + code, true);  
		 	xmlhttp.open("POST", "SixSigma_msgSend.jsp?id=" + val + "&sendMsg=" + sendMsg.value + "&select=" + code +
		 			"&problem="+problem.value+ "&product_name="+ product_name.value + "&typeProject=" + typeProject.value + "&dept=" + dept.value, true);  		 	
		 	
		 	
		 	
			xmlhttp.send(); 
		}else{
			alert("No Reason message Found!, Error Occurred...!!!!");
		}
	}
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
	font-size: 10px;
	border-width: 1px;
	padding: 3px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	color: black;
	/* background-color: #dedede; */
}

table.gridtable td {
font-size: 10px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
} 
</style>
</head>

<body style="color: black;">
<%
try{
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0;
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
	java.util.Date date2cmp;
	Calendar calobj = Calendar.getInstance();
	String todays_date = format2.format(calobj.getTime());
	date2cmp = format2.parse(todays_date);
	
	
	
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
        String define="new_project";
        %>
        <jsp:include page="SixSigma_Header.jsp" > 
  		<jsp:param name="define" value="<%=define %>" />
		</jsp:include>  
        </div> 
<!-- ********************************************************************************************************************* -->


<div class="table-responsive">
<div style="width: 40%;float: left;">
<form action="SixSigma_ProblemControl" method="post" id="feedback_form" class="form-validate form-horizontal" onsubmit="submit.disabled = true; return true;">
<table class="gridtable" width="100%"> 
  <tr>
    <th style="background-color: #000f6e;color: white;font-size: 12px;" colspan="2"> <strong>Problem Registrations</strong>
    	<%
  		if(request.getParameter("success")!=null){
		%> 
        <strong style="font-size: 12px;background-color: #1f9f11;color: white;"><%=request.getParameter("success") %> </strong> 
        <%
		}if(request.getParameter("statusNop")!=null){
			%> 
	     <strong style="font-size: 12px;background-color: #c31f00;color: white;"><%=request.getParameter("statusNop") %> </strong> 
	    <%
			}
		%>  
  	</th>
  </tr>
  <tr>
    <td style="font-size: 11px;"> <strong>Plant</strong><b style="color: red;"> * </b></td>
    <td>
    <%
    ps_check = con.prepareStatement("select * from user_tbl_company where enable=1 and Company_Id="+comp_id + " union all select * from user_tbl_company where enable=1 and Company_Id!="+comp_id);
    rs_check = ps_check.executeQuery();
    %>
   		<select name="plant" id="plant" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
   	 	<%
   		while(rs_check.next()){
   		%>
   		<option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("Company_Name") %> - <%=rs_check.getString("plant") %></option>
    	<%
   		}
    	%>
    	</select> 
    </td>
  </tr>
  <tr>
    <td style="font-size: 11px;"><strong>Department</strong><b style="color: red;"> * </b></td>
    <td> 
    <%
    ps_check = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and searchTerm='dept'");
    rs_check = ps_check.executeQuery();
    %>
	<select name="dept" id="dept" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	<option value=""> - - - - Select - - - - </option>
	<%
	while(rs_check.next()){
	%>
	<option value="<%=rs_check.getInt("id")%>"><%=rs_check.getString("master_name") %></option>
	<%
	}
	%>
	</select>
	</td>
  </tr>
  <tr>
    <td style="font-size: 11px;"><strong>Problem</strong><b style="color: red;"> * </b></td>
    <td>  
   	<input class="form-control" style="font-weight: bold;color: black;font-size: 12px;" name="problem" id="problem" 
       onkeypress="return checkQuote();" onkeyup="GetavailProblems(this.value)" type="text" required /> 
    </td>
  </tr>
  <tr>
    <td style="font-size: 11px;"><strong>Search Product</strong><b style="color: red;"> * </b></td>
    <td>
	<span id="adoptprodCode">
	<input type="hidden" name="MtCode" id="MtCode">
	<input class="form-control" style="font-weight: bold;color: black;font-size: 12px;" id="search_product" name="search_product" minlength="1000"
       onkeypress="return checkQuote();" onkeyup="GetmatDetails(this.value)" type="text" required />
	</span>
	</td>
  </tr>
  <tr>
    <td style="font-size: 11px;"><strong>Product Name<br>
    (If call by Other Name)</strong><b style="color: red;"></b></td>
    <td>   
    <input class="form-control" name="product_descr" id="product_descr" onkeypress="return checkQuote();" style="font-weight: bold;color: black;" /> 
 	</td>
  </tr>
  <tr>
    <td style="font-size: 11px;"><strong>Type of Project</strong><b style="color: red;"> * </b></td>
    <td> 
   	<%
    ps_check = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and searchTerm='typeProject'");
    rs_check = ps_check.executeQuery();
    %>
	<select name="typeProject" id="typeProject" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	<option value=""> - - - - Select - - - - </option>
	<%
	while(rs_check.next()){
	%>
	<option value="<%=rs_check.getInt("id")%>"><%=rs_check.getString("master_name") %></option>
	<%
	}
	%>
	</select>
    </td>
  </tr> 
  <tr style="height: 50px;">
    <td colspan="2" align="center"> 
    <input type="submit" class="btn btn-primary" name="submit" id="submit" value="Save Problem" style="font-weight: bold;"></td> 
  </tr>
</table>    	      
             </form>
             </div> 
           <div style="width: 59%;height:310px;overflow:scroll; float: right;">
             <table style="width: 100%;" class="gridtable">
             	<tr>
             		<th style="font-size: 10px;background-color: #000f6e;color: white;font-size: 10px;">Lookup</th>
             	</tr> 
			</table> 
            <span id="materialSearch">
            <table style="width: 100%;" class="gridtable">
             	<tr>
             		<th>Product Code</th>
                    <th>Product Description</th>
                    <th>Adopt</th>
             	</tr> 
			</table>
            </span>
            </div>
        	<div style="width: 100%;height:400px;overflow:scroll; float: left;">
              <table class="gridtable" width="100%">
              		<tr>
   			 			<th style="font-size: 10px;background-color: #000f6e;color: white;font-size: 10px;" colspan="12"> <strong>My Problems</strong></th> 
  					</tr>
					<tr style="background-color: #dedede;color: black;"> 
						<th>No</th>
						<th>Plant</th>
						<th>Problem Description</th>
						<th>Product </th>  
						<th>Product Other Name </th>
						<th>Type of Project</th> 
						<th>Department</th> 
						<th>Phase</th>
						<th>Approval</th> 
						<th>Date</th> 
						<th>Message</th>
						<th>Activity</th>
					</tr>
					<%
					String deptsearchTerm = "",searchTerm="",matCode="",phase="",approval="";
					PreparedStatement ps_data=null;
					ResultSet rs_data=null;
					ps_check = con_master.prepareStatement("select * from tran_pt_problem where created_by="+uid + " order by log_date desc");
					rs_check = ps_check.executeQuery();
					while(rs_check.next()){
						ps_data = con_master.prepareStatement("select searchTerm from rel_pt_masterData where id="+rs_check.getInt("dept_id"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							deptsearchTerm = rs_data.getString("searchTerm");
						}
						ps_data = con_master.prepareStatement("select searchTerm from rel_pt_masterData where id="+rs_check.getInt("typeProject"));
						rs_data = ps_data.executeQuery();
						while(rs_data.next()){
							searchTerm = rs_data.getString("searchTerm");
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
					%>
					<tr>
						<td align="right"><%=rs_check.getInt("id") %></td>
						<td align="right"><%=rs_check.getString("plant") %></td>
						<td><%-- %=rs_check.getString("problem_descr") %> --%>
<textarea class="form-control" style="color: black;font-size: 10px;" rows="1" cols="20" name="problem<%=rs_check.getInt("id") %>" id="problem<%=rs_check.getInt("id") %>" onkeypress="return checkQuote();" required><%=rs_check.getString("problem_descr") %></textarea>
						</td> 
						<td><b><%=matCode %></b><br><%=rs_check.getString("product_codeDescr") %></td>
						<td>
<textarea class="form-control" onkeypress="return checkQuote();" style="color: black;font-size: 10px;" rows="1" cols="5" id="product_name<%=rs_check.getInt("id") %>" name="product_name<%=rs_check.getInt("id") %>"><%=rs_check.getString("type_product_code") %></textarea>
						</td>
						<td> 
	<% 
	ps_data = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and id="+rs_check.getInt("typeProject")+" union all "+
    		" select * from rel_pt_masterData where enable=1 and id!="+rs_check.getInt("typeProject")+" and searchTerm='"+searchTerm+"'");
	rs_data = ps_data.executeQuery();
    %>
	<select name="typeProject<%=rs_check.getInt("id") %>" id="typeProject<%=rs_check.getInt("id") %>" class="form-control" style="font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<%
	while(rs_data.next()){
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%>
	</select>
		</td><td>
	<%
    ps_data = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and id="+rs_check.getInt("dept_id")+"  union all "+
    		" select * from rel_pt_masterData where enable=1 and id!="+rs_check.getInt("dept_id")+" and searchTerm='"+deptsearchTerm+"'");
    rs_data = ps_data.executeQuery();
    %>
	<select name="dept<%=rs_check.getInt("id") %>" id="dept<%=rs_check.getInt("id") %>" class="form-control" style=" font-size: 10px !important;height: 30px !important;color: black;text-align: left !important;width: 150px;" required>
	<%
	while(rs_data.next()){
	%>
	<option value="<%=rs_data.getInt("id")%>"><%=rs_data.getString("master_name") %></option>
	<%
	}
	%> 
	</select>
	</td>
						<td>
						<%
						if(rs_check.getInt("enable")!=0){
						%>
						<%=phase %>
						<%
						}else{
						%>
						<strong style="color: red;cursor: pointer;" title="<%=rs_check.getString("delete_reason")%>">Deleted</strong>
						<%	
						}
						%> 
						</td>
						<td style="width: 80px;">
						<%=approval %> 
						<b>Project Lead :</b><%=rs_check.getString("project_leadName") %>
						</td>
						<td><%=format.format(rs_check.getDate("tran_date")) %></td>
						<td>
						<span id="sendMsgBack<%=rs_check.getInt("id")%>">
							<textarea class="form-control" onkeypress="return checkQuote();" style="color: black;font-size: 10px;" rows="1" cols="5" id="sendMsg<%=rs_check.getInt("id") %>" name="sendMsg<%=rs_check.getInt("id") %>"></textarea>
						</span>
						</td>
						<td align="center" style="width: 100px;">
						<%
						if(rs_check.getInt("approval_id")==1){
						%>
<img src="img/close.png" title="Delete" style="cursor: pointer;" onclick="sendMessage(<%=rs_check.getInt("id") %>,'2'); return false;" id="reject<%=rs_check.getInt("id") %>">
<img src="img/pencil.png" title="Edit Data" style="cursor: pointer;"  onclick="sendMessage(<%=rs_check.getInt("id") %>,'9'); return false;" id="edit<%=rs_check.getInt("id") %>">
						<%
						}
						%> 
<img src="img/send.png" title="Send Message" style="cursor: pointer;"  onclick="sendMessage(<%=rs_check.getInt("id") %>,'1'); return false;" id="msg<%=rs_check.getInt("id") %>">
						 
<a data-toggle="modal" href="#myModal<%=rs_check.getInt("id")%>">
	<img src="img/LogHere.png" title="History" style="cursor: pointer;" id="log<%=rs_check.getInt("id") %>">
</a>
                <!-- Modal -->
                <div class="modal fade" id="myModal<%=rs_check.getInt("id") %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
             
			</div> 
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
  <script src="js/jquery-ui-1.10.4.min.js"></script>
  <script src="js/jquery-1.8.3.min.js"></script>
  <script type="text/javascript" src="js/jquery-ui-1.9.2.custom.min.js"></script>
  <!-- bootstrap -->
  <script src="js/bootstrap.min.js"></script>
  <!-- nice scroll -->
  <script src="js/jquery.scrollTo.min.js"></script>
  <script src="js/jquery.nicescroll.js" type="text/javascript"></script>
  <!-- charts scripts -->
  <script src="assets/jquery-knob/js/jquery.knob.js"></script>
  <script src="js/jquery.sparkline.js" type="text/javascript"></script>
  <script src="assets/jquery-easy-pie-chart/jquery.easy-pie-chart.js"></script>
  <script src="js/owl.carousel.js"></script>
  <!-- jQuery full calendar -->
  <script src="js/fullcalendar.min.js"></script>
    <!-- Full Google Calendar - Calendar -->
    <script src="assets/fullcalendar/fullcalendar/fullcalendar.js"></script>
    <!--script for this page only-->
    <script src="js/calendar-custom.js"></script>
    <script src="js/jquery.rateit.min.js"></script>
    <!-- custom select -->
    <script src="js/jquery.customSelect.min.js"></script>
    <script src="assets/chart-master/Chart.js"></script>

    <!--custome script for all page-->
    <script src="js/scripts.js"></script>
    <!-- custom script for this page-->
    <script src="js/sparkline-chart.js"></script>
    <script src="js/easy-pie-chart.js"></script>
    <script src="js/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="js/jquery-jvectormap-world-mill-en.js"></script>
    <script src="js/xcharts.min.js"></script>
    <script src="js/jquery.autosize.min.js"></script>
    <script src="js/jquery.placeholder.min.js"></script>
    <script src="js/gdp-data.js"></script>
    <script src="js/morris.min.js"></script>
    <script src="js/sparklines.js"></script>
    <script src="js/charts.js"></script>
    <script src="js/jquery.slimscroll.min.js"></script>
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