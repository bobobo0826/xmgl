import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {Row, Col, Form, Input, Select,message, Button, Upload, Icon, Modal,} from 'antd';
import {ListHead, ListItem, ToolBox} from '../../../public/list_component/index';
import PlanOutputInfo from './PlanOutputInfo';

const createPlanOutputModel = function (modelName) {
    mirror.model({
        name:modelName,
        initialState:{
            columns:[
                {
                    field: 'id',
                    hidden: true,
                    name: 'ID',
                    col: 2,
                },{
                    field: 'plan_id',
                    hidden: true,
                    name: '计划id',
                    col: 2,
                },{
                    field: 'doc_name',
                    hidden: false,
                    name: '文档名称',
                    col: 4,
                },{
                    field: 'output_category',
                    hidden: false,
                    name: '输出类别',
                    col: 4,
                },{
                    field: 'order_num',
                    hidden: false,
                    name: '内部序号',
                    col: 4,
                },{
                    field: 'output_type',
                    hidden: false,
                    name: '输出类型',
                    col: 4,
                },{
                    field: 'output_desc',
                    hidden: false,
                    name: '输出描述',
                    col: 4,
                },{
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 4,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                                <span className="ac-edit" onClick={()=>{actions[modelName].editInfo(row.id)}}
                                >编辑</span>
                                <span className="ac-delete" onClick={()=>{actions[modelName].deleteOutputList(row.id)}}
                                >删除</span>
                            </div>
                        );
                    }
                }
            ],
            outputShow :false,
            forceQuery: true,
            list:undefined,
            checkId:undefined,
            planId: null
        },
        reducers:{
            setList(state, data){
                return{
                    ...state,
                    list:data,
                    forceQuery :false,
                }
            },
            setMirrorState(state,newState) {
                return {
                    ...state,
                    ...newState,
                }
            }
        },
        effects:{
            async initData(data,getState){
                let listState = await actions[modelName].getPlanOutputList(data.planId);
                let newState = Object.assign({}, {planStatus: data.planStatus}, listState,
                    {planId: data.planId}, {forceQuery: false});
                actions[modelName].setMirrorState(newState);
            },
            async getPlanOutputList(planId,getState){
                let request =await getJson('/api/plan/getPlanOutputList/' + planId,{'method': 'GET'});

                if (request.status) {
                    request = []
                }
                return{list: request};
            },
            async deleteOutputList(data,getState) {
                let request = await getJson('/api/plan/deleteOutputById', {
                    body:{
                        id :data,
                        planStatus: getState()[modelName].planStatus,
                    },
                    method: 'DELETE'
                })
                if(request.success){
                    message.success('删除成功！');
                    /*actions[modelName].getPlanOutputList();*/
                }
                else {message.error('删除失败！');}
                actions[modelName].setMirrorState({forceQuery: true})
            },
            async editInfo(data,getState){
                if (actions.planOutputInfo) {
                    actions.planOutputInfo.initData({id: data, planId:getState()[modelName].planId});
                }
                actions[modelName].setMirrorState({ outputShow: true,checkId: data})
            }

        },

    })
    render()
}

const PlanOutput = connect ((state,ownProps)=>{
    let modelName = ownProps.modelName
    if(state[modelName].forceQuery && ownProps.planId && ownProps.planId > 0) {
        actions[modelName].initData(ownProps)
    }
    return state[modelName]
})(props=>{
    let content = (<div>加载中...</div>);
    if(props.list && props.list.length>0) {
        content = props.list.map((item) => (
            <ListItem key={item.id} columns={props.columns} data={item}/>
        ))
    }
    else {content = (<div>暂无输出数据！</div>);}

    let planOutputInfo = null;
    if(props.outputShow) {
        planOutputInfo = (<PlanOutputInfo pModelName={props.modelName} id={props.checkId} planId={props.planId} outputShow={props.outputShow}/>);
    }
    return(<div>
        <Row className="add-info-button">
            <Col >
                <Button type="primary" size="large" icon="plus" onClick={()=>{actions[props.modelName].editInfo(-1)}}>新增</Button>
            </Col>
        </Row>
        <Row>
            <Col className="list">
                <ListHead columns={props.columns}/>
                {content}
            </Col>
            <div>{planOutputInfo}</div>
        </Row>
    </div>)
})

export default PlanOutput
export {createPlanOutputModel}