package com.qgbest.xmgl.task.service.controller;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

/**
 * Created with IntelliJ IDEA.
 * User: liubo
 * Date: 2017/8/07
 * Time: 16.18
 * description: 执行全部测试用例
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
        MyTaskControllerTest.class,
        TaskControllerTest.class,
        DicControllerTest.class,
        DictionaryControllerTest.class,
        SysdataGridDefaultConfigControllerTest.class,
        SysdataGridPersonConfigControllerTest.class,
        SystemConfigControllerTest.class,
        StandardsControllerTest.class,
        EmailControllerTest.class
})
public class AllSuite {

}
