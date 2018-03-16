//Created by wjy on 2017/9/26.

import React from 'react'
import {actions} from 'mirrorx'
import TaskList, {createTaskListModel} from './TaskList'
import QueryCondition from './QueryCondition'
import factory from '../../ComponentFactory'
import '../tp.scss';

const modelName = "taskCheckList";
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
    formatter: function (row, data, index) {//显示操作按钮i)
        let evalFlag = (row.task_condition === "已完成" || row.task_condition === "已考评");
        let cancelFlag = (row.task_condition === "进行中");
        let cancelButton = (<span onClick={() => {
            actions[modelName].cancelTask({'id': row.id})
        }} className="ac-delete">注销</span>)
        let evalButton = (<span onClick={() => {
            actions[modelName].doEval(
                {
                    'id': row.id,
                    'name': row.task_name,
                    'employee': row.participants,
                    'type': "createEval"
                })
        }} className="ac-other">考评</span>)
        let expectedButton = null;
        if(row.expected_end_time<getNowFormatDate()) {
            expectedButton = (<span onClick={()=>{actions[modelName].sendEmailSubmit({'row':row,'nowDate':getNowFormatDate()})}} className="ac-delete">延迟警告</span>)
        }
        return (
            <div className="list-item-action">
                <span onClick={() => {
                    actions[modelName].editInfo({'id': row.id, 'name': row.task_name})
                }} className="ac-edit">详情</span>
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
                                    'name': row.task_name,
                                    'employee': row.participants,
                                    'type': "createEval"
                                })
                        }} className="ac-other">考评</span>
                        <span onClick={() => {
                            actions[modelName].doEval({
                                'id': row.id,
                                'name': row.task_name,
                                'type': "taskEval"
                            })
                        }} className="ac-other">任务考评</span>
                        <span onClick={() => {
                            actions[modelName].doEval({
                                'id': row.id,
                                'employee': row.participants,
                                'type': "employeeEval",
                                'name': row.task_name,
                            })
                        }} className="ac-other">员工考评</span>
            </div>
        );
    }
}];

const TaskCheckIndex = () => {
    if (!actions[modelName]) {
        createTaskListModel(modelName);
    }
    let listContent = (
        <TaskList addColumns={evalColumns}
                  modelName={modelName} queryType="CK"/>);
    return (
        <div className="list-index">
            <QueryCondition parentModel={modelName}/>
            {listContent}
        </div>
    )
};

factory.register('TaskCheckIndex', <TaskCheckIndex/>)