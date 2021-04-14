package com.facilitytracker.controller;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
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

@WebServlet("/DWM_Register_Control")
public class DWM_Register_Control extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try { 
			InputStream file_Input = null;
			String status="";
			boolean flag = false,file_avail=false;
			HttpSession session = request.getSession();
			// ********************************************************************************************************
			WFH_VO bean = new WFH_VO();
			WFH_DAO dao = new WFH_DAO();
			/**********************************************************************************************************
			 * For MultipartContent Separate FILE Fields and FORM Fields
			 **********************************************************************************************************/
			if (ServletFileUpload.isMultipartContent(request)) {
				String fieldName, fieldValue = "";
				ServletFileUpload servletFileUpload = new ServletFileUpload(
						new DiskFileItemFactory());
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
						if (fieldName.equalsIgnoreCase("dwm_title")) {
							fieldValue = fieldValue.replaceAll("\"", "");
							fieldValue = fieldValue.replaceAll("\'", "");
							bean.setDwm_title(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("dwm_task_desc")) {
							fieldValue = fieldValue.replaceAll("\"", "");
							fieldValue = fieldValue.replaceAll("\'", "");
							bean.setDwm_task_desc(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("time_required")) {
							bean.setTime_required(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("taskAssigned_By")) {
							bean.setTaskAssigned_By(Integer.valueOf(fieldValue)); 
						}
						if (fieldName.equalsIgnoreCase("tot_file")) {
							bean.setTot_file(Integer.valueOf(fieldValue)); 
						}
						if (fieldName.equalsIgnoreCase("tran_date")) {
							bean.setTran_date(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("frm")) {
							bean.setFrm(fieldValue);  
						} 
					} else {
						// *************************************************************************************************************
						// IF FILE inputs === >
						// *************************************************************************************************************
						String file_stored = null;
						fileItem = fileItemTemp;
						fieldName = fileItem.getFieldName();
						fieldValue = fileItem.getString(); 
						
						for (int k = 0; k <bean.getTot_file(); k++) {
							
							// *************************************************************************************************************
							// if multiple files then there names are
							// inputName1,inputName2,inputName3,.......
							// *************************************************************************************************************
							if (fieldName.equalsIgnoreCase("dwmAttach" + k)) {
								file_stored = fileItem.getName(); 
								bean.setFileName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream());
 
						//		System.out.println(bean.getDwm_title() + bean.getDwm_task_desc() + bean.getTime_required() +  bean.getTaskAssigned_By());
								
								if (bean.getDwm_title() != ""
										&& bean.getDwm_task_desc() != ""
										&& bean.getTime_required() != "" 
										&& bean.getTaskAssigned_By() != 0  && k < 1) {
									int dwm_id = dao.regDWM_Task(bean, session); 
									bean.setDwm_id(dwm_id);
								}
								// Attach file ====>
								bean.setFile_blob(file_Input);
								if (bean.getFileName() != "" && bean.getDwm_id()!=0) {
									flag = dao.attachDWM_File(bean, session);
								} 
								file_avail = true;
							} 
						}
					} 
				}  		
				if(file_avail==false){
					int dwm_id = dao.regDWM_Task(bean, session); 
					if(dwm_id>0){
						flag=true;
					}
				}
			}
			if(flag==true && bean.getFrm().equalsIgnoreCase("0")){
				status="DWM Added";
				response.sendRedirect("WFH_Transaction.jsp?none=1&statusok="+status);
			}else if(flag==true && !bean.getFrm().equalsIgnoreCase("0")){
				status="DWM Added";
				response.sendRedirect(bean.getFrm()+"&tabsave=1");
			}else{	
				status="Issue Occurred...";
				response.sendRedirect("WFH_Transaction.jsp?none=1");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
