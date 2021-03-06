package com.inspur.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @RequestMapping("/hello")
    public String hello(){
        return "HelloWorld";
    }
    @RequestMapping("/bye")
    public String bye(){return "ByeBye";}
    @RequestMapping("/XiJinPin")
    public String xi(){
        return "连任！";
    }
}
