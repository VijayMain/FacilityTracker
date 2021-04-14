package com.facilitytracker.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.dao.Facility_DAO;
import com.facilitytracker.vo.Facility_VO;
 
@WebServlet("/Generate_ReportControl")
public class Generate_ReportControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 try {
			 
			 String from="",to="";
			 int company=0,priority=0,facility=0,resp_dept=0;
			 Facility_VO vo = new Facility_VO();
			 Facility_DAO dao =new Facility_DAO();
			 HttpSession session = request.getSession();
			 SimpleDateFormat sdf1 = new SimpleDateFormat("MM/dd/yyyy");
			 from = request.getParameter("fromdate");
			 to = request.getParameter("todate");
			 company = Integer.valueOf(request.getParameter("company"));
			 priority = Integer.valueOf(request.getParameter("priority"));
			 facility = Integer.valueOf(request.getParameter("facility"));
			 resp_dept = Integer.valueOf(request.getParameter("resp_dept")); 
			 Connection con = Connection_Util.getLocalUserConnection();  
			 java.util.Date datefrom = sdf1.parse(from);
			 java.sql.Date sqlStartDate = new java.sql.Date(datefrom.getTime());
			 java.util.Date dateto = sdf1.parse(to);
			 java.sql.Date sqlEndDate = new java.sql.Date(dateto.getTime()); 
			 Timestamp timeStampfromDate = new Timestamp(sqlStartDate.getTime());
			 Timestamp timeStamptodate= new Timestamp(sqlEndDate.getTime()); 
			 timeStamptodate.setHours(23);
			   
			 
			 vo.setFromDate(timeStampfromDate);
			 vo.setToDate(timeStamptodate);
			 vo.setCompany(company);
			 vo.setPriority(priority);
			 vo.setFacility_for(facility);
			 vo.setResp_dept(resp_dept);
			 
			 dao.getReport(vo,session,request,response);
			 
			 
		} catch (Exception e) {
			// TODO: handle exception
		}
	} 
}