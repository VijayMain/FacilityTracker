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

@WebServlet("/PRJ_Task_Register_Control")
public class PRJ_Task_Register_Control extends HttpServlet {
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
						if (fieldName.equalsIgnoreCase("prj_task_title")) {
							bean.setPrj_title(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("prj_task_task_desc")) {
							fieldValue = fieldValue.replaceAll("\"", "");
							fieldValue = fieldValue.replaceAll("\'", "");
							bean.setPrj_desc(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("time_required")) {
							bean.setTime_required(fieldValue); 
						}
						if (fieldName.equalsIgnoreCase("status")) {
							bean.setStatus(Integer.valueOf(fieldValue)); 
						}
						if (fieldName.equalsIgnoreCase("tot_prjfile")) {
							bean.setTot_file(Integer.valueOf(fieldValue)); 
						}
						if (fieldName.equalsIgnoreCase("prj_Id")) {
							bean.setPrj_id(Integer.valueOf(fieldValue)); 
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
							if (fieldName.equalsIgnoreCase("prjAttach" + k)) {
								file_stored = fileItem.getName(); 
								bean.setFileName(FilenameUtils.getName(file_stored)); 
								file_Input = new DataInputStream(fileItem.getInputStream());
 
						//		System.out.println(bean.getDwm_title() + bean.getDwm_task_desc() + bean.getTime_required() +  bean.getTaskAssigned_By());
								
								if (bean.getPrj_title() != ""
										&& bean.getPrj_desc() != ""
										&& bean.getTime_required() != "" 
										&& bean.getStatus() != 0  && k < 1) {
									int prjTask_id = dao.regProject_Task(bean, session); 
									bean.setPrjTask_id(prjTask_id);
								}
								// Attach file ====>
								bean.setFile_blob(file_Input);
								if (bean.getFileName() != "" && bean.getPrjTask_id()!=0) {
									flag = dao.attachPrj_Task_File(bean, session);
								} 
								file_avail = true;
							} 
						}
					} 
				}  		
				if(file_avail==false){
					int dwm_id = dao.regProject_Task(bean, session); 
					if(dwm_id>0){
						flag=true;
					}
				}
			}
			if(flag==true){
				status="Project Task Added";
				response.sendRedirect("WFH_ProjectTask.jsp?prjID="+bean.getPrj_id()+"&none=1&statusok="+status);
			}else{
				status="Issue Occurred...";
				response.sendRedirect("WFH_ProjectTask.jsp?prjID="+bean.getPrj_id()+"&none=1&statusNop="+status);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
