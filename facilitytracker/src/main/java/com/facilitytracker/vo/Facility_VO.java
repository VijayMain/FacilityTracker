package com.facilitytracker.vo;

import java.io.InputStream;
import java.sql.Timestamp;
import java.util.Date;

public class Facility_VO {

	String name = "", pass = "", issue = "";
	int company = 0, facility_for = 0, priority = 0, resp_dept = 0, fm_ID = 0,
			status_id = 0, attended_by = 0, followup = 0;
	String file_imageName = "", file_docName = "", solution = "";
	InputStream file_image = null, file_doc = null;
	Timestamp fromDate = null, toDate = null;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public String getIssue() {
		return issue;
	}

	public void setIssue(String issue) {
		this.issue = issue;
	}

	public int getCompany() {
		return company;
	}

	public void setCompany(int company) {
		this.company = company;
	}

	public int getFacility_for() {
		return facility_for;
	}

	public void setFacility_for(int facility_for) {
		this.facility_for = facility_for;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public int getResp_dept() {
		return resp_dept;
	}

	public void setResp_dept(int resp_dept) {
		this.resp_dept = resp_dept;
	}

	public String getFile_imageName() {
		return file_imageName;
	}

	public void setFile_imageName(String file_imageName) {
		this.file_imageName = file_imageName;
	}

	public String getFile_docName() {
		return file_docName;
	}

	public void setFile_docName(String file_docName) {
		this.file_docName = file_docName;
	}

	public InputStream getFile_image() {
		return file_image;
	}

	public void setFile_image(InputStream file_image) {
		this.file_image = file_image;
	}

	public InputStream getFile_doc() {
		return file_doc;
	}

	public void setFile_doc(InputStream file_doc) {
		this.file_doc = file_doc;
	}

	public int getAttended_by() {
		return attended_by;
	}

	public void setAttended_by(int attended_by) {
		this.attended_by = attended_by;
	}

	public int getFollowup() {
		return followup;
	}

	public void setFollowup(int followup) {
		this.followup = followup;
	}

	public String getSolution() {
		return solution;
	}

	public void setSolution(String solution) {
		this.solution = solution;
	}

	public int getFm_ID() {
		return fm_ID;
	}

	public void setFm_ID(int fm_ID) {
		this.fm_ID = fm_ID;
	}

	public int getStatus_id() {
		return status_id;
	}

	public void setStatus_id(int status_id) {
		this.status_id = status_id;
	}

	public Timestamp getFromDate() {
		return fromDate;
	}

	public void setFromDate(Timestamp fromDate) {
		this.fromDate = fromDate;
	}

	public Timestamp getToDate() {
		return toDate;
	}

	public void setToDate(Timestamp toDate) {
		this.toDate = toDate;
	}

}
