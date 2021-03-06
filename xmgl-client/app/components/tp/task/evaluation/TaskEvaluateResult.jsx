//Created by liubo on 2017/9/28.
import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import {Row, Col, message, Input, Select, Form, Button,Pagination} from 'antd';
import '../../tp.scss';
import EvaluationList,{evaluationListModel} from './EvaluationList'

const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {span: 6},
    wrapperCol: {span: 14},
};
const taskEvaluateResultModel = function (modelName){
mirror.model({
    name:modelName,
    initialState: {
        list: undefined,
        curTaskId:0,
        columns: [
            {
             field: 'id',
             hidden: true,
             name: 'ID',
             col: 1,
             },
            {
                field: 'task_id',
                hidden: true,
                name: '任务ID',
                col: 1,
            },
            {
                field: 'task_name',
                hidden: false,
                name: '任务名称',
                col: 5,
            },
            {
                field: 'average_score',
                hidden: false,
                name: '综合考评均分',
                col: 6,
            },
            {
                field: 'modify_time',
                hidden: false,
                name: '最后修改时间',
                col: 6,
            },{
                field: '',
                hidden: false,
                name: '操作',
                col: 5,
                formatter: function (row, data, index) {//显示操作按钮
                    return (
                        <div className="list-item-action">
                                <span onClick={() => {
                                    actions[modelName].editInfo({'id':row.task_id})
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
            let response;
            if(typeof(data.curTaskId)!="undefined"){
                let curTaskId = data.curTaskId;
                response = await getJson('/api/task/getTaskEvaluateResultListByTaskId/'+curTaskId,
                    {
                        body: {
                            queryOptions: queryOptions,
                            curPage: curPage,
                            pageSize: pageSize
                        }
                    });
            }else{
                response = await getJson('/api/task/getTaskEvaluateResultList',
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
        async editInfo(data,getState){
            let name = `evaluationList${data.id}`;
            if(!getState()[name]){
                evaluationListModel(name);
            }
            let content = (<EvaluationList curTaskId = {data.id} forceQuery={true} modelName = {name}/>);
            actions.tabsTmpl.addTab({key:name,name:`任务考评详情`,'content':content});
        },
    }
})
    render();
}

const TaskEvaluateResult = connect((state,ownProps) => {
    let modelName = ownProps.modelName;
    if (state[modelName].forceQuery) {
        actions
            [modelName]
            .getList({curTaskId:ownProps.curTaskId})
    }
    return state[modelName]
})(props => {
        let modelName=props.modelName;
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
                            <FormItem {...formItemLayout} label="任务名称：">
                                <Input
                                    value={props.queryOptions.task_name}
                                    onChange={(e) => {
                                        actions[modelName].handleChange({'task_name': e.target.value})
                                    }}
                                    placeholder="任务名称"/>

                            </FormItem>
                        </Col>
                        <Col span={8}>
                            <FormItem {...formItemLayout} label="综合考评均分：">
                                <Input
                                    value={props.queryOptions.average_score}
                                    onChange={(e) => {
                                        actions[modelName].handleChange({'average_score': e.target.value})
                                    }}
                                    placeholder="综合考评均分"/>

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

        )
    }
)

export default TaskEvaluateResult
export {taskEvaluateResultModel};