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

@WebServlet("/SixSigma_defineControl")
public class SixSigma_defineControl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			SixSigma_ProblemVO vo = new SixSigma_ProblemVO();
			SixSigma_PhaseDAO dao = new SixSigma_PhaseDAO();
			HttpSession session = request.getSession();
			// classProject impact_intCust impact_extCust dataAnalysis crossfun_rate
			// exp_Saving baselinePPM targetPPM baseline target_baseline

			vo.setProblem_id(Integer.valueOf(request.getParameter("prob_id")));
			
			vo.setClassProject(Integer.valueOf(request.getParameter("classProject")));
			vo.setImpact_intCust(Integer.valueOf(request.getParameter("impact_intCust")));
			vo.setImpact_extCust(Integer.valueOf(request.getParameter("impact_extCust")));
			vo.setDataAnalysis(Integer.valueOf(request.getParameter("dataAnalysis")));
			vo.setCrossfun_rate(Integer.valueOf(request.getParameter("crossfun_rate"))); 
			vo.setExp_Saving(Float.valueOf(request.getParameter("exp_Saving"))); 
			if(request.getParameter("baselinePPM")!=""){
			vo.setBaselinePPM(Float.valueOf(request.getParameter("baselinePPM")));
			}
			if(request.getParameter("targetPPM")!=""){
			vo.setTargetPPM(Float.valueOf(request.getParameter("targetPPM")));
			}
			if(request.getParameter("baseline")!=""){
			vo.setBaseline(request.getParameter("baseline"));
			}
			if(request.getParameter("target_baseline")!=""){
			vo.setTarget_baseline(request.getParameter("target_baseline"));
			}
			if(request.getParameter("myHid")!=""){
			vo.setProject_score(Float.valueOf(request.getParameter("myHid")));
			}
			if(request.getParameter("rateDefine")!=""){
				vo.setRateDefine(request.getParameter("rateDefine"));
			} 
			
			dao.phaseDataUpdate(vo, response, session);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
