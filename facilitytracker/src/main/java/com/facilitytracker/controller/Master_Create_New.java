package com.facilitytracker.controller;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

import com.facilitytracker.connectionUtil.Connection_Util;
import com.facilitytracker.dao.MasterData_DAO;
import com.facilitytracker.vo.StockTaking_VO;

@WebServlet("/Master_Create_New")
public class Master_Create_New extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// plant     mat_type   mat_name   qty   location   uom   mat_group   1010   1020  1030   2010  2020  
		//  3010    rate    contact    hsn_no    reason    remark    file_doc
 
		PrintWriter out = response.getWriter();
		try {
			Connection con = Connection_Util.getConnectionMaster();
			InputStream file_Input = null;
			boolean flag = false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			StockTaking_VO vo = new StockTaking_VO();
			MasterData_DAO dao = new MasterData_DAO();
			/**********************************************************************************************************
			 * For MultipartContent Separate FILE Fields and FORM Fields
			 **********************************************************************************************************/
			if (ServletFileUpload.isMultipartContent(request)) {
				String fieldName, fieldValue = "";
				ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
				List fileItemsList;
				fileItemsList = servletFileUpload.parseRequest(request);
				// Collect data into list
				FileItem fileItem = null;
				Iterator it = fileItemsList.iterator();
				// iterate list to sort data(i.e. form / file Fields)
				while (it.hasNext()) {
					FileItem fileItemTemp = (FileItem) it.next();
					// if data is form field ==== >
					if (fileItemTemp.isFormField()) {
						// INPUT FORM FIELDS are ==== >
						fieldName = fileItemTemp.getFieldName();
						fieldValue = fileItemTemp.getString();
						// TO SELECT PARTICULAR FORM FIELD ====>
						if (fieldName.equalsIgnoreCase("plant")) {
							vo.setPlant(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("mat_type")) {
							vo.setMat_type(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("mat_name")) {
							vo.setMat_name(fieldValue.toUpperCase());
						}
						if (fieldName.equalsIgnoreCase("qty")) {
							vo.setQty(Integer.valueOf(fieldValue));
						}
						if (fieldName.equalsIgnoreCase("location")) {
							vo.setLocation(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("uom")) {
							vo.setUom(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("mat_group")) {
							vo.setMat_group(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant1010")) {
							vo.setPlant1010(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant1020")) {
							vo.setPlant1020(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant1030")) {
							vo.setPlant1030(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant1050")) {
							vo.setPlant1050(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant2010")) {
							vo.setPlant2010(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant2020")) {
							vo.setPlant2020(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("plant3010")) {
							vo.setPlant3010(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("rate")) {
							vo.setRate(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("contact")) {
							vo.setContact(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("hsn_no")) {
							vo.setHsn_no(fieldValue);
						}
						if (fieldName.equalsIgnoreCase("reason")) {
							vo.setReason(fieldValue.toUpperCase());
						}
						if (fieldName.equalsIgnoreCase("editid")) {
							vo.setEditid(Integer.valueOf(fieldValue));
						}
						if (fieldName.equalsIgnoreCase("appr")) {
							vo.setAppr(Integer.valueOf(fieldValue));
						}
						
					} else {
						// *************************************************************************************************************
						// IF FILE inputs === >
						// *************************************************************************************************************
						String file_stored = null;
						fileItem = fileItemTemp;
						fieldName = fileItem.getFieldName();
						fieldValue = fileItem.getString();

						file_stored = fileItem.getName();
						vo.setFileName(FilenameUtils.getName(file_stored));
						file_Input = new DataInputStream(fileItem.getInputStream());
					}
					vo.setFile_blob(file_Input);
				}
			PreparedStatement ps_chek = null;
			ResultSet rs_check = null;
			
			if(vo.getHsn_no().equalsIgnoreCase("")){
				ps_chek = con.prepareStatement("select material_description from rel_SAPmaster_mm60 where enable=1 and material_type='"+vo.getMat_type()+"' and material_description='"+vo.getMat_name()+"'");
				rs_check = ps_chek.executeQuery();
			if(rs_check.next()){
					response.sendRedirect("Master_Create.jsp?statusNop=Already Available");
			}else{
				dao.add_newMaterial(response, vo, session);
			}
			}else{
			 
			ps_chek = con.prepareStatement("select * from rel_SAPmaster_HSN where enable=1 and hsnCode='"+vo.getHsn_no()+"'");
			rs_check = ps_chek.executeQuery();
			if(rs_check.next()){
			 	ps_chek = con.prepareStatement("select material_description from rel_SAPmaster_mm60 where enable=1 and material_type='"+vo.getMat_type()+"' and material_description='"+vo.getMat_name()+"'");
				rs_check = ps_chek.executeQuery();
				if(rs_check.next()){
					response.sendRedirect("Master_Create.jsp?statusNop=Already Available");
			}else{
				dao.add_newMaterial(response, vo, session);
			}
			}else{
				response.sendRedirect("Master_Create.jsp?statusNop=HSN No Not Found in System..Error Occurred..!");
			}
		  }
		  }
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}