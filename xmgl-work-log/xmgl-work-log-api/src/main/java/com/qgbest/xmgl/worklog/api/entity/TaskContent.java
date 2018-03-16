package com.qgbest.xmgl.worklog.api.entity;

/**
 * Created by quangao on 2017/7/4.
 */

public class TaskContent {
    private String start_time;//开始时间
    private String end_time;//结束时间
    private String task_type;//任务类型
    private String project;//所属项目
    private String module;//所属模块
    private String record;//任务记录
    private String complete;//完成情况
    private String incomplete_explain;//未完成情况描述

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    public String getTask_type() {
        return task_type;
    }

    public void setTask_type(String task_type) {
        this.task_type = task_type;
    }

    public String getProject() {
        return project;
    }

    public void setProject(String project) {
        this.project = project;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getRecord() {
        return record;
    }

    public void setRecord(String record) {
        this.record = record;
    }

    public String getComplete() {
        return complete;
    }

    public void setComplete(String complete) {
        this.complete = complete;
    }

    public String getIncomplete_explain() {
        return incomplete_explain;
    }

    public void setIncomplete_explain(String incomplete_explain) {
        this.incomplete_explain = incomplete_explain;
    }
}
