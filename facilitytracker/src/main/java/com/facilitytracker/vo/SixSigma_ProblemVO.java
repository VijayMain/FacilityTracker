package com.facilitytracker.vo;

import java.io.InputStream;
import java.sql.Date;

public class SixSigma_ProblemVO {

	String plant = "", problem = "", product_descr = "", search_product = "",
			rateDefine = "", baseline = "", target_baseline = "",
			reasonPlan = "", findings = "", phasedata = "", approval_date = "",
			actionDetails = "", scientific_reason = "",
			problem_lastManProcess = "", problem_processStages = "",
			flag_new = "", import_completeDate = "", specification = "",
			rejection_trnd6Month_fileName = "",
			concentration_chart_filename = "", abnormal_eqCond_fileName = "",
			measureVar_studyreq_filename = "", actionImprove = "",
			abnormal_processPara_filename = "", analyze_filename = "",
			controlDate = "", measureVar_studyreq_filename_flag = "",
			concentration_chart_filename_flag = "",
			rejection_trnd6Month_fileName_flag = "",
			abnormal_processPara_filename_flag = "",
			abnormal_eqCond_fileName_flag = "";
	int problem_id = 0, def_probID = 0, mtCode = 0, dept = 0, typeProject = 0,
			classProject = 0, impact_intCust = 0, impact_extCust = 0,
			his_id = 0, input_value = 0, dataAnalysis = 0, crossfun_rate = 0,
			teamMember = 0, team_user = 0, phaseValue = 0, namePhase = 0,
			statusAction = 0, phaseID = 0, logScore = 0, editMeasure = 0,
			act_status = 0, measurePhaseID = 0, month_minRejection,
			year_minRejection, month_maxRejection, year_maxRejection,
			min_rejectPPM, max_rejectPPM, no_machinesUsed, no_streams,
			response, abnormal_equipmentCond, abnormal_processParameters,
			rejection_trnd6Month, concentration_chart,
			measureVariation_studyreq, measureCnt, measurePID, measureID = 0,
			responsibleUser = 0, ssv_measure = 0, ssv_confirm = 0,
			applicable_act = 0, basline_rejectionPPM = 0,
			targetted_rejectionPPM = 0, actual_achieved_PPM = 0,
			plan_savingRs = 0, actual_savingRs = 0;
	float exp_Saving = 0, baselinePPM = 0, targetPPM = 0, project_score = 0,
			reviewPRjID = 0, reviewPRj_phase = 0;
	Date reviewDate = null, targetDate = null, completeDate = null,
			confirm_completeDate = null;
	double expectedSaving = 0, actualSaving = 0, ActualPPMAcieved = 0;
	InputStream abnormal_eqCond_attach, abnormal_processPara_attach,
			rejection_trnd6Month_attach, concentration_chart_attach,
			measureVar_studyreq_attach, analyze_attach;

	public int getHis_id() {
		return his_id;
	}

	public void setHis_id(int his_id) {
		this.his_id = his_id;
	}

	public String getFlag_new() {
		return flag_new;
	}

	public void setFlag_new(String flag_new) {
		this.flag_new = flag_new;
	}

	public int getAct_status() {
		return act_status;
	}

	public void setAct_status(int act_status) {
		this.act_status = act_status;
	}

	public int getMeasureID() {
		return measureID;
	}

	public void setMeasureID(int measureID) {
		this.measureID = measureID;
	}

	public String getMeasureVar_studyreq_filename_flag() {
		return measureVar_studyreq_filename_flag;
	}

	public void setMeasureVar_studyreq_filename_flag(
			String measureVar_studyreq_filename_flag) {
		this.measureVar_studyreq_filename_flag = measureVar_studyreq_filename_flag;
	}

	public String getConcentration_chart_filename_flag() {
		return concentration_chart_filename_flag;
	}

	public void setConcentration_chart_filename_flag(
			String concentration_chart_filename_flag) {
		this.concentration_chart_filename_flag = concentration_chart_filename_flag;
	}

	public String getRejection_trnd6Month_fileName_flag() {
		return rejection_trnd6Month_fileName_flag;
	}

	public void setRejection_trnd6Month_fileName_flag(
			String rejection_trnd6Month_fileName_flag) {
		this.rejection_trnd6Month_fileName_flag = rejection_trnd6Month_fileName_flag;
	}

	public String getAbnormal_processPara_filename_flag() {
		return abnormal_processPara_filename_flag;
	}

	public void setAbnormal_processPara_filename_flag(
			String abnormal_processPara_filename_flag) {
		this.abnormal_processPara_filename_flag = abnormal_processPara_filename_flag;
	}

	public String getAbnormal_eqCond_fileName_flag() {
		return abnormal_eqCond_fileName_flag;
	}

	public void setAbnormal_eqCond_fileName_flag(
			String abnormal_eqCond_fileName_flag) {
		this.abnormal_eqCond_fileName_flag = abnormal_eqCond_fileName_flag;
	}

	public int getEditMeasure() {
		return editMeasure;
	}

	public void setEditMeasure(int editMeasure) {
		this.editMeasure = editMeasure;
	}

	public double getActualPPMAcieved() {
		return ActualPPMAcieved;
	}

	public void setActualPPMAcieved(double actualPPMAcieved) {
		ActualPPMAcieved = actualPPMAcieved;
	}

	public double getExpectedSaving() {
		return expectedSaving;
	}

	public double getActualSaving() {
		return actualSaving;
	}

	public void setExpectedSaving(double expectedSaving) {
		this.expectedSaving = expectedSaving;
	}

	public void setActualSaving(double actualSaving) {
		this.actualSaving = actualSaving;
	}

	public String getControlDate() {
		return controlDate;
	}

	public void setControlDate(String controlDate) {
		this.controlDate = controlDate;
	}

	public void setExpectedSaving(float expectedSaving) {
		this.expectedSaving = expectedSaving;
	}

	public void setActualSaving(float actualSaving) {
		this.actualSaving = actualSaving;
	}

	public int getBasline_rejectionPPM() {
		return basline_rejectionPPM;
	}

	public void setBasline_rejectionPPM(int basline_rejectionPPM) {
		this.basline_rejectionPPM = basline_rejectionPPM;
	}

	public int getTargetted_rejectionPPM() {
		return targetted_rejectionPPM;
	}

	public void setTargetted_rejectionPPM(int targetted_rejectionPPM) {
		this.targetted_rejectionPPM = targetted_rejectionPPM;
	}

	public int getActual_achieved_PPM() {
		return actual_achieved_PPM;
	}

	public void setActual_achieved_PPM(int actual_achieved_PPM) {
		this.actual_achieved_PPM = actual_achieved_PPM;
	}

	public int getPlan_savingRs() {
		return plan_savingRs;
	}

	public void setPlan_savingRs(int plan_savingRs) {
		this.plan_savingRs = plan_savingRs;
	}

	public int getActual_savingRs() {
		return actual_savingRs;
	}

	public void setActual_savingRs(int actual_savingRs) {
		this.actual_savingRs = actual_savingRs;
	}

	public int getApplicable_act() {
		return applicable_act;
	}

	public void setApplicable_act(int applicable_act) {
		this.applicable_act = applicable_act;
	}

	public String getImport_completeDate() {
		return import_completeDate;
	}

	public void setImport_completeDate(String import_completeDate) {
		this.import_completeDate = import_completeDate;
	}

	public String getActionImprove() {
		return actionImprove;
	}

	public void setActionImprove(String actionImprove) {
		this.actionImprove = actionImprove;
	}

	public int getResponsibleUser() {
		return responsibleUser;
	}

	public void setResponsibleUser(int responsibleUser) {
		this.responsibleUser = responsibleUser;
	}

	public Date getConfirm_completeDate() {
		return confirm_completeDate;
	}

	public void setConfirm_completeDate(Date confirm_completeDate) {
		this.confirm_completeDate = confirm_completeDate;
	}

	public InputStream getAnalyze_attach() {
		return analyze_attach;
	}

	public void setAnalyze_attach(InputStream analyze_attach) {
		this.analyze_attach = analyze_attach;
	}

	public int getMeasurePID() {
		return measurePID;
	}

	public void setMeasurePID(int measurePID) {
		this.measurePID = measurePID;
	}

	public int getMeasurePhaseID() {
		return measurePhaseID;
	}

	public void setMeasurePhaseID(int measurePhaseID) {
		this.measurePhaseID = measurePhaseID;
	}

	public int getSsv_measure() {
		return ssv_measure;
	}

	public void setSsv_measure(int ssv_measure) {
		this.ssv_measure = ssv_measure;
	}

	public int getSsv_confirm() {
		return ssv_confirm;
	}

	public void setSsv_confirm(int ssv_confirm) {
		this.ssv_confirm = ssv_confirm;
	}

	public String getAnalyze_filename() {
		return analyze_filename;
	}

	public void setAnalyze_filename(String analyze_filename) {
		this.analyze_filename = analyze_filename;
	}

	public InputStream getAbnormal_eqCond_attach() {
		return abnormal_eqCond_attach;
	}

	public void setAbnormal_eqCond_attach(InputStream abnormal_eqCond_attach) {
		this.abnormal_eqCond_attach = abnormal_eqCond_attach;
	}

	public InputStream getAbnormal_processPara_attach() {
		return abnormal_processPara_attach;
	}

	public void setAbnormal_processPara_attach(
			InputStream abnormal_processPara_attach) {
		this.abnormal_processPara_attach = abnormal_processPara_attach;
	}

	public InputStream getRejection_trnd6Month_attach() {
		return rejection_trnd6Month_attach;
	}

	public void setRejection_trnd6Month_attach(
			InputStream rejection_trnd6Month_attach) {
		this.rejection_trnd6Month_attach = rejection_trnd6Month_attach;
	}

	public InputStream getConcentration_chart_attach() {
		return concentration_chart_attach;
	}

	public void setConcentration_chart_attach(
			InputStream concentration_chart_attach) {
		this.concentration_chart_attach = concentration_chart_attach;
	}

	public InputStream getMeasureVar_studyreq_attach() {
		return measureVar_studyreq_attach;
	}

	public void setMeasureVar_studyreq_attach(
			InputStream measureVar_studyreq_attach) {
		this.measureVar_studyreq_attach = measureVar_studyreq_attach;
	}

	public String getAbnormal_eqCond_fileName() {
		return abnormal_eqCond_fileName;
	}

	public void setAbnormal_eqCond_fileName(String abnormal_eqCond_fileName) {
		this.abnormal_eqCond_fileName = abnormal_eqCond_fileName;
	}

	public String getAbnormal_processPara_filename() {
		return abnormal_processPara_filename;
	}

	public void setAbnormal_processPara_filename(
			String abnormal_processPara_filename) {
		this.abnormal_processPara_filename = abnormal_processPara_filename;
	}

	public String getScientific_reason() {
		return scientific_reason;
	}

	public void setScientific_reason(String scientific_reason) {
		this.scientific_reason = scientific_reason;
	}

	public String getProblem_lastManProcess() {
		return problem_lastManProcess;
	}

	public void setProblem_lastManProcess(String problem_lastManProcess) {
		this.problem_lastManProcess = problem_lastManProcess;
	}

	public String getProblem_processStages() {
		return problem_processStages;
	}

	public void setProblem_processStages(String problem_processStages) {
		this.problem_processStages = problem_processStages;
	}

	public String getSpecification() {
		return specification;
	}

	public void setSpecification(String specification) {
		this.specification = specification;
	}

	public String getRejection_trnd6Month_fileName() {
		return rejection_trnd6Month_fileName;
	}

	public void setRejection_trnd6Month_fileName(
			String rejection_trnd6Month_fileName) {
		this.rejection_trnd6Month_fileName = rejection_trnd6Month_fileName;
	}

	public String getConcentration_chart_filename() {
		return concentration_chart_filename;
	}

	public void setConcentration_chart_filename(
			String concentration_chart_filename) {
		this.concentration_chart_filename = concentration_chart_filename;
	}

	public String getMeasureVar_studyreq_filename() {
		return measureVar_studyreq_filename;
	}

	public void setMeasureVar_studyreq_filename(
			String measureVar_studyreq_filename) {
		this.measureVar_studyreq_filename = measureVar_studyreq_filename;
	}

	public int getMonth_minRejection() {
		return month_minRejection;
	}

	public void setMonth_minRejection(int month_minRejection) {
		this.month_minRejection = month_minRejection;
	}

	public int getYear_minRejection() {
		return year_minRejection;
	}

	public void setYear_minRejection(int year_minRejection) {
		this.year_minRejection = year_minRejection;
	}

	public int getMonth_maxRejection() {
		return month_maxRejection;
	}

	public void setMonth_maxRejection(int month_maxRejection) {
		this.month_maxRejection = month_maxRejection;
	}

	public int getYear_maxRejection() {
		return year_maxRejection;
	}

	public void setYear_maxRejection(int year_maxRejection) {
		this.year_maxRejection = year_maxRejection;
	}

	public int getMin_rejectPPM() {
		return min_rejectPPM;
	}

	public void setMin_rejectPPM(int min_rejectPPM) {
		this.min_rejectPPM = min_rejectPPM;
	}

	public int getMax_rejectPPM() {
		return max_rejectPPM;
	}

	public void setMax_rejectPPM(int max_rejectPPM) {
		this.max_rejectPPM = max_rejectPPM;
	}

	public int getNo_machinesUsed() {
		return no_machinesUsed;
	}

	public void setNo_machinesUsed(int no_machinesUsed) {
		this.no_machinesUsed = no_machinesUsed;
	}

	public int getNo_streams() {
		return no_streams;
	}

	public void setNo_streams(int no_streams) {
		this.no_streams = no_streams;
	}

	public int getResponse() {
		return response;
	}

	public void setResponse(int response) {
		this.response = response;
	}

	public int getAbnormal_equipmentCond() {
		return abnormal_equipmentCond;
	}

	public void setAbnormal_equipmentCond(int abnormal_equipmentCond) {
		this.abnormal_equipmentCond = abnormal_equipmentCond;
	}

	public int getAbnormal_processParameters() {
		return abnormal_processParameters;
	}

	public void setAbnormal_processParameters(int abnormal_processParameters) {
		this.abnormal_processParameters = abnormal_processParameters;
	}

	public int getRejection_trnd6Month() {
		return rejection_trnd6Month;
	}

	public void setRejection_trnd6Month(int rejection_trnd6Month) {
		this.rejection_trnd6Month = rejection_trnd6Month;
	}

	public int getConcentration_chart() {
		return concentration_chart;
	}

	public void setConcentration_chart(int concentration_chart) {
		this.concentration_chart = concentration_chart;
	}

	public int getMeasureVariation_studyreq() {
		return measureVariation_studyreq;
	}

	public void setMeasureVariation_studyreq(int measureVariation_studyreq) {
		this.measureVariation_studyreq = measureVariation_studyreq;
	}

	public int getMeasureCnt() {
		return measureCnt;
	}

	public void setMeasureCnt(int measureCnt) {
		this.measureCnt = measureCnt;
	}

	public int getLogScore() {
		return logScore;
	}

	public void setLogScore(int logScore) {
		this.logScore = logScore;
	}

	public int getPhaseID() {
		return phaseID;
	}

	public void setPhaseID(int phaseID) {
		this.phaseID = phaseID;
	}

	public String getReasonPlan() {
		return reasonPlan;
	}

	public void setReasonPlan(String reasonPlan) {
		this.reasonPlan = reasonPlan;
	}

	public String getFindings() {
		return findings;
	}

	public void setFindings(String findings) {
		this.findings = findings;
	}

	public String getActionDetails() {
		return actionDetails;
	}

	public void setActionDetails(String actionDetails) {
		this.actionDetails = actionDetails;
	}

	public int getTeamMember() {
		return teamMember;
	}

	public void setTeamMember(int teamMember) {
		this.teamMember = teamMember;
	}

	public int getStatusAction() {
		return statusAction;
	}

	public void setStatusAction(int statusAction) {
		this.statusAction = statusAction;
	}

	public float getReviewPRjID() {
		return reviewPRjID;
	}

	public void setReviewPRjID(float reviewPRjID) {
		this.reviewPRjID = reviewPRjID;
	}

	public float getReviewPRj_phase() {
		return reviewPRj_phase;
	}

	public void setReviewPRj_phase(float reviewPRj_phase) {
		this.reviewPRj_phase = reviewPRj_phase;
	}

	public Date getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(Date reviewDate) {
		this.reviewDate = reviewDate;
	}

	public Date getTargetDate() {
		return targetDate;
	}

	public void setTargetDate(Date targetDate) {
		this.targetDate = targetDate;
	}

	public Date getCompleteDate() {
		return completeDate;
	}

	public void setCompleteDate(Date completeDate) {
		this.completeDate = completeDate;
	}

	public int getNamePhase() {
		return namePhase;
	}

	public void setNamePhase(int namePhase) {
		this.namePhase = namePhase;
	}

	public String getApproval_date() {
		return approval_date;
	}

	public void setApproval_date(String approval_date) {
		this.approval_date = approval_date;
	}

	public int getDef_probID() {
		return def_probID;
	}

	public void setDef_probID(int def_probID) {
		this.def_probID = def_probID;
	}

	public int getInput_value() {
		return input_value;
	}

	public void setInput_value(int input_value) {
		this.input_value = input_value;
	}

	public int getPhaseValue() {
		return phaseValue;
	}

	public void setPhaseValue(int phaseValue) {
		this.phaseValue = phaseValue;
	}

	public String getPhasedata() {
		return phasedata;
	}

	public void setPhasedata(String phasedata) {
		this.phasedata = phasedata;
	}

	public String getPlant() {
		return plant;
	}

	public void setPlant(String plant) {
		this.plant = plant;
	}

	public String getProblem() {
		return problem;
	}

	public void setProblem(String problem) {
		this.problem = problem;
	}

	public String getProduct_descr() {
		return product_descr;
	}

	public void setProduct_descr(String product_descr) {
		this.product_descr = product_descr;
	}

	public int getMtCode() {
		return mtCode;
	}

	public void setMtCode(int mtCode) {
		this.mtCode = mtCode;
	}

	public int getDept() {
		return dept;
	}

	public void setDept(int dept) {
		this.dept = dept;
	}

	public int getTypeProject() {
		return typeProject;
	}

	public void setTypeProject(int typeProject) {
		this.typeProject = typeProject;
	}

	public String getSearch_product() {
		return search_product;
	}

	public void setSearch_product(String search_product) {
		this.search_product = search_product;
	}

	public String getBaseline() {
		return baseline;
	}

	public void setBaseline(String baseline) {
		this.baseline = baseline;
	}

	public String getTarget_baseline() {
		return target_baseline;
	}

	public void setTarget_baseline(String target_baseline) {
		this.target_baseline = target_baseline;
	}

	public int getProblem_id() {
		return problem_id;
	}

	public void setProblem_id(int problem_id) {
		this.problem_id = problem_id;
	}

	public int getClassProject() {
		return classProject;
	}

	public void setClassProject(int classProject) {
		this.classProject = classProject;
	}

	public int getImpact_intCust() {
		return impact_intCust;
	}

	public void setImpact_intCust(int impact_intCust) {
		this.impact_intCust = impact_intCust;
	}

	public int getImpact_extCust() {
		return impact_extCust;
	}

	public void setImpact_extCust(int impact_extCust) {
		this.impact_extCust = impact_extCust;
	}

	public int getDataAnalysis() {
		return dataAnalysis;
	}

	public void setDataAnalysis(int dataAnalysis) {
		this.dataAnalysis = dataAnalysis;
	}

	public int getCrossfun_rate() {
		return crossfun_rate;
	}

	public void setCrossfun_rate(int crossfun_rate) {
		this.crossfun_rate = crossfun_rate;
	}

	public float getExp_Saving() {
		return exp_Saving;
	}

	public void setExp_Saving(float exp_Saving) {
		this.exp_Saving = exp_Saving;
	}

	public float getBaselinePPM() {
		return baselinePPM;
	}

	public void setBaselinePPM(float baselinePPM) {
		this.baselinePPM = baselinePPM;
	}

	public float getTargetPPM() {
		return targetPPM;
	}

	public void setTargetPPM(float targetPPM) {
		this.targetPPM = targetPPM;
	}

	public float getProject_score() {
		return project_score;
	}

	public void setProject_score(float project_score) {
		this.project_score = project_score;
	}

	public String getRateDefine() {
		return rateDefine;
	}

	public void setRateDefine(String rateDefine) {
		this.rateDefine = rateDefine;
	}

	public int getTeam_user() {
		return team_user;
	}

	public void setTeam_user(int team_user) {
		this.team_user = team_user;
	}

}
