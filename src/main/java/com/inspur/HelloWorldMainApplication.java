package com.inspur;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class HelloWorldMainApplication {
    public static void main(String[] args) {
        //启动spring应用
        SpringApplication.run(HelloWorldMainApplication.class,args);
    }
}
