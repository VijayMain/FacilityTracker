<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.GregorianCalendar"%>
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
<title>Software Usage</title>
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
	padding: 4px;
	border-style: solid;
	border-color: #666666;
	text-align: center;
	color: black;
	background-color: #dedede;
}

table.gridtable td {
font-size: 12px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
	font-weight: bold;
	text-align: right;
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
	SimpleDateFormat formatmpr = new SimpleDateFormat("dd/MM/YYYY");
	SimpleDateFormat odkFormat = new SimpleDateFormat("yyyy-MM-dd"); 
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date date2cmp;
	Calendar calobj = Calendar.getInstance();
	String todays_date = format2.format(calobj.getTime());
	date2cmp = format2.parse(todays_date);
	/* date1cmp = sdf2.parse(october_date);
	diff = Math.abs(date2cmp.getTime() - date1cmp.getTime()) / (1000 * 60 * 60 * 24); */
	
Class.forName("com.mysql.jdbc.Driver"); 
Connection conOdk = DriverManager.getConnection( "jdbc:mysql://192.168.0.29:3306/odk?autoReconnect=true&useSSL=false", "user1", "Satara@123");
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
       	<ol class="breadcrumb"> 
			<li><i class="icon_ol"></i><strong>IT Software Usage</strong></li>  
		</ol>
        <%-- <%
  		if(request.getParameter("success")!=null){
		%> 
         <strong class="alert alert-success fade in"><%=request.getParameter("success") %> </strong> 
        <%
		}if(request.getParameter("statusNop")!=null){
			%> 
	         <strong class="alert alert-block alert-danger fade in"><%=request.getParameter("statusNop") %> </strong> 
	        <%
			}
		%>
           --%>    
        </div> 
<!-- ********************************************************************************************************************* -->
<div  style="height:500px;overflow: scroll;"> 
			<table class="gridtable" width="100%"> 
  <tr>
    <td colspan="2"><table class="gridtable" width="100%"> 
      <tr>
        <th colspan="10" align="center"><strong>Software Usage Details</strong></th>
      </tr>
      
      <%
     
		
		// ============================================ Facility Tracker ========================================================		
		int totfm=0,newfm=0,openfm=0,closefm=0,reopenfm=0;
		PreparedStatement psfm = con.prepareStatement("SELECT count(*) FROM facility_req_tbl where status_id=1 and sys_date BETWEEN date_sub(now(),INTERVAL 30 DAY) AND NOW() and enable=1");
		ResultSet rsfm = psfm.executeQuery();
		while(rsfm.next()){
			newfm = rsfm.getInt("count(*)");
		}
		psfm = con.prepareStatement("SELECT count(*) FROM facility_req_tbl where status_id=2 and sys_date BETWEEN date_sub(now(),INTERVAL 30 DAY) AND NOW() and enable=1");
		rsfm = psfm.executeQuery();
		while(rsfm.next()){
			openfm = rsfm.getInt("count(*)");
		}
		psfm = con.prepareStatement("SELECT count(*) FROM facility_req_tbl where status_id=5 and sys_date BETWEEN date_sub(now(),INTERVAL 30 DAY) AND NOW() and enable=1");
		rsfm = psfm.executeQuery();
		while(rsfm.next()){
			closefm = rsfm.getInt("count(*)");
		}
		psfm = con.prepareStatement("SELECT count(*) FROM facility_req_tbl where status_id=4 and sys_date BETWEEN date_sub(now(),INTERVAL 30 DAY) AND NOW() and enable=1");
		rsfm = psfm.executeQuery();
		while(rsfm.next()){
			reopenfm = rsfm.getInt("count(*)");
		}
		totfm = newfm + openfm + closefm + reopenfm;
		// ======================================================================================================================
		// ============================================ Facility Tracker - Master Create ========================================		
				int totmst=0,mstCRTD=0,mstREL=0,mstREJ=0,mstDONE=0;
				PreparedStatement psmst = con_master.prepareStatement("select COUNT(*) AS CNT from tran_SAPmaster_create where status_id='CRTD' AND enable=1 and created_date BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()");
				ResultSet rsmst = psmst.executeQuery();
				while(rsmst.next()){
					mstCRTD = rsmst.getInt("CNT");
				}
				psmst = con_master.prepareStatement("select COUNT(*) AS CNT from tran_SAPmaster_create where status_id='REL' AND enable=1 and created_date BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()");
				rsmst = psmst.executeQuery();
				while(rsmst.next()){
				mstREL = rsmst.getInt("CNT");
				}
				psmst = con_master.prepareStatement("select COUNT(*) AS CNT from tran_SAPmaster_create where status_id='DONE' AND enable=1 and created_date BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()");
				rsmst = psmst.executeQuery();
				while(rsmst.next()){
					mstDONE = rsmst.getInt("CNT");
				}
				psmst = con_master.prepareStatement("select COUNT(*) AS CNT from tran_SAPmaster_create where status_id='REJ' AND enable=1 and created_date BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()");
				rsmst = psmst.executeQuery();
				while(rsmst.next()){
					mstREJ = rsmst.getInt("CNT");
				}
				totmst = mstCRTD+mstREL+mstDONE+mstREJ;
		// ======================================================================================================================
		// ============================================ Self Declare ============================================================
				/* int totselfdeclare=0;
				PreparedStatement pssd = con.prepareStatement("SELECT count(*) as cnt FROM selfdeclare_tbl where enable_id=1 and sys_date BETWEEN date_sub(now(),INTERVAL 30 DAY) AND NOW()");
				ResultSet rssd = pssd.executeQuery();
				while(rsfm.next()){
					totselfdeclare = rssd.getInt("cnt");
				} */
		// ======================================================================================================================
		// ============================================ Work From Home ==========================================================
				int totwfh=0,wfhNew=0,wfhappr=0,wfhrej=0;
				PreparedStatement pswfh = con_master.prepareStatement("select COUNT(*) as cnt from tran_dwm_tasks where enable_id=1 and tran_date between DATEADD(DAY, -30, GETDATE()) AND GETDATE() and approval_id is null");
				ResultSet rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					wfhNew = rswfh.getInt("cnt");
				}
				
				pswfh = con_master.prepareStatement("select COUNT(*) as cnt from tran_dwm_tasks where enable_id=1 and tran_date between DATEADD(DAY, -30, GETDATE()) AND GETDATE() and approval_id=2");
				rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					wfhrej = rswfh.getInt("cnt");
				}
				
				pswfh = con_master.prepareStatement("select COUNT(*) as cnt from tran_dwm_tasks where enable_id=1 and tran_date between DATEADD(DAY, -30, GETDATE()) AND GETDATE() and approval_id=3");
				rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					wfhappr = rswfh.getInt("cnt");
				}
				totwfh = wfhNew + wfhrej + wfhappr;
				// ========================================================= MPR data ====================================	
				// date before 30 = = = 
				Date today = new Date();
				Calendar cal = new GregorianCalendar();
				cal.setTime(today);
				Date todayNew = cal.getTime();
				
				cal.add(Calendar.DAY_OF_MONTH, -30);
				Date today30 = cal.getTime(); 
				
				int mprCnt=0;
			//	System.out.println("count = " + formatmpr.format(today30) + " = " + formatmpr.format(todayNew));
			//	pswfh = con_master.prepareStatement("select COUNT(*) as cnt from mp_req_tbl where req_date!='NULL'  and req_date between '"+formatmpr.format(today30) +"' and '"+ formatmpr.format(todayNew)+"'");
				pswfh = con_master.prepareStatement("select COUNT(*) as cnt from mp_req_tbl where req_date!='NULL'  and req_date between CONVERT(VARCHAR(10), '"+formatmpr.format(today30)+"', 120) and CONVERT(VARCHAR(10), '"+formatmpr.format(todayNew)+"', 120) and enable_id=1");
				rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					mprCnt = rswfh.getInt("cnt");
				}
			// ========================================================== Vehicle Logger =========================================
			 	int loggerCnt=0; 
				pswfh = conOdk.prepareStatement("select count(*) as cnt from BUILD313758_CORE where CAST(_SUBMISSION_DATE as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"'");
			    rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					loggerCnt = rswfh.getInt("cnt"); 
				}
			// ======================================================================================================================
			// ========================================================== Material Wt Collection =========================================
				int deliveryCnt=0; 
				pswfh = conOdk.prepareStatement("SELECT count(*) as cnt FROM odk.BUILD_MATERIAL_WEIGHT_MONITOR_1598762930_CORE where _CREATION_DATE between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"'");
			    rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					deliveryCnt = rswfh.getInt("cnt"); 
				}
			// ======================================================================================================================
			
				// ========================================================== Six Sigma Data Portal =========================================
				int sixSigmaCnt=0; 
				pswfh = con_master.prepareStatement("select count(*) as cnt from tran_pt_problem where enable=1 and tran_date between DATEADD(DAY, -30, GETDATE()) AND GETDATE()");
				rswfh = pswfh.executeQuery();
				while(rswfh.next()){
					sixSigmaCnt = rswfh.getInt("cnt");
				}
			// ======================================================================================================================
					
					
			// ==================================== Software Usages for ComplaintZilla ====================================
			      int newcz=0,opencz=0,resolved=0,reopen=0,closed=0,actionPerformed=0,sumcz=0;
					
					PreparedStatement psCZ = con.prepareStatement("SELECT count(*) FROM complaint_tbl where  CAST(Complaint_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and Status_Id=1");
					ResultSet rsCZ = psCZ.executeQuery();
					while(rsCZ.next()){
						newcz = rsCZ.getInt("count(*)");
					}
					rsCZ.close();
					
					PreparedStatement psCZopen = con.prepareStatement("SELECT count(*) FROM complaint_tbl where  CAST(Complaint_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and Status_Id=2");
					ResultSet rsCZopen = psCZopen.executeQuery();
					while(rsCZopen.next()){
						opencz = rsCZopen.getInt("count(*)");
					}
					rsCZopen.close();
					
					PreparedStatement psCZresolved = con.prepareStatement("SELECT count(*) FROM complaint_tbl where  CAST(Complaint_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and Status_Id=3");
					ResultSet rsCZresolved = psCZresolved.executeQuery();
					while(rsCZresolved.next()){
						resolved = rsCZresolved.getInt("count(*)");
					}
					rsCZresolved.close();
					
					PreparedStatement psCZreopen = con.prepareStatement("SELECT count(*) FROM complaint_tbl where  CAST(Complaint_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and Status_Id=4");
					ResultSet rsCZreopen = psCZreopen.executeQuery();
					while(rsCZreopen.next()){
						reopen = rsCZreopen.getInt("count(*)");
					}
					rsCZreopen.close();
					
					PreparedStatement psCZclosed = con.prepareStatement("SELECT count(*) FROM complaint_tbl where  CAST(Complaint_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and Status_Id=5");
					ResultSet rsCZclosed = psCZclosed.executeQuery();
					while(rsCZclosed.next()){
						closed = rsCZclosed.getInt("count(*)");
					}
					rsCZclosed.close();
					
					PreparedStatement psCZaction = con.prepareStatement("SELECT count(*) FROM complaint_tbl_action where  CAST(Action_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"'");
					ResultSet rsCZaction = psCZaction.executeQuery();
					while(rsCZaction.next()){
						actionPerformed = rsCZaction.getInt("count(*)");
					}
					rsCZaction.close();
					sumcz= newcz + opencz + resolved + reopen + closed + actionPerformed;
					// ======================================================================================================================
					// ================================================== IT Tracker Software Count =========================================
					int itpending=0,itinprogress=0,itclosed=0,itreopen=0,sumIT = 0;
					PreparedStatement pspending = con.prepareStatement("SELECT count(*) FROM it_user_requisition where  CAST(Req_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='Pending'");
					ResultSet rspending = pspending.executeQuery();
					while(rspending.next()){
						itpending = rspending.getInt("count(*)");
					}
					rspending.close(); 
					
					PreparedStatement psinprogress = con.prepareStatement("SELECT count(*) FROM it_user_requisition where  CAST(Req_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='In Progress'");
					ResultSet rsinprogress = psinprogress.executeQuery();
					while(rsinprogress.next()){
						itinprogress = rsinprogress.getInt("count(*)");
					}
					rsinprogress.close();
					
					PreparedStatement psclosed = con.prepareStatement("SELECT count(*) FROM it_user_requisition where  CAST(Req_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='Closed'");
					ResultSet rsclosed = psclosed.executeQuery();
					while(rsclosed.next()){
						itclosed = rsclosed.getInt("count(*)");
					}
					rsclosed.close();
					
					PreparedStatement psreopen = con.prepareStatement("SELECT count(*) FROM it_user_requisition where  CAST(Req_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='Reopen'");
					ResultSet rsreopen = psreopen.executeQuery();
					while(rsreopen.next()){
						itreopen = rsreopen.getInt("count(*)");
					} 
					rsreopen.close();
					
					PreparedStatement psITpending = con.prepareStatement("SELECT count(*) FROM it_requisition_remark_tbl where  CAST(Remark_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='Pending'");
					ResultSet rsITpending = psITpending.executeQuery();
					while(rsITpending.next()){
						itpending = itpending + rsITpending.getInt("count(*)");
					}
					rsITpending.close();
					
					PreparedStatement psITinprogress = con.prepareStatement("SELECT count(*) FROM it_requisition_remark_tbl where  CAST(Remark_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='In Progress'");
					ResultSet rsITinprogress = psITinprogress.executeQuery();
					while(rsITinprogress.next()){
						itinprogress = itinprogress + rsITinprogress.getInt("count(*)");
					}
					rsITinprogress.close();
					
					PreparedStatement psITclosed = con.prepareStatement("SELECT count(*) FROM it_requisition_remark_tbl where  CAST(Remark_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='Closed'");
					ResultSet rsITclosed = psITclosed.executeQuery();
					while(rsITclosed.next()){
						itclosed = itclosed + rsITclosed.getInt("count(*)");
					}
					rsITclosed.close();
					
					PreparedStatement psITreopen = con.prepareStatement("SELECT count(*) FROM it_requisition_remark_tbl where  CAST(Remark_Date as date) between '"+ odkFormat.format(today30) +"' and '"+ odkFormat.format(todayNew) +"' and status='Reopen'");
					ResultSet rsITreopen = psITreopen.executeQuery();
					while(rsITreopen.next()){
						itreopen = itreopen + rsITreopen.getInt("count(*)");
					}			
					rsITreopen.close();
					
					sumIT = itpending + itinprogress + itclosed + itreopen;
					// ======================================================================================================================
      %>
      <tr>
        <th>ComplaintZilla</th>
        <th>IT Tracker</th>
        <th>FacilityTracker</th>
        <th>ManPower Requisition</th>
        <th>SAPMaster Creation</th> 
        <th>Delivery Logger</th> 
        <th>Material Weight Collection</th> 
        <!-- <th>Work From Home</th> -->
        <th>Six Sigma Project</th>
      </tr>
      <tr>
        <td><%= sumcz %></td>
        <td><%= sumIT %></td>
        <td><%= totfm %></td>
        <td><%= mprCnt %></td>
        <td><%= totmst %></td>
        <td><%= loggerCnt %></td>  
        <td><%= deliveryCnt %></td>
        <%-- <td><%= totwfh %></td> --%>
        <td><%= sixSigmaCnt %></td>
      </tr>
    </table></td> 
  </tr>
  <tr>
    <td><table class="gridtable" width="100%"> 
      <tr>
        <th colspan="6"><strong>IT Tracker</strong></th>
      </tr>
      <tr> 
        <th>Pending</th>
        <th>In Progress</th>
        <th>Closed</th>
        <th>Reopen</th>
      </tr> 
      <tr> 
        <td><%=itpending %></td>
        <td><%=itinprogress %></td>
        <td><%=itclosed %></td>
        <td><%=itreopen %></td> 
      </tr>
    </table></td>
    <td><table class="gridtable" width="100%"> 
      <tr>
        <th colspan="6"><strong>Facility Tracker</strong></th>
      </tr>
      <tr> 
        <th>New</th>
        <th>Open</th>
        <th>Close</th>
        <th>Reopen</th>
      </tr>
      <tr>
        <td><%=newfm %></td>
        <td><%=openfm %></td>
        <td><%=closefm %></td>
        <td><%=reopenfm %></td> 
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><table class="gridtable" width="100%"> 
      <tr>
        <th colspan="6"><strong>Man Power Requisition</strong></th>
      </tr>
      <tr>
        <th>Plant</th>
        <th>New</th>
        <th>Open</th>
        <th>Resolved</th>
        <th>Reopen</th>
        <th>Close</th>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table></td>
    <td><table class="gridtable" width="100%"> 
      <tr>
        <th colspan="6"><strong>ComplaintZilla</strong></th>
      </tr>
      <tr> 
        <th>New</th>
        <th>Open</th>
        <th>Resolved</th>
        <th>Reopen</th>
        <th>Close</th>
      </tr>
      <tr>
        <td><%=newcz %></td>
        <td><%=opencz %></td>
        <td><%=resolved + actionPerformed %></td>
        <td><%=reopen %></td>
        <td><%=closed %></td> 
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><table class="gridtable" width="100%"> 
      <tr>
        <th colspan="6"><strong>SAP Master Creation</strong></th>
      </tr>
      <tr>
        <th>CRTD</th>
        <th>REL</th>
        <th>REJ</th>
        <th>DONE</th> 
      </tr>
      <tr>
        <td><%=mstCRTD %></td>
        <td><%=mstREL %></td>
        <td><%=mstREJ %></td>
        <td><%=mstDONE %></td> 
      </tr>
    </table></td>
    <td>
    
    
    <table class="gridtable" width="100%"> 
      <tr>
        <th colspan="6"><strong>Work From Home</strong></th>
      </tr>
      <tr> 
        <th>Pending</th>
        <th>Approved</th>
        <th>Rejected</th> 
      </tr>
      <tr>
        <td><%=wfhNew %></td>
        <td><%=wfhappr %></td>
        <td><%=wfhrej %></td> 
      </tr>
    </table>
    
    
    
    </td>
  </tr>
    
</table>

			
			
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