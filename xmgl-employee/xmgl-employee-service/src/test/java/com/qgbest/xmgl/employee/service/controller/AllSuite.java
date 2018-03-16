package com.qgbest.xmgl.employee.service.controller;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

/**
 * Created by IntelliJ IDEA 2017.
 * User:wangchao
 * Date:2017/8/7
 * Time:16:16
 * description:员工接口测试
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
  EmployeeControllerTest.class,
  DictionaryControllerTest.class,
  DicControllerTest.class,
  SysdataGridDefaultConfigControllerTest.class,
  SysdataGridPersonConfigControllerTest.class,
  SystemConfigControllerTest.class
})
public class AllSuite {

}
