//Created by wjy on 2017/9/26.
import React from 'react'
import "../../../styles/public/css/info.scss"
import "../tp.scss"
import mirror, {connect, actions, render} from 'mirrorx'
import LzEditor from 'react-lz-editor/editor/index'
import {getJson} from '../../request'
import {
    Form, Row, Col, message, Input, Select, Button, Icon, Radio, DatePicker, Progress, Upload,
    Collapse
} from 'antd';
import moment from 'moment';
import {createPlanAlterListModel} from "./alterAndProcess/PlanAlterList";
import PlanAlterList from "./alterAndProcess/PlanAlterList";
import PlanOutput, {createPlanOutputModel} from "./alterAndProcess/PlanOutput";
import Cache from "../../cache"
import AlterDescContent from "../task/alterAndProcess/AlterDesc";
import {createCreatePlanEvalModel} from "./evaluation/CreatePlanEvaluation";
import CreatePlanEvaluation from "./evaluation/CreatePlanEvaluation";
import DataLoadingPage from "../DataLoadingPage";
import DataLoadFailed from "../DataLoadFailed";

const {MonthPicker, RangePicker} = DatePicker;
const dateFormat = 'YYYY-MM-DD';
const FormItem = Form.Item;
const RadioGroup = Radio.Group;
const Panel = Collapse.Panel;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
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

const createPlanInfoModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            loadedDataResponse: "LOADING",
            planData: {},
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
                    planData: Object.assign({}, state.planData, obj),
                }
            },
            doAlterPlan(state, data) {
                return {
                    ...state,
                    planData: Object.assign({}, state.planData, {plan_condition_code: "BGDTJ"}),
                    contentReadonly: false,
                }
            },
            alterDescShowOrHide(state, data) {
                return {
                    ...state,
                    modalVisible: data,
                }
            },
            hdChangeAlter(state, data) {
                return {
                    ...state,
                    alterDesc: data
                }
            },
            alterDescShowOrHide(state, data) {
                return {
                    ...state,
                    modalVisible: data,
                }
            },
        },
        effects: {
            async initLoadData(ownProps, getState) {
                let curUser = await getJson("/api/task/getCurUser", {'method': 'GET'});
                let curEmployee = await getJson("/api/employee/manage/employee/getEmployeeInfoByUserId/" + curUser.id, {'method': 'GET'});
                let dicState = await actions[modelName].loadDic();
                let planState = await actions[modelName].loadPlanData({id: ownProps.planId, supTask: ownProps.supTask,creator:curUser.displayName});
                let alterMarkState = {};
                if (planState.planData.plan_condition_code === "DZX"){
                    alterMarkState =  await actions[modelName].getAlterMark({plan_id: ownProps.planId});
                }
                let taskListState = await actions[modelName].loadTaskList();
                let participantsState = null;
                if (planState.planData.task_id) {
                    participantsState = await actions[modelName].loadParticipants(planState.planData.task_id);
                }
                let newState = Object.assign({}, dicState, planState, {curUser}, {curEmployee}, taskListState, participantsState, alterMarkState);
                actions[modelName].setMirrorState(newState);
            },
            async getAlterMark(data, getState) {
                let alterMark = {};
                if (data.plan_id) {
                    let mark = await getJson('/api/plan/getAlterMark/' + data.plan_id, {'method': 'GET'});
                    mark.map((item) => {
                        let obj = {};
                        obj[item.field_name] = true;
                        alterMark = Object.assign({}, alterMark, obj);
                    });
                }
                return {alterMark};
            },

            async loadPlanData(data, getState) {
                let info = {};
                let loadData = "";
                if (data.id === -1 || !data.id) {
                    if (data.supTask) {
                        let participants = data.supTask.participants.split(",")
                        info = {
                            task_id: data.supTask.id,
                            task_name: data.supTask.task_name,
                            participants: participants,
                            sup_module_name:data.supTask.sup_module_name,
                            sup_project_name:data.supTask.sup_project_name,
                            task_type_code:data.supTask.task_type_code,
                        }
                    }
                    info =Object.assign({},info, {plan_condition_code: "CG",creator:data.creator || "",
                            create_time:moment().format('YYYY-MM-DD HH:mm')});
                    loadData = "SUCCESS";
                } else {
                    info = await getJson('/api/plan/getPlanInfoById/' + data.id);
                    if (info.status) {
                        loadData = "FAILED";
                    } else {
                        loadData = "SUCCESS";
                    }
                }
                let cd = info.plan_condition_code;
                let contentReadonly = false;
                if (cd === "JXZ" || cd === "YWC" || cd === "YKP" || cd === "DCJ" || cd === "BGDPG") {
                    contentReadonly = true;
                }
                return {planData: info, loadedDataResponse: loadData, contentReadonly};
            },
            async loadDic(data,                                                                                                       getState) {
                let planConditionList = await getJson('/api/plan/getPlanConditionDic');
                planConditionList = planConditionList.status ? {} : planConditionList;
                let conditionTable = {};
                for (let i = 0; i < planConditionList.length; i++) {
                    conditionTable[planConditionList[i].data_code] = planConditionList[i].data_name;
                }
                return {conditionTable};
            },
            async savePlanInfo(data, getState) {
                let saveData = data.planData || getState()[modelName].planData;
                if (!saveData.plan_name || !saveData.task_name || !saveData.plan_desc || !saveData.contractor) {
                    let mag = "请输入："
                    if (!saveData.plan_name) {
                        mag += "计划名称  "
                    }
                    if (!saveData.task_name) {
                        mag += "任务名称  "
                    }
                    if (!saveData.plan_desc) {
                        mag += "计划描述 "
                    }
                    if (!saveData.contractor) {
                        mag += "承接人 "
                    }
                    message.info(mag);
                    return;
                }
                let msg;
                if (data.opr === "save") {
                    msg = "保存成功"
                } else if (data.opr === "submit") {
                    actions[modelName].sendEmailForSubmit(); //提交发送邮件操作
                    saveData.plan_condition_code = "DZX";
                    msg = "提交成功"
                }else if (data.opr === "alter"){
                    saveData.plan_condition_code = "DZX";
                    msg = "提交成功"
                }else if (data.opr === "confirmWC"){
                    let actual_plan_end_time =  moment().format('YYYY-MM-DD HH:mm');
                    saveData = Object.assign({},getState()[modelName].planData,{actual_plan_end_time},
                        {plan_condition_code: "YWC"});
                }
                let response = await getJson('/api/plan/savePlanInfo', {body: saveData});
                message.success(msg);
                let planData = response.plan;
                let cd = planData.plan_condition_code;
                let contentReadonly = false;
                if (cd === "JXZ" || cd === "YWC" || cd === "YKP" || cd === "DCJ" || cd === "BGDPG") {
                    contentReadonly = true;
                }
                let alterMarkState = data.opr === "alter" ? await actions[modelName].getAlterMark({plan_id: planData.id}):{};
                let newState = Object.assign({}, alterMarkState, {planData}, {contentReadonly});
                actions[modelName].setMirrorState(newState);
            },
            async doSubmitPlan(data, getState) {
                let planData = getState()[modelName].planData;
                if (planData.plan_condition_code === "BGDTJ") {
                    actions[modelName].alterDescShowOrHide(true);
                } else {
                    actions[modelName].savePlanInfo({opr: "submit"})
                }
            },
            async loadTaskList(data, getState) {
                let response = await getJson('/api/task/getTaskList',{body:{
                    queryOptions:{isToAddNewPlan:true}
                }});
                let taskList = response.list;
                taskList = taskList.status ? {} : taskList;
                return {taskList};
            },
            async onChangeTask(data, getState) {
                let state = getState()[modelName];
                let task = data.split("~")
                let participantsState = await actions[modelName].loadParticipants(task[0]);
                let task_type_code=" ";
                if(task[4]=="软件研发"){
                    task_type_code="RJYF";
                }
                if(task[4]=="其他"){
                    task_type_code="others";
                }
                if(task[4]=="内部管理"){
                    task_type_code="NBGL";
                }
                if(task[4]=="员工培训"){
                    task_type_code="YGPX";
                }
                if(task[4]=="技术学习"){
                    task_type_code="JSXX";
                }
                let planData = Object.assign({}, state.planData, {contractor: ""}, {
                    task_id: task[0],
                    task_name: task[1],
                    sup_project_name:task[2],
                    sup_module_name:task[3],
                    task_type_code:task_type_code,
                });
                let newState = Object.assign({}, {planData}, participantsState);
                actions[modelName].setMirrorState(newState);
            },
            async handleFileChange(info, getState) {
                let fileList = info.fileList;
                let attachments = []
                let updateFlag = true;
                fileList.map((file) => {
                    if (file.response) {
                        let obj = {}
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
                    if (file.status !== "done") {
                        updateFlag = false
                    }
                })
                if (updateFlag) {
                    if (attachments === []) {
                        attachments = null
                    }
                    actions[modelName].updateAttachment(attachments)
                }
                actions[modelName].handleChange({value: JSON.stringify(attachments), key: 'attachment'})
            },
            async updateAttachment(attachmentInfo, getState) {
                let planId = getState()[modelName].planData.id;
                await getJson("/api/plan/updateAttachment", {body: {planId: planId, attachmentInfo: attachmentInfo}});
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
            async loadParticipants(data, getState) {
                let response = await getJson('/api/task/getTaskInfoById/' + data);
                let participants = null
                if (response.participants) {
                    participants = response.participants.split(",");
                }
                participants = response.status ? [] : participants;
                return {participants};
            },

            async doQueryAlter(data, getState) {
                let alterModelName = `planAlterList${data.planId}`;
                if (!actions[alterModelName]) {
                    createPlanAlterListModel(alterModelName);
                }
                let content = <PlanAlterList modelName={alterModelName} planId={data.planId}/>;
                actions.tabsTmpl.addTab({key: alterModelName, name: "计划变更查询", 'content': content});
            },
            async doCreateEval(data, getState) {
                let evalModelName = "newPlanEval";
                if (!actions[evalModelName]) {
                    createCreatePlanEvalModel(evalModelName);
                }
                let planData = getState()[modelName].planData;
                let employee = planData.contractor;
                let content = <CreatePlanEvaluation modelName={evalModelName} evalId={-1} planId={planData.id}
                                                employee={employee} planName = {planData.plan_name}/>;
                actions.tabsTmpl.addTab({key: evalModelName, name: "录入考评", 'content': content});
            },


            async submitAlter(data, getState) {
                actions[modelName].sendEmailForChange(data);
                await getJson("/api/plan/recordPlanAlter", {
                    body: {
                        planData: getState()[modelName].planData,
                        alterDesc: data
                    }
                });
                actions[modelName].savePlanInfo({opr: "alter"});
            },
            async doConfirm(data, getState) {

                actions[modelName].savePlanInfo({planData, opr: "confirm"});
            },

            async reloadData(data, getState) {
                let planState = await actions[modelName].loadPlanData({id: getState()[modelName].planData.id});
                let newState = planState.status ? [] : planState;
                actions[modelName].setMirrorState(newState);
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
                let empParticipants = getState()[modelName].planData.contractor;
                if(empParticipants!=null) {
                    let emailAdds = await actions[modelName].emailForAddress(empParticipants)
                    await getJson('/api/plan/sendBusinessEmail',
                        {
                            body: {
                                templet_code: "CJJHTZ",
                                plan_name: getState()[modelName].planData.plan_name,
                                creator: getState()[modelName].planData.creator,
                                plan_start_time: getState()[modelName].planData.plan_start_time,
                                plan_end_time: getState()[modelName].planData.plan_end_time,
                                receivers: emailAdds,
                            }
                        })
                }
            },
            //邮件变更通知
            async sendEmailForChange(alterDesc, getState){
                let prePlanId = getState()[modelName].planData.id;
                let prePlanInfo = await getJson('/api/plan/getPlanInfoById/' + prePlanId, {'method': 'GET'});
                let prePlanName = prePlanInfo.plan_name
                let preParticipants   = prePlanInfo.contractor
                let alertData = getState()[modelName].planData
                let nowPctNames = splitPerson(alertData.contractor,2)
                if(preParticipants!=null) {
                    let emailAdds = await actions[modelName].emailForAddress(preParticipants)
                    await getJson('/api/plan/sendBusinessEmail',
                        {
                            body: {
                                templet_code: "JHBGTZ",
                                pre_plan_name: prePlanName,
                                plan_name:alertData.plan_name,
                                nowPctNames: nowPctNames.join(","),
                                plan_end_time: alertData.plan_end_time || "当天",
                                alterDesc:alterDesc,
                                receivers: emailAdds,
                            }
                        })
                }
            }
        }
    });
    render();
};

const PlanInfo = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].loadedDataResponse === "LOADING") {
        actions[modelName].initLoadData(ownProps);
    }
    return state[modelName]
})(props => {
    let planDataToSave = props.planData;
    let modelName = props.modelName;
    let bottom;
    let disabled = props.contentReadonly;
    if (props.loadedDataResponse === "SUCCESS") {
        let editPermissionFlag = (props.curUser.id === props.planData.creator_id || !props.planData.id);

        const upLoadProps = {
            action: '/api/file/publicfile/uploadFile',
            headers: {token: Cache.getAccessToken()},
            data: function(file){
                return {
                    _fileName : encodeURI(file.name),
                    _id: props.planId,
                    _module: "JHFJ"
                }
            },
            onChange: actions[props.modelName].handleFileChange,
            onRemove: actions[props.modelName].deleteFile,
            onPreview: actions[props.modelName].downloadFile,
            multiple: true,
        };
        let closeButton = (
            <Button size="large"
                    onClick={() => {
                        actions.tabsTmpl.closeCurTab()
                    }}
            ><Icon type="cross-circle"/>关闭</Button>);
        let alterButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doAlterPlan();
                    }}
            ><Icon type="exclamation-circle"/> 变更</Button>
        )
        let queryAlterButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doQueryAlter({planId: props.planData.id});
                    }}
            >
                <Icon type="bars"/>
                变更记录</Button>
        );
        let createEvalButton = (
            <Button size="large"
                    onClick={() => {
                        actions[props.modelName].doCreateEval()
                    }}
            ><Icon type="message"/>考评</Button>);
        let saveButton = (
            <Button size="large" onClick={() => {
                actions[props.modelName].savePlanInfo({opr: "save"})
            }}><Icon type="save"/>保存</Button>
        );
        let finishButton = (
            <Button size="large" onClick={() => {
                actions[props.modelName].savePlanInfo({opr: "confirmWC"})
            }}><Icon type="save"/>确认完成</Button>
        );
        let submitButton = (
            <Button size="large" onClick={() => {
                actions[props.modelName].doSubmitPlan()
            }}><Icon type="check-circle"/>提交</Button>);
        if (planDataToSave.plan_condition_code === "CG" || planDataToSave.plan_condition_code === "BGDTJ") {
            bottom = <div>
                {editPermissionFlag ? saveButton:null}&nbsp;&nbsp;
                {editPermissionFlag ? submitButton:null}&nbsp;&nbsp;
                {closeButton}
            </div>
        } else if (planDataToSave.plan_condition_code === "DZX" || planDataToSave.plan_condition_code === "JXZ") {
            bottom = <div>
                {editPermissionFlag ? alterButton:null}&nbsp;&nbsp;
                {editPermissionFlag ? finishButton:null}&nbsp;&nbsp;
                {queryAlterButton}&nbsp;&nbsp;
                {closeButton}&nbsp;&nbsp;
            </div>
        } else if (planDataToSave.plan_condition_code === "YWC" || planDataToSave.plan_condition_code === "YKP"){
            bottom = <div>
                {queryAlterButton}&nbsp;&nbsp;
                {createEvalButton}&nbsp;&nbsp;
                {closeButton}&nbsp;&nbsp;
            </div>
        }else{
            bottom = <div>
                {closeButton}&nbsp;&nbsp;
            </div>
        }
        let taskList
        if (props.taskList && props.taskList.length) {
            taskList = props.taskList.map((item) => (
                    <Select.Option key={item.id + "~" + item.task_name+"~"+item.sup_project_name+"~"+item.sup_module_name+"~"+item.task_type}>
                        {item.task_name}
                    </Select.Option>
                )
            )
        }
        let employeeDic
        if (props.participants && props.participants.length) {
            employeeDic = props.participants.map((item) => (
                    <Select.Option key={item}>{item.split("~")[2]}</Select.Option>
                )
            )
        }

        let summary
        if (planDataToSave.plan_condition_code === "YWC") {
            summary =
                <Col span={24}>
                    <Col sm={22} pull={1} style={{marginLeft: 35}}>
                        <FormItem labelCol={{span: 2}} wrapperCol={{span: 20}} label="计划结果总结：">
                            <div style={{height: 200}}>
                                <LzEditor
                                    active={true} lang="en"
                                    cbReceiver={(e) => {
                                        planDataToSave.plan_result_summary = e
                                    }}
                                    video={false}
                                    audio={false}
                                    importContent={planDataToSave.plan_result_summary}/>
                            </div>
                        </FormItem>
                    </Col>
                </Col>
        }
        //计划输出
        let modelNames = 'modelName'
        if (!actions[modelNames]) {
            createPlanOutputModel(modelNames);
        }
        const outPutContext = (
            <Panel header="计划输出" key="3">
                <PlanOutput planId={planDataToSave.id} modelName={modelNames}
                            planStatus={planDataToSave.plan_condition_code}/>
            </Panel>
        );
        const markIcon = (<Icon className="alterMark" type="edit"/>);
        const alterDescContent = (
            <AlterDescContent modalVisible={props.modalVisible} modelName={props.modelName}
                              alterDesc={props.alterDesc}
            />);
        const baseInfo = ( <Panel header="基本信息" key="1">

            <Row gutter={60}>
                <Col sm={6}>
                    <Col sm={23}>
                        <FormItem {...formItemLayout} label={`计划名称：`}
                                  validateStatus={planDataToSave.plan_name ? '' : 'error'}>
                            <Input
                                defaultValue={planDataToSave.plan_name}
                                onChange={(e) => {
                                    actions[modelName].handleChange({value: e.target.value, key: 'plan_name'})
                                }}
                                disabled={disabled}
                            />
                        </FormItem>
                    </Col>
                    <Col span={1} pull={3}>
                        <span className="star">*</span>
                    </Col>
                    <Col span={1} pull={3}>
                        {props.alterMark.plan_name ? markIcon : null}
                    </Col>
                </Col>
                <Col sm={6}>
                    <Col sm={23}>
                        <FormItem {...formItemLayout} label={`任务名称：`}
                                  validateStatus={planDataToSave.task_name ? '' : 'error'}>
                            <Select size="default"
                                    style={{width: '100%'}}
                                    allowClear
                                    defaultValue={planDataToSave.task_name}
                                    onChange={(e) => {
                                        actions[modelName].onChangeTask(e)
                                        //actions[modelName].handleChange({value: e, key: 'task_name'})
                                    }}
                                    disabled={disabled}

                                >
                                    {taskList}
                                </Select>
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
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`计划状态：`}>
                                <Input value={props.conditionTable? props.conditionTable[planDataToSave.plan_condition_code]:''}
                                       disabled/>
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`计划结果状态：`}>
                                <Input defaultValue={planDataToSave.plan_result_condition_code} disabled/>
                            </FormItem>
                        </Col>
                    </Col>
                </Row>
                <Row gutter={60}>
                    <Col sm={6}>
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`计划开始日期：`}>
                                <DatePicker
                                    defaultValue={planDataToSave.plan_start_time ? moment(planDataToSave.plan_start_time,dateFormat):""}
                                    format={dateFormat}
                                    className="datePicker"
                                    onChange={(date, dateString) => {
                                        actions[modelName].handleChange({value: dateString, key: 'plan_start_time'})
                                    }}
                                    disabled={disabled}
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.plan_start_time ? markIcon : null}
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`计划结束日期：`}>
                                <DatePicker
                                    defaultValue={planDataToSave.plan_end_time ? moment(planDataToSave.plan_end_time,dateFormat):""}
                                    format={dateFormat}
                                    className="datePicker"
                                    onChange={(date, dateString) => {
                                        actions[modelName].handleChange({value: dateString, key: 'plan_end_time'})
                                    }}
                                    disabled={disabled}
                                />
                            </FormItem>
                        </Col>
                        <Col span={1} pull={3}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.plan_end_time ? markIcon : null}
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`实际开始时间：`}>
                                <Input
                                    defaultValue={planDataToSave.actual_plan_start_time}
                                    disabled
                                />
                            </FormItem>
                        </Col>
                    </Col>
                    <Col sm={6}>
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`实际结束时间：`}>
                                <Input
                                    defaultValue={planDataToSave.actual_plan_end_time}
                                    disabled
                                />
                            </FormItem>
                        </Col>
                    </Col>
                </Row>
                <Row gutter={60}>
                    <Row gutter={60}>
                        <Col sm={6}>
                            <Col sm={23}>
                                <FormItem {...formItemLayout} label={`创建人：`}>
                                    <Input defaultValue={planDataToSave.creator} disabled/>
                                </FormItem>
                            </Col>
                        </Col>
                        <Col sm={6}>
                            <Col sm={23}>
                                <FormItem {...formItemLayout} label={`创建时间：`}>
                                    <Input defaultValue={planDataToSave.create_time} disabled/>
                                </FormItem>
                            </Col>
                        </Col>
                        <Col sm={6}>
                            <Col sm={23}>
                                <FormItem {...formItemLayout} label={`修改人：`}>
                                    <Input
                                        defaultValue={planDataToSave.modifier}
                                        disabled
                                    />
                                </FormItem>
                            </Col>
                        </Col>
                        <Col sm={6}>
                            <Col sm={23}>
                                <FormItem {...formItemLayout} label={`修改时间：`}>
                                    <Input
                                        defaultValue={planDataToSave.modify_time}
                                        disabled
                                    />
                                </FormItem>
                            </Col>
                        </Col>
                    </Row>
                </Row>
                <Row gutter={60}>
                    <Col sm={12}>
                        <Col sm={22} style={{marginLeft:26}}>
                            <FormItem labelCol={{span: 2}}
                                      wrapperCol={{span: 14}} label={`承接人：`}>
                                <Select className="select"
                                        value={planDataToSave.contractor}
                                        onChange={(e) => {
                                            actions[modelName].handleChange({value: e, key: 'contractor'})
                                        }}
                                        disabled={disabled}
                                >
                                    {employeeDic}
                                </Select>
                            </FormItem>
                        </Col>
                        <Col span={1} pull={7}>
                            <span className="star">*</span>
                        </Col>
                        <Col span={1} pull={3}>
                            {props.alterMark.contractor ? markIcon : null}
                        </Col>
                    </Col>
                    <Col span={6}>
                        <Col sm={23}>
                            <FormItem {...formItemLayout} label={`附件：`}>
                                <Upload {...upLoadProps}
                                        fileList={planDataToSave.attachment? JSON.parse(planDataToSave.attachment):null}>
                                <Button
                                        disabled = {props.planId===-1}
                                    >
                                        <Icon type="upload"/> 点击上传
                                    </Button>
                                </Upload>
                            </FormItem>
                        </Col>
                    </Col>
                </Row>
            </Panel>);
        const otherInfo = ( <Panel header="详细信息" key="2">
            <Row>
                <Col span={24}>
                    <Col sm={22} style={{marginLeft: 28}}>
                        <FormItem labelCol={{span: 1}} wrapperCol={{span: 20}} label="计划描述：">
                            <div style={{height: 200}}>
                                <LzEditor
                                    active={true} lang="en"
                                    importContent={planDataToSave.plan_desc}
                                    cbReceiver={(e) => {
                                        planDataToSave.plan_desc = e
                                    }}
                                    video={false}
                                    audio={false}
                                />
                            </div>
                        </FormItem>
                    </Col>
                    <Col span={1} pull={3}>
                        {props.alterMark.plan_desc ? markIcon : null}
                    </Col>
                </Col>

                {summary}
            </Row>
        </Panel>);
        return (
            <div>
                <Collapse bordered={false} defaultActiveKey={['1']}>
                    {baseInfo}
                    {otherInfo}
                    {outPutContext}
                </Collapse>
                <Row className="list-action" style={{marginTop: 20}}>
                    <Col span={8} offset={10}>
                        {bottom}
                    </Col>
                </Row>
                {alterDescContent}
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

export default PlanInfo;
export {createPlanInfoModel};