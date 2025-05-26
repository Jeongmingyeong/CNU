package com.test.cnu.service;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("testService")
public class TestService {
	@Autowired
	SqlSessionTemplate sqlSession;
	static Logger logger = LoggerFactory.getLogger(TestService.class);
	
	public Map<String, Object> checkHakbun(Map<String, Object> paramData) {
		List<Map<String, Object>> resultData = sqlSession.selectList("cnu.checkHakbun", paramData);
		logger.info("===== checkHakbun Call DB =====");
		paramData.put("resultData_hakbun", resultData);
        return paramData;
	}	
}
