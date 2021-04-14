package com.facilitytracker.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.util.JRLoader;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.StockTaking_VO;

@WebServlet("/Stock_TakingCheck_Control")
public class Stock_TakingCheck_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			StockTaking_VO vo = new StockTaking_VO(); 
			vo.setFiscal_year(Integer.valueOf(request.getParameter("fiscal_year")));
			vo.setComp_id(request.getParameter("company"));
			vo.setImportfor(request.getParameter("import_for"));
			vo.setStock_typeID(Integer.valueOf(request.getParameter("stock_type")));
			Connection con = Connection_Util.getConnectionMaster();
			int ct =0;
			String stocktype="";
			
			PreparedStatement ps_check = con.prepareStatement("SELECT *  FROM stocktaking_stocktype where enable=1 and id="+vo.getStock_typeID());
			ResultSet rs_check = ps_check.executeQuery();
		    while(rs_check.next()){
		    	stocktype = rs_check.getString("stock_type");
		    } 
			
			
			ps_check = con.prepareStatement("SELECT * from stocktaking_attachments where enable=1 and  plant='"+vo.getComp_id()+"' and storage_loc='" +vo.getImportfor()+"' and fiscal_year='" +vo.getFiscal_year()+"' and stocktype_desc='"+stocktype+"'");
			rs_check = ps_check.executeQuery();
			while (rs_check.next()) {
				ct=rs_check.getInt("id");
			}
			
			File folder = new File("C:/reportxls");
			File[] listOfFiles = folder.listFiles();
			String listname = "";
			 int val = listOfFiles.length + 1;
			
			String path =  vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_"+ val + ".pdf";
			String p4= "A4"+ vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_"+  val + ".pdf";	
			String p=  "A3_"+vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_" + val + ".pdf";
    		String p1= "A4_"+ vo.getComp_id() +"_"+ vo.getImportfor() + "_" +stocktype+ "_"+  val + ".pdf";
				
				Map parameters = new HashMap();
				parameters.put("plant", vo.getComp_id());
				parameters.put("storageLoc", vo.getImportfor());			
				parameters.put("fiscal_year", vo.getFiscal_year());
				parameters.put("stocktype", stocktype);
				 
		         
		     	JasperReport jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Stock_Taking.jrxml"); 
				JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
				JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+path);
				
				
				
				jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Extra_A4.jrxml"); 
				jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
				JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+p1);
				
				jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Extra_A3.jrxml"); 
				jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
				JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+p);  
				
				jasperReport = JasperCompileManager.compileReport("C:/reportxls/Report/Stock_Taking_A4.jrxml"); 
				jasperPrint = JasperFillManager.fillReport(jasperReport,parameters, con);
				JasperExportManager.exportReportToPdfFile(jasperPrint, "C:/reportxls/"+p4);  
		
			response.sendRedirect("Stock_Taking_log.jsp?path="+path+"&comp="+vo.getComp_id()+"&str="+vo.getImportfor() +"&fiscal="+vo.getFiscal_year()+ "&ct="+ct+ "&p3="+p + "&p4="+p1+ "&a4="+p4+"&st="+stocktype);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
