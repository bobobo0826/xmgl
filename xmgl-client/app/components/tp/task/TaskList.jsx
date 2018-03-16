//Created by wjy on 2017/9/26.
import React from 'react'
import mirror, {connect, actions, render} from 'mirrorx'
import {getJson} from '../../request'
import {ListHead, ListItem, ToolBox} from '../../public/list_component';
import {message, Pagination} from 'antd';
import TaskInfo, {createTaskInfoModel} from './TaskInfo';
import {createTaskOutputModel} from './alterAndProcess/TaskOutput'
import CreateEvaluation, {createCreateTaskEvalModel} from './evaluation/CreateEvaluation';
import TaskEvaluateResult, {taskEvaluateResultModel} from './evaluation/TaskEvaluateResult';
import EmployeeEvaluateResultList, {employeeEvaluateResultModel} from './evaluation/EmployeeEvaluateResultList';
import '../tp.scss';
const splitPerson = function (data,index) {
    let firstSplit = data.split(",");
    let value = [];
    firstSplit.map((item)=>{
        let secondSplit = item.split("~");
        value.push(secondSplit[index])
    })
    return value

};

const  dateDiff = function (startDate, endDate){
        var aDate, oDate1, oDate2, iDays ;
        aDate = startDate.split('-');
        oDate1 = new Date(aDate[1]+'-'+aDate[2]+'-'+aDate[0]) ;
        aDate = endDate.split('-');
        oDate2 = new Date(aDate[1]+'-'+ aDate[2] +'-'+aDate[0]);
        iDays = parseInt(Math.abs(oDate1 -oDate2)/1000/60/60/24); //把相差的毫秒数转换为天数
        return iDays ;
}

const createTaskListModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            columns: [
                {
                    field: 'id',
                    hidden: true,
                    name: 'ID',
                },
                {
                    field: 'task_name',
                    hidden: false,
                    name: '名称',
                    col: 2,
                },
                {
                    field: 'sup_project_name',
                    hidden: false,
                    name: '所属项目',
                    col: 2,
                    // formatter: function (row, data, index) {
                    //     return (row.sup_project_name.split(",")[1])
                    // }
                },
                {
                    field: 'task_condition',
                    hidden: false,
                    name: '状态',
                    col: 2,
                },
                {
                    field: 'task_start_time',
                    hidden: true,
                    name: '开始时间',
                    col: 2,
                },
                {
                    field: 'task_end_time',
                    hidden: true,
                    name: '结束时间',
                    col: 2,
                },
                {
                    field: 'period',
                    hidden: false,
                    name: '起止时间',
                    col: 2,
                    formatter: function (row, data, index) {
                        return ((row.task_start_time && row.task_end_time) ? row.task_start_time + "~" + row.task_end_time : '');
                    }
                },
                {
                    field: 'complete',
                    hidden: false,
                    name: '完成进度',
                    col: 2,
                    formatter: function (row, data, index) {
                        return (row.complete + "%")
                    }
                },
                {
                    field: 'task_type',
                    hidden: false,
                    name: '类型',
                    col: 2,
                },
                {
                    field: 'importance',
                    hidden: false,
                    name: '重要性',
                    col: 2,
                },
                {
                    field: 'urgency',
                    hidden: false,
                    name: '紧急性',
                    col: 2,
                },
                {
                    field: 'participants',
                    hidden: true,
                    name: '承接人',
                    col: 2,
                },{
                    field: 'expectedEndTime',
                    hidden: true,
                    name: '预计完成时间',
                    col: 2,
                },
/*                {
                    field: 'task_result_condition',
                    hidden: false,
                    name: '结果状态',
                    col: 2,
                },*/
                {
                    field: 'creator',
                    hidden: false,
                    name: '创建人',
                    col: 2,
                },
                {
                    field: 'create_time',
                    hidden: false,
                    name: '创建时间',
                    col: 2,
                },
            ],
            loadingTasks: true,
            queryOptions: {},
            curPage: 1,
            pageSize: 10,
            totalItem: 0,
        },
        reducers: {

            setTaskList(state, data) {
                return {
                    ...state,
                    loadingTasks: false,
                    list: data.list,
                    totalItem: data.totalItem ? data.totalItem :0,
                }
            },
            doQuery(state, data) {
                return {
                    ...state,
                    queryOptions: data || state.queryOptions,
                    loadingTasks: true,
                    curPage: 1,
                }
            },
            onChangePage(state, data) {
                return {
                    ...state,
                    curPage: data,
                    loadingTasks: true,
                }
            },
            onShowSizeChange(state, data) {
                return {
                    ...state,
                    pageSize: data.pageSize,
                    curPage: data.current,
                    loadingTasks: true,
                }
            }
        },
        effects: {
            async getTaskList(data, getState) {
                let queryOptions = Object.assign({}, {queryType: data}, getState()[modelName].queryOptions);
                let curPage = getState()[modelName].curPage;
                let pageSize = getState()[modelName].pageSize;
                let response = await getJson('/api/task/getTaskList',
                    {
                        body: {
                            queryOptions: queryOptions,
                            curPage: curPage,
                            pageSize: pageSize
                        }
                    });
                let list = response.list;
                if (!list) {
                    list = []
                }
                actions[modelName]
                    .setTaskList({list: list, totalItem: response.totalitem});
            },
            async deleteTask(data, getState) {
                let response = await getJson('/api/task/deleteTask', {
                    body: {
                        id: Number(data.id)
                    }
                });
                //删除任务下面的计划
                await getJson('/api/plan/deletePlanByTaskId',{body:{taskId:data.id}});
                if (response.success) {
                    message.success("删除成功！");
                    actions[modelName].doQuery();
                }
            },
            async cancelTask(data,getState) {
                let response = await getJson('/api/task/cancelTask', {
                    body: {
                        id: Number(data.id)
                    }
                });
                //注销任务下面的计划
                await getJson('/api/plan/cancelPlanByTaskId',{body:{taskId:data.id}});
                if (response.success) {
                    message.success("注销成功！");
                    actions[modelName].doQuery();
                }
            },
            async editInfo(data, getState) {
                let name = `taskInfo${data.id}`;
                let toModelName = `taskInfo${data.id}Output`
                if (!actions[name]) {
                    createTaskInfoModel(name);
                    createTaskOutputModel(toModelName);

                }
                let content = (<TaskInfo
                    taskId={data.id} modelName={name} toModelName={toModelName}/>);
                actions.tabsTmpl.addTab({key: name, name: data.name, content: content});
            },
            async doEval(data, getState) {
                let content;
                let tabsName;
                let evalModelName;
                switch (data.type) {
                    case "createEval":
                        evalModelName = `newTaskEval${data.id}`;
                        if (!actions[evalModelName]) {
                            createCreateTaskEvalModel(evalModelName);
                        }
                        content = <CreateEvaluation modelName={evalModelName} evalId={-1} taskId={data.id}
                                                    employee={data.employee} taskName={data.name}/>;
                        tabsName = `${data.name}录入考评`;
                        // actions.createEvaluation.setForceQuery({forceQuery:true});
                        break;
                    case "taskEval":
                        evalModelName = `taskEvaluateResult${data.id}`;
                        if (!getState()[evalModelName]) {
                            taskEvaluateResultModel(evalModelName);
                        }
                        content = <TaskEvaluateResult curTaskId={data.id} modelName={evalModelName} forceQuery={true}/>;
                        tabsName = "任务考评结果列表";
                        //actions.taskEvaluateResult.setCurTaskId({curTaskId:data.id,forceQuery:true});
                        break;
                    case "employeeEval":
                        evalModelName = `employeeEvaluateResult${data.id}`;
                        if (!getState()[evalModelName]) {
                            employeeEvaluateResultModel(evalModelName);
                        }
                        let employee = data.employee.split(",");
                        let str
                        let employee_id = [];
                        let k = 0;
                        let employeeId = "";
                        for (let i = 0; i < employee.length; i++) {
                            str = employee[i].split("~");
                            employee_id[k] = str[0];
                            k++;
                        }
                        employeeId = employee_id.join(",");
                        content = <EmployeeEvaluateResultList employeeId={employeeId} modelName={evalModelName} forceQuery={true}
                                                              curTaskId={data.id}/>;
                        tabsName = "员工考评结果列表";
                        // actions.employeeEvaluateResult.setEmployeeId({employee:data.employee,forceQuery:true});
                        break;
                    default:
                        break;
                }
                actions.tabsTmpl.addTab({key: evalModelName, name: tabsName, 'content': content});
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
            async sendEmailSubmit(data,getState){
                let allData = data.row

                if(allData){
                   let emailAdds = await actions[modelName].emailForAddress(allData.participants)
                    let emailValue = [];
                    let emailCreator = await getJson("/api/employee/manage/employee/getEmployeeInfoById/" +allData.creator_id,{'method': 'GET'});
                    let obj = JSON.parse(emailCreator.basic_info);
                    emailValue.push(obj.email);
                    let dataDifference =dateDiff(data.nowDate,allData.expected_end_time)

                   await getJson('/api/task/sendBusinessEmail',{
                       body:{
                           templet_code: "RWCSBJ_R",
                           task_name : allData.task_name,
                           creator : allData.creator,
                           expected_end_time : allData.expected_end_time,
                           timeDiff :dataDifference,
                           receivers: emailAdds
                       },
                   })

                    await getJson('/api/task/sendBusinessEmail',{
                        body:{
                            templet_code: "RWCSBJ_C",
                            task_name : allData.task_name,
                            expected_end_time : allData.expected_end_time,
                            timeDiff :dataDifference,
                            receivers: emailValue
                        },
                    })
                }
            }


        }
    });
    render();
};

const TaskList = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].loadingTasks) {
        actions[modelName].getTaskList(ownProps.queryType)
    }
    return state[modelName];
})(props => {
        let content = (<div>暂无数据</div>);
        let columns = props.columns;
        let list = props.list;
        columns = columns.concat(props.addColumns);
        if (list && list.length) {
            content = list.map((item) => (
                    <ListItem key={item.id + Math.random()} columns={columns} data={item}/>
                )
            )
        }
        return (
            <div className="list">
                <ListHead columns={columns}/>
                {content}
                <Pagination className="list-pagination"
                            showSizeChanger
                            showQuickJumper
                            defaultCurrent={props.curPage}
                            total={props.totalItem}
                            onChange={(e) => actions[props.modelName].onChangePage(e)}
                            onShowSizeChange={(current, pageSize) =>
                                (actions[props.modelName].onShowSizeChange({current: current, pageSize: pageSize}))}
                            showTotal = {() => "共"+props.totalItem+"条数据"}
                />
            </div>
        )
    }
)

export default TaskList;
export {createTaskListModel};