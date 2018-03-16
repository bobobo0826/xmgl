//Created by liubo on 2017/9/29.
import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {ListHead,ListItem,ToolBox} from '../../../public/list_component/index';
import {Row,Col,message, Input, Select,Form,Button,Pagination} from 'antd';
import '../../tp.scss';
import CreatePlanEvalution, {createCreatePlanEvalModel} from './CreatePlanEvaluation'

const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: { span:6 },
    wrapperCol: { span:14 },
};
const planEvaluationListModel = function (modelName) {
mirror.model({
    name: modelName,
    initialState:{
        list: undefined,
        evaluateLevelList: undefined,
        evaluateTypeList: undefined,
        evaluateObjectList: undefined,
        columns:[
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
                col: 2,
            },
            {
                field: 'evaluate_object',
                hidden: false,
                name: '考评对象',
                col: 1,
            },
            {
                field: 'single_contractor',
                hidden: false,
                name: '单一承接人',
                col: 2,
                formatter:(row,data,index)=>(
                    data?data.split("~")[2]:null
                )
            },
            {
                field: 'evaluate_type',
                hidden: false,
                name: '考评类别',
                col: 2,
            },
            {
                field: 'evaluate_sup_type',
                hidden: false,
                name: '考评子类别',
                col: 2,
            },
            {
                field: 'evaluate_level',
                hidden: false,
                name: '考评等级',
                col: 2,
            },
            {
                field: 'evaluate_description',
                hidden: false,
                name: '考评描述',
                col: 3,
            },
            {
                field: 'evaluate_people',
                hidden: false,
                name: '考评人',
                col: 2,
            },
            {
                field: 'evaluate_time',
                hidden: false,
                name: '考评时间',
                col: 2,
            },
            {
                field: 'modify_time',
                hidden: false,
                name: '修改时间',
                col: 2,
            },
            {
                field: '',
                hidden: false,
                name: '操作',
                col: 2,
                formatter: function (row, data, index) {//显示操作按钮
                    return (
                        <div className="list-item-action">
                                <span onClick={() => {
                                    actions[modelName].editInfo({'id':row.id})
                                }} className="ac-edit">编辑</span>
                            <span onClick={() => {
                                actions[modelName].deleteEvaluation( {'id':row.id
                                })
                            }} className="ac-delete">删除</span>
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
                forceQuery:false
            }
        },
        showDic(state, data) {
            return {
                ...state,
                evaluateLevelList: data.evaluateLevelList   ,
                evaluateTypeList: data.evaluateTypeList,
                evaluateObjectList: data.evaluateObjectList,
                forceQuery: false
            }
        },
        handleChange(state,data){
            return {
                ...state,
                queryOptions:Object.assign({},state.queryOptions,data),
                forceQuery:false
            }
        },
        doClear(state){
            let queryOptions = {};
            return {
                ...state,
                queryOptions:queryOptions,
                forceQuery:true
            }
        },
        doQuery(state, data){
            return {
                ...state,
                queryOptions: data,
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
        async getList(data,getState) {
            let queryOptions = getState()[modelName].queryOptions;
            let curPage = getState()[modelName].curPage;
            let pageSize = getState()[modelName].pageSize || 10;
            let response;
            if(typeof(data.curPlanId) != "undefined"){
                let curPlanId = data.curPlanId;
                response = await getJson('/api/plan/getEvaluationListByPlanId/'+curPlanId,
                    {body:{
                        queryOptions:queryOptions,
                        curPage: curPage,
                        pageSize: pageSize
                    }});
            }else if(typeof(data.curEmployeeId) != "undefined"){
                let curEmployeeId = data.curEmployeeId;
                let planId=data.planId;
                response = await getJson('/api/plan/getEvaluationListByEmployeeId/'+planId+'/'+curEmployeeId,
                    {body:{
                        queryOptions:queryOptions,
                        curPage: curPage,
                        pageSize: pageSize
                    }});
            }else{
                response = await getJson('/api/plan/getEvaluationList',
                    {body:{
                        queryOptions:queryOptions,
                        curPage: curPage,
                        pageSize: pageSize
                    }});
            }
            let list = response.list;
            if (!list) {
                list = []
            }
            actions[modelName].setList({list:list,totalItem:response.totalitem})
        },
        async getDic() {
            let evaluateLevelList = await getJson('/api/plan/getEvaluateLevelDic');
            evaluateLevelList = evaluateLevelList.status ? {} : evaluateLevelList; //若返回了status 说明 出错。
            let evaluateTypeList = await getJson('/api/plan/getEvaluateTypeDic');
            evaluateTypeList = evaluateTypeList.status ? {} : evaluateTypeList; //若返回了status 说明 出错。
            let evaluateObjectList = await getJson('/api/plan/getEvaluateObjectDic');
            evaluateObjectList = evaluateObjectList.status ? {} : evaluateObjectList; //若返回了status 说明 出错。
            actions[modelName].showDic({evaluateLevelList: evaluateLevelList, evaluateTypeList: evaluateTypeList, evaluateObjectList: evaluateObjectList});
        },
        async deleteEvaluation(data,getState){
            let response = await getJson('/api/plan/deleteEvaluation',{
                body:{
                    id: Number(data.id)
                }
            })
            if (response.success){
                message.success("删除成功！");
                actions[modelName].getList();
            }
        },
        async editInfo(data, getState){
            let evalModelName = `EvalInfo${data.id}`;
            if (!actions[evalModelName]) {
                createCreatePlanEvalModel(evalModelName);
            }
            let content = (<CreatePlanEvalution evalId={data.id} modelName={evalModelName}/>);
            actions.tabsTmpl.addTab({key:evalModelName,name: `考评详情`, 'content': content});
        },

    }
})
    render();
}

const PlanEvaluationList = connect((state, ownProps) =>{
    let modelName = ownProps.modelName;
    if (state[modelName].forceQuery) {
        actions[modelName].getList({curEmployeeId:ownProps.curEmployeeId,planId:ownProps.planId,curPlanId:ownProps.curPlanId})
    }
    if (!state[modelName].evaluateLevelList||!state[modelName].evaluateTypeList||!state[modelName].evaluateObjectList) {
        actions
            [modelName]
            .getDic(state)
    }
    return state[modelName]
})(props => {
        let modelName=props.modelName;
        let evaluateLevel
        let evaluateType
        let evaluateObject
        if (props.evaluateLevelList && props.evaluateLevelList.length) {
            evaluateLevel = props.evaluateLevelList.map((item) => (
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            )
        }
        if (props.evaluateTypeList && props.evaluateTypeList.length) {
            evaluateType = props.evaluateTypeList.map((item) => (
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            )
        }
        if (props.evaluateObjectList && props.evaluateObjectList.length) {
            evaluateObject = props.evaluateObjectList.map((item) => (
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            )
        }
        let content = (<div>暂无数据</div>);
        if (props.list && props.list.length){
            content = props.list.map((item)=>(
                    <ListItem key ={item.id} columns = {props.columns} data = {item}/>
                )
            )
        }
        return(
            <div>
                <Form className="list-search">
                    <Row gutter={64}>
                        <Col span={8}>
                            <FormItem {...formItemLayout} label="考评对象：">
                                <Select size="default"
                                        style={{width: '100%'}}
                                        defaultValue=""
                                        allowClear
                                        value={props.queryOptions.evaluate_object}
                                        onChange={(val) => {
                                            actions[modelName].handleChange({'evaluate_object':val})
                                        }}

                                >
                                    {evaluateObject}
                                </Select>
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
                            <FormItem {...formItemLayout} label="考评等级：">
                                <Select size="default"
                                        style={{width: '100%'}}
                                        defaultValue=""
                                        allowClear
                                        value={props.queryOptions.evaluate_level}
                                        onChange={(val) => {
                                            actions[modelName].handleChange({'evaluate_level':val})
                                        }}

                                >
                                    {evaluateLevel}
                                </Select>

                            </FormItem>
                        </Col>
                    </Row>

                </Form>

                <Row>
                    <Col span={8} className="list-btn">
                        <Button type="primary" size="large" icon="search" onClick={()=>{actions[modelName].doQuery(props.queryOptions)}}>查询</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button type="danger" size="large" icon="reload" onClick={()=>{actions[modelName].doClear()}}>清空</Button>
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


        )
    }
)

export default PlanEvaluationList
export {planEvaluationListModel};