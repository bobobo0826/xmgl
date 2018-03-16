//Created by wjy on 2017/9/26.
import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
import {Form, Row, Col, message, Input, Select, Button} from 'antd';
import {getJson} from "../../request";
import CreatePlanIndex from "./CreatePlanIndex";
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

mirror.model({
    name:'queryConditionPlan',
    initialState:{
        queryOptions:{
            plan_name : ''
        },
        planResultDic:[],
        planConditionDic:[],
    },
    reducers:{
        handleChange(state,data){
            return {
                ...state,
                queryOptions:Object.assign({},state.queryOptions,data)
            }
        },
        doClear(state){
            let queryOptions = {};
            return {
                ...state,
                queryOptions:queryOptions
            }
        },
        setDic(state, data){
            return {
                ...state,
                planResultDic: data.planResultDic,
                planConditionDic: data.planConditionDic,
            }
        },
    },
    effects: {
        async getDic(data, getState){
            let planResultDic = [];
            let planConditionDic = [];
            let response = await getJson('/api/plan/getPlanResultDic');
            if (!response) {
                response = []
            }
            response.map((item) =>
                planResultDic.push(<Select.Option key={item.data_code}>{item.data_name}</Select.Option>));
            response = await getJson('/api/plan/getPlanConditionDic');
            if (!response) {
                response = []
            }
            response.map((item) =>
                planConditionDic.push(<Select.Option key={item.data_code}>{item.data_name}</Select.Option>));
            actions.queryConditionPlan.setDic({planResultDic: planResultDic,planConditionDic:planConditionDic})
        },

        async doAdd(data,getState){
            let content = (<CreatePlanIndex />);
            actions.tabsTmpl.addTab({key:"planInfoNew","name": "计划录入", "content":content});
        }
    }
})

const QueryConditionPlan =connect(state =>{
    if (!(state.queryConditionPlan.planResultDic) || !state.queryConditionPlan.planResultDic.length||!(state.queryConditionPlan.planConditionDic)||!state.queryConditionPlan.planConditionDic.length) {
        actions.queryConditionPlan.getDic()
    }
    return state.queryConditionPlan
})(props =>{
    return(
        <div>
            <Form>
                <Row gutter={64}>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`计划名称：`}>
                            <Input
                                placeholder="计划名称"
                                value = {props.queryOptions.plan_name || ''}
                                onChange={(e) => {
                                    actions.queryConditionPlan.handleChange({'plan_name': e.target.value})
                                }}
                            />
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`计划结果状态：`}>
                            <Select
                                defaultValue=""
                                value={props.queryOptions.plan_result_condition}
                                style={{width: '100%'}}
                                onChange={(val) => {
                                    actions.queryConditionPlan.handleChange({'plan_result_condition':val})
                                }}
                                allowClear
                            >
                                {props.planResultDic}
                            </Select>
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`计划状态：`}>
                            <Select
                                defaultValue=""
                                value={props.queryOptions.plan_condition}
                                style={{width: '100%'}}
                                onChange={(val) => {
                                    actions.queryConditionPlan.handleChange({'plan_condition':val})
                                }}
                                allowClear
                            >
                                {props.planConditionDic}
                            </Select>
                        </FormItem>
                    </Col>
                   {/* <Col sm={8}>
                        <FormItem {...formItemLayout} label={`创建人：`}>
                            <Input
                                placeholder="创建人"
                                value = {props.queryOptions.creator}
                                onChange={(e) => {
                                    actions.queryConditionPlan.handleChange({'creator':e.target.value})
                                }}
                            />
                        </FormItem>
                    </Col>*/}
                </Row>
            </Form>
            <Row>
                <Col sm={8} offset={8}>
                    <Button size="large" icon="plus" onClick={()=>{actions.queryConditionPlan.doAdd()}}>添加</Button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <Button type="primary" size="large" icon="search" onClick={()=>{actions[props.parentModel].doQuery(props.queryOptions)}}>查询</Button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <Button type="danger" size="large" icon="reload" onClick={()=>{actions[props.parentModel].doQuery({}); actions.queryConditionPlan.doClear()}}>清空</Button>
                </Col>
            </Row>
        </div>
    )}
)

export default QueryConditionPlan