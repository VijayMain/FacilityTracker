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
<title>Tag Punching</title>
  <!-- Bootstrap CSS -->
  <link href="css/bootstrap.min.css" rel="stylesheet">
  <!-- bootstrap theme -->
  <link href="css/bootstrap-theme.css" rel="stylesheet">
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
</head>
<script type="text/javascript">
function getStorageLocation(val) {
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value ="";
	
	var fiscal_year = document.getElementById("fiscal").value;
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
				document.getElementById("getLoc").innerHTML = xmlhttp.responseText;
			}
		};
		xmlhttp.open("POST", "Stock_Taking_StorageAJAX.jsp?plant=" + val + "&fiscal="+fiscal_year, true);
		xmlhttp.send();
};

function search_recordCall(data_entryPLant,store_loc,stockType,mat_type,phy_location,extra_select) {
	 
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value ="";
	
	var sno_search = document.getElementById("sno_search").value;
	var tno_search = document.getElementById("tno_search").value;
	var mat_search = document.getElementById("mat_search").value;
	
	// alert(mat_search);
	
	var fiscal_year = document.getElementById("fiscal").value; 
	
//	alert(value+call+store_loc+stockType+mat_type+phy_location+extra_select);
	//alert(sno_search + " = " +  tno_search);
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
				document.getElementById("search_tagsSno").innerHTML = xmlhttp.responseText;
			}
		};
		xmlhttp.open("POST", "Stock_Taking_SearchCallAJAX.jsp?plant=" + data_entryPLant + "&fiscal="+fiscal_year+
				"&sno_search="+sno_search+"&tno_search="+tno_search+"&store_loc="+store_loc+"&stockType="+stockType+"&mat_type="+mat_type+"&phy_loc="+phy_location+"&extra_select="+extra_select+"&mat_search="+mat_search, true);
		xmlhttp.send();
};



function getphysical_Location(val) {
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value ="";
	
	var fiscal_year = document.getElementById("fiscal").value; 
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	
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
				document.getElementById("getPHYLoc").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "Stock_Taking_locPhyAJAX.jsp?store_loc=" + val + "&fiscal="+fiscal_year+"&data_entryPLant="+data_entryPLant, true);
		xmlhttp.send();
};

function getphy_audit(val) {
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value ="";
	
	var fiscal_year = document.getElementById("fiscal").value; 
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	 
	
	if(val!=""){
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
				document.getElementById("getPHYAuditLoc").innerHTML = xmlhttp.responseText; 
		}
	};
	xmlhttp.open("POST", "Stock_Taking_locPhyAuditAJAX.jsp?phy_loc=" + val + "&fiscal="+fiscal_year+"&data_entryPLant="+data_entryPLant, true);
	xmlhttp.send(); 
	
	/* --------------------------------------------------------------------------------------------------------------  */
	var xmlhttp1; 
	var store_loc = document.getElementById("store_loc").value; 
	var stockType = document.getElementById("stockType").value; 
	var mat_type = document.getElementById("mat_type").value; 
	var extra_select = document.getElementById("extra_select").value; 
	
	if (window.XMLHttpRequest) {
		// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp1 = new XMLHttpRequest();
	} else {
		// code for IE6, IE5
		xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp1.onreadystatechange = function() {
		if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
			document.getElementById("tagUpload").innerHTML = xmlhttp1.responseText; 
	}
	};
	xmlhttp1.open("POST", "Stock_Taking_viewHistoryAJAX.jsp?phy_loc=" + val + "&fiscal="+fiscal_year+"&data_entryPLant="+data_entryPLant
			+ "&store_loc="+store_loc + "&stockType="+stockType + "&mat_type="+mat_type + "&extra_select="+extra_select, true);
	xmlhttp1.send();
	/* --------------------------------------------------------------------------------------------------------------  */
	
	}else{
		document.getElementById("getPHYAuditLoc").innerHTML ="";
	}
};

function upload_Tag() {
	var sno = document.getElementById("sno").value;
	var batchNo = document.getElementById("batchNo").value;
	var entry_qty = document.getElementById("entry_qty").value;
	var tag_no = document.getElementById("tag_no").value;
	var stockType = document.getElementById("stockType").value;
	var mat_type = document.getElementById("mat_type").value;
	
	var store_loc = document.getElementById("store_loc").value;
	var phy_location = document.getElementById("phy_location").value;
	
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	
	var multiCode_select = document.getElementById("multiCode_select").value;
	var extra_select = document.getElementById("extra_select").value; 
	
//	if(sno!="" && entry_qty!="" && tag_no!="" && store_loc!="" && phy_location!=""){
	
	if(sno=="" && extra_select!=1){
		alert("S.No ?");
		var input = document.getElementById('sno'); 
		input.focus();
	}else if(entry_qty==""){
		alert("Entry Qty ?");
		var input = document.getElementById('entry_qty'); 
		input.focus();
	}else if(tag_no==""){
		alert("Tag No ?");
		var input = document.getElementById('tag_no'); 
		input.focus();
	}else if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else if(phy_location==""){
		alert("Physical Location ?"); 
	}else{
		
	if(extra_select!=1){
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
				document.getElementById("tagUpload").innerHTML = xmlhttp.responseText; 
		}
	};
	xmlhttp.open("POST", "Stock_Taking_UploadTagAJAX.jsp?sno=" + sno + "&batchNo="+batchNo+ "&entry_qty="+entry_qty+ "&tag_no="+tag_no+ "&stockType="+stockType+ "&mat_type="+mat_type+ "&store_loc="+store_loc
			+ "&phy_location="+phy_location+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant + "&multiCode_select="+multiCode_select + "&extra_select="+extra_select, true);
	xmlhttp.send();
	
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value ="";
	
	var input = document.getElementById('sno'); 
	input.focus();
	
	var Table = document.getElementById("summCode");
	Table.innerHTML = "";
	
	// *******************************************************************************************************************
	// ***************************************************** Extra Sheet Data ********************************************
	// *******************************************************************************************************************
	}else{
		
		var MtCode = document.getElementById("MtCode").value; 
		 
		if(MtCode==""){
			alert("Please Adopt Material Code Properly...!");
			var input = document.getElementById('sno'); 
			input.focus();
		}else{
		
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
				document.getElementById("tagUpload").innerHTML = xmlhttp.responseText; 
		}
		};
	xmlhttp.open("POST", "Stock_Taking_UploadTagExtraAJAX.jsp?batchNo="+batchNo+ "&entry_qty="+entry_qty+ "&tag_no="+tag_no+ "&stockType="+stockType+ "&mat_type="+mat_type+ "&store_loc="+store_loc
			+ "&phy_location="+phy_location+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant + "&multiCode_select="+multiCode_select + "&extra_select="+extra_select + "&MtCode=" + MtCode, true);
	xmlhttp.send();
	
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value ="";
	
	var input = document.getElementById('sno');
	input.focus();
	
	var Table = document.getElementById("summCode");
	Table.innerHTML = "";
	}
	}
	// *******************************************************************************************************************
	} 
};

// ***********************************************************************************************************************************************
function upload_TagInformation(id,batch,entry_qty,tagNo,plant,fiscal_year,deleteFlag) {
	
	//alert(id+" = "+batch+" = "+entry_qty+" = "+tagNo+" = "+plant+" = "+fiscal_year+" = "+deleteFlag);
	
	var entry_qty_ajax = document.getElementById("entry_qty_ajax"+id).value;
	var batchNo_ajax = document.getElementById("batchNo_ajax"+id).value;
	var tag_no_ajax = document.getElementById("tag_no_ajax"+id).value;
	
	var extra_select = document.getElementById("extra_select").value; 
	
	 if(entry_qty_ajax==""){
		alert("Entry Qty ?");
		var input = document.getElementById('entry_qty_ajax'); 
		input.focus();
	}else if(tag_no_ajax==""){
		alert("Tag No ?");
		var input = document.getElementById('tag_no_ajax'); 
		input.focus();
	}else{
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
				document.getElementById("tag_edit"+id).innerHTML = xmlhttp.responseText; 
		}
	};
	xmlhttp.open("POST", "Stock_Taking_EditTagAJAX.jsp?id="+id+"&batch="+batch+"&entry_qty="+entry_qty+"&tagNo="+tagNo+"&plant="+plant+"&fiscal_year="+fiscal_year+
			"&entry_qty_ajax="+entry_qty_ajax + "&batchNo_ajax="+batchNo_ajax + "&tag_no_ajax="+tag_no_ajax + "&extra_select=" + extra_select + "&deleteFlag="+deleteFlag, true);
	xmlhttp.send();
	
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	
	var input = document.getElementById('sno'); 
	input.focus();
	
	var Table = document.getElementById("summCode");
	Table.innerHTML = "";
	} 
};

//***********************************************************************************************************************************************

function getDataSummary(val) {
	var sno = document.getElementById("sno").value;
	var batchNo = document.getElementById("batchNo").value;
	var entry_qty = document.getElementById("entry_qty").value;
	var tag_no = document.getElementById("tag_no").value;
	var stockType = document.getElementById("stockType").value;
	var mat_type = document.getElementById("mat_type").value;
	var store_loc = document.getElementById("store_loc").value;
	var phy_location = document.getElementById("phy_location").value; 
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value; 
	if(val!=""){
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
					document.getElementById("summCode").innerHTML = xmlhttp.responseText; 
			}
		};
		xmlhttp.open("POST", "Stock_Taking_viewRecordAJAX.jsp?sno=" + sno + "&batchNo="+batchNo+ "&entry_qty="+entry_qty+ "&tag_no="+tag_no+ "&stockType="+stockType+ "&mat_type="+mat_type+ "&store_loc="+store_loc
				+ "&phy_location="+phy_location+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant, true);
		xmlhttp.send();
		}
	
}	


// ******* Excel Export ====> 
function DownloadExcel(val) {
	var stockType = document.getElementById("stockType").value; 
	var store_loc = document.getElementById("store_loc").value;  
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	
	if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else{	
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
			document.getElementById("excelExp").innerHTML = xmlhttp.responseText; 
	}
};
	xmlhttp.open("POST", "Stock_Taking_ExcelExporttAJAX.jsp?stockType="+stockType+ "&store_loc="+store_loc
		+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant+"&excel="+val, true);
	xmlhttp.send();
	
}
	
}
 
function DownloadExcel_Extra(val) {
	var stockType = document.getElementById("stockType").value; 
	var store_loc = document.getElementById("store_loc").value;  
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	
	if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else{	
	
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
			document.getElementById("excelExp_Extra").innerHTML = xmlhttp.responseText; 
	}
	};
	xmlhttp.open("POST", "Stock_Taking_ExcelExporttAJAX.jsp?stockType="+stockType+ "&store_loc="+store_loc
		+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant+"&excel="+val, true);
	xmlhttp.send();
	}
	
}



function Download_getChecked(val) {
	var stockType = document.getElementById("stockType").value; 
	var store_loc = document.getElementById("store_loc").value;  
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	var phy_location = document.getElementById("phy_location").value; 
	
	if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else if(phy_location==""){
		alert("Physical Location ?");
		var input = document.getElementById('phy_location'); 
		input.focus();
	}else{	
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
			document.getElementById("getcheckUpload").innerHTML = xmlhttp.responseText; 
	}
};
	xmlhttp.open("POST", "Stock_Taking_ExcelUploadAJAX.jsp?stockType="+stockType+ "&store_loc="+store_loc
		+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant+"&excel="+val+"&phy_location="+phy_location, true);
	xmlhttp.send();
	
}
	
}

function Download_getCheckedExtra(val) {
	var stockType = document.getElementById("stockType").value; 
	var store_loc = document.getElementById("store_loc").value;  
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	var phy_location = document.getElementById("phy_location").value;
	
	if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else if(phy_location==""){
		alert("Physical Location ?");
		var input = document.getElementById('phy_location'); 
		input.focus();
	}else{	
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
			document.getElementById("getcheckUpload_Extra").innerHTML = xmlhttp.responseText; 
	}
};
	xmlhttp.open("POST", "Stock_Taking_ExcelUploadAJAX.jsp?stockType="+stockType+ "&store_loc="+store_loc
		+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant+"&excel="+val +"&phy_location="+phy_location, true);
	xmlhttp.send(); 
}
}















function Download_getCheckedAll(val) {
	var stockType = document.getElementById("stockType").value; 
	var store_loc = document.getElementById("store_loc").value;  
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	var phy_location = document.getElementById("phy_location").value; 
	
	if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else{	
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
			document.getElementById("getcheckUploadAll").innerHTML = xmlhttp.responseText; 
	}
};
	xmlhttp.open("POST", "Stock_Taking_ExcelUploadAllAJAX.jsp?stockType="+stockType+ "&store_loc="+store_loc
		+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant+"&excel="+val+"&phy_location="+phy_location, true);
	xmlhttp.send();
	
}
	
}

function Download_getCheckedExtraAll(val) {
	var stockType = document.getElementById("stockType").value; 
	var store_loc = document.getElementById("store_loc").value;  
	var fiscal_year = document.getElementById("fiscal").value;
	var data_entryPLant = document.getElementById("data_entryPLant").value;
	var phy_location = document.getElementById("phy_location").value;
	
	if(store_loc==""){
		alert("Storage Location ?");
		var input = document.getElementById('store_loc'); 
		input.focus();
	}else{	
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
			document.getElementById("getcheckUpload_ExtraAll").innerHTML = xmlhttp.responseText; 
	}
};
	xmlhttp.open("POST", "Stock_Taking_ExcelUploadAllAJAX.jsp?stockType="+stockType+ "&store_loc="+store_loc
		+ "&fiscal_year="+fiscal_year+ "&data_entryPLant="+data_entryPLant+"&excel="+val +"&phy_location="+phy_location, true);
	xmlhttp.send(); 
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
	
function alterValidation() {
	var extra_check = document.getElementById("extra_check");
	var multiCode_check = document.getElementById("multiCode_check");
	var batch_check = document.getElementById("batch_check");
	document.getElementById("sno").value ="";
	document.getElementById("batchNo").value ="";
	document.getElementById("entry_qty").value ="";
	document.getElementById("tag_no").value ="";
	document.getElementById("MtCode").value ="";
	document.getElementById("material_search").value =""; 
	document.getElementById("getMaterialData").innerHTML ="";
	
	
	var phy_location = document.getElementById("phy_location");
	phy_location.selectedIndex = 0;
	// ************************************* Extra check
	if (extra_check.checked == true){
		document.getElementById("extra_select").value=1;
		document.getElementById("materialSearch_head").style.display="table-cell";		   
		document.getElementById("materialSearch_value").style.display="table-cell";
		
		document.getElementById("sno_head").style.display="none";		   
		document.getElementById("sno_value").style.display="none";
	} else {
		document.getElementById("extra_select").value=0;
		document.getElementById("materialSearch_head").style.display="none";
		document.getElementById("materialSearch_value").style.display="none";
		
		document.getElementById("sno_head").style.display="table-cell";		   
		document.getElementById("sno_value").style.display="table-cell";
	}
	// ************************************* Multi code validation
	if (multiCode_check.checked == true){
		 document.getElementById("multiCode_select").value=1;
	} else {
		document.getElementById("multiCode_select").value=0;
	}
	// ************************************* Batch Check
	if (batch_check.checked == true){
		 document.getElementById("batch_select").value=1;
		 document.getElementById("batchId_head").style.display="table-cell";
		 document.getElementById("batchId_row").style.display="table-cell";
	} else {
		 document.getElementById("batch_select").value=0;
		 document.getElementById("batchId_head").style.display="none";
		 document.getElementById("batchId_row").style.display="none";
	}
	//alert(document.getElementById("extra_select").value + " = " + document.getElementById("multiCode_select").value + " = " + document.getElementById("batch_select").value);
}

function GetmatDetails(val) {
	var mat_type = document.getElementById("mat_type").value; 
	var plant = document.getElementById("data_entryPLant").value; 
	 if(val!=""){
		var xmlhttp1;
		if (window.XMLHttpRequest) {
			xmlhttp1 = new XMLHttpRequest();
		} else {
			xmlhttp1 = new ActiveXObject("Microsoft.XMLHTTP");
		} 
		xmlhttp1.onreadystatechange = function() {
			if (xmlhttp1.readyState == 4 && xmlhttp1.status == 200) {
				document.getElementById("getMaterialData").innerHTML = xmlhttp1.responseText; 
			}
		}; 
		xmlhttp1.open("POST", "Stock_Taking_getMatExtraAJAX.jsp?plant=" + plant + "&matSearch=" + val + "&mat_type=" + mat_type, true); 
		xmlhttp1.send();
	 }else{
		alert("Material is not Valid...!");
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
				document.getElementById("getCode").innerHTML = xmlhttp1.responseText; 
			}
		}; 
		xmlhttp1.open("POST", "Stock_Taking_getMatAdoptAJAX.jsp?id=" + val, true); 
		xmlhttp1.send();
};

 

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
	font-size: 12px;
	border-width: 1px;
	padding: 4px;
	border-style: solid;
	border-color: #666666; 
	color: black;
	background-color: #9ECEE0;
}

table.gridtable td {
font-size: 12px;
	border-width: 1px;
	padding: 2px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
} 
</style>
<body style="font-family: Arial, Helvetica, sans-serif; color: black;">
<%
try{
/*-------------------------------------------------------------------------------------------------------------------*/
Connection con = Connection_Util.getConnectionMaster();
String plant_code = session.getAttribute("plant").toString();
String username = session.getAttribute("username").toString();		
int dept_idlog = Integer.valueOf(session.getAttribute("dept_id").toString());
int year = Calendar.getInstance().get(Calendar.YEAR);
year--;
int uid = Integer.valueOf(session.getAttribute("uid").toString());
PreparedStatement ps_check=null;
ResultSet rs_check=null;

 

/*-------------------------------------------------------------------------------------------------------------------*/
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
          <div class="col-lg-12">
            <!-- <h3 class="page-header"><i class="fa fa-laptop"></i> Dashboard</h3> -->
            <ol class="breadcrumb">
              <li><b><i class="icon_tag_alt"></i>Tag Data Punch</b> 
              <%
					if (request.getParameter("error") != null) {
				%> <strong style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;<%=request.getParameter("error")%></strong> 
				<%
 				} 
 				%> 
              </li>
              <%
              if(dept_idlog==18 || dept_idlog==31){
              %>
    		  <li> 
    		  <span id="excelExp">Excel 
    		  <img alt="#" src="img/excel_export.png" title="Click to download SAP Import Excel" style="cursor:pointer; height: 22px;" onclick="DownloadExcel(0)"> 
    		  </span> 
    		  &nbsp;|&nbsp; 
    		  <span id="excelExp_Extra">Sheet
    		  <img alt="#" src="img/excel_export.png" title="Click to download SAP Import Excel Extra Sheet" style="cursor:pointer; height: 22px;" onclick="DownloadExcel_Extra(1)"> 
    		  </span>
    		  </li>
			<%
              }
 			%>
 			&nbsp;|&nbsp;
 			<a href="Stock_Taking_Count.jsp" style="font-weight: bold;">Refresh</a> 
 			&nbsp;|&nbsp;
 			<li> 
 			  &nbsp;|&nbsp;
    		  <span id="getcheckUpload">Upload 
    		  <img alt="#" src="img/excel_export.png" title="Click to download SAP Import Excel" style="cursor:pointer; height: 22px;" onclick="Download_getChecked(0)"> 
    		  </span>
    		  &nbsp;|&nbsp; 
    		  <span id="getcheckUpload_Extra"> Upload Extra
    		  <img alt="#" src="img/excel_export.png" title="Click to download SAP Import Excel Extra Sheet" style="cursor:pointer; height: 22px;" onclick="Download_getCheckedExtra(1)"> 
    		  </span>
    		  &nbsp;|&nbsp;
    		  <span id="getcheckUploadAll">All Uploads
    		  <img alt="#" src="img/excel_export.png" title="Click to download SAP Import Excel" style="cursor:pointer; height: 22px;" onclick="Download_getCheckedAll(0)"> 
    		  </span>
    		  &nbsp;|&nbsp; 
    		  <span id="getcheckUpload_ExtraAll">All Upload Extra
    		  <img alt="#" src="img/excel_export.png" title="Click to download SAP Import Excel Extra Sheet" style="cursor:pointer; height: 22px;" onclick="Download_getCheckedExtraAll(1)"> 
    		  </span>
    		</li>
<!--  ***************************************************************************************************************  -->
<!--  ************************************************* Modals ******************************************************  --> 		
  	         </ol>
          </div>
        </div> 
				      
<!-- ********************************************************************************************************************* -->
<!-- ************************************ Tiles to Display**************************************************************** -->
	<div class="row">
          <div class="col-lg-12">
            <section class="panel">
               <div class="panel-body">
                <div class="form"> 
                
                <div style="float: left;width: 60%;">
<table class="gridtable" width="100%"> 
<tr>
 <th>Data Entry Plant</th>
  <th>Stock Type</th>
 <th>Data Entry User Name</th>
 <th>Extra</th>
 <th>Multi Code</th>
 <th>Batch</th>
</tr>
<tr style="height: 30px;">
 	<td>
 	<input type="hidden" name="fiscal" id="fiscal" value="<%=year%>">
 	<select name="data_entryPLant" id="data_entryPLant" class="form-control" onchange="getStorageLocation(this.value)" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<option value="">- - Select - -</option>
	 	<%
	 	String selectPlant = "";
	 	if(dept_idlog==18 || dept_idlog==31){
	 		ps_check = con.prepareStatement("SELECT plant FROM stocktaking_company where enable=1");
	        rs_check = ps_check.executeQuery();
	        while(rs_check.next()){
	        %>
	        <option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("plant") %></option>
	        <%
	        }
	 	}else{
	 	int pcnt=0;
        ps_check = con.prepareStatement("SELECT plant FROM stocktaking_dataEntry_opr where enable=1 and u_id="+uid);
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        	if(pcnt==0){
        		selectPlant=rs_check.getString("plant");
        		pcnt++;
        	}
        %>
        <option value="<%=rs_check.getString("plant") %>"><%=rs_check.getString("plant") %></option>
        <%
        }
	 	}
        %>
	</select> 
 	</td>
 	<td>
 	<select name="stockType" id="stockType" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	<%
 	ps_check = con.prepareStatement("select * FROM stocktaking_stocktype where enable=1 and id!=4");
    rs_check = ps_check.executeQuery();
    while(rs_check.next()){
    %>
    <option value="<%=rs_check.getInt("id")%>"><%=rs_check.getString("stock_type") %></option>
    <% 
   	}
 	%>
 	</select>
 	</td>
	<td style="background-color: #F2E89D;"><b><%=username %></b></td>
	<td align="center">
	<input type="checkbox" name="extra_check" id="extra_check" value="0" onclick="alterValidation()">
	<input type="hidden" name="extra_select" id="extra_select" value="0">
	</td>
	<td align="center">
	<input type="checkbox" name="multiCode_check" id="multiCode_check" value="1" onclick="alterValidation()">
	<input type="hidden" name="multiCode_select" id="multiCode_select" value="0">
	</td>
	<td align="center">
	<input type="checkbox" name="batch_check" id="batch_check" value="2" onclick="alterValidation()">
	<input type="hidden" name="batch_select" id="batch_select" value="0">
	</td>
</tr>
</table>

<table class="gridtable" width="100%"> 
<tr>
 <th>Storage Location</th>
  <th>Material Type</th> 
 <th>Physical Location</th>
 </tr>
 <tr style="height: 30px;">
 <td>
 	<span id="getLoc">
 	<select name="store_loc" id="store_loc" onchange="getphysical_Location(this.value)" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<%
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_storageLocation where enable=1 and plant='"+selectPlant+"'");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getInt("id") %>"><%=rs_check.getString("storage_location") %> - <%=rs_check.getString("storage_locationDesc") %></option>
        <%
        }
        %>
	</select>
	</span>
 	</td>
 	<td>
 	<select name="mat_type" id="mat_type"  class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	 	<%
        ps_check = con.prepareStatement("SELECT * FROM stocktaking_mattype where enable=1");
        rs_check = ps_check.executeQuery();
        while(rs_check.next()){
        %>
        <option value="<%=rs_check.getString("mat_type") %>"><%=rs_check.getString("mat_type") %> - <%=rs_check.getString("mat_typeDescr") %></option>
        <%
        }
        %>
	</select>
 	</td>
 	<td>
 	<span id="getPHYLoc">
 	<select name="phy_location" id="phy_location" onchange="getphy_audit(this.value)" class="form-control" style="font-weight:bold; font-size: 12px !important;height: 30px !important;color: black;text-align: left !important;" required>
	</select>
 	</span>
 	</td>
 </tr>
 </table>
 <span id="getPHYAuditLoc">
 <table class="gridtable" width="100%"> 
 <tr>
 <th>Location Owner Name</th>
 <th>Location Auditor Name</th> 
 </tr>
  <tr style="height: 30px;">
 	<td></td>
 	<td></td> 
 </tr>
</table> 
</span>
<table class="gridtable" width="100%"> 
<tr>
 <th id="sno_head">S.No</th>
 <th id="materialSearch_head" style="display: none;">Material Search</th>
 <th id="batchId_head" style="display: none;">Batch No (If Any)</th>
 <th>Entry Qty</th>
 <th>Tag No</th>
 <th>Add</th>
</tr>
<tr style="height: 30px;">
 	<td id="sno_value"><input type="text" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*?)\..*/g, '$1');" onkeyup="getDataSummary(this.value)" name="sno" id="sno" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td  id="materialSearch_value" style="display: none;">	
		<span id="getCode">
		<input type="hidden" name="MtCode" id="MtCode" value="">
		<input class="form-control" style="font-weight: bold;color: black;font-size: 12px;" id="material_search" name="material_search" minlength="1000"
       		   onkeypress="return checkQuote();" onkeyup="GetmatDetails(this.value)" type="text" required />
       	</span>	   
    </td>
 	<td id="batchId_row" style="display: none;"><input type="text" class="form-control" name="batchNo" id="batchNo"  style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*?)\..*/g, '$1');" name="entry_qty" id="entry_qty" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td><input type="text" oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*?)\..*/g, '$1');" name="tag_no" id="tag_no" class="form-control" style="color: black;font-size: 12px;font-weight: bold;"></td>
 	<td>
 	<input type="button" value="ADD TAG" name="submit_tag" id="submit_tag" onclick="upload_Tag()" class="btn-primary" style="height: 30px;font-weight: bold;">
 	</td>
</tr>
</table>
<span id="summCode"></span>
<span id="getMaterialData"></span>
</div>

<div style="float: right;width: 39.8%;overflow: scroll;height: 500px;">
<span id="tagUpload">
 <table class="gridtable" width="100%">
 <tr>
 <th>S.No</th>
 <th>Batch No (If Any)</th>
 <th>Entry Qty</th>
 <th>Tag No</th> 
 <th>Action</th>
</tr>
</table> 
</span>         
   </div>
   </div> 
      </div>
       </section>
        </div>
          </div>
        
        
        
        <!-- project team & activity end -->

      </section> 
    </section>
    
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
  <<script src="js/fullcalendar.min.js"></script>
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