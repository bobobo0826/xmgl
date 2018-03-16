import QueryConditionPlan from './QueryConditionPlan'
import mirror, {connect, actions} from 'mirrorx'
import PlanList from './PlanList'
import React from 'react'
import factory from '../../ComponentFactory'
import '../tp.scss';
import {getJson} from '../../request'
mirror.model({
    name: "planListIndex",
    initialState: {
        editColumns: [
            {
                field: '',
                hidden: false,
                name: '操作',
                col: 2,
                formatter: function (row, data, index) {//显示操作按钮
                    return (
                        <div className="list-item-action">
                            <span onClick={() => {
                                actions.planList.editInfo({'id': row.id, 'name': row.plan_name})
                            }} className="ac-edit">编辑</span>
                            <span onClick={() => {
                                actions.planList.deletePlan({
                                    'id': row.id
                                })
                            }} className="ac-delete">删除</span>
                        </div>
                    );
                }
            }
        ],
        list: [],
        forceUpdate: true,
        queryOptions: {queryType: "DCL"},
    },
    reducers: {
        setList(state, data) {
            return {
                ...state,
                forceUpdate: false,
                list: data
            }
        },
        doQuery(state, data){
            let options = Object.assign({}, {queryType: "DCL"}, data);
            return {
                ...state,
                queryOptions: options,
                forceUpdate: true
            }
        },
    },
    effects: {
        async getList(data, getState) {
            let queryOptions = getState().planListIndex.queryOptions;
            let response = await getJson('/api/plan/getPlanList',
                {
                    body: {
                        queryOptions: queryOptions,
                        page: 1,
                        pageSize: 20
                    }
                });
            let list = response.list;
            if (!list) {
                list = []
            }
            actions.planListIndex.setList(list)
        },
    }
});

const PlanListIndex = connect(state => {
    if (state.planListIndex.forceUpdate) {
        actions.planListIndex.getList()
    }
    return state.planListIndex;
})(props => {
    let listContent = (<PlanList addColumns={props.editColumns} list={props.list}/>);
    return (
        <div className="list-index">
            <QueryConditionPlan parentModel="planListIndex"/>
            {listContent}
        </div>
    )
});

factory.register('PlanListIndex', <PlanListIndex />)