import QueryConditionPlan from './QueryConditionPlan'
import mirror, {connect, actions} from 'mirrorx'
import PlanList, {createPlanListModel} from './PlanList'
import React from 'react'
import factory from '../../ComponentFactory'
import '../tp.scss';
import {getJson} from '../../request'

const modelName = "planEditList";
const  editColumns = [
            {
                field: '',
                hidden: false,
                name: '操作',
                col: 2,
                formatter: function (row, data, index) {//显示操作按钮
                    let content;
                    let editButton = ( <span onClick={() => {
                        actions[modelName].editInfo({'id': row.id, 'name': row.plan_name})
                    }} className="ac-edit">编辑</span>)
                    if (row.plan_condition === "草稿") {
                        content = (
                            <div className="list-item-action">
                                {editButton}
                                <span onClick={() => {
                                    actions[modelName].deletePlan({'id': row.id})
                                }} className="ac-delete">删除</span>
                            </div>
                        )
                    }
                    else{
                        content = (
                            <div className="list-item-action">
                                {editButton}
                                <span onClick={() => {
                                    actions[modelName].cancelPlan({'id': row.id})
                                }} className="ac-delete">注销</span>
                            </div>
                        )
                    }
                    return content;
                }
            }
        ];
const PlanEditIndex = ()=>{
    if(!actions[modelName]){
        createPlanListModel(modelName);
    }
    let listContent = (<PlanList addColumns={editColumns}
                                 modelName = {modelName} queryType = "DCL" />);
    return (
        <div className = "list-index">
            <QueryConditionPlan parentModel = {modelName}/>
            {listContent}
        </div>
    )
};

factory.register('PlanEditIndex',<PlanEditIndex />)