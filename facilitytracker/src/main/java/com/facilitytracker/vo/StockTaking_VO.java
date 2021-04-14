package com.facilitytracker.vo;

import java.io.InputStream;

public class StockTaking_VO {
	String fileName = "", importfor = "", comp_id = "", contact = "",
			reason = "", plant = "", mat_type = "", mat_name = "",
			location = "", uom = "", mat_group = "", plant1010 = "",
			plant1020 = "", plant1030 = "", plant1050 = "", plant2010 = "",
			plant2020 = "", plant3010 = "", rate = "", hsn_no = "",
			remark = "", file_doc = "", hsn = "";

	InputStream file_blob;
	int fiscal_year = 0, stock_typeID = 0, qty = 0, editid = 0, appr = 0;

	public String getHsn() {
		return hsn;
	}

	public void setHsn(String hsn) {
		this.hsn = hsn;
	}

	public int getStock_typeID() {
		return stock_typeID;
	}

	public void setStock_typeID(int stock_typeID) {
		this.stock_typeID = stock_typeID;
	}

	public String getComp_id() {
		return comp_id;
	}

	public void setComp_id(String comp_id) {
		this.comp_id = comp_id;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getImportfor() {
		return importfor;
	}

	public void setImportfor(String importfor) {
		this.importfor = importfor;
	}

	public InputStream getFile_blob() {
		return file_blob;
	}

	public void setFile_blob(InputStream file_blob) {
		this.file_blob = file_blob;
	}

	public int getFiscal_year() {
		return fiscal_year;
	}

	public void setFiscal_year(int fiscal_year) {
		this.fiscal_year = fiscal_year;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getPlant() {
		return plant;
	}

	public void setPlant(String plant) {
		this.plant = plant;
	}

	public String getMat_type() {
		return mat_type;
	}

	public void setMat_type(String mat_type) {
		this.mat_type = mat_type;
	}

	public String getMat_name() {
		return mat_name;
	}

	public void setMat_name(String mat_name) {
		this.mat_name = mat_name;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getUom() {
		return uom;
	}

	public void setUom(String uom) {
		this.uom = uom;
	}

	public String getMat_group() {
		return mat_group;
	}

	public void setMat_group(String mat_group) {
		this.mat_group = mat_group;
	}

	public String getPlant1010() {
		return plant1010;
	}

	public void setPlant1010(String plant1010) {
		this.plant1010 = plant1010;
	}

	public String getPlant1020() {
		return plant1020;
	}

	public void setPlant1020(String plant1020) {
		this.plant1020 = plant1020;
	}

	public String getPlant1030() {
		return plant1030;
	}

	public void setPlant1030(String plant1030) {
		this.plant1030 = plant1030;
	}

	public String getPlant2010() {
		return plant2010;
	}

	public void setPlant2010(String plant2010) {
		this.plant2010 = plant2010;
	}

	public String getPlant2020() {
		return plant2020;
	}

	public void setPlant2020(String plant2020) {
		this.plant2020 = plant2020;
	}

	public String getPlant3010() {
		return plant3010;
	}

	public void setPlant3010(String plant3010) {
		this.plant3010 = plant3010;
	}

	public String getRate() {
		return rate;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}

	public String getHsn_no() {
		return hsn_no;
	}

	public void setHsn_no(String hsn_no) {
		this.hsn_no = hsn_no;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getFile_doc() {
		return file_doc;
	}

	public void setFile_doc(String file_doc) {
		this.file_doc = file_doc;
	}

	public String getPlant1050() {
		return plant1050;
	}

	public void setPlant1050(String plant1050) {
		this.plant1050 = plant1050;
	}

	public int getEditid() {
		return editid;
	}

	public void setEditid(int editid) {
		this.editid = editid;
	}

	public int getAppr() {
		return appr;
	}

	public void setAppr(int appr) {
		this.appr = appr;
	}

}
