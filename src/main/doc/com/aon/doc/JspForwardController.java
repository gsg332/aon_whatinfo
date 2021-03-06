package com.aon.doc;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class JspForwardController {

	@RequestMapping(value = "*")
	public ModelAndView forward(@RequestParam Map<String, String> model, HttpServletRequest req) {
		return new ModelAndView();
	}
}
