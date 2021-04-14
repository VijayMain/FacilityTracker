package com.facilitytracker.vo;

import java.io.InputStream;

public class WFH_VO {

	String sapCode = "", email = "", contact = "", fileName = "",
			dwm_title = "", dwm_task_desc = "", time_required = "",
			prj_title = "", prj_desc = "", remark_project = null,
			tran_date = "", tot_part = "", frm = "";
	InputStream file_blob;
	int tot_file = 0, taskAssigned_By = 0, prj_id = 0, dwm_id = 0,
			prjTask_id = 0, tot_prjfile = 0, status = 0, maxId = 0,
			taskApprover = 0;

	public int getTaskApprover() {
		return taskApprover;
	}

	public void setTaskApprover(int taskApprover) {
		this.taskApprover = taskApprover;
	}

	public String getFrm() {
		return frm;
	}

	public void setFrm(String frm) {
		this.frm = frm;
	}

	public String getSapCode() {
		return sapCode;
	}

	public void setSapCode(String sapCode) {
		this.sapCode = sapCode;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public InputStream getFile_blob() {
		return file_blob;
	}

	public void setFile_blob(InputStream file_blob) {
		this.file_blob = file_blob;
	}

	public String getDwm_title() {
		return dwm_title;
	}

	public void setDwm_title(String dwm_title) {
		this.dwm_title = dwm_title;
	}

	public String getDwm_task_desc() {
		return dwm_task_desc;
	}

	public void setDwm_task_desc(String dwm_task_desc) {
		this.dwm_task_desc = dwm_task_desc;
	}

	public String getTime_required() {
		return time_required;
	}

	public void setTime_required(String time_required) {
		this.time_required = time_required;
	}

	public int getTaskAssigned_By() {
		return taskAssigned_By;
	}

	public void setTaskAssigned_By(int taskAssigned_By) {
		this.taskAssigned_By = taskAssigned_By;
	}

	public int getTot_file() {
		return tot_file;
	}

	public void setTot_file(int tot_file) {
		this.tot_file = tot_file;
	}

	public int getDwm_id() {
		return dwm_id;
	}

	public void setDwm_id(int dwm_id) {
		this.dwm_id = dwm_id;
	}

	public String getPrj_title() {
		return prj_title;
	}

	public void setPrj_title(String prj_title) {
		this.prj_title = prj_title;
	}

	public String getPrj_desc() {
		return prj_desc;
	}

	public void setPrj_desc(String prj_desc) {
		this.prj_desc = prj_desc;
	}

	public String getRemark_project() {
		return remark_project;
	}

	public void setRemark_project(String remark_project) {
		this.remark_project = remark_project;
	}

	public int getTot_prjfile() {
		return tot_prjfile;
	}

	public void setTot_prjfile(int tot_prjfile) {
		this.tot_prjfile = tot_prjfile;
	}

	public String getTot_part() {
		return tot_part;
	}

	public void setTot_part(String tot_part) {
		this.tot_part = tot_part;
	}

	public int getPrj_id() {
		return prj_id;
	}

	public void setPrj_id(int prj_id) {
		this.prj_id = prj_id;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getPrjTask_id() {
		return prjTask_id;
	}

	public void setPrjTask_id(int prjTask_id) {
		this.prjTask_id = prjTask_id;
	}

	public int getMaxId() {
		return maxId;
	}

	public void setMaxId(int maxId) {
		this.maxId = maxId;
	}

	public String getTran_date() {
		return tran_date;
	}

	public void setTran_date(String tran_date) {
		this.tran_date = tran_date;
	}

}
