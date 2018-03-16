//Created by liubo on 2017/10/9.
import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import {Row, Col, message, Input, Select, Form, Button,Pagination} from 'antd';
import '../../tp.scss';
import PlanEvaluationList,{planEvaluationListModel} from './PlanEvaluationList'

const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {span: 6},
    wrapperCol: {span: 14},
};
const planEmployeeEvaResultModel = function (modelName){
mirror.model({
    name:modelName,
    initialState: {
        list: undefined,
        evaluateTypeList: undefined,
        columns: [
            {
             field: 'id',
             hidden: true,
             name: 'ID',
             col: 1,
             },
            {
                field: 'plan_id',
                hidden: true,
                name: '计划ID',
                col: 1,
            },
            {
                field: 'plan_name',
                hidden: false,
                name: '计划名称',
                col: 3,
            },
            {
                field: 'employee_id',
                hidden: true,
                name: '人员ID',
                col: 1,
            },
            {
                field: 'employee_name',
                hidden: false,
                name: '人员名称',
                col: 3,
            },
            {
                field: 'evaluate_type',
                hidden: false,
                name: '考评类别',
                col: 4,
            },{
                field: 'average_type',
                hidden: false,
                name: '类别均分',
                col: 4,
            },{
                field: 'modify_time',
                hidden: false,
                name: '最后修改时间',
                col: 4,
            },{
                field: '',
                hidden: false,
                name: '操作',
                col: 3,
                formatter: function (row, data, index) {//显示操作按钮
                    return (
                        <div className="list-item-action">
                                <span onClick={() => {
                                    actions[modelName].editInfo({'employee_id':row.employee_id,'plan_id':row.plan_id})
                                }} className="ac-edit">详情</span>
                        </div>
                    );
                }
            }
        ],
        queryOptions: {},
        forceQuery: true,
        curPage: 1,
        pageSize: 10,
        totalItem:0,
    },
    reducers: {
        setList(state, data) {
            return {
                ...state,
                list: data.list,
                totalItem:data.totalItem ? data.totalItem :0,
                forceQuery: false,
            }
        },
        setEvaluateTypeList(state, data) {
            return {
                ...state,
                evaluateTypeList: data,
                forceQuery:false

            }
        },
        handleChange(state,data){
            return {
                ...state,
                queryOptions:Object.assign({},state.queryOptions,data),
                forceQuery:false
            }
        },
        doQuery(state, data){
            return {
                ...state,
                queryOptions: data,
                forceQuery: true

            }
        },
        doClear(state){
            return {
                ...state,
                queryOptions: {},
                forceQuery: true
            }
        },
        onChangePage(state, data) {
            return {
                ...state,
                curPage: data,
                forceQuery: true,
            }
        },
        onShowSizeChange(state, data) {
            return {
                ...state,
                pageSize: data.pageSize,
                curPage: data.current,
                forceQuery: true,
            }
        }
    },
    effects: {
        async getList(data, getState) {
            let queryOptions = getState()[modelName].queryOptions;
            let curPage = getState()[modelName].curPage;
            let pageSize = getState()[modelName].pageSize || 10;
            let employeeId = data.employeeId;
            let response;
            if(typeof(employeeId)!="undefined"){
                response = await getJson('/api/plan/getEmployeeEvaluateResultListByEmployeeId/'+employeeId+'/'+data.curPlanId,
                    {
                        body: {
                            queryOptions: queryOptions,
                            curPage: curPage,
                            pageSize: pageSize
                        }
                    });
            }else{
                response = await getJson('/api/plan/getEmployeeEvaluateResultList',
                    {
                        body: {
                            queryOptions: queryOptions,
                            curPage: curPage,
                            pageSize: pageSize
                        }
                    });
            }

            let list = response.list;
            if (!list) {
                list = []
            }
            actions[modelName].setList({list:list,totalItem:response.totalitem})
        },
        async getEvaluateTypeList() {
            let evaluateTypeList = await getJson('/api/plan/getEvaluateTypeDic');
            if (!evaluateTypeList) {
                evaluateTypeList = []
            }
            actions[modelName].setEvaluateTypeList(evaluateTypeList)
        },
        async editInfo(data,getState){
            let modelName = `evaluationList${data.id}`;
            if(!getState()[modelName]){
                planEvaluationListModel(modelName);
            }
            let content = (<PlanEvaluationList curEmployeeId={data.employee_id} planId={data.plan_id} modelName = {modelName}/>);
            actions.tabsTmpl.addTab({key:modelName,name:`员工考评详情`,'content':content});
        },
    }
})
    render();
}

const PlanEmployeeEvaResult = connect((state,ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].forceQuery) {
        actions
            [modelName]
            .getList({employeeId:ownProps.employeeId,curPlanId:ownProps.curPlanId})
    }
    if (!state[modelName].evaluateTypeList) {
        actions
            [modelName]
            .getEvaluateTypeList()
    }
    return state[modelName];
})(props => {
        let modelName=props.modelName;
        let evaluateType
        if (props.evaluateTypeList && props.evaluateTypeList.length) {
            evaluateType = props.evaluateTypeList.map((item) => (
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            )
        }
        let content = (<div>正在加载中...</div>);
        if (props.list && props.list.length) {
            content = props.list.map((item) => (
                    <ListItem key={item.id} columns={props.columns} data={item}/>
                )
            )
        } else {
            content = (<div>暂无数据</div>)
        }
        return (
            <div>
                <Form className="list-search">
                    <Row gutter={64}>
                        <Col span={8}>
                            <FormItem {...formItemLayout} label="计划名称：">
                                <Input
                                    value={props.queryOptions.plan_name}
                                    onChange={(e) => {
                                        actions[modelName].handleChange({'plan_name': e.target.value})
                                    }}
                                    placeholder="计划名称"/>

                            </FormItem>
                        </Col>
                        <Col span={8}>
                            <FormItem {...formItemLayout} label="考评类别：">
                                <Select size="default"
                                        style={{width: '100%'}}
                                        defaultValue=""
                                        allowClear
                                        value={props.queryOptions.evaluate_type}
                                        onChange={(val) => {
                                            actions[modelName].handleChange({'evaluate_type':val})
                                        }}

                                >
                                    {evaluateType}
                                </Select>

                            </FormItem>
                        </Col>
                        <Col span={8}>
                            <FormItem {...formItemLayout} label="类别均分：">
                                <Input
                                    value={props.queryOptions.average_type}
                                    onChange={(e) => {
                                        actions[modelName].handleChange({'average_type': e.target.value})
                                    }}
                                    placeholder="类别均分"/>

                            </FormItem>
                        </Col>

                    </Row>

                </Form>

                <Row>
                    <Col span={8} className="list-btn">
                        <Button type="primary" size="large" icon="search" onClick={() => {
                            actions[modelName].doQuery(props.queryOptions)
                        }}>查询</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button type="danger" size="large" icon="reload" onClick={() => {
                            actions[modelName].doClear()
                        }}>清空</Button>
                    </Col>
                    <Col span={24} className="list">
                        <ListHead columns={props.columns}/>
                        {content}
                        <Pagination className="list-pagination"
                                    showSizeChanger
                                    showQuickJumper
                                    defaultCurrent={props.curPage}
                                    total={props.totalItem}
                                    onChange={(e)=>actions[props.modelName].onChangePage(e)}
                                    onShowSizeChange={(current,pageSize)=>(actions[props.modelName].onShowSizeChange({current:current,pageSize:pageSize}))}
                                    showTotal = {() => "共"+props.totalItem+"条数据"}
                        />
                    </Col>
                </Row>

            </div>

            /*<div className = "list">
             <ListHead columns = {props.columns}/>
             {content}
             </div>*/
        )
    }
)

export default PlanEmployeeEvaResult
export {planEmployeeEvaResultModel};