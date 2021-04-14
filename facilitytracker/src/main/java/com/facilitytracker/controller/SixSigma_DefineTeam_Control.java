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

@WebServlet("/SixSigma_DefineTeam_Control")
public class SixSigma_DefineTeam_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
			SixSigma_PhaseDAO dao = new SixSigma_PhaseDAO();
			HttpSession session = request.getSession(); 
			
			vo.setProblem_id(Integer.valueOf(request.getParameter("hid_problemID"))); 
			vo.setTeam_user(Integer.valueOf(request.getParameter("team_user")));
			vo.setPhaseID(Integer.valueOf(request.getParameter("hid_namePhase")));
			dao.defineTeam_Members(vo, response, session);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}