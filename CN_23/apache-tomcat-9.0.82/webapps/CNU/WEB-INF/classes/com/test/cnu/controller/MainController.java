package com.test.cnu.controller;

import java.io.IOException;
import java.io.Writer;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.test.cnu.service.TestService;

import net.sf.json.JSONObject;


@Controller
public class MainController {
	@Autowired
	SqlSessionTemplate sqlSession;	
	@Resource(name = "testService")
	private TestService testService;
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);	
	//private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.POST})
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "index";
	}
	@RequestMapping(value = "/main.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String testMain(Model model, HttpServletRequest request) {
		logger.info("===== main START =====", request.getServletPath());
		return "test/main";
	}
	
	@RequestMapping(value = "/checkHakbun.do", method = {RequestMethod.POST})
	public ModelAndView checkHakbun(Model model, HttpSession session, HttpServletRequest request,
			HttpServletResponse response, @RequestParam Map<String, Object> paramData)
			throws IOException {
		logger.info("===== checkHakbun START =====", request.getServletPath());
		response.setContentType("application/x-json; charset=UTF-8");
		JSONObject joReturn = new JSONObject();
		Writer out = null;
		Map<String, Object> returnData = testService.checkHakbun(paramData);
		joReturn.put("returnData", returnData);
		out = response.getWriter();
		out.write(joReturn.toString());
		
		return null;
	}
	@RequestMapping(value = "/logging.do", method = {RequestMethod.POST})
	public ModelAndView loggingAdd(Model model, HttpSession session, HttpServletRequest request,
			HttpServletResponse response, @RequestParam Map<String, Object> paramData)
					throws IOException {
		logger.info("===== logging START =====", request.getServletPath());
		String item = paramData.get("item").toString();
		String studentNm = paramData.get("studentNm").toString();
		logger.info("My("+studentNm+") choice ------> ["+item+"]");		
		response.setContentType("application/x-json; charset=UTF-8");
		JSONObject joReturn = new JSONObject();
		Writer out = null;
		joReturn.put("returnData", item);
		out = response.getWriter();
		out.write(joReturn.toString());
		
		return null;
	}
	
	
}
