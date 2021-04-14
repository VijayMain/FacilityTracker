<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
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
<title>Dashboard</title>
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
	function sendMessage(val) {
		 var sendMsg = document.getElementById('sendMsg'+val);  
		 var msgTeam = document.getElementById('msgSend'+val);
		 
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
					document.getElementById("sendMsgBack"+val).innerHTML = xmlhttp.responseText; 
				}
			};
		 	xmlhttp.open("POST", "SixSigma_msgSendtoTeam.jsp?id=" + val + "&sendMsg=" + sendMsg.value + "&select=1", true);  
			xmlhttp.send(); 
		}else{
			alert("Message For Team...?");
		}
	}
	function showMySelection(val,val1,cnt) {
		 if(cnt!=0){
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
					document.getElementById("dash_Data").innerHTML = xmlhttp.responseText; 
				}
			};
		 	xmlhttp.open("POST", "SixSigma_DashboardAjax.jsp?phase=" + val + "&plant=" + val1, true);  
			xmlhttp.send(); 
		}else{
			alert("No Record Found...?");
		}
	}
	
	function getProblemsData() {			         
	var plant = document.getElementById('plant').value;
	var typeProject = document.getElementById('typeProject').value;
	var problem = document.getElementById('problem').value;	
	var phaseSelect = document.getElementById('phaseSelect').value;
		
		if(plant!="" || typeProject!="" || problem!="" || phaseSelect!=""){
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
					document.getElementById("dash_Data").innerHTML = xmlhttp.responseText; 
				}
			};
		 	xmlhttp.open("POST", "SixSigma_DashAjax.jsp?plant=" + plant + "&typeProject=" + typeProject + 
		 			"&problem=" + problem + "&phaseSelect=" + phaseSelect, true);  
			xmlhttp.send(); 
		}else{
			alert("Please Select Parameter...?");
		}
	}
	
	
	
	function checkQuote() {
		if(event.keyCode == 39 || event.keyCode == 34 || event.keyCode == 47) {
			event.keyCode = 0;
			return false;
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
	font-size:11px; 
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	color: black;
	/* background-color: #dedede; */
}

table.gridtable td {
	font-size:10px; 
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
	int newCount=0, openCount=0, reOpenCount=0, closedCount=0, cntLog=0;
	Connection con = Connection_Util.getLocalUserConnection();
	Connection con_master = Connection_Util.getConnectionMaster();
	int comp_id = Integer.valueOf(session.getAttribute("comp_id").toString()); 
	int uid = Integer.valueOf(session.getAttribute("uid").toString());
	boolean availFlag=false ;
	String deptsearchTerm = "",matCode="",phase="",approval="",searchTerm="";
	PreparedStatement ps_data=null,ps_data1=null,ps_data2=null;
	int company_id=0;
	ResultSet rs_data=null,rs_data1=null,rs_data2=null;
	String defineQuery ="";	
	int dept_id = Integer.valueOf(session.getAttribute("dept_id").toString());
	PreparedStatement ps_check = null, ps_check1=null,ps_local=null;
	ResultSet rs_check = null,rs_check1=null,rs_local=null; 
	SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date date2cmp;
	Calendar calobj = Calendar.getInstance();
	String todays_date = format2.format(calobj.getTime());
	date2cmp = format2.parse(todays_date);
	ArrayList phaseCount = new ArrayList();
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
        String dashboard="dashboard";
        %>
        <jsp:include page="SixSigma_Header.jsp" > 
  		<jsp:param name="define" value="<%=dashboard %>" />
		</jsp:include> 
        </div> 
<!-- ********************************************************************************************************************* -->
<div style="height:500px;overflow: scroll;">
<table border="1" width="100%" style="margin-bottom: 5px;">
  <tr>
    <td style="background-color: #019f9a;color: white;font-weight: bold;font-size: 14px;width:180px;">Search Problems &#8649;</td>
    <td style="background-color: white;width:150px;">
		<%
    ps_check = con.prepareStatement("select * from user_tbl_company where enable=1 and Company_Id="+comp_id + " union all select * from user_tbl_company where enable=1 and Company_Id!="+comp_id);
    rs_check = ps_check.executeQuery();
    %>
   		<select name="plant" id="plant" onchange="getProblemsData()" class="form-control" style="font-weight:bold;font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;">
   	 	<option value="">Select Plant</option>
   	 	<%
   		while(rs_check.next()){
   		%>
   		<option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("Company_Name") %> - <%=rs_check.getString("plant") %></option>
    	<%
   		}
    	%>
    	</select> 
	</td> 
	<td style="background-color: white;width:150px;">
		<%
    	ps_check = con_master.prepareStatement("select * from rel_pt_phase where enable=1");
    	rs_check = ps_check.executeQuery();
    	%>
   		<select name="phaseSelect" id="phaseSelect" onchange="getProblemsData()" class="form-control" style="font-weight:bold;font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;">
   	 	<option value="">Select Phase</option>
   	 	<%
   		while(rs_check.next()){
   		%>
   		<option value="<%=rs_check.getInt("seqNo") %>"><%=rs_check.getString("phase") %></option>
    	<%
   		}
    	%>
    	</select> 
	</td> 
    <td style="background-color: white;width:200px;">
    <%
    ps_check = con_master.prepareStatement("select * from rel_pt_masterData where enable=1 and searchTerm='typeProject'");
    rs_check = ps_check.executeQuery();
    %>
	<select name="typeProject" id="typeProject"  onchange="getProblemsData()" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;">
	<option value="">Select Problem Type</option>
	<%
	while(rs_check.next()){
	%>
	<option value="<%=rs_check.getInt("id")%>"><%=rs_check.getString("master_name") %></option>
	<%
	}
	%>
	</select>
    </td>
    <td>
    <input class="form-control" placeholder="Search Problem"  onkeyup="getProblemsData()" style="font-weight: bold;color: white; font-size: 14px;background-color: #162872;" name="problem" id="problem" onkeypress="return checkQuote();" type="text"/>
	</td> 
</tr>    
</table>

<table border="1" width="100%">
  <tr align="center" style="background-color: #2b4256;color: white;">
    <td align="left">Plant &darr;&nbsp;&nbsp;Phase &rarr;</td>
    <%
    ps_data = con_master.prepareStatement("select phase from rel_pt_phase where enable=1");
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		cntLog++;
    %>
    <td><%=rs_data.getString("phase") %></td>
   <%
	}
   %>
   <td>Total</td>
  </tr>
  <!-- ******************************************************************************************************************* -->
  <!-- ****************************************** Dashboard Values ******************************************************* -->
  <!-- ******************************************************************************************************************* -->
  <%
  boolean checkFlag=false;
  int rowSum=0;
  String newQuery="";
  	PreparedStatement ps_user = con_master.prepareStatement("select id from rel_pt_releaseMaster where enable=1 and app_uid="+uid);
	ResultSet rs_user = ps_user.executeQuery();
	while(rs_user.next()){
		checkFlag=true;
	}
	ps_user = con_master.prepareStatement("select id from rel_pt_reviewer where enable=1 and u_id="+uid);
	rs_user = ps_user.executeQuery();
	while(rs_user.next()){
		checkFlag=true;
	}
  
  int phaseCnt=0;
  ps_data1 = con.prepareStatement("SELECT plant,company_name FROM user_tbl_company where enable=1 order by plant");
  rs_data1 = ps_data1.executeQuery();
  while(rs_data1.next()){
  %>
  <tr> 
    <td style="background-color: white;color: black;font-size: 12px;width: 20%;"><%=rs_data1.getString("plant") %> - <%=rs_data1.getString("company_name") %></td> 
    <%
    ps_data = con_master.prepareStatement("select seqNo,phase from rel_pt_phase where enable=1");
	rs_data = ps_data.executeQuery();
	while(rs_data.next()){
		if(checkFlag==true){
			newQuery = "select COUNT(phase_id) as phase from tran_pt_problem where enable=1 and plant='"+rs_data1.getString("plant")+"' and phase_id="+rs_data.getInt("seqNo");
		}else{
			newQuery = "select COUNT(phase_id) as phase from tran_pt_problem where enable=1 and plant='"+rs_data1.getString("plant")+"' and phase_id="+rs_data.getInt("seqNo") +" and project_lead="+uid; 
		}
		
		ps_data2 = con_master.prepareStatement(newQuery);
		rs_data2 = ps_data2.executeQuery();
		while(rs_data2.next()){
			phaseCnt=rs_data2.getInt("phase"); 
		}
		phaseCount.add(phaseCnt);
    %>
    <td style="background-color: white;color: black;text-align: right;font-size: 14px;width: 300px;">
    <a href="javascript:showMySelection(<%=rs_data.getInt("seqNo")%>,<%=rs_data1.getString("plant")%>,<%=phaseCnt %>);" style="color: black;"><%=phaseCnt %></a>
    </td>
   <%
   rowSum = rowSum + phaseCnt; 
	}
   %>
	<td align="right" style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 100px;font-weight: bold;">
	<a href="javascript:showMySelection(0,<%=rs_data1.getString("plant")%>,<%=rowSum%>);" style="color: black;"><%=rowSum %></a>
	</td>
   <%
	rowSum=0;
   %>
  </tr>
  <%
	}
  	ArrayList sum_h21=new ArrayList();
  	ArrayList sum_h25=new ArrayList();
	ArrayList sum_u3=new ArrayList();
	ArrayList sum_mfpl=new ArrayList();
	ArrayList sum_pc=new ArrayList();
	ArrayList sum_di=new ArrayList(); 
	int sum_approval=0,sum_define=0,sum_measure=0,sum_analyze=0,sum_improve=0,sum_control=0,sum_result=0,sum_sustain=0;
 
  for(int i=0;i<phaseCount.size();i+=cntLog){
	  int end = Math.min(i + cntLog, phaseCount.size());
	//System.out.println(i + " = " + end + "data = " + phaseCount.subList(i, end)); 
      List<String> sublist = phaseCount.subList(i, end);
      
      for(int j=0;j<phaseCount.subList(i, end).size();j++){ 
    	  if(end==8){
    		  sum_h21.add(phaseCount.subList(i, end).get(j).toString()); 
    	  }
    	  if(end==16){
    		  sum_h25.add(phaseCount.subList(i, end).get(j).toString()); 
    	  }
    	  if(end==24){
    		  sum_u3.add(phaseCount.subList(i, end).get(j).toString()); 
    	  }
    	  if(end==32){
    		  sum_mfpl.add(phaseCount.subList(i, end).get(j).toString()); 
    	  }
    	  if(end==40){
    		  sum_pc.add(phaseCount.subList(i, end).get(j).toString()); 
    	  }
    	  if(end==48){
    		  sum_di.add(phaseCount.subList(i, end).get(j).toString()); 
    	  }
      }
   // System.out.println(phaseCnt + "count = " + phaseCount + " = " + phaseCount.size() + " = = " + cntLog);
  }
  for(int i=0;i<sum_h21.size();i++){
	  sum_approval = Integer.valueOf(sum_h21.get(0).toString()) + Integer.valueOf(sum_h25.get(0).toString()) + 
			  			Integer.valueOf(sum_u3.get(0).toString()) + Integer.valueOf(sum_mfpl.get(0).toString()) +   
			  			Integer.valueOf(sum_pc.get(0).toString()) + Integer.valueOf(sum_di.get(0).toString());
	  
		sum_define=	Integer.valueOf(sum_h21.get(1).toString()) + Integer.valueOf(sum_h25.get(1).toString()) + 
	  					Integer.valueOf(sum_u3.get(1).toString()) + Integer.valueOf(sum_mfpl.get(1).toString()) +   
	  					Integer.valueOf(sum_pc.get(1).toString()) + Integer.valueOf(sum_di.get(1).toString());
		
		sum_measure=Integer.valueOf(sum_h21.get(2).toString()) + Integer.valueOf(sum_h25.get(2).toString()) + 
						Integer.valueOf(sum_u3.get(2).toString()) + Integer.valueOf(sum_mfpl.get(2).toString()) +   
						Integer.valueOf(sum_pc.get(2).toString()) + Integer.valueOf(sum_di.get(2).toString());
		
		sum_analyze=Integer.valueOf(sum_h21.get(3).toString()) + Integer.valueOf(sum_h25.get(3).toString()) + 
						Integer.valueOf(sum_u3.get(3).toString()) + Integer.valueOf(sum_mfpl.get(3).toString()) +   
						Integer.valueOf(sum_pc.get(3).toString()) + Integer.valueOf(sum_di.get(3).toString());
		
		sum_improve=Integer.valueOf(sum_h21.get(4).toString()) + Integer.valueOf(sum_h25.get(4).toString()) + 
						Integer.valueOf(sum_u3.get(4).toString()) + Integer.valueOf(sum_mfpl.get(4).toString()) +   
						Integer.valueOf(sum_pc.get(4).toString()) + Integer.valueOf(sum_di.get(4).toString());
		
		sum_control=Integer.valueOf(sum_h21.get(5).toString()) + Integer.valueOf(sum_h25.get(5).toString()) + 
						Integer.valueOf(sum_u3.get(5).toString()) + Integer.valueOf(sum_mfpl.get(5).toString()) +   
						Integer.valueOf(sum_pc.get(5).toString()) + Integer.valueOf(sum_di.get(5).toString());
		
		sum_result=Integer.valueOf(sum_h21.get(6).toString()) + Integer.valueOf(sum_h25.get(6).toString()) + 
						Integer.valueOf(sum_u3.get(6).toString()) + Integer.valueOf(sum_mfpl.get(6).toString()) +   
						Integer.valueOf(sum_pc.get(6).toString()) + Integer.valueOf(sum_di.get(6).toString());
		
		sum_sustain=Integer.valueOf(sum_h21.get(7).toString()) + Integer.valueOf(sum_h25.get(7).toString()) + 
						Integer.valueOf(sum_u3.get(7).toString()) + Integer.valueOf(sum_mfpl.get(7).toString()) +   
						Integer.valueOf(sum_pc.get(7).toString()) + Integer.valueOf(sum_di.get(7).toString());
		
  }
  int grandSum = sum_approval + sum_define + sum_measure + sum_analyze + sum_improve + sum_control + sum_result + sum_sustain;
  %>
  <tr> 
    <td style="background-color: #42b9f5;color: black;font-size: 15px;width: 20%;font-weight: bold;font-size: 14px;">Total &#8658;</td>  
 
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(1,0,<%=sum_approval %>);" style="color: black;"><%= sum_approval%></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(2,0,<%= sum_define%>);" style="color: black;"><%=sum_define %></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(3,0,<%= sum_measure%>);" style="color: black;"><%=sum_measure %></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(4,0,<%= sum_analyze%>);" style="color: black;"><%=sum_analyze %></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(5,0,<%= sum_improve%>);" style="color: black;"><%=sum_improve %></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(6,0,<%= sum_control%>);" style="color: black;"><%=sum_control %></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(7,0,<%= sum_result%>);" style="color: black;"><%=sum_result %></a></td>
    <td style="background-color: #42b9f5;color: black;text-align: right;font-size: 16px;width: 300px;font-weight: bold;"><a href="javascript:showMySelection(9,0,<%= sum_sustain%>);" style="color: black;"><%=sum_sustain %></a></td>
    <td style="background-color: #eff542;color: black;text-align: right;font-size: 16px;font-weight: bold;"><%=grandSum %></td>
  </tr>
  <!-- ******************************************************************************************************************* -->
  <!-- ******************************************************************************************************************* -->
</table>
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
			</table> 
	</span>
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