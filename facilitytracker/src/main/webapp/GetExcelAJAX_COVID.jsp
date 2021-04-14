<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxl.write.Label"%>
<%@page import="jxl.write.WritableSheet"%>
<%@page import="jxl.format.BorderLineStyle"%>
<%@page import="jxl.format.Border"%>
<%@page import="jxl.format.Alignment"%>
<%@page import="jxl.write.WritableCellFormat"%>
<%@page import="jxl.write.WritableFont"%>
<%@page import="jxl.format.Colour"%>
<%@page import="jxl.Workbook"%>
<%@page import="jxl.write.WritableWorkbook"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
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
<title>Ajax</title>
</head>
<body>
<%
try{
 	String custCode = request.getParameter("q");
 	SimpleDateFormat mailDateFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
 	Connection con = Connection_Util.getLocalUserConnection();
	int uid = Integer.parseInt(session.getAttribute("uid").toString());  
	PreparedStatement ps_mst = null, ps_mst1 = null;
	ResultSet rs_mst = null, rs_mst1 = null;
%>	 
<span id="covid19">  
<%


ArrayList alistFile = new ArrayList();
File folder = new File("C:/reportxls");
File[] listOfFiles = folder.listFiles();
String listname = "";  

int val = listOfFiles.length + 1;
String fileName = "C:/reportxls/facility"+val+".xls";
File exlFile = new File(fileName); 


WritableWorkbook writableWorkbook = Workbook.createWorkbook(exlFile); 


Colour bckcolor = Colour.TURQUOISE;
WritableFont font = new WritableFont(WritableFont.ARIAL);
font.setColour(Colour.BLACK); 

WritableFont fontbold = new WritableFont(WritableFont.ARIAL);
fontbold.setColour(Colour.BLACK);
fontbold.setBoldStyle(WritableFont.BOLD);

WritableCellFormat cellFormat = new WritableCellFormat();
cellFormat.setBackground(bckcolor);
cellFormat.setAlignment(Alignment.CENTRE);
cellFormat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK); 
cellFormat.setFont(fontbold); 

WritableCellFormat cellRIghtformat = new WritableCellFormat(); 
cellRIghtformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
font.setColour(Colour.BLACK); 
cellRIghtformat.setFont(font);
cellRIghtformat.setAlignment(Alignment.RIGHT);

WritableCellFormat cellFormatWrap = new WritableCellFormat();
cellFormatWrap.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
font.setColour(Colour.BLACK); 
cellFormatWrap.setFont(font);
cellFormatWrap.setAlignment(Alignment.RIGHT); 
cellFormatWrap.setWrap(true);

WritableCellFormat cellleftformat = new WritableCellFormat(); 
cellleftformat.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
font.setColour(Colour.BLACK); 
cellleftformat.setFont(font); 	
cellleftformat.setAlignment(Alignment.LEFT);

WritableSheet writableSheet = writableWorkbook.createSheet("COVID 19", 0);
writableSheet.setColumnView(0, 10);
writableSheet.setColumnView(1, 10);
writableSheet.setColumnView(2, 10);
writableSheet.setColumnView(3, 10);
writableSheet.setColumnView(4, 10);
writableSheet.setColumnView(5, 10);
writableSheet.setColumnView(6, 10);
writableSheet.setColumnView(7, 10);
writableSheet.setColumnView(8, 10);
writableSheet.setColumnView(9, 10);
writableSheet.setColumnView(10, 10);
writableSheet.setColumnView(11, 10);
writableSheet.setColumnView(12, 10);
writableSheet.setColumnView(13, 10);
writableSheet.setColumnView(14, 10);
writableSheet.setColumnView(15, 10);
writableSheet.setColumnView(16, 10);
writableSheet.setColumnView(17, 10);
writableSheet.setColumnView(18, 10);
writableSheet.setColumnView(19, 10);
writableSheet.setColumnView(20, 10); 

Label label0 = new Label(0,0, "D.No",cellFormat);
Label label1 = new Label(1,0, "User Name",cellFormat);
Label label2 = new Label(2,0, "Contact No",cellFormat);
Label label3 = new Label(3,0, "Emergency Contact",cellFormat);
Label label4 = new Label(4,0, "Contact Address",cellFormat);
Label label5 = new Label(5,0, "Arogya Setu Registered",cellFormat);
Label label6 = new Label(6,0, "Working in",cellFormat);
Label label7 = new Label(7,0, "Email ID",cellFormat);
Label label8 = new Label(8,0, "Employee ID",cellFormat);
Label label9 = new Label(9,0, "Symptoms - Fever",cellFormat);
Label label10 = new Label(10,0, "Symptoms -cough",cellFormat);
Label label11 = new Label(11,0, "Symptoms - brethlessness",cellFormat);
Label label12 = new Label(12,0, "Symptoms -sorethroat",cellFormat);
Label label13 = new Label(13,0, "Symptoms - other",cellFormat);
Label label14 = new Label(14,0, "Travel before 14 days",cellFormat);
Label label15 = new Label(15,0, "travel Locations",cellFormat);
Label label16 = new Label(16,0, "travel arrivalDate",cellFormat);
Label label17 = new Label(17,0, "travel departureDate",cellFormat);
Label label18 = new Label(18,0, "contact positive 14 days Case",cellFormat);
Label label19 = new Label(19,0, "Total Family Nos",cellFormat);
Label label20 = new Label(20,0, "Registered Date",cellFormat);
Label label21 = new Label(21,0, "Register in Arogya Setu",cellFormat);
 

writableSheet.addCell(label0);
writableSheet.addCell(label1);
writableSheet.addCell(label2);
writableSheet.addCell(label3);
writableSheet.addCell(label4);
writableSheet.addCell(label5);
writableSheet.addCell(label6);
writableSheet.addCell(label7);
writableSheet.addCell(label8);
writableSheet.addCell(label9);
writableSheet.addCell(label10);
writableSheet.addCell(label11);
writableSheet.addCell(label12);
writableSheet.addCell(label13);
writableSheet.addCell(label14);
writableSheet.addCell(label15);
writableSheet.addCell(label16);
writableSheet.addCell(label17);
writableSheet.addCell(label18);
writableSheet.addCell(label19);
writableSheet.addCell(label20);
writableSheet.addCell(label21);
 

WritableSheet writableSheet1 = writableWorkbook.createSheet("Family Details", 1);
writableSheet1.setColumnView(0, 10);
writableSheet1.setColumnView(1, 10);
writableSheet1.setColumnView(2, 10);
writableSheet1.setColumnView(3, 10);
writableSheet1.setColumnView(4, 10);
writableSheet1.setColumnView(5, 10);
writableSheet1.setColumnView(6, 10);
writableSheet1.setColumnView(7, 10);
 
Label act1 = new Label(0, 0, "D.NO",cellFormat);
Label act2 = new Label(1, 0, "Name",cellFormat);
Label act3 = new Label(2, 0, "Relation",cellFormat);
Label act4 = new Label(3, 0, "Age",cellFormat);
Label act5 = new Label(4, 0, "Flue Symptoms",cellFormat);
Label act6 = new Label(5, 0, "Travel Before 14 Days",cellFormat);
Label act7 = new Label(6, 0, "Close Contact with Positive case",cellFormat);
Label act8 = new Label(7, 0, "Registered Date",cellFormat);

// Add the created Cells to the sheet
writableSheet1.addCell(act1);
writableSheet1.addCell(act2);
writableSheet1.addCell(act3);
writableSheet1.addCell(act4);
writableSheet1.addCell(act5);
writableSheet1.addCell(act6);
writableSheet1.addCell(act7);
writableSheet1.addCell(act8);


int r=1,s=1;
PreparedStatement ps_check1=null,ps_check2=null;
ResultSet rs_check1=null,rs_check2=null;
Label lable = null;
String company="",ariveDate="",departDate="",relation="";
PreparedStatement ps_check = con.prepareStatement("SELECT * FROM selfdeclare_tbl where enable_id=1 order by sys_date desc");
ResultSet rs_check = ps_check.executeQuery();
while (rs_check.next()) {
	
	if(rs_check.getDate("trav_arrivalDate")!=null){
		ariveDate =  mailDateFormat.format(rs_check1.getTimestamp("trav_arrivalDate"));
	}
	if(rs_check.getDate("trav_departureDate")!=null){
		departDate= mailDateFormat.format(rs_check1.getTimestamp("trav_departureDate"));
	}
	
	ps_check1 = con.prepareStatement("SELECT * FROM user_tbl_company where Company_Id="+Integer.valueOf(rs_check.getString("working_in")));
	rs_check1 = ps_check1.executeQuery();
	while(rs_check1.next()){
	company = rs_check1.getString("Company_Name");	
	}
	
	lable = new Label(0, r, String.valueOf(rs_check.getInt("id")),cellRIghtformat);
	writableSheet.addCell(lable);
	
	lable = new Label(1, r, String.valueOf(rs_check.getString("user_name")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(2, r, String.valueOf(rs_check.getString("contact_no")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(3, r, String.valueOf(rs_check.getString("emergency_contactno")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(4, r, String.valueOf(rs_check.getString("contact_address")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(5, r, String.valueOf(rs_check.getString("asetu_register")),cellRIghtformat);
	writableSheet.addCell(lable);
	
	lable = new Label(6, r, company,cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(7, r, String.valueOf(rs_check.getString("email_id")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(8, r, String.valueOf(rs_check.getString("employee_id")),cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(9, r, String.valueOf(rs_check.getString("sympt_fever")),cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(10, r, String.valueOf(rs_check.getString("sympt_cough")),cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(11, r, String.valueOf(rs_check.getString("sympt_brethlessness")),cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(12, r, String.valueOf(rs_check.getString("sympt_sorethroat")),cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(13, r, String.valueOf(rs_check.getString("sympt_other")),cellleftformat);
	writableSheet.addCell(lable);
	
	
	lable = new Label(14, r, String.valueOf(rs_check.getString("trav_before14days")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(15, r, String.valueOf(rs_check.getString("trav_location")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(16, r, ariveDate,cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(17, r, departDate,cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(18, r, String.valueOf(rs_check.getString("contact_positive14daysCase")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(19, r, String.valueOf(rs_check.getString("totalFamilyMembers")),cellleftformat);
	writableSheet.addCell(lable);
	
	lable = new Label(20, r, mailDateFormat.format(rs_check.getTimestamp("sys_date")),cellleftformat);
	writableSheet.addCell(lable);
	 
	lable = new Label(21, r, String.valueOf(rs_check.getString("asetu_register")),cellleftformat);
	writableSheet.addCell(lable);
	
	r++; 	
}
/************************************************************************************************************************************/			
	ps_check1 = con.prepareStatement("select * from selfdeclare_rel_tbl where enable=1  order by co_id desc");
	rs_check1 = ps_check1.executeQuery();
	while (rs_check1.next()) {
		
	lable = new Label(0, s, rs_check1.getString("co_id"),cellRIghtformat);
	writableSheet1.addCell(lable);
	
	lable = new Label(1, s, rs_check1.getString("name"),cellleftformat);
	writableSheet1.addCell(lable);
	
	ps_check2 = con.prepareStatement("SELECT * FROM selfdeclare_family_rel_tbl where id="+rs_check1.getInt("relation"));
	rs_check2 = ps_check2.executeQuery();
	while(rs_check2.next()){
	relation = rs_check2.getString("relationEN");	
	}
	
	lable = new Label(2, s,relation ,cellleftformat);
	writableSheet1.addCell(lable);
	
	lable = new Label(3, s, rs_check1.getString("age"),cellRIghtformat);
	writableSheet1.addCell(lable);
	
	lable = new Label(4, s, rs_check1.getString("flu_symptoms"),cellleftformat);
	writableSheet1.addCell(lable);
	
	lable = new Label(5, s, rs_check1.getString("travel14Before"),cellleftformat);
	writableSheet1.addCell(lable);
	
	lable = new Label(6, s, rs_check1.getString("closecontact"),cellleftformat);
	writableSheet1.addCell(lable);
	
	lable = new Label(7, s, mailDateFormat.format(rs_check1.getTimestamp("sys_date")),cellleftformat);
	writableSheet1.addCell(lable);
	 
/************************************************************************************************************************************/
	s++;
	} 


writableWorkbook.write();
writableWorkbook.close();

%>
<a href="DownloadFile.jsp?filepath=<%=fileName%>" style="color: green;background-color: yellow;"><i class="icon_download"></i>&nbsp;<b> Download File</b></a>
</span>
<%
}catch(Exception e){
	e.printStackTrace();
}
%>  
</body>
</html>