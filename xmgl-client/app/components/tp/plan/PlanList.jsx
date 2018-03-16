import React from 'react'
import mirror, {connect, actions, render} from 'mirrorx'
import {getJson} from '../../request'
import {ListHead, ListItem, ToolBox} from '../../public/list_component';
import {Row, Col, message} from 'antd';
import PlanInfo, {createPlanInfoModel} from './PlanInfo';
import CreatePlanEvaluation, {createCreatePlanEvalModel} from './evaluation/CreatePlanEvaluation';
import PlanEvaluateResult, {planEvaluateResultModel} from './evaluation/PlanEvaluateResult';
import PlanEmployeeEvaResult, {planEmployeeEvaResultModel} from './evaluation/PlanEmployeeEvaResult';
import '../tp.scss';
import Pagination from "antd/es/pagination/Pagination";
import PlanTrack, {createPlanTrackModel} from './alterAndProcess/PlanTrack'
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

const createPlanListModel = function (modelName) {
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
                    field: 'task_id',
                    hidden: true,
                    name: '任务ID',
                },
                {
                    field: 'plan_name',
                    hidden: false,
                    name: '计划名称',
                    col: 2,
                },
                {
                    field: 'task_name',
                    hidden: false,
                    name: '任务名称',
                    col: 2,
                },
                {
                    field: 'plan_condition',
                    hidden: false,
                    name: '状态',
                    col: 1,
                },
                {
                    field: 'plan_start_time',
                    hidden: false,
                    name: '计划开始时间',
                    col: 2,
                },
                {
                    field: 'plan_end_time',
                    hidden: false,
                    name: '计划结束时间',
                    col: 2,
                },
                /*{
                    field: 'period',
                    hidden: false,
                    name: '计划起始时间',
                    col: 2,
                    formatter: function (row, data, index) {
                        return ((row.plan_start_time && row.plan_start_time) ? row.plan_start_time + "~" + row.plan_start_time : '');
                    }
                },*/
                {
                    field: 'actual_plan_start_time',
                    hidden: false,
                    name: '实际开始时间',
                    col: 2,
                },
                {
                    field: 'actual_plan_end_time',
                    hidden: false,
                    name: '实际结束时间',
                    col: 2,
                },
                /*{
                    field: 'actual_period',
                    hidden: false,
                    name: '实际起始时间',
                    col: 2,
                    formatter: function (row, data, index) {
                        return ((row.actual_plan_start_time && row.actual_plan_end_time) ? row.actual_plan_start_time + "~" + row.actual_plan_end_time : '');
                    }
                },*/
                {
                    field: 'plan_result_condition',
                    hidden: false,
                    name: '计划结果状态',
                    col: 2,

                },
                {
                    field: 'contractor',
                    hidden: false,
                    name: '承接人',
                    col: 1,
                    formatter: function (row, data, index) {
                        return (data ? data.split("~")[2] : null);
                    }
                },
                {
                    field: 'creator',
                    hidden: false,
                    name: '创建人',
                    col: 1,
                },
                // {
                //     field: 'create_time',
                //     hidden: false,
                //     name: '创建时间',
                //     col: 2,
                // },
                {
                    field: 'modify_time',
                    hidden: false,
                    name: '最后修改时间',
                    col: 2,
                },
            ],
            loadingPlans: true,
            queryOptions: {},
            curPage: 1,
            pageSize: 10,
            totalItem: 0,
        },
        reducers: {
            setPlanList(state, data) {
                return {
                    ...state,
                    loadingPlans: false,
                    list: data.list,
                    totalItem: data.totalItem ? data.totalItem :0,

                }
            },
            doQuery(state, data) {
                return {
                    ...state,
                    queryOptions: data || state.queryOptions,
                    loadingPlans: true,
                    curPage: 1,

                }
            },
            onChangePage(state, data) {
                return {
                    ...state,
                    curPage: data,
                    loadingPlans: true,
                }
            },
            onShowSizeChange(state, data) {
                return {
                    ...state,
                    pageSize: data.pageSize,
                    curPage: data.current,
                    loadingPlans: true,
                }
            }
        },
        effects: {
            async getPlanList(data, getState) {
                let queryOptions = Object.assign({}, {queryType: data}, getState()[modelName].queryOptions);
                let curPage = getState()[modelName].curPage;
                let pageSize = getState()[modelName].pageSize;
                let response = await getJson('/api/plan/getPlanList',
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
                    .setPlanList({list, totalItem: response.totalitem})
            },

            async deletePlan(data, getState) {
                let response = await getJson('/api/plan/deletePlanById', {
                    body: {
                        id: Number(data.id)
                    }
                })
                if (response.success) {
                    message.success("删除成功！");
                    actions[modelName].doQuery();
                }
            },
            async cancelPlan(data, getState) {
                let response = await getJson('/api/plan/cancelPlan', {
                    body: {
                        id: Number(data.id)
                    }
                });
                if (response.success) {
                    message.success("注销成功！");
                    actions[modelName].doQuery();
                }
            },
            async editInfo(data, getState) {
                let modelName = `planInfo${data.id}`;
                if (!actions[modelName]) {
                    createPlanInfoModel(modelName);
                }
                let content = (<PlanInfo
                    planId={data.id} modelName={modelName}/>);
                actions.tabsTmpl.addTab({key: modelName, name: data.name, 'content': content});
            },
            async planTrack(data,getState){
                let trackModelName = `planTrack${data.id}`
                let tabsName = `${data.name}的跟踪日志`
                if(!actions[trackModelName]){
                    createPlanTrackModel(trackModelName);
                    actions[trackModelName].setQueryOptions({plan_id:data.id,plan_name:data.name})
                }
                let content = (<PlanTrack modelName = {trackModelName} />)
                actions.tabsTmpl.addTab({key: trackModelName, name: tabsName, 'content': content});
            },
            async doEval(data, getState) {
                let content;
                let tabsName;
                let evalModelName;
                switch (data.type) {
                    case "createPlanEval":
                        evalModelName = `newPlanEval${data.id}`;
                        if (!actions[evalModelName]) {
                            createCreatePlanEvalModel(evalModelName);
                        }
                        content = <CreatePlanEvaluation modelName={evalModelName} evalId={-1} planId={data.id}
                                                        employee={data.employee} planName={data.name}/>;
                        tabsName = `${data.name}录入考评`;
                        // actions.createEvaluation.setForceQuery({forceQuery:true});
                        break;
                    case "planEval":
                        let name = `planEvaluateResult${data.id}`;
                        if (!getState()[name]) {
                            planEvaluateResultModel(name);
                        }
                        content = <planEvaluateResult curPlanId={data.id} modelName={name} forceQuery={true}/>;
                        tabsName = "计划考评结果列表";
                        //actions.taskEvaluateResult.setCurTaskId({curTaskId:data.id,forceQuery:true});
                        break;
                    case "employeeEval":
                        name = `employeeEvaluateResult${data.id}`;
                        if (!getState()[name]) {
                            planEmployeeEvaResultModel(name);
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
                        content = <PlanEmployeeEvaResult employeeId={employeeId} modelName={name} forceQuery={true}
                                                         curPlanId={data.id}/>;
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
                    let emailAdds = await actions[modelName].emailForAddress(allData.contractor)
                    let emailValue = [];
                    let emailCreator = await getJson("/api/employee/manage/employee/getEmployeeInfoById/" +allData.creator_id,{'method': 'GET'});
                    let obj = JSON.parse(emailCreator.basic_info);
                    emailValue.push(obj.email);
                    let dataDifference =dateDiff(data.nowDate,allData.plan_end_time)

                    await getJson('/api/plan/sendBusinessEmail',{
                        body:{
                            templet_code: "JHCSBJ_R",
                            plan_name : allData.plan_name,
                            creator : allData.creator,
                            plan_end_time : allData.plan_end_time,
                            timeDiff :dataDifference,
                            receivers: emailAdds
                        },
                    })

                    await getJson('/api/plan/sendBusinessEmail',{
                        body:{
                            templet_code : "JHCSBJ_C",
                            plan_name : allData.plan_name,
                            plan_end_time : allData.plan_end_time,
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

const PlanList = connect((state, ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].loadingPlans) {
        actions[modelName].getPlanList(ownProps.queryType)
    }
    return state[modelName];
})(props => {
        let content = (<div>暂无数据</div>);
        let columns = props.columns;
        let list = props.list;

        columns = columns.concat(props.addColumns);
        if (list && list.length) {
            content = list.map((item) => {
                return (
                    <ListItem key={item.id} columns={columns} data={item}/>

                )
            })
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
                            showTotal={() => "共" + props.totalItem + "条数据"}
                />
            </div>
        )
    }
)

export default PlanList
export {createPlanListModel};