package com.qgbest.xmgl.worklog.service.controller;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

/**
 * Created with IntelliJ IDEA.
 * User: wangchao
 * Date: 2017/8/04
 * Time: 8:42
 * description: 执行全部测试用例
 */
@RunWith(Suite.class)
@Suite.SuiteClasses({
  CommentsController.class,
  DayLogControllerTest.class,
  DictionaryControllerTest.class,
  GlanceOverControllerTest.class,
  MessageControllerTest.class,
  MonthLogControllerTest.class,
  SysdataGridDefaultConfigControllerTest.class,
  SysdataGridPersonConfigControllerTest.class,
  SystemConfigControllerTest.class,
  ThumbsUpControllerTest.class,
  UpdateLogControllerTest.class,
  WeekLogControllerTest.class,
  WorkLogDictionaryControllerTest.class,
  TaskLogControllerTest.class
})
public class AllSuite {
}
