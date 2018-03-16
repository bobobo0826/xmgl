package com.qgbest.xmgl.worklog.api.entity;

/**
 * Created by quangao on 2017/7/5.
 */
public class DayTaskJson {
    private String task_start_time;
    private String task_end_time;
    private String task_type;
    private String sup_project;
    private String sup_module;
    private String record;
    private String complete;
    private String incomplete_explain;
    private Integer sup_project_id;
    private Integer sup_module_id;
    private String task_name;

    public Integer getSup_project_id() {
        return sup_project_id;
    }

    public void setSup_project_id(Integer sup_project_id) {
        this.sup_project_id = sup_project_id;
    }

    public Integer getSup_module_id() {
        return sup_module_id;
    }

    public void setSup_module_id(Integer sup_module_id) {
        this.sup_module_id = sup_module_id;
    }

    public String getTask_name() {
        return task_name;
    }

    public void setTask_name(String task_name) {
        this.task_name = task_name;
    }

    public String getTask_start_time() {
        return task_start_time;
    }

    public void setTask_start_time(String task_start_time) {
        this.task_start_time = task_start_time;
    }

    public String getTask_end_time() {
        return task_end_time;
    }

    public void setTask_end_time(String task_end_time) {
        this.task_end_time = task_end_time;
    }

    public String getTask_type() {
        return task_type;
    }

    public void setTask_type(String task_type) {
        this.task_type = task_type;
    }

    public String getSup_project() {
        return sup_project;
    }

    public void setSup_project(String sup_project) {
        this.sup_project = sup_project;
    }

    public String getSup_module() {
        return sup_module;
    }

    public void setSup_module(String sup_module) {
        this.sup_module = sup_module;
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
