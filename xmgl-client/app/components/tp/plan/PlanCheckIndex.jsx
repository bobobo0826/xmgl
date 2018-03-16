import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
import PlanList, {createPlanListModel} from './PlanList'
import QueryConditionPlan from './QueryConditionPlan'
import factory from '../../ComponentFactory'
import '../tp.scss';
import {getJson} from '../../request'

const modelName = "planCheckList";
const getNowFormatDate =function() {
    let date = new Date();
    const seperator1 = "-";
    let month = date.getMonth() + 1;
    let strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
    return currentdate;
}
const evalColumns = [{
    field: '',
    hidden: false,
    name: '操作',
    col: 1,
    formatter: function (row, data, index) {//显示操作按钮
        let evalFlag = (row.plan_condition === "已完成" || row.plan_condition === "已考评");
        let cancelFlag = (row.plan_condition === "进行中");
        let cancelButton = (
            <span onClick={() => {
                actions[modelName].cancelPlan({
                    'id': row.id
                })
            }} className="ac-delete">注销</span>
        )
        let evalButton = (<span onClick={() => {
            actions[modelName].doEval(
                {
                    'id': row.id,
                    'name': row.plan_name,
                    'employee': row.contractor,
                    'type': "createPlanEval"
                })
        }} className="ac-other">考评</span>)
        let expectedButton = null;

        if(row.plan_end_time<getNowFormatDate()) {
            expectedButton = (<span onClick={()=>{actions[modelName].sendEmailSubmit({'row':row,'nowDate':getNowFormatDate()})}} className="ac-delete">延迟警告</span>)
        }
        return (
            <div className="list-item-action">
                        <span onClick={() => {
                            actions[modelName].editInfo({'id': row.id, 'name': row.plan_name})
                        }} className="ac-edit">详情</span>
                <span onClick={() => {
                    actions[modelName].planTrack(
                        {
                            'id': row.id,
                            'name': row.plan_name,
                        })
                }} className="ac-other">跟踪</span>
               {/* {evalFlag ? evalButton : null}*/}
                {cancelFlag ? cancelButton : null}
                {cancelFlag ? expectedButton : null}
            </div>
        );
    }
}, {
    field: '',
    name: '考评查询',
    hidden: false,
    col: 3,
    formatter: function (row, data, index) {
        return (
            <div className="list-item-action">
                        <span onClick={() => {
                            actions[modelName].doEval(
                                {
                                    'id': row.id,
                                    'name': row.plan_name,
                                    'employee': row.contractor,
                                    'type': "createPlanEval"
                                })
                        }} className="ac-other">考评</span>
                        <span onClick={() => {
                            actions[modelName].doEval({
                                'id': row.id,
                                'name': row.plan_name,
                                'type': "planEval"
                            })
                        }} className="ac-other">计划考评</span>
                        <span onClick={() => {
                            actions[modelName].doEval({
                                'id': row.id,
                                'employee': row.contractor,
                                'type': "employeeEval",
                                'name': row.plan_name,
                            })
                        }} className="ac-other">员工考评</span>
            </div>
        );
    }

}];


const PlanCheckIndex = () => {
    if (!actions[modelName]) {
        createPlanListModel(modelName);
    }
    let listContent = (
        <PlanList addColumns={evalColumns}
                  modelName={modelName} queryType="CK"/>);
    return (
        <div className="list-index">
            <QueryConditionPlan parentModel={modelName}/>
            {listContent}
        </div>
    )
};

factory.register('PlanCheckIndex', <PlanCheckIndex/>)