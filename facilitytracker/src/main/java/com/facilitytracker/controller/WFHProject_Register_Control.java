package com.facilitytracker.controller;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
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

import com.facilitytracker.dao.WFH_DAO;
import com.facilitytracker.vo.WFH_VO;

@WebServlet("/WFHProject_Register_Control")
public class WFHProject_Register_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// prj_title   prj_desc    remark_project   tot_prjfile   tot_part    
		try { 
			InputStream file_Input = null;
			String status="";
			int chk =1;
			ArrayList userList = new ArrayList();
			boolean flag = false, flagAvail=false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			WFH_VO bean = new WFH_VO();
			WFH_DAO dao = new WFH_DAO();
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
						if (fieldName.equalsIgnoreCase("prj_title")) {
							bean.setPrj_title(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("prj_desc")) {
							fieldValue = fieldValue.replaceAll("\"", "");
							fieldValue = fieldValue.replaceAll("\'", "");
							bean.setPrj_desc(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("remark_project")) {
							fieldValue = fieldValue.replaceAll("\"", "");
							fieldValue = fieldValue.replaceAll("\'", "");
							bean.setRemark_project(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("tot_prjfile")) {
							bean.setTot_prjfile(Integer.valueOf(fieldValue)); 
						}
						if (fieldName.equalsIgnoreCase("tot_part")) {
							bean.setTot_part(fieldValue);
						}
						
						
					} else {
						// *************************************************************************************************************
						// IF FILE inputs === >
						// *************************************************************************************************************
						String file_stored = null;
						fileItem = fileItemTemp;
						fieldName = fileItem.getFieldName();
						fieldValue = fileItem.getString(); 
						
						for (int k = 0; k <bean.getTot_prjfile(); k++) {
							
							// *************************************************************************************************************
							// if multiple files then there names are
							// inputName1,inputName2,inputName3,.......
							// *************************************************************************************************************
							if (fieldName.equalsIgnoreCase("prjAttach" + k)) {
								file_stored = fileItem.getName(); 
								bean.setFileName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream()); 
						 
								if(bean.getPrj_title() !="" &&   bean.getPrj_desc() !="" && bean.getTot_part() !="" && bean.getRemark_project() !="" && bean.getTot_prjfile()!=0 && k==0){
									int prj_id = dao.regWFHProject(bean, session); 
									bean.setPrj_id(prj_id); 
										flag=true;    
								}
								// Attach file ====>
								bean.setFile_blob(file_Input);
								if (bean.getFileName() != "" && bean.getPrj_id() !=0) {
									flag = dao.attachProject_File(bean, session); 
								} 
								flagAvail=true;
							}
						}
					}
				}
				if(flagAvail==false){ 
					int prj_id = dao.regWFHProject(bean, session); 
					if(prj_id>0){
						flag=true;
					}
				}
			}
			if(flag==true){
				status="Project Added";
				response.sendRedirect("WFH_Transaction.jsp?none=1&statusok="+status+"&prjtab=1");
			}else{
				status="Issue Occurred...";
				response.sendRedirect("WFH_Transaction.jsp?none=1&statusNop="+status+"&prjtab=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
