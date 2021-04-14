package com.facilitytracker.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.dao.SixSigma_PhaseDAO;
import com.facilitytracker.vo.SixSigma_ProblemVO;

@WebServlet("/SixSigma_ResultControl")
public class SixSigma_ResultControl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
			SixSigma_PhaseDAO dao = new SixSigma_PhaseDAO();
			HttpSession session = request.getSession();  
			DecimalFormat format = new DecimalFormat("####");
			
			vo.setProblem_id(Integer.valueOf(request.getParameter("hid_problem_id"))); 
			vo.setPhaseID(Integer.valueOf(request.getParameter("hid_phase_id")));
			vo.setBasline_rejectionPPM(Integer.valueOf(request.getParameter("baseLineReject")));
			vo.setTargetted_rejectionPPM(Integer.valueOf(request.getParameter("baseLineReject_target"))); 
			
			vo.setActualPPMAcieved(Double.valueOf(request.getParameter("actualAchievedPPM"))); 
			vo.setExpectedSaving(Double.valueOf(request.getParameter("expectedSaving")));
			vo.setActualSaving(Double.valueOf(request.getParameter("actualSaving")));  
			vo.setControlDate(request.getParameter("controlDate"));
			 
			
			dao.resultUpload(vo, response, session);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}