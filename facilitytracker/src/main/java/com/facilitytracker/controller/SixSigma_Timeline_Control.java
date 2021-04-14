package com.facilitytracker.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.facilitytracker.dao.SixSigma_PhaseDAO;
import com.facilitytracker.vo.SixSigma_ProblemVO;

@WebServlet("/SixSigma_Timeline_Control")
public class SixSigma_Timeline_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
			SixSigma_PhaseDAO dao = new SixSigma_PhaseDAO();
			HttpSession session = request.getSession();
			//  def_probID   namePhase   approval_date    input_value
			
			vo.setProblem_id(Integer.valueOf(request.getParameter("def_probID"))); 
			vo.setNamePhase(Integer.valueOf(request.getParameter("namePhase")));
			vo.setApproval_date(request.getParameter("approval_date"));
			vo.setInput_value(Integer.valueOf(request.getParameter("input_value")));  
			vo.setLogScore(Integer.valueOf(request.getParameter("logScore")));
			
			dao.phaseValueUpdate(vo, response, session);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
