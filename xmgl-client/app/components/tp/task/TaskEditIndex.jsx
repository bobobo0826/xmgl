//Created by wjy on 2017/9/26.

import QueryCondition from './QueryCondition'
import mirror, {connect, actions} from 'mirrorx'
import TaskList, {createTaskListModel} from './TaskList'
import React from 'react'
import factory from '../../ComponentFactory'
import '../tp.scss';

const modelName = "taskEditList";
const editColumns = [
    {
        field: '',
        hidden: false,
        name: '操作',
        col: 2,
        formatter: function (row, data, index) {//显示操作按钮
            let content;
            let editButton = ( <span onClick={() => {
                actions[modelName].editInfo({'id': row.id, 'name': row.task_name})
            }} className="ac-edit">编辑</span>)
            if (row.task_condition === "草稿") {
                content = (
                    <div className="list-item-action">
                        {editButton}
                        <span onClick={() => {
                            actions[modelName].deleteTask({'id': row.id})
                        }} className="ac-delete">删除</span>
                    </div>
                )
            }
            else{
                content = (
                    <div className="list-item-action">
                        {editButton}
                        <span onClick={() => {
                            actions[modelName].cancelTask({'id': row.id})
                        }} className="ac-delete">注销</span>
                    </div>
                )
            }
            return content;
        }
    }
];
const TaskEditIndex = () => {
    if (!actions[modelName]) {
        createTaskListModel(modelName);
    }
    let listContent = (<TaskList addColumns={editColumns}
                                 modelName={modelName} queryType="DCL"/>);
    return (
        <div className="list-index">
            <QueryCondition parentModel={modelName}/>
            {listContent}
        </div>
    )
};

factory.register('TaskEditIndex', <TaskEditIndex/>)