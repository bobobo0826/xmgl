//Created by wjy on 2017/9/26.
import React from 'react'
import "../../../styles/public/css/info.scss"
import mirror, {connect, actions, render} from 'mirrorx'
import LzEditor from 'react-lz-editor/editor/index'
import SelectEmployee from '../../public/selects/SelectEmployee';
import {getJson} from '../../request'
import {
    Form, Row, Col, message, Input, Select, Button, Icon, Radio, DatePicker, Progress, Upload, Modal,
    Collapse
} from 'antd';
import moment from 'moment';
import TaskOutput from './alterAndProcess/TaskOutput'
import SselectModule from "../../oa/bug/SselectModule";
import {createCreateTaskEvalModel} from "./evaluation/CreateEvaluation";
import CreateEvaluation from "./evaluation/CreateEvaluation";
import {createTaskAlterListModel} from "./alterAndProcess/TaskAlterList";
import TaskAlterList from "./alterAndProcess/TaskAlterList";
import {createPlanInfoModel} from "../plan/PlanInfo";
import PlanInfo from "../plan/PlanInfo";
import AlterDescContent from "./alterAndProcess/AlterDesc";
import Cache from "../../cache"
import DataLoadingPage from "../DataLoadingPage";
import DataLoadFailed from "../DataLoadFailed";

const dateFormat = 'YYYY-MM-DD';
const FormItem = Form.Item;
const RadioGroup = Radio.Group;
const Panel = Collapse.Panel;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};
const updatePerson = function (data) {
    let employees = [];
    let obj = JSON.parse(data);
    for (let i = 0; i < obj.length; i++) {
        employees.push(obj[i].id + "~" + obj[i].dept + "~" + obj[i].name);
    }
    return employees.join(",");
};
const splitPerson = function (data,index) {
    let firstSplit = data.split(",");
    let value = [];
    firstSplit.map((item)=>{
        let secondSplit = item.split("~");
        value.push(secondSplit[index])
    })
    return value

};
/*
let emailDataToSave = {};
let emailDataToAlert = {};
const emailValueChange = function(name,pro, val) {
    name[pro] = val;
    return name;
};
const getNowFormatDate =function() {
    let date = new Date();
    const seperator1 = "-";
    const seperator2 = ":";
    let month = date.getMonth() + 1;
    let strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
        + " " + date.getHours() + seperator2 + date.getMinutes();
    return currentdate;
}
*/



const getConfirmPermission = function (employeeId, participants) {
    let parts = participants ? participants.split(",") : [];
    let flag = false;
    parts.map((item) => {
        if (employeeId === item.split("~")[0]) {
            flag = true; //该员工为承接人
        }
    });
    return flag;
}

const createTaskInfoModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            isToLoadModule: true,
            loadedDataResponse: "LOADING",
            personArray: [],
            taskData: {},
            task_result_summary: "",
            contentReadonly: false,
            isTemp: false, //是否为任务变更临时数据
            modalVisible: false,
            alterDesc: "",
            alterMark: {},
            curUser: {},
            curEmployee: {},
        },
        reducers: {
            setMirrorState(state, newState) {
                return {
                    ...state,
                    ...newState,
                }
            },
            handleChange(state, data) {
                let obj = {};
                obj[data.key] = data.value;
                return {
                    ...state,
                    taskData: Object.assign({}, state.taskData, obj)
                }
            },
            hdChangeAlter(state, data) {
                return {
                    ...state,
                    alterDesc: data
                }
            },
            doAlterTask(state, data) {
                let id = state.taskData.id;
                return {
                    ...state,
                    taskData: {
                        ...state.taskData,
                        id: null,
                        task_id: id,//变更成临时数据。
                        task_condition_code: "BGDTJ",
                    },
                    isTemp: true,
                    contentReadonly: false,
                }
            },
            onchangeModule(state, data) {
                return {
                    ...state,
                    taskData: Object.assign({}, state.taskData, {sup_module_name: data[0]})
                }
            },
            alterDescShowOrHide(state, data) {
                return {
                    ...state,
                    modalVisible: data,
                }
            },
            setFileList(state, flieList) {
                return {
                    ...state,
                    fileList: fileList,
                }
            },
        },

        effects: {
            async initLoadData(ownProps, getState) {
                let curUser = await getJson("/api/task/getCurUser", {'method': 'GET'});
                let curEmployee = await getJson("/api/employee/manage/employee/getEmployeeInfoByUserId/" + curUser.id, {'method': 'GET'});
                let dicState = await actions[modelName].loadTaskDic();
                let taskState = await actions[modelName].loadTaskData({id: ownProps.taskId, creator:curUser.displayName,creator_id:curUser.id});
                let alterMarkState = await actions[modelName].getAlterMark({task_id: ownProps.taskId});
                let moduleDicState = await actions[modelName].loadModuleDicByProjectId(taskState.taskData.sup_project_id);
                let newState = Object.assign({}, dicState, taskState, alterMarkState, moduleDicState, {curUser}, {curEmployee});
                actions[modelName].setMirrorState(newState);
            },
            async loadTaskData(data, getState) {
                let info = {};
                let loadData = "";
                if (data.id === -1 || !data.id) {
                    info = {
                        data: {
                            task_condition_code: "CG",
                            create_time: moment().format('YYYY-MM-DD HH:mm'),
                            creator: data.creator || "",
                            creator_id:data.creator_id || null
                        }
                    };
                    loadData = "SUCCESS";
                } else {
                    info = await getJson('/api/task/getTaskInfoOrTempByTaskId/' + data.id, {'method': 'GET'});
                    if (info.status) {
                        loadData = "FAILED";
                    } else {
                        loadData = "SUCCESS";
                    }
                }
                let cd = info.data.task_condition_code;
                let contentReadonly = false;
                if (cd !== "CG" && cd !== "BGDTJ") {
                    contentReadonly = true;
                }
                return {
                    taskData: info.data,
                    loadedDataResponse: loadData,
                    contentReadonly,
                    isTemp: !!info.data.task_id
                };
            },
            async loadTaskDic(data, getState) {
                let projectList = await getJson('/api/task/getProject');
                projectList = projectList.status ? {} : projectList; //若返回了status 说明 出错。
                let taskTypeList = await getJson('/api/task/getTaskDic/task_type');
                taskTypeList = taskTypeList.status ? {} : taskTypeList;
                let taskConditionList = await getJson('/api/task/getTaskDic/task_condition');
                taskConditionList = taskConditionList.status ? {} : taskConditionList;
                let conditionTable = {};
                for (let i = 0; i < taskConditionList.length; i++) {
                    conditionTable[taskConditionList[i].data_code] = taskConditionList[i].data_name;
                }
                return {projectList, taskTypeList, conditionTable}
            },
            async loadModuleDicByProjectId(data, getState) {
                if (data !== null && data > 0) {
                    let moduleList = await getJson('/api/task/getModuleByProjectId/' + data);
                    return {moduleList}
                } else {
                    return {}
                }
            },
            async onChangeProj(data, getState) {
                let state = getState()[modelName];
                let moduleDicState = await actions[modelName].loadModuleDicByProjectId(data[0]);
                let taskData = Object.assign({}, state.taskData, {sup_module_name: "", sup_module_id: null},
                    {sup_projec_id: data[0], sup_project_name: data[1]});
                let newState = Object.assign({}, moduleDicState, {taskData});
                actions[modelName].setMirrorState(newState);
            },
            async saveTaskInfo(data, getState) {
                let isTemp = getState()[modelName].isTemp;
                let saveData = data.taskData || getState()[modelName].taskData;
                if (!saveData.task_name || !saveData.sup_project_name) {
                    let mag = "请输入：";
                    if (!data.task_name) {
                        mag += "任务名称  "
                    }
                    if (!saveData.sup_project_name) {
                        mag += "所属项目 "
                    }
                    message.info(mag);
                    return;
                }
                // 保存前操作
                let msg = ""
                let saveUrl = "";
                if (!data.opr || data.opr === "save") {
                    if (isTemp) {
                        saveUrl = "/api/task/saveTaskTempInfo";
                    } else {
                        saveUrl = "/api/task/saveTaskInfo";
                    }
                    msg = "保存成功";
                } else if (data.opr === "submit") {

                    actions[modelName].sendEmailForSubmit(); //提交邮件操作

                    saveData.task_condition_code = "DCJ";
                    saveUrl = "/api/task/saveTaskInfo";
                    msg = "提交成功";

                } else if (data.opr === "confirm") {
                    saveUrl = "/api/task/saveTaskInfo";
                    msg = "已确认";
                }else if (data.opr === "alter"){
                    saveUrl = "/api/task/saveTaskInfo";
                    msg = "提交成功";
                }
                let taskData = (await getJson(saveUrl, {body: saveData})).data; //正常数据或者临时数据
                //保存后操作
                message.success(msg);
                let cd = taskData.task_condition_code;
                let contentReadonly = false;
                if (cd !== "CG" && cd !== "BGDTJ") {
                    contentReadonly = true;
                }
                let alterMarkState = await actions[modelName].getAlterMark({task_id: taskData.id});
                let newState = Object.assign({}, alterMarkState, {taskData}, {isTemp: !!taskData.task_id}, {contentReadonly});
                actions[modelName].setMirrorState(newState);
            },
            async doSubmitTask(data, getState) {
                let isTemp = getState()[modelName].isTemp;
                if (isTemp) {
                    actions[modelName].alterDescShowOrHide(true);
                } else {
                    actions[modelName].saveTaskInfo({opr: "submit"})
                }
            },
            async handleFileChange(info, getState) {
                let fileList = info.fileList;
                let attachments = []
                let updateFlag = true;
                // 2. read from response and show file link
                fileList.map((file) => {
                    if (file.response) {
                        let obj = {}
                        //过滤多余的字段
                        obj["name"] = file.name;
                        obj["uid"] = file.response.uid;
                        obj["file_path"] = file.response.file_path;
                        obj["file_id"] = file.response.file_id;
                        obj["url"] = file.response.url;
                        obj["status"] = file.status;
                        attachments.push(obj)
                    } else {
                        attachments.push(file)
                    }
                    //有文件还在传输中或传输错误时不执行更新attachment操作
                    if (file.status !== "done") {
                        updateFlag = false
                    }
                })
                if (updateFlag) {
                    //每次刷新将渲染的数据拿去保存，保持页面和数据库一致
                    if (attachments === []) {
                        attachments = null
                    }
                    actions[modelName].updateAttachment(attachments)
                }
                actions[modelName].handleChange({value: JSON.stringify(attachments), key: 'attachment'})
            },
            async updateAttachment(attachmentInfo, getState) {
                let taskId = getState()[modelName].taskData.id;
                await getJson("/api/task/updateAttachment", {body: {taskId: taskId, attachmentInfo: attachmentInfo}});
            },
            async recordTaskAlter(data, getState) {
                await getJson("/api/task/recordTaskAlter", {body: data});
            },
            async doCreateEval(data, getState) {
                let evalModelName = "newTaskEval";
                if (!actions[evalModelName]) {
                    createCreateTaskEvalModel(evalModelName);
                }
                let taskData = getState()[modelName].taskData;
                let employee = taskData.participants;
                let content = <CreateEvaluation modelName={evalModelName} evalId={-1} taskId={taskData.id}
                                                employee={employee} taskName = {taskData.task_name}/>;
                actions.tabsTmpl.addTab({key: evalModelName, name: "录入考评", 'content': content});
            },

            async doQueryAlter(data, getState) {
                let alterModelName = `taskAlterList${data.taskId}`;
                if (!actions[alterModelName]) {
                    createTaskAlterListModel(alterModelName);
                }
                let content = <TaskAlterList modelName={alterModelName} taskId={data.taskId}/>;
                actions.tabsTmpl.addTab({key: alterModelName, name: "任务变更查询", 'content': content});
            },
            async reloadData(data, getState) {
                let taskState = await actions[modelName].loadTaskData({id: getState()[modelName].taskData.id});
                let alterMarkState = await actions[modelName].getAlterMark({task_id: getState()[modelName].taskData.id});
                let newState = Object.assign({}, taskState, alterMarkState);
                actions[modelName].setMirrorState(newState);
            },
/*            async doCreateSubPlan(data, getState) {
                let planModelName = "newPlan";
                if (!actions[planModelName]) {
                    createPlanInfoModel(planModelName);
                }
                let content = <PlanInfo planId={-1} modelName={planModelName}
                                        supTask={getState()[modelName].taskData}/>;
                actions[planModelName].setMirrorState({loadedDataResponse: "LOADING"});
                actions.tabsTmpl.addTab({key: planModelName, name: "新建计划", 'content': content});
            },*/
            async doConfirm(data, getState) {
                let code = "";
                let nowTime = moment().format('YYYY-MM-DD HH:mm');
                let task_start_time =getState()[modelName].taskData.task_start_time;
                let task_end_time = getState()[modelName].taskData.task_end_time;
                switch (data.opr) {
                    case "confirmKS":
                        code = "JXZ";
                        task_start_time = nowTime;
                        break;
                    case "confirmWC":
                        code = "YWC";
                        task_end_time = nowTime;
                        break;
                    default:
                        break;
                }
                let taskData = Object.assign(getState()[modelName].taskData, {task_condition_code: code,task_start_time,task_end_time});
                actions[modelName].saveTaskInfo({taskData, opr: "confirm"});
            },
            async deleteFile(file) {
                if (file.file_path) {
                    await getJson("/api/file/deleteFile", {body: {uid: file.uid}});
                }
            },
            async downloadFile(file) {
                if (file.file_path) {
                    window.open(encodeURI(encodeURI("/api/file/publicfile/downloadFile?fileId=" + file.file_id + "&filePath=" + file.file_path + "&fileName=" + file.name)))
                }
            },
            async getAlterMark(data, getState) {
                let alterMark = {};
                if (data.task_id) {
                    let mark = await getJson('/api/task/getAlterMark/' + data.task_id, {'method': 'GET'});
                    mark.map((item) => {
                        let obj = {};
                        obj[item.field_name] = true;
                        alterMark = Object.assign({}, alterMark, obj);
                    });
                }
                return {alterMark};
            },
            async doSaveSummary(data, getState) {
                let taskData = Object.assign({},
                    getState()[modelName].taskData,
                    {task_result_summary: getState()[modelName].task_result_summary});
                actions[modelName].saveTaskInfo({taskData, opr: "save"});
            },
            //确认变更提交，供AlterDesc组件使用。
            async submitAlter(alterDesc, getState) {
                actions[modelName].sendEmailForChange(alterDesc);
                let saveData = getState()[modelName].taskData;
                saveData = Object.assign({}, saveData, {id: saveData.task_id, task_id: undefined}); //还原成正常task
                let taskData = getState()[modelName].taskData;
                let tempId = taskData.id;//临时数据的id，不是task_id
                taskData = Object.assign({}, taskData, {id: taskData.task_id, task_id: undefined,task_condition_code:"BGDPG"}); //还原成正常task
                await getJson("/api/task/recordTaskAlter", {
                    body: {
                        taskData: taskData,
                        alterDesc: alterDesc
                    }
                });
                await getJson("/api/plan/alterPlanByTaskId", {body: {taskId: taskData.id}}); //把所有下属计划的状态变为 变更待提交
                await getJson("/api/task/deleteTaskTemp", {body: {id: tempId}});
                actions[modelName].saveTaskInfo({taskData,opr: "alter"});
            },
            async doConfirmAlter(data, getState) {
                let taskData = await getJson("/api/task/confirmAlter", {
                    body: {
                        taskId: getState()[modelName].taskData.id,
                        employeeId: getState()[modelName].curEmployee.id
                    }
                });
                actions[modelName].setMirrorState({taskData});
            },
            //邮件获取邮件地址
            async emailForAddress(data, getState){
                let splitParticipants = splitPerson(data,0)//承接人的id
                let emailAdd = [];
                for(let i=0;i<splitParticipants.length;i++){
                    let getEmployeeInfo = await getJson("/api/employee/manage/employee/getEmployeeInfoById/" + splitParticipants[i],{'method': 'GET'});
                    let obj = JSON.parse(getEmployeeInfo.basic_info);
                    emailAdd.push(obj.email);
                }
                return emailAdd
            },
            //邮件提交通知
            async sendEmailForSubmit(data,getState){
                let empParticipants = getState()[modelName].taskData.participants;
                if(empParticipants!=null) {
                    let emailAdds = await actions[modelName].emailForAddress(empParticipants)
                    await getJson('/api/task/sendBusinessEmail',
                        {
                            body: {
                                templet_code: "CJRWTZ",
                                task_name: getState()[modelName].taskData.task_name,
                                creator: getState()[modelName].taskData.creator,
                                task_create_time: getState()[modelName].taskData.create_time,
                                expected_end_time: getState()[modelName].taskData.expected_end_time || "当天",
                                receivers: emailAdds,
                            }
                        })
                }
            },
            /*async sendEmailForSubmit(data,getState){
                let empParticipants = getState()[modelName].taskData.participants;
                let emailAdds =  await actions[modelName].emailForAddress(empParticipants)
                let emailAddValues = emailAdds;
                let emailTaskName = getState()[modelName].taskData.task_name;
                let emailCreator = getState()[modelName].taskData.creator;
                let emailProjectName = getState()[modelName].taskData.sup_project_name;
                let emailImportance = getState()[modelName].taskData.importance;
                let emailUrgency = getState()[modelName].taskData.urgency;
                let title = "您的"+emailTaskName+"任务已提交！"
                let context = "由"+emailCreator+"新建立的，"+emailTaskName+"任务已提交，该任务属于"+emailProjectName+"项目，该任务状态为"+emailImportance+","+emailUrgency+"。"
                emailValueChange(emailDataToSave,"title",title)
                emailValueChange(emailDataToSave,"context",context)

                emailValueChange(emailDataToSave,"send_time",getNowFormatDate())

                let receiver = splitPerson(empParticipants,2)
                emailValueChange(emailDataToSave,"receiver",receiver.join(","))

                await getJson('/api/oa/saveEmailInfo', {body: {...emailDataToSave, emailAddValues}})

            },*/
            //邮件变更通知
            async sendEmailForChange(alterDesc, getState){
                let preTaskId = getState()[modelName].taskData.task_id;
                let preTaskInfo = await getJson('/api/task/getTaskInfoById/' + preTaskId, {'method': 'GET'});
                let preTaskName = preTaskInfo.task_name
                let preParticipants   = preTaskInfo.participants
                let alertData = getState()[modelName].taskData
                let nowPctNames = splitPerson(alertData.participants,2)
                if(preParticipants!=null) {
                    let emailAdds = await actions[modelName].emailForAddress(preParticipants)
                    await getJson('/api/task/sendBusinessEmail',
                        {
                            body: {
                                templet_code: "RWBGTX",
                                pre_task_name: preTaskName,
                                task_name:alertData.task_name,
                                modifier: alertData.modifier,
                                nowPctNames: nowPctNames.join(","),
                                expected_end_time: alertData.expected_end_time || "当天",
                                alterDesc:alterDesc,
                                receivers: emailAdds,
                            }
                        })
                }
            }
            /*async sendEmailForChange(data, getState){
                let emailTaskID = getState()[modelName].taskData.task_id;
                let alterInfoList = await getJson('/api/task/getTaskInfoById/' + emailTaskID, {'method': 'GET'});
                let emailName = alterInfoList.task_name;
                let emailProjectName = alterInfoList.sup_project_name;
                let emailUrgency   = alterInfoList.urgency  ;
                let emailImportance   = alterInfoList.importance  ;
                let emailParticipant     = alterInfoList.participants    ;
                let emailOldPart = splitPerson(emailParticipant,2)
                let emailAdds =  await actions[modelName].emailForAddress(emailParticipant)
                let emailAddValues = emailAdds;
                let alertData = getState()[modelName].taskData
                let emailNewPart = splitPerson(alertData.participants,2)
                let title = "您的"+emailName+"任务已变更！"
                let context = alertData.modifier+"对任务"+emailName+"进行变更操作。</br>"+"变更前===》"+"任务名称："+emailName+"，所属项目："+emailProjectName+"，紧急性："+emailUrgency+"，重要性："+emailImportance+"，承接人："+emailOldPart
                +"</br>"+"变更后===》"+"任务名称："+alertData.task_name+"，所属项目："+alertData.sup_project_name+"，紧急性："+alertData.urgency+"，重要性："+alertData.importance+"，承接人："+emailNewPart
                emailValueChange(emailDataToAlert,"title",title)
                emailValueChange(emailDataToAlert,"context",context)
                emailValueChange(emailDataToAlert,"receiver",emailOldPart.join(","))
                emailValueChange(emailDataToSave,"send_time",getNowFormatDate())
                await getJson('/api/oa/saveEmailInfo', {body: {...emailDataToAlert, emailAddValues}})
            }*/
        }
    });
    render();
};

const TaskInfo = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].loadedDataResponse === "LOADING") {
        actions[modelName].initLoadData(ownProps)
    }
    return state[modelName]
})(props => {
    let taskData = props.taskData; //这个好像是指向同一地址。
    let handleChange = actions[props.modelName].handleChange;
    let projectDic;
    if (props.projectList && props.projectList.rows && props.projectList.rows.length) {
        projectDic = props.projectList.rows.map((item) => (
            <Select.Option key={item.id + ',' + item.project_name}>{item.project_name}</Select.Option>))
    }
    let taskTypeDic;
    if (props.taskTypeList && props.taskTypeList.length) {
        taskTypeDic = props.taskTypeList.map((item) => (
            <Select.Option key={item.data_code}>{item.data_name}</Select.Option>))
    }
    if (props.loadedDataResponse === "SUCCESS") {
        let bottom;
        let confirmPermissionFlag = getConfirmPermission(props.curEmployee.id, props.taskData.participants);  //判断用户是否是任务承接人
        let editPermissionFlag = (props.curUser.id === props.taskData.creator_id || !props.taskData.id);
        confirmPermissionFlag = confirmPermissionFlag || editPermissionFlag;
        //定义按钮
        let closeButton = (
            <Button size="large"
                    onClick={() => {
                        actions.tabsTmpl.closeCurTab();
                    }}
            ><Icon type="cross-circle"/>关闭</Button>);
        let queryAlterButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doQueryAlter({taskId: props.taskData.id});
                    }}
            >
                <Icon type="bars"/>
                变更记录</Button>);
        let alterButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doAlterTask();
                    }}
            ><Icon type="exclamation-circle"/>变更</Button>);
        let finishButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doConfirm({opr: "confirmWC"});
                    }}
            ><Icon type="check"/>确认完成</Button>);
/*        let createPlanButton = (
            <Button size="large" class="btn"
                    onClick={() => {
                        actions[props.modelName].doCreateSubPlan();
                    }}
            ><Icon type="plus-circle"/>新建计划</Button>);*/
        let startButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doConfirm({opr: "confirmKS"});
                    }}
            ><Icon type="smile"/>确认开始</Button>);
        let saveTaskButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].saveTaskInfo({opr: "save"})
                    }}><Icon type="save"/>保存</Button>);
        let submitTaskButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doSubmitTask();
                    }}><Icon type="check-circle"/>提交</Button>);
        let saveSummaryButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doSaveSummary()
                    }}
            >总结任务</Button>);
        let createEvalButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doCreateEval()
                    }}
            ><Icon type="message"/>考评</Button>);
        let code = taskData.task_condition_code;

        if (code === "CG" || code === "BGDTJ") {
            bottom = <div>
                {editPermissionFlag ? saveTaskButton : null}&nbsp;&nbsp;
                {editPermissionFlag ? submitTaskButton : null}&nbsp;&nbsp;
                {closeButton}&nbsp;&nbsp;
            </div>
        } else if (code === "DCJ" || code === "BGDPG") {
            bottom = <div>
               {/* {confirmPermissionFlag ? createPlanButton : null}&nbsp;&nbsp;*/}
                {editPermissionFlag ? startButton : null}&nbsp;&nbsp;
                {editPermissionFlag ? alterButton : null}&nbsp;&nbsp;
                {code === "BGDPG" ? queryAlterButton : null}&nbsp;&nbsp;
                {closeButton}&nbsp;&nbsp;
            </div>
        } else if (code === "YWC" || code === "YKP") {
            bottom = <div>
                {editPermissionFlag ? saveSummaryButton : null}&nbsp;&nbsp;
                {queryAlterButton}&nbsp;&nbsp;
                {createEvalButton}&nbsp;&nbsp;
                {closeButton}&nbsp;&nbsp;
            </div>
        } else if (code === "JXZ") {
            bottom = <div>
                {editPermissionFlag ? alterButton : null}&nbsp;&nbsp;
                {queryAlterButton}&nbsp;&nbsp;
                {editPermissionFlag ? finishButton : null}&nbsp;&nbsp;
                {closeButton}&nbsp;&nbsp;
            </div>
        } else {
            bottom = <div>
                {closeButton}&nbsp;&nbsp;
            </div>
        }
        let summary
        if (taskData.task_condition_code === "YWC" || taskData.task_condition_code === "YKP") {
            summary =
                <Col span={24}>
                    <Col sm={22}>
                        <FormItem labelCol={{span: 2}} wrapperCol={{span: 20}} label="任务总结：">
                            <div style={{height: 200}}>
                                <LzEditor
                                    active={true} lang="en"
                                    cbReceiver={(e) => {
                                        handleChange({value: e, key: 'task_result_summary'})
                                    }}
                                    video={false}
                                    audio={false}
                                    importContent={props.task_result_summary}/>
                            </div>
                        </FormItem>
                    </Col>
                </Col>
        }
        let disabled = props.contentReadonly || !editPermissionFlag;
        const upLoadProps = {
            action: '/api/file/publicfile/uploadFile',
            headers: {
                token: Cache.getAccessToken()
            },
            data: function(file){
                return {
                    _fileName : encodeURI(file.name),
                    _id: props.taskId,
                    _module: "RWFJ"
                }
            },
            onChange: actions[props.modelName].handleFileChange,
            onRemove: actions[props.modelName].deleteFile,
            onPreview: actions[props.modelName].downloadFile,
            multiple: true,
        };
        const markIcon = (<Icon className="alterMark" type="edit"/>);
        const baseContent = (
            <Panel header="基本信息" key="1">
                <Row gutter={60}>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务名称：`}
                                      validateStatus={taskData.task_name ? '' : 'error'}>
                                <Input
                                    defaultValue={taskData.task_name}
                                    onChange={(e) => {
                                        handleChange({value: e.target.value, key: 'task_name'})
                                    }}
                                    disabled={disabled}
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.task_name ? markIcon : null}
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务类别：`}>
                                <Select className="select"
                                        value={taskData.task_type_code}
                                        onChange={(e) => {
                                            handleChange({value: e, key: 'task_type_code'})
                                        }}
                                        disabled={disabled}
                                >
                                    {taskTypeDic}
                                </Select>
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        {props.alterMark.task_type_code ? markIcon : null}
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label="所属项目:"
                                      validateStatus={taskData.sup_project_name ? '' : 'error'}>
                                <Select className="select"
                                        defaultValue={taskData.sup_project_name}
                                        onChange={(e) => {
                                            let idn = e.split(",");
                                            actions[props.modelName].onChangeProj(idn);
                                        }}
                                        disabled={disabled}
                                >
                                    {projectDic}
                                </Select>
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3} className="star">
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.sup_project_name ? markIcon : null}
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`所属模块：`}>
                                <Input
                                    value={props.taskData.sup_module_name}
                                    onChange={(e) => {
                                        handleChange({value: e.target.value, key: 'sup_module_name'})
                                    }}
                                    disabled={disabled}
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <SselectModule treeData={props.moduleList}
                                           getTreeResult={actions[props.modelName].onchangeModule}/>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.sup_module_name ? markIcon : null}
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`期望完成日期：`}>
                                <DatePicker
                                    defaultValue={taskData.expected_end_time ? moment(taskData.expected_end_time,dateFormat):""}
                                    format={dateFormat}
                                    className="datePicker"
                                    onChange={(date, dateString) => {
                                        handleChange({value: dateString, key: 'expected_end_time'})
                                    }}
                                    disabled={disabled}
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.expected_end_time ? markIcon : null}
                        </Col>

                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务汇报周期：`}>
                                <Select className="select"
                                        defaultValue={taskData.report_cycle}
                                        onChange={(e) => {
                                            handleChange({value: e, key: 'report_cycle'})
                                        }}
                                        disabled={disabled}
                                >
                                    <Select.Option key={'WEEK'}>{'每周'}</Select.Option>
                                    <Select.Option key={'DAY'}>{'每日'}</Select.Option>
                                </Select>
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.report_cycle ? markIcon : null}
                        </Col>

                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`重要程度：`}>
                                <RadioGroup defaultValue={taskData.importance}
                                            onChange={(e) => {
                                                handleChange({value: e.target.value, key: 'importance'})
                                            }}
                                            disabled={disabled}

                                >
                                    <Radio value={'重要'} className="radioA">重要</Radio>
                                    <Radio value={'不重要'}>不重要</Radio>
                                </RadioGroup>
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.importance ? markIcon : null}
                        </Col>

                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`紧急程度：`}>
                                <RadioGroup defaultValue={taskData.urgency}
                                            onChange={(e) => {
                                                handleChange({value: e.target.value, key: 'urgency'})
                                            }}
                                            disabled={disabled}
                                >
                                    <Radio value={'紧急'} className="radioA">紧急</Radio>
                                    <Radio value={'不紧急'}>不紧急</Radio>
                                </RadioGroup>
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.urgency ? markIcon : null}
                        </Col>

                    </Col>

                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务开始时间：`}>
                                <Input
                                    defaultValue={taskData.task_start_time}
                                    disabled
                                />
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务结束时间：`}>
                                <Input
                                    defaultValue={taskData.task_end_time}
                                    disabled
                                />
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务状态：`}>
                                <Input
                                    value={props.conditionTable ? props.conditionTable[taskData.task_condition_code] : null}
                                    disabled/>
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务完成进度：`}>
                                <Progress percent={taskData.complete || 0} strokeWidth={6}/>
                            </FormItem>
                        </Col>
                    </Col>

                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`创建人：`}>
                                <Input defaultValue={taskData.creator} disabled/>
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`创建时间：`}>
                                <Input defaultValue={taskData.create_time} disabled/>
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`修改人：`}>
                                <Input
                                    defaultValue={taskData.modifier}
                                    disabled
                                />
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`修改时间：`}>
                                <Input
                                    defaultValue={taskData.modify_time}
                                    disabled
                                />
                            </FormItem>
                        </Col>
                    </Col>


                    <Col sm={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`任务结果状态：`}>
                                <Input
                                    defaultValue={taskData.task_result_condition} disabled
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                        </Col>
                    </Col>
                </Row>
                <Row gutter={60}>
                    <Col sm={12}>
                        <Col sm={22}>
                            <FormItem labelCol={{span: 2}} style={{marginLeft: '3%'}}
                                      wrapperCol={{span: 20}} label={`承接人：`}>
                                <SelectEmployee
                                    employees={taskData.participants ? taskData.participants.split(",").map((item) => {
                                        return parseInt(item.split("~")[0]);
                                    }) : []
                                    }
                                    updatePerson={(e) => {
                                        handleChange({value: updatePerson(e), key: 'participants'})
                                    }
                                    }
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={5}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={5}>
                            {props.alterMark.participants ? markIcon : null}
                        </Col>
                    </Col>
                    <Col span={6}>
                        <Col sm={22}>
                            <FormItem {...formItemLayout} label={`附件：`}>
                                <Upload {...upLoadProps}
                                        fileList={taskData.attachment ? JSON.parse(taskData.attachment) : null}>
                                    <Button
                                        disabled={props.taskId === -1}
                                    >
                                        <Icon type="upload"/> 点击上传
                                    </Button>
                                </Upload>
                            </FormItem>
                        </Col>
                    </Col>
                </Row>
            </Panel>
        );
        const detail = (
            <Panel header="详细信息" key="2">
                <Row gutter={20}>
                    <Col span={24}>
                        <Col sm={22}>
                            <FormItem labelCol={{span: 2}} wrapperCol={{span: 20}} label="任务描述：">
                                <div style={{height: 200}}>
                                    <LzEditor
                                        active={true} lang="en"
                                        importContent={taskData.task_desc}
                                        cbReceiver={(e) => {
                                            handleChange({value: e, key: 'task_desc'})
                                        }}
                                        video={false}
                                        audio={false}
                                    />
                                </div>
                            </FormItem>
                        </Col>
                        <Col span={1} push={1}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} push={1}>
                            {props.alterMark.task_desc ? markIcon : null}
                        </Col>
                    </Col>
                    <Col span={24}>
                        <Col sm={22}>
                            <FormItem labelCol={{span: 2}} wrapperCol={{span: 20}} label="任务详细信息：">
                                <div style={{height: 200}}>
                                    <LzEditor
                                        cbReceiver={(e) => {
                                            handleChange({value: e, key: 'detail'})
                                        }}
                                        active={true} lang="en"
                                        importContent={taskData.detail}
                                        video={false}
                                        audio={false}
                                    />
                                </div>
                            </FormItem>
                        </Col>
                        <Col span={1} push={1}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} push={1}>
                            {props.alterMark.detail ? markIcon : null}
                        </Col>
                    </Col>
                    {summary}
                </Row>
            </Panel>
        );
        const opContent = (
            <Panel header="任务输出" key="3">
                <TaskOutput taskId={taskData.id} modelName={props.toModelName}
                            taskStatus={taskData.task_condition_code}/>
            </Panel>
        );
        const alterDescContent = (
            <AlterDescContent modalVisible={props.modalVisible} modelName={props.modelName}
            />
        );
        let opShowFlag = (taskData.task_condition_code === "JXZ" ||
            taskData.task_condition_code === "YWC" ||
            taskData.task_condition_code === "YKP");
        let alterShowFlag = (taskData.task_condition_code === "BGDTJ" );
        return (
            <div>
                <Collapse bordered={false} defaultActiveKey={['1']}>
                    {baseContent}
                    {detail}
                    {opShowFlag ? opContent : null}
                </Collapse>
                <Row className="list-action" type="flex" justify="center" style={{marginTop: 20}}>
                    <Col span={8}>
                        {bottom}
                    </Col>
                </Row>
                {alterShowFlag ? alterDescContent : null}
            </div>
        )
    }
    else if (props.loadedDataResponse === "LOADING") {
        return (
            <DataLoadingPage/>
        )
    }
    else if (props.loadedDataResponse === "FAILED") {
        return (
            <DataLoadFailed/>
        )
    } else {
        return (
            <DataLoadFailed/>
        )
    }
})

export default TaskInfo;
export {createTaskInfoModel};