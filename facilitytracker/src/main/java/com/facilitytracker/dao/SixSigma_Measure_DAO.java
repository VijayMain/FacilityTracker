package com.facilitytracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.vo.SixSigma_ProblemVO;

public class SixSigma_Measure_DAO {

	public void measureDetails(HttpSession session, SixSigma_ProblemVO vo,
			HttpServletResponse response) {
		try {
			boolean flag = false;
			SendMail_DAO sendMail = new SendMail_DAO();
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString(), status = "";
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			int up =0;
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");

			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis = System.currentTimeMillis();
			java.sql.Date todaysdate = new java.sql.Date(millis);
			PreparedStatement ps_data1 = null;
			ResultSet rs_data1 = null;
			// *******************************************************************************************************************************************************************
			ArrayList toolsUsed = new ArrayList();
			for (int i = 1; i <= vo.getMeasureCnt(); i++) {
				if (session.getAttribute("tools" + i) != null) {
					toolsUsed.add(session.getAttribute("tools" + i).toString());
					session.removeAttribute("tools" + i);
				}
			}
			String[] months = new DateFormatSymbols().getMonths();
			String monthmaxRej = months[vo.getMonth_maxRejection()].toString();
			String monthminRej = months[vo.getMonth_minRejection()].toString();

			if(vo.getEditMeasure()!=1){
			PreparedStatement ps_data = con_master.prepareStatement("insert into rel_pt_measurePhase"
							+ "(problem_id,phase_id,scientific_reason,problem_lastManProcess,problem_processStages,month_minRejection,month_mincnt,"
							+ "year_mincnt,month_maxRejection,month_maxcnt,year_maxcnt,min_rejectPPM,max_rejectPPM,no_machinesUsed,no_streams,"
							+ "response,specification,abnormal_equipmentCond,abnormal_processParameters,rejection_trnd6Month,concentration_chart,"
							+ "measureVariation_studyreq,enable,created_by,created_date,changed_by,changed_date,abnormal_eqCond_fileName,abnormal_eqCond_attach,"
							+ "abnormal_processPara_filename,abnormal_processPara_attach,rejection_trnd6Month_fileName,rejection_trnd6Month_attach,"
							+ "concentration_chart_filename,concentration_chart_attach,measureVar_studyreq_filename,measureVar_studyreq_attach) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_data.setInt(1, vo.getProblem_id());
			ps_data.setInt(2, vo.getPhaseID());
			ps_data.setString(3, vo.getScientific_reason());
			ps_data.setString(4, vo.getProblem_lastManProcess());
			ps_data.setString(5, vo.getProblem_processStages());
			ps_data.setString(6, monthminRej + " " + vo.getYear_minRejection());
			ps_data.setInt(7, vo.getMonth_minRejection());
			ps_data.setInt(8, vo.getYear_minRejection());
			ps_data.setString(9, monthmaxRej + " " + vo.getYear_maxRejection());
			ps_data.setInt(10, vo.getMonth_maxRejection());
			ps_data.setInt(11, vo.getYear_maxRejection());
			ps_data.setInt(12, vo.getMin_rejectPPM());
			ps_data.setInt(13, vo.getMax_rejectPPM());
			ps_data.setInt(14, vo.getNo_machinesUsed());
			ps_data.setInt(15, vo.getNo_streams());
			ps_data.setInt(16, vo.getResponse());
			ps_data.setString(17, vo.getSpecification());
			ps_data.setInt(18, vo.getAbnormal_equipmentCond());
			ps_data.setInt(19, vo.getAbnormal_processParameters());
			ps_data.setInt(20, vo.getRejection_trnd6Month());
			ps_data.setInt(21, vo.getConcentration_chart());
			ps_data.setInt(22, vo.getMeasureVariation_studyreq());
			ps_data.setInt(23, 1);
			ps_data.setInt(24, uid);
			ps_data.setTimestamp(25, timeStamp);
			ps_data.setInt(26, uid);
			ps_data.setTimestamp(27, timeStamp);
			
			ps_data.setString(28, vo.getAbnormal_eqCond_fileName());
			ps_data.setBlob(29, vo.getAbnormal_eqCond_attach());
			ps_data.setString(30, vo.getAbnormal_processPara_filename());
			ps_data.setBlob(31, vo.getAbnormal_processPara_attach());
			ps_data.setString(32, vo.getRejection_trnd6Month_fileName());
			ps_data.setBlob(33, vo.getRejection_trnd6Month_attach());
			ps_data.setString(34, vo.getConcentration_chart_filename());
			ps_data.setBlob(35, vo.getConcentration_chart_attach());
			ps_data.setString(36, vo.getMeasureVar_studyreq_filename());
			ps_data.setBlob(37, vo.getMeasureVar_studyreq_attach());

			up = ps_data.executeUpdate();

			int measureID = 0;
			ps_data = con_master.prepareStatement("select max(id) as cnt from rel_pt_measurePhase");
			ResultSet rs_data = ps_data.executeQuery();
			while (rs_data.next()) {
				measureID = rs_data.getInt("cnt");
			}

			for (int i = 0; i < toolsUsed.size(); i++) {
				ps_data = con_master.prepareStatement("insert into rel_pt_measurePhase_tools"
				+ "(measurePhase_id,tools_used_id,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?)");
				ps_data.setInt(1, measureID);
				ps_data.setInt(2, Integer.valueOf(toolsUsed.get(i).toString()));
				ps_data.setInt(3, 1);
				ps_data.setInt(4, uid);
				ps_data.setTimestamp(5, timeStamp);
				ps_data.setInt(6, uid);
				ps_data.setTimestamp(7, timeStamp);
				up = ps_data.executeUpdate();
			}
			}else{
				// Update history 
				PreparedStatement ps_data = con_master.prepareStatement("select * from rel_pt_measurePhase where enable=1 and problem_id="+vo.getProblem_id()+" and phase_id="+vo.getPhaseID());
				ResultSet rs_data = ps_data.executeQuery();
				while (rs_data.next()) {
			ps_data1 = con_master.prepareStatement("insert into rel_pt_measurePhase_hist"
							+ "(problem_id,phase_id,scientific_reason,problem_lastManProcess,problem_processStages,month_minRejection,month_mincnt,"
							+ "year_mincnt,month_maxRejection,month_maxcnt,year_maxcnt,min_rejectPPM,max_rejectPPM,no_machinesUsed,no_streams,"
							+ "response,specification,abnormal_equipmentCond,abnormal_processParameters,rejection_trnd6Month,concentration_chart,"
							+ "measureVariation_studyreq,enable,created_by,created_date,changed_by,changed_date,abnormal_eqCond_fileName,abnormal_eqCond_attach,"
							+ "abnormal_processPara_filename,abnormal_processPara_attach,rejection_trnd6Month_fileName,rejection_trnd6Month_attach,"
							+ "concentration_chart_filename,concentration_chart_attach,measureVar_studyreq_filename,measureVar_studyreq_attach,changed_hisby,changed_hisdate) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps_data1.setInt(1,rs_data.getInt("problem_id"));
			ps_data1.setInt(2,rs_data.getInt("phase_id"));
			ps_data1.setString(3,rs_data.getString("scientific_reason"));
			ps_data1.setString(4,rs_data.getString("problem_lastManProcess"));
			ps_data1.setString(5,rs_data.getString("problem_processStages"));
			ps_data1.setString(6,rs_data.getString("month_minRejection"));
			ps_data1.setInt(7,rs_data.getInt("month_mincnt"));
			ps_data1.setInt(8,rs_data.getInt("year_mincnt"));
			ps_data1.setString(9,rs_data.getString("month_maxRejection"));
			ps_data1.setInt(10,rs_data.getInt("month_maxcnt"));
			ps_data1.setInt(11,rs_data.getInt("year_maxcnt"));
			ps_data1.setInt(12,rs_data.getInt("min_rejectPPM"));
			ps_data1.setInt(13,rs_data.getInt("max_rejectPPM"));
			ps_data1.setInt(14,rs_data.getInt("no_machinesUsed"));
			ps_data1.setInt(15,rs_data.getInt("no_streams"));
			ps_data1.setInt(16,rs_data.getInt("response"));
			ps_data1.setString(17,rs_data.getString("specification"));
			ps_data1.setInt(18,rs_data.getInt("abnormal_equipmentCond"));
			ps_data1.setInt(19,rs_data.getInt("abnormal_processParameters"));
			ps_data1.setInt(20,rs_data.getInt("rejection_trnd6Month"));
			ps_data1.setInt(21,rs_data.getInt("concentration_chart"));
			ps_data1.setInt(22,rs_data.getInt("measureVariation_studyreq"));
			ps_data1.setInt(23,rs_data.getInt("enable"));
			ps_data1.setInt(24,rs_data.getInt("created_by"));
			ps_data1.setTimestamp(25,rs_data.getTimestamp("created_date"));
			ps_data1.setInt(26,rs_data.getInt("changed_by"));
			ps_data1.setTimestamp(27,rs_data.getTimestamp("changed_date"));
			
			ps_data1.setString(28,rs_data.getString("abnormal_eqCond_fileName"));
			ps_data1.setBlob(29,rs_data.getBlob("abnormal_eqCond_attach"));
			ps_data1.setString(30,rs_data.getString("abnormal_processPara_filename"));
			ps_data1.setBlob(31,rs_data.getBlob("abnormal_processPara_attach"));
			ps_data1.setString(32,rs_data.getString("rejection_trnd6Month_fileName"));
			ps_data1.setBlob(33,rs_data.getBlob("rejection_trnd6Month_attach"));
			ps_data1.setString(34,rs_data.getString("concentration_chart_filename"));
			ps_data1.setBlob(35,rs_data.getBlob("concentration_chart_attach"));
			ps_data1.setString(36,rs_data.getString("measureVar_studyreq_filename"));
			ps_data1.setBlob(37,rs_data.getBlob("measureVar_studyreq_attach"));
			ps_data1.setInt(38, uid);
			ps_data1.setTimestamp(39, timeStamp);
			
			up = ps_data1.executeUpdate();
			}
			
				ps_data1 = con_master.prepareStatement("select * from rel_pt_measurePhase_tools where enable=1 and measurePhase_id=" + vo.getMeasureID());
				rs_data1 = ps_data1.executeQuery();
				while (rs_data1.next()) {
						ps_data = con_master.prepareStatement("insert into rel_pt_measurePhase_tools_hist"
								+ "(measurePhase_id,tools_used_id,enable,created_by,created_date,changed_by,changed_date,changed_hisby,changed_hisdate) values(?,?,?,?,?,?,?,?,?)");
						ps_data.setInt(1, rs_data1.getInt("measurePhase_id"));
						ps_data.setInt(2, rs_data1.getInt("tools_used_id"));
						ps_data.setInt(3, rs_data1.getInt("enable"));
						ps_data.setInt(4, rs_data1.getInt("created_by"));
						ps_data.setTimestamp(5, rs_data1.getTimestamp("created_date"));
						ps_data.setInt(6, rs_data1.getInt("changed_by"));
						ps_data.setTimestamp(7, rs_data1.getTimestamp("changed_date")); 
						ps_data.setInt(8, uid);
						ps_data.setTimestamp(9, timeStamp);
						up = ps_data.executeUpdate();
				}
				for (int i = 0; i < toolsUsed.size(); i++) {
				ps_data = con_master.prepareStatement("insert into rel_pt_measurePhase_tools"
						+ "(measurePhase_id,tools_used_id,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?)");
						ps_data.setInt(1, vo.getMeasureID());
						ps_data.setInt(2, Integer.valueOf(toolsUsed.get(i).toString()));
						ps_data.setInt(3, 1);
						ps_data.setInt(4, uid);
						ps_data.setTimestamp(5, timeStamp);
						ps_data.setInt(6, uid);
						ps_data.setTimestamp(7, timeStamp);
						up = ps_data.executeUpdate();	
				}
				
				
				
		ps_data = con_master.prepareStatement("update rel_pt_measurePhase"
						+ " set problem_id=?,phase_id=?,scientific_reason=?,problem_lastManProcess=?,problem_processStages=?,month_minRejection=?,month_mincnt=?,"
						+ "year_mincnt=?,month_maxRejection=?,month_maxcnt=?,year_maxcnt=?,min_rejectPPM=?,max_rejectPPM=?,no_machinesUsed=?,no_streams=?,"
						+ "response=?,specification=?,abnormal_equipmentCond=?,abnormal_processParameters=?,rejection_trnd6Month=?,concentration_chart=?,"
						+ "measureVariation_studyreq=?,enable=?,created_by=?,created_date=?,changed_by=?,changed_date=? where id="+vo.getMeasureID()); 						
		/*+ "abnormal_eqCond_fileName=?,abnormal_eqCond_attach=?,abnormal_processPara_filename=?,abnormal_processPara_attach=?,rejection_trnd6Month_fileName=?,rejection_trnd6Month_attach=?,"
		  + "concentration_chart_filename=?,concentration_chart_attach=?,measureVar_studyreq_filename=?,measureVar_studyreq_attach=? ");*/ 		
		ps_data.setInt(1, vo.getProblem_id());
		ps_data.setInt(2, vo.getPhaseID());
		ps_data.setString(3, vo.getScientific_reason());
		ps_data.setString(4, vo.getProblem_lastManProcess());
		ps_data.setString(5, vo.getProblem_processStages());
		ps_data.setString(6, monthminRej + " " + vo.getYear_minRejection());
		ps_data.setInt(7, vo.getMonth_minRejection());
		ps_data.setInt(8, vo.getYear_minRejection());
		ps_data.setString(9, monthmaxRej + " " + vo.getYear_maxRejection());
		ps_data.setInt(10, vo.getMonth_maxRejection());
		ps_data.setInt(11, vo.getYear_maxRejection());
		ps_data.setInt(12, vo.getMin_rejectPPM());
		ps_data.setInt(13, vo.getMax_rejectPPM());
		ps_data.setInt(14, vo.getNo_machinesUsed());
		ps_data.setInt(15, vo.getNo_streams());
		ps_data.setInt(16, vo.getResponse());
		ps_data.setString(17, vo.getSpecification());
		ps_data.setInt(18, vo.getAbnormal_equipmentCond());
		ps_data.setInt(19, vo.getAbnormal_processParameters());
		ps_data.setInt(20, vo.getRejection_trnd6Month());
		ps_data.setInt(21, vo.getConcentration_chart());
		ps_data.setInt(22, vo.getMeasureVariation_studyreq());
		ps_data.setInt(23, 1);
		ps_data.setInt(24, uid);
		ps_data.setTimestamp(25, timeStamp);
		ps_data.setInt(26, uid);
		ps_data.setTimestamp(27, timeStamp);
		
		/*ps_data.setString(28, vo.getAbnormal_eqCond_fileName());
		ps_data.setBlob(29, vo.getAbnormal_eqCond_attach());
		
		ps_data.setString(30, vo.getAbnormal_processPara_filename());
		ps_data.setBlob(31, vo.getAbnormal_processPara_attach());
		
		ps_data.setString(32, vo.getRejection_trnd6Month_fileName());
		ps_data.setBlob(33, vo.getRejection_trnd6Month_attach());
		
		ps_data.setString(34, vo.getConcentration_chart_filename());
		ps_data.setBlob(35, vo.getConcentration_chart_attach());
		
		ps_data.setString(36, vo.getMeasureVar_studyreq_filename());
		ps_data.setBlob(37, vo.getMeasureVar_studyreq_attach());*/

		up = ps_data.executeUpdate();
				
		if(!vo.getAbnormal_eqCond_fileName_flag().equalsIgnoreCase("avail")){
		ps_data = con_master.prepareStatement("update rel_pt_measurePhase"
				+ " set abnormal_eqCond_fileName=?,abnormal_eqCond_attach=?" + " where id="+vo.getMeasureID()); 		
		ps_data.setString(1, vo.getAbnormal_eqCond_fileName());
		ps_data.setBlob(2, vo.getAbnormal_eqCond_attach());		
		up = ps_data.executeUpdate();
		}
		
		if(!vo.getAbnormal_processPara_filename_flag().equalsIgnoreCase("avail")){
			ps_data = con_master.prepareStatement("update rel_pt_measurePhase"
					+ " set abnormal_processPara_filename=?,abnormal_processPara_attach=?" + " where id="+vo.getMeasureID()); 		
			ps_data.setString(1, vo.getAbnormal_processPara_filename());
			ps_data.setBlob(2, vo.getAbnormal_processPara_attach());	
			up = ps_data.executeUpdate();
		}
		
		if(!vo.getRejection_trnd6Month_fileName_flag().equalsIgnoreCase("avail")){
			ps_data = con_master.prepareStatement("update rel_pt_measurePhase"
					+ " set rejection_trnd6Month_fileName=?,rejection_trnd6Month_attach=?" + " where id="+vo.getMeasureID()); 		
			ps_data.setString(1, vo.getRejection_trnd6Month_fileName());
			ps_data.setBlob(2, vo.getRejection_trnd6Month_attach());
			up = ps_data.executeUpdate();
		} 
		if(!vo.getConcentration_chart_filename_flag().equalsIgnoreCase("avail")){
			ps_data = con_master.prepareStatement("update rel_pt_measurePhase"
					+ " set concentration_chart_filename=?,concentration_chart_attach=?" + " where id="+vo.getMeasureID());
			ps_data.setString(1, vo.getConcentration_chart_filename());
			ps_data.setBlob(2, vo.getConcentration_chart_attach());
			up = ps_data.executeUpdate();
		}
		if(!vo.getMeasureVar_studyreq_filename_flag().equalsIgnoreCase("avail")){
			ps_data = con_master.prepareStatement("update rel_pt_measurePhase"
					+ " set measureVar_studyreq_filename=?,measureVar_studyreq_attach=?" + " where id="+vo.getMeasureID());
			ps_data.setString(1, vo.getMeasureVar_studyreq_filename());
			ps_data.setBlob(2, vo.getMeasureVar_studyreq_attach());
			up = ps_data.executeUpdate();
		}
		 	
				
			}
			if (up > 0) {
				status = "Data upload success";
				response.sendRedirect("SixSigma_Measure_Data.jsp?success="
						+ status + "&problem_id=" + vo.getProblem_id());
			} else {
				status = "Issue Occurred...!";
				response.sendRedirect("SixSigma_Measure_Data.jsp?statusNop="
						+ status + "&problem_id=" + vo.getProblem_id());
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void analyzeDetails(HttpSession session, SixSigma_ProblemVO vo,
			HttpServletResponse response) {
		try {
			boolean flag = false;
			// SendMail_DAO sendMail = new SendMail_DAO();
			int up=1;
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			String emailUser = session.getAttribute("email_id").toString();
			String uname = session.getAttribute("username").toString(), status = "";
			Connection con = Connection_Util.getLocalUserConnection();
			Connection con_master = Connection_Util.getConnectionMaster();
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime().getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-YYYY");

			date = simpleDateFormat.parse(dt.toString() + " " + sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis = System.currentTimeMillis();
			java.sql.Date todaysdate = new java.sql.Date(millis);
			// *******************************************************************************************************************************************************************
			ArrayList pinpoint = new ArrayList();
			for (int i = 1; i <= vo.getMeasureCnt(); i++) {
				if (session.getAttribute("pinpoint" + i) != null) {
					pinpoint.add(session.getAttribute("pinpoint" + i).toString());
					session.removeAttribute("pinpoint" + i);
				}
			}
			PreparedStatement ps_data = con_master.prepareStatement("insert into rel_pt_analyzePhase_SSV"
					+ "(problem_id,phase_id,measurePhaseSSV_id,analyze_confirm_id,file_name,attachment,enable,created_by,created_date,changed_by,changed_date)values(?,?,?,?,?,?,?,?,?,?,?)");
			
			ps_data.setInt(1, vo.getMeasurePID());
			ps_data.setInt(2, vo.getMeasurePhaseID());
			ps_data.setInt(3, vo.getSsv_measure());
			ps_data.setInt(4, vo.getSsv_confirm());
			ps_data.setString(5, vo.getAnalyze_filename());
			ps_data.setBlob(6, vo.getAnalyze_attach());
			ps_data.setInt(7, 1);
			ps_data.setInt(8, uid); 
			ps_data.setTimestamp(9, timeStamp);
			ps_data.setInt(10, uid);
			ps_data.setTimestamp(11, timeStamp);
			
			up = ps_data.executeUpdate();

			int measureID = 0;
			ps_data = con_master.prepareStatement("select max(id) as cnt from rel_pt_analyzePhase_SSV where enable=1 and phase_id="+vo.getMeasurePhaseID()+" and problem_id="+vo.getMeasurePID());
			ResultSet rs_data = ps_data.executeQuery();
			while (rs_data.next()) {
				measureID = rs_data.getInt("cnt");
			}
			for (int i = 0; i < pinpoint.size(); i++) {
				ps_data = con_master.prepareStatement("insert into rel_pt_analyzePhaseTools_SSV"
								+ "(problem_id,analyzePhase_SSV_id,analyze_toolsUsed_id,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?)");
				ps_data.setInt(1, vo.getMeasurePID());
				ps_data.setInt(2, measureID);
				ps_data.setInt(3, Integer.valueOf(pinpoint.get(i).toString()));
				ps_data.setInt(4, 1);
				ps_data.setInt(5, uid);
				ps_data.setTimestamp(6, timeStamp);
				ps_data.setInt(7, uid);
				ps_data.setTimestamp(8, timeStamp);
				up = ps_data.executeUpdate();
			}

			if (up > 0) {
				status = "Data upload success";
				response.sendRedirect("SixSigma_Analyze_Data.jsp?success="+ status + "&problem_id=" + vo.getMeasurePID());
			} else {
				status = "Issue Occurred...!";
				response.sendRedirect("SixSigma_Analyze_Data.jsp?statusNop="+ status + "&problem_id=" + vo.getMeasurePID());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// *******************************************************************************************************************
	// *******************************************************************************************************************
	public void importDetails(HttpSession session, SixSigma_ProblemVO vo, HttpServletResponse response) {
		try {
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con_master = Connection_Util.getConnectionMaster();
			Connection con = Connection_Util.getLocalUserConnection();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
			String uNameResp="";
			int up=0;
			
			//System.out.println(vo.getHis_id() + " = " + vo.getAct_status() + " = " + vo.getAnalyze_filename());
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			 
			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis=System.currentTimeMillis();
		    java.sql.Date todaysdate=new java.sql.Date(millis); 
		     
			// *******************************************************************************************************************************************************************
			ArrayList improveAction = new ArrayList();
			for (int i = 1; i <= vo.getMeasureCnt(); i++) {
				if (session.getAttribute("pinpoint" + i) != null) {
					improveAction.add(session.getAttribute("pinpoint" + i).toString());
					session.removeAttribute("pinpoint" + i);
				}
			}
			ps_user = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+vo.getResponsibleUser());
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				uNameResp = rs_user.getString("u_name");
			}
			
			String queryLog ="",act_stat="";
			ps_user = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+vo.getAct_status());
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				act_stat=rs_user.getString("master_name");
			}
			  
			if(vo.getFlag_new().equalsIgnoreCase("new")){
			if(act_stat!="Completed"){
				queryLog = "insert into rel_pt_improvePhase_Causes"
					+ "(analyzeSSV_id,problem_id,improvement_action,image_name,image_attach,status_id,status_name,enable,created_by,created_date,changed_by,changed_date,resp_uid,resp_name)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			}else{
				queryLog = "insert into rel_pt_improvePhase_Causes"
						+ "(analyzeSSV_id,problem_id,improvement_action,image_name,image_attach,status_id,status_name,enable,created_by,created_date,changed_by,changed_date,resp_uid,resp_name,completion_date)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";	
			}
			 
			PreparedStatement ps_data = con_master.prepareStatement(queryLog);
			ps_data.setInt(1, vo.getSsv_measure());
			ps_data.setInt(2, vo.getMeasurePID()); 
			ps_data.setString(3, vo.getActionImprove());
			ps_data.setString(4, vo.getAnalyze_filename());
			ps_data.setBlob(5, vo.getAnalyze_attach());
			ps_data.setInt(6, vo.getAct_status()); 
			ps_data.setString(7, act_stat);
			ps_data.setInt(8, 1);
			ps_data.setInt(9, uid); 
			ps_data.setTimestamp(10, timeStamp);
			ps_data.setInt(11, uid);
			ps_data.setTimestamp(12, timeStamp); 
			ps_data.setInt(13, vo.getResponsibleUser());
			ps_data.setString(14, uNameResp);
			
			if(act_stat=="Completed"){
			ps_data.setTimestamp(15, timeStamp);
			}
			
			up = ps_data.executeUpdate();

			int improveID = 0;
			ps_data = con_master.prepareStatement("select max(id) as cnt from rel_pt_improvePhase_Causes where enable=1 and problem_id="+vo.getMeasurePID());
			ResultSet rs_data = ps_data.executeQuery();
			while (rs_data.next()) {
				improveID = rs_data.getInt("cnt");
			}
			for (int i = 0; i < improveAction.size(); i++) {
				ps_data = con_master.prepareStatement("insert into rel_pt_improvePhase_CausesAction"
								+ "(improvePhase_Causes_id,problem_id,actionType_id,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?)");
				ps_data.setInt(1, improveID);
				ps_data.setInt(2, vo.getMeasurePID());
				ps_data.setInt(3, Integer.valueOf(improveAction.get(i).toString()));
				ps_data.setInt(4, 1);
				ps_data.setInt(5, uid);
				ps_data.setTimestamp(6, timeStamp);
				ps_data.setInt(7, uid);
				ps_data.setTimestamp(8, timeStamp);
				up = ps_data.executeUpdate();
			}
			
			}else{
				ps_user = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+vo.getAct_status());
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
					act_stat=rs_user.getString("master_name");
				}
				
				if(!act_stat.equalsIgnoreCase("Completed")){
					queryLog = "UPDATE rel_pt_improvePhase_Causes SET status_id=?,status_name=?,changed_by=?,changed_date=? WHERE id="+vo.getHis_id();
				}else{
					queryLog = "UPDATE rel_pt_improvePhase_Causes SET status_id=?,status_name=?,changed_by=?,changed_date=?,completion_date=? WHERE id="+vo.getHis_id();
				}
				 ps_check = con_master.prepareStatement(queryLog);
				 ps_check.setInt(1, vo.getAct_status()); 
				 ps_check.setString(2, act_stat); 
				 ps_check.setInt(3, uid); 
				 ps_check.setTimestamp(4, timeStamp);
				
				 if(act_stat.equalsIgnoreCase("Completed")){
				 ps_check.setTimestamp(5, timeStamp);
				 }
				 
				 up = ps_check.executeUpdate();
				 
				 if(vo.getAnalyze_filename()!=""){
					 queryLog = "UPDATE rel_pt_improvePhase_Causes SET image_name=?,image_attach=? WHERE id="+vo.getHis_id();
					 ps_check = con_master.prepareStatement(queryLog);
					 ps_check.setString(1, vo.getAnalyze_filename());
					 ps_check.setBlob(2, vo.getAnalyze_attach()); 
					 
					 up = ps_check.executeUpdate();
				 }
				 
			}
			 
			String status="";

			
			if (up > 0) {
				status = "Data upload success";
				response.sendRedirect("SixSigma_Improve_Data.jsp?success="+ status + "&problem_id=" + vo.getMeasurePID());
			} else {
				status = "Issue Occurred...!";
				response.sendRedirect("SixSigma_Improve_Data.jsp?statusNop="+ status + "&problem_id=" + vo.getMeasurePID());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// *******************************************************************************************************************
	// *******************************************************************************************************************

	public void controlDetails(HttpSession session, SixSigma_ProblemVO vo, HttpServletResponse response) {
		try {
			int uid = Integer.valueOf(session.getAttribute("uid").toString());
			Connection con_master = Connection_Util.getConnectionMaster();
			Connection con = Connection_Util.getLocalUserConnection();
			PreparedStatement ps_user = null, ps_check = null;
			ResultSet rs_user = null, rs_check = null;
			String uNameResp="";
			int up=0;
			// *******************************************************************************************************************************************************************
			java.util.Date date = null;
			java.sql.Timestamp timeStamp = null;
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
			java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			 
			date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
			timeStamp = new java.sql.Timestamp(date.getTime());
			long millis=System.currentTimeMillis();
		    java.sql.Date todaysdate=new java.sql.Date(millis); 
			// *******************************************************************************************************************************************************************
			ArrayList improveAction = new ArrayList();
			for (int i = 1; i <= vo.getMeasureCnt(); i++) {
				if (session.getAttribute("pinpoint" + i) != null) {
					improveAction.add(session.getAttribute("pinpoint" + i).toString());
					session.removeAttribute("pinpoint" + i);
				}
			}
			ps_user = con.prepareStatement("SELECT u_name FROM user_tbl where u_id="+vo.getResponsibleUser());
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				uNameResp = rs_user.getString("u_name");
			}
			
			String queryLog ="",act_stat="";
			ps_user = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+vo.getAct_status());
			rs_user = ps_user.executeQuery();
			while(rs_user.next()){
				act_stat=rs_user.getString("master_name");
			}
			  // --------------- Control Phase Update ---------------------------------- 
			if(vo.getFlag_new().equalsIgnoreCase("new")){
			if(act_stat!="Completed"){
				queryLog = "insert into rel_pt_controlPhase_Causes(improveCause_id,problem_id,applicable_act,enable,created_by,created_date,changed_by,changed_date,resp_uid,resp_name,status_id,status_name,control_filename)values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			}else{
				queryLog = "insert into rel_pt_controlPhase_Causes(improveCause_id,problem_id,applicable_act,enable,created_by,created_date,changed_by,changed_date,resp_uid,resp_name,status_id,status_name,control_filename,completion_date)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			}
			
			PreparedStatement ps_data = con_master.prepareStatement(queryLog);
			ps_data.setInt(1, vo.getSsv_measure());
			ps_data.setInt(2, vo.getMeasurePID()); 
			ps_data.setInt(3, vo.getApplicable_act());
			ps_data.setInt(4, 1);
			ps_data.setInt(5, uid); 
			ps_data.setTimestamp(6, timeStamp);
			ps_data.setInt(7, uid);
			ps_data.setTimestamp(8, timeStamp); 
			ps_data.setInt(9, vo.getResponsibleUser());
			ps_data.setString(10, uNameResp);
			ps_data.setInt(11, vo.getAct_status()); 
			ps_data.setString(12, act_stat);
			ps_data.setString(13, vo.getAnalyze_filename());
			if(act_stat=="Completed"){
				ps_data.setTimestamp(14, timeStamp);
			}
			
			up = ps_data.executeUpdate();

			int improveID = 0;
			ps_data = con_master.prepareStatement("select max(id) as cnt from rel_pt_controlPhase_Causes where enable=1 and problem_id="+vo.getMeasurePID());
			ResultSet rs_data = ps_data.executeQuery();
			while (rs_data.next()) {
				improveID = rs_data.getInt("cnt");
			}
			for (int i = 0; i < improveAction.size(); i++) {
				ps_data = con_master.prepareStatement("insert into rel_pt_controlPhase_Causes_crtMethod"
								+ "(controlPhaseCauses_id,problem_id,control_method_id,enable,created_by,created_date,changed_by,changed_date) values(?,?,?,?,?,?,?,?)");
				ps_data.setInt(1, improveID);
				ps_data.setInt(2, vo.getMeasurePID());
				ps_data.setInt(3, Integer.valueOf(improveAction.get(i).toString()));
				ps_data.setInt(4, 1);
				ps_data.setInt(5, uid);
				ps_data.setTimestamp(6, timeStamp);
				ps_data.setInt(7, uid);
				ps_data.setTimestamp(8, timeStamp);
				up = ps_data.executeUpdate();
			}
			
			}else{
				
				
				
				ps_user = con_master.prepareStatement("select master_name from rel_pt_masterData where id="+vo.getAct_status());
				rs_user = ps_user.executeQuery();
				while(rs_user.next()){
					act_stat=rs_user.getString("master_name");
				}
				
				if(!act_stat.equalsIgnoreCase("Completed")){
					queryLog = "UPDATE rel_pt_controlPhase_Causes SET status_id=?,status_name=?,changed_by=?,changed_date=? WHERE id="+vo.getHis_id();
				}else{
					queryLog = "UPDATE rel_pt_controlPhase_Causes SET status_id=?,status_name=?,changed_by=?,changed_date=?,completion_date=? WHERE id="+vo.getHis_id();
				}
				 ps_check = con_master.prepareStatement(queryLog);
				 ps_check.setInt(1, vo.getAct_status()); 
				 ps_check.setString(2, act_stat); 
				 ps_check.setInt(3, uid); 
				 ps_check.setTimestamp(4, timeStamp);
				
				 if(act_stat.equalsIgnoreCase("Completed")){
				 ps_check.setTimestamp(5, timeStamp);
				 }
				 
				 up = ps_check.executeUpdate();
				 
				 if(vo.getAnalyze_filename()!=""){
					 queryLog = "UPDATE rel_pt_controlPhase_Causes SET control_filename=?,controlFile_attach=? WHERE id="+vo.getHis_id();
					 ps_check = con_master.prepareStatement(queryLog);
					 ps_check.setString(1, vo.getAnalyze_filename());
					 ps_check.setBlob(2, vo.getAnalyze_attach());
					 
					 up = ps_check.executeUpdate();
				 }
				
				
			}
			
			
			String status="";
			if (up > 0) {
				status = "Data upload success";
				response.sendRedirect("SixSigma_Control_Data.jsp?success="+ status + "&problem_id=" + vo.getMeasurePID());
			} else {
				status = "Issue Occurred...!";
				response.sendRedirect("SixSigma_Control_Data.jsp?statusNop="+ status + "&problem_id=" + vo.getMeasurePID());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ***********************************************************************************************************************
	// ***********************************************************************************************************************
	public void define_Attach(HttpSession session, SixSigma_ProblemVO vo,
			HttpServletResponse response) {
	try {
		int uid = Integer.valueOf(session.getAttribute("uid").toString());
		String uname = session.getAttribute("username").toString();
		Connection con_master = Connection_Util.getConnectionMaster();
		Connection con = Connection_Util.getLocalUserConnection();
		PreparedStatement ps_user = null, ps_check = null;
		ResultSet rs_user = null, rs_check = null;
		String uNameResp="";
		int up=0;
		
		// *******************************************************************************************************************************************************************
		java.util.Date date = null;
		java.sql.Timestamp timeStamp = null;
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		java.sql.Date dt = new java.sql.Date(calendar.getTimeInMillis());
		java.sql.Time sqlTime = new java.sql.Time(calendar.getTime()	.getTime());
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		SimpleDateFormat cellDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
		timeStamp = new java.sql.Timestamp(date.getTime());
		
		// *******************************************************************************************************************************************************************
		date = simpleDateFormat.parse(dt.toString() + " "	+ sqlTime.toString());
		timeStamp = new java.sql.Timestamp(date.getTime());
		long millis=System.currentTimeMillis();
	    java.sql.Date todaysdate=new java.sql.Date(millis);
	    // *******************************************************************************************************************************************************************
		
	    ps_check = con_master.prepareStatement("insert into rel_pt_definePhase_Attach"
	    		+ " (problem_id,phase_id,define_attach,define_attach_name,created_by,created_date,changed_by,changed_date,created_byName,enable) values(?,?,?,?,?,?,?,?,?,?)");
	    ps_check.setInt(1, vo.getProblem_id());
	    ps_check.setInt(2, vo.getDef_probID());
	    ps_check.setBlob(3, vo.getAnalyze_attach());
	    ps_check.setString(4, vo.getAnalyze_filename());
	    ps_check.setInt(5, uid);
	    ps_check.setTimestamp(6, timeStamp);
	    ps_check.setInt(7, uid);
	    ps_check.setTimestamp(8, timeStamp);
	    ps_check.setString(9, uname);
	    ps_check.setInt(10, 1);
	    up = ps_check.executeUpdate();
	    
	    String status="";
	    if(up>0){
			status = "Success";
			response.sendRedirect("SixSigma_Define_Charter.jsp?success="+status+"&problem_id="+vo.getProblem_id());
		}else{
			status = "Issue Occurred";
			response.sendRedirect("SixSigma_Define_Charter.jsp?statusNop="+status+"&problem_id="+vo.getProblem_id());
		}
	} catch (Exception e) {
	
	}
	// ***********************************************************************************************************************
	// ***********************************************************************************************************************
	}
}