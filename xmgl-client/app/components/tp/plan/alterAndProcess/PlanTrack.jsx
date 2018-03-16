//Created by wangchao on 2017/9/28.
import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import {Row, Col, Form, Input, Select, Button,Pagination} from 'antd';
import '../../tp.scss';

const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};
const createPlanTrackModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            list: undefined,
            columns: [
                {
                    field: 'id',
                    hidden: true,
                    name: 'ID',
                    col: 2,
                },
                {
                    field: 'work_log_name',
                    hidden: false,
                    name: '日志记录名称',
                    col: 2,
                },
                {
                    field: 'plan_name',
                    hidden: false,
                    name: '计划名称',
                    col: 2,
                },
                {
                    field: 'sup_project',
                    hidden: false,
                    name: '所属项目',
                    col: 2,
                },
                {
                    field: 'sup_module',
                    hidden: false,
                    name: '所属模块',
                    col: 2,
                },
                {
                    field: 'sup_task',
                    hidden: false,
                    name: '所属任务',
                    col: 2,
                },
                {
                    field: 'record',
                    hidden: false,
                    name: '工作记录',
                    col: 4,
                },
                {
                    field: 'complete',
                    hidden: false,
                    name: '完成情况',
                    col: 2,
                },

                {
                    field: 'task_start_time',
                    hidden: false,
                    name: '开始时间',
                    col: 2,
                },
                {
                    field: 'task_end_time',
                    hidden: false,
                    name: '结束时间',
                    col: 2,
                },
                {
                    field: 'modifier',
                    hidden: false,
                    name: '提交人',
                    col: 2,
                },
                {
                    field: 'modify_date',
                    hidden: false,
                    name: '提交时间',
                    col: 2,
                }
            ],
            queryOptions: {
                plan_id:'',//计划跟踪按钮专用
                plan_name: '',
                sup_task: '',
                period: ''
            },
            periodDic: [],
            forceQuery: true,
            curPage: 1,
            pageSize: 10,
            totalItem: 0,
        },
        reducers: {
            setList(state, data) {
                return {
                    ...state,
                    list: data.list,
                    totalItem: data.totalItem ? data.totalItem :0,
                    forceQuery: false
                }
            },
            doQuery(state){
                return {
                    ...state,
                    curPage:1,
                    forceQuery: true
                }
            },
            doClear(state){
                return {
                    ...state,
                    queryOptions: {
                        plan_id:'',
                        plan_name: '',
                        sup_task: '',
                    },
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
            },
            setPeriodDic(state, data){
                return {
                    ...state,
                    periodDic: data.periodDic,
                    queryOptions:  Object.assign({}, state.queryOptions, {period: data.defaultKey}),
                }
            },
            handleChange(state, data) {
                let obj = {};
                let queryFlag = false
                obj[data.key] = data.value;
                if (data.key === "period") {
                    queryFlag = true
                }else{
                    obj["plan_id"]='';//从计划列表点跟踪进来的查询条件是带plan_id的，改变除周期外的查询框，都要把plan_id置空
                }
                return {
                    ...state,
                    queryOptions: Object.assign({}, state.queryOptions, obj),
                    forceQuery: queryFlag,
                }
            },
            setQueryOptions(state,queryOptions){
                return{
                    ...state,
                    queryOptions:Object.assign({}, queryOptions),
                }
                
            }


        },
        effects: {
            async getList(data, getState) {
                let queryOptions = getState()[modelName].queryOptions;
                let curPage = getState()[modelName].curPage;
                let pageSize = getState()[modelName].pageSize;

                let response = await getJson('/api/worklog/getPlanLogList',
                    {
                        body: {
                            queryOptions: queryOptions,
                            page: curPage,
                            pageSize: pageSize
                        }
                    });
                let list = response.list;
                if (!list) {
                    list = []
                }
                actions[modelName]
                    .setList({list: list, totalItem: response.totalitem})
            },
            async getPeriodDic(data, getState){
                let periodDic = [];
                let response = await getJson('/api/worklog/getPeriodDic');
                if (!response) {
                    response = []
                }
                response.map((item) =>
                    periodDic.push(<Option key={item.data_code}>{item.data_name}</Option>));
                actions[modelName]
                    .setPeriodDic({periodDic: periodDic, defaultKey: response[0].data_code})
            }
        }
    })
    render();
};

const PlanTrack = connect((state,ownProps) => {
    let modelName = ownProps.modelName;
    if (!state[modelName].queryOptions.period) {
        actions[modelName].getPeriodDic()
    }
    if (state[modelName].forceQuery&&state[modelName].queryOptions.period) {
        actions[modelName].getList()
    }
    return state[modelName]
})(props => {
        let modelName = props.modelName;
        let content = (<div>正在加载中...</div>);
        if (props.list && props.list.length > 0) {
            content = props.list.map((item) => (
                    <ListItem key={item.id} columns={props.columns} data={item}/>
                )
            )
        } else if(props.list){
            content = (<div>暂无数据</div>)
        }
        return (
            <div>
                <Row gutter={64}>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`计划名称：`}>
                            <Input
                                placeholder="计划名称"
                                value={props.queryOptions.plan_name||''}
                                onChange={(e) => {
                                    actions[modelName].handleChange({value:e.target.value, key:'plan_name'})
                                }}
                            />
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`所属任务：`}>
                            <Input
                                placeholder="所属任务"
                                value={props.queryOptions.sup_task||''}
                                onChange={(e) => {
                                    actions[modelName].handleChange({value:e.target.value,key: 'sup_task'})
                                }}
                            />
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`周期：`}>
                            <Select
                                defaultValue=""
                                value={props.queryOptions.period||''}
                                style={{width: '100%'}}
                                onChange={(val) => {
                                    actions[modelName].handleChange({value:val, key:'period'})
                                }}
                            >
                                {props.periodDic}
                            </Select>
                        </FormItem>
                    </Col>
                </Row>
                <Row>
                    <Col sm={4} offset={10}>
                        <Button type="primary" size="large" icon="search" onClick={actions[modelName].doQuery}>查询</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button type="danger" size="large" icon="reload" onClick={actions[modelName].doClear}>清空</Button>
                    </Col>
                </Row>
                <div className="list">
                    <ListHead columns={props.columns}/>
                    {content}
                    <Pagination className="list-pagination"
                                showSizeChanger showQuickJumper
                                defaultCurrent={props.curPage}
                                total={props.totalItem}
                                onChange={(e) => actions[modelName].onChangePage(e)}
                                onShowSizeChange={(current, pageSize) =>
                                    (actions[modelName].onShowSizeChange({current: current, pageSize: pageSize}))}
                                showTotal = {() => "共"+props.totalItem+"条数据"}

                    />
                </div>
            </div>
        )
    }
)

export default PlanTrack
export {createPlanTrackModel};