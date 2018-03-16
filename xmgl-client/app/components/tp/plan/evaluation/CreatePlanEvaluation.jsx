//Created by liubo on 2017/9/28.
import React from 'react'
import mirror, {connect, actions,render} from 'mirrorx'
import {getJson} from '../../../request'
import {Row, Col, message, Input, Select, Form, Button} from 'antd';
import '../../tp.scss';
import LzEditor from 'react-lz-editor/editor/index'
const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {span: 6},
    wrapperCol: {span: 14},
};

const createCreatePlanEvalModel = function (modelName) {
    mirror.model({
        name: modelName,
        initialState: {
            evaluateLevelList: undefined,
            evaluateTypeList: undefined,
            evaluateSupTypeList: undefined,
            evaluateObjectList: undefined,
            evalData:{},
            reLoadSubTypeList: false, //重新读取子类别
            loadedDataResponse:"LOADING",
            renderFlag:true, //需要渲染界面时，置反该变量。

        },
        reducers: {
            setEvalData(state, data){
                return {
                    ...state,
                    evalData:data.data,
                    loadedDataResponse:data.loadData,
                }
            },
            setDicList(state, data) {
                return {
                    ...state,
                    evaluateLevelList: data.evaluateLevelList,
                    evaluateTypeList: data.evaluateTypeList,
                    evaluateObjectList: data.evaluateObjectList,
                }
            },
            setEvaluateSupTypeList(state, data) {
                return {
                    ...state,
                    evaluateSupTypeList: data,
                    reLoadSubTypeList:false,
                }
            },
            handleChange(state, data){
                let obj = {};
                let reLoadSubTypeList = false;
                if (data.key == "evaluate_type_code") {
                    reLoadSubTypeList = true;
                }
                obj[data.key] = data.value;
                return {
                    ...state,
                    reLoadSubTypeList: reLoadSubTypeList,
                    evalData:Object.assign({},state.evalData,obj)
                }
            },

        },
        effects: {
            async loadEvalData(data,getState){
                let info = {};
                let loadData = "";
                if (data.id === -1 || !data.id){
                    info = {
                        plan_id:data.planId,
                        plan_name:data.planName,
                        employee:data.employee,
                    };
                    loadData = "SUCCESS";
                }else{
                    info = await getJson('/api/plan/getEvaluationInfoById/' + data.id);
                    if (info.status) {
                        loadData = "FAILED";
                    }else{
                        loadData = "SUCCESS";
                    }
                }
                actions[modelName].setEvalData({data:info,loadData:loadData});
            },
            async getDicList() {
                let evaluateLevelList = await getJson('/api/plan/getEvaluateLevelDic');
                if (!evaluateLevelList) {
                    evaluateLevelList = []
                }
                let evaluateTypeList = await getJson('/api/plan/getEvaluateTypeDic');
                if (!evaluateTypeList) {
                    evaluateTypeList = []
                }
                let evaluateObjectList = await getJson('/api/plan/getEvaluateObjectDic');
                if (!evaluateObjectList) {
                    evaluateObjectList = []
                }
                actions[modelName].setDicList({
                    evaluateLevelList: evaluateLevelList,
                    evaluateTypeList: evaluateTypeList,
                    evaluateObjectList: evaluateObjectList
                })
            },
            async getEvaluateSupTypeList (data,getState) {
                let evalData = getState()[modelName].evalData;
                let evaluateTypeCode =evalData.evaluate_type_code;
                let evaluateSupTypeList = await getJson('/api/plan/getEvaluateSupTypeList/' + evaluateTypeCode);
                if (!evaluateSupTypeList) {
                    evaluateSupTypeList = []
                }
                actions[modelName].setEvaluateSupTypeList(evaluateSupTypeList)
            },

            async save(data, getState){
                if (!data.evaluate_object_code || !data.evaluate_type_code || !data.evaluate_level_code) {
                    let mag = "请输入："
                    if (!data.evaluate_object_code) {
                        mag += "考评对象  "
                    }
                    if (!data.evaluate_type_code) {
                        mag += "考评类别  "
                    }
                    if (!data.evaluate_level_code) {
                        mag += "考评等级  "
                    }
                    message.info(mag);
                    return;
                }
                await getJson('/api/plan/saveEvaluation', {
                    body: data,
                })
                message.success("保存成功！");
            },
            async reloadData(data,getState){
                actions[modelName].loadEvalData({id:getState()[modelName].evalData.id})
            }

        }
    })
    render();
}

const CreatePlanEvaluation = connect((state,ownProps) => {
    let modelName = ownProps.modelName;
    if (!state[modelName].evaluateLevelList||!state[modelName].evaluateTypeList||!state[modelName].evaluateObjectList) {
        actions
            [modelName]
            .getDicList(state)
    }
    if (state[modelName].reLoadSubTypeList) {
        actions
            [modelName]
            .getEvaluateSupTypeList()
    }
    if (state[modelName].loadedDataResponse==="LOADING"){
        let employee=[];
        if(ownProps.employee){
            employee=ownProps.employee.split(",");
        }
        actions[modelName].loadEvalData({id:ownProps.evalId,planId:ownProps.planId,employee:employee,planName:ownProps.planName});    }
    return state[modelName]
})(props => {
        let modelName = props.modelName;
        let evalData = props.evalData;
        let evaluateLevel
        let evaluateType
        let evaluateSupType
        let evaluateObject
        let employeeDic
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
        if (props.evaluateSupTypeList && props.evaluateSupTypeList.length) {
            evaluateSupType = props.evaluateSupTypeList.map((item) => (
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            )
        }

        if(evalData.employee&&evalData.employee.length){
            employeeDic =evalData.employee.map((item) => (
                    <Option key={item}>{item.split("~")[2]}</Option>
                )
            )
        }
        let evaluate_sup_type_code=evalData.evaluate_sup_type_code;
        let evaluate_sup_type=""
        if(evaluate_sup_type_code=="CFDML"){
            evaluate_sup_type="重复代码量";
        }
        if(evaluate_sup_type_code=="DMLJ"){
            evaluate_sup_type="代码逻辑清晰程度";
        }
        if(evaluate_sup_type_code=="PB"){
            evaluate_sup_type="排版";
        }
        if(evaluate_sup_type_code=="ZS"){
            evaluate_sup_type="注释";
        }
        if(evaluate_sup_type_code=="ZJ"){
            evaluate_sup_type="章节";
        }
        if(evaluate_sup_type_code=="MMXG"){
            evaluate_sup_type="命名习惯";
        }
        if(evaluate_sup_type_code=="QTGDGF"){
            evaluate_sup_type="其它规定规范";
        }
        if(evaluate_sup_type_code=="QM"){
            evaluate_sup_type="签名";
        }
        let single
        if(evalData.evaluate_object_code=="PEOPLE"){
            single=(
                <Col span={8}>
                    <Col span={22}>
                        <FormItem {...formItemLayout} label="单一承接人：">
                            <Select className="select"
                                    value={evalData.single_contractor}
                                    onChange={(e) => {
                                        actions[modelName].handleChange({value: e, key: 'single_contractor'})
                                    }}>
                                {employeeDic}
                            </Select>
                        </FormItem>
                    </Col>
                    <Col span={2} pull={3}>
                        <span className="star">*</span>
                    </Col>
                </Col>
            )
        }

    return (
            <div>

                <Form>
                    <Row gutter={60}>
{/*
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="计划ID：">
                                    <Input
                                        value={evalData.plan_id}
                                        onChange={(e) => {
                                            actions[modelName].handleChange({value: e.target.value, key: 'plan_id'})
                                        }}
                                        disabled
                                        placeholder="计划ID"/>
                                </FormItem>
                            </Col>
                        </Col>
*/}
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="计划名称：">
                                    <Input
                                        value={evalData.plan_name}
                                        onChange={(e) => {
                                            actions[modelName].handleChange({value: e.target.value, key: 'plan_name'})
                                        }}
                                        disabled
                                        placeholder="计划名称"/>

                                </FormItem>
                            </Col>
                            <Col span={2} pull={3}>
                                <span className="star">*</span>
                            </Col>
                        </Col>
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="考评对象："
                                          validateStatus={evalData.evaluate_object_code ? '' : 'error'}>
                                    <Select size="default"
                                            style={{width: '100%'}}
                                            allowClear
                                            value={evalData.evaluate_object_code}
                                            onChange={(e) => {
                                                actions[modelName].handleChange({value: e, key: 'evaluate_object_code'})
                                            }}
                                    >
                                        {evaluateObject}
                                    </Select>
                                </FormItem>
                            </Col>
                            <Col span={2} pull={3}>
                                <span className="star">*</span>
                            </Col>
                        </Col>
                        {single}
                       {/* <Col span={8}>
                            <FormItem {...formItemLayout} label="单一承接人：">
                                <Select className="select"
                        value={evalData.single_contractor}
                                        onChange={(e) => {
                                            actions[modelName].handleChange({value: e, key: 'single_contractor'})
                                        }}>
                                    {employeeDic}
                                </Select>
                                 <Input
                        value={evalData.single_contractor}
                                 onChange={(e) => {
                                 actions.createPlanEvaluation.handleChange({
                                 value: e.target.value,
                                 key: 'single_contractor'
                                 })
                                 }}
                                 placeholder="单一承接人"/>

                            </FormItem>
                        </Col>*/}
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="考评类别："
                                          validateStatus={evalData.evaluate_type_code ? '' : 'error'}>
                                    <Select size="default"
                                            style={{width: '100%'}}
                                            allowClear
                                            value={evalData.evaluate_type_code}
                                            onChange={(e) => {
                                                actions[modelName].handleChange({value: e, key: 'evaluate_type_code'})
                                            }}
                                    >
                                        {evaluateType}
                                    </Select>

                                </FormItem>
                            </Col>
                            <Col span={2} pull={3}>
                                <span className="star">*</span>
                            </Col>
                        </Col>
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="考评子类别：">
                                    <Select size="default"
                                            style={{width: '100%'}}
                                            allowClear
                                            value={evaluate_sup_type}
                                            onChange={(e) => {
                                                actions[modelName].handleChange({value: e, key: 'evaluate_sup_type_code'})
                                            }}
                                    >
                                        {evaluateSupType}
                                    </Select>

                                </FormItem>
                            </Col>
                        </Col>
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="考评等级："
                                          validateStatus={evalData.evaluate_level_code ? '' : 'error'}>
                                    <Select size="default"
                                            style={{width: '100%'}}
                                            allowClear
                                            value={evalData.evaluate_level_code}
                                            onChange={(e) => {
                                                actions[modelName].handleChange({value: e, key: 'evaluate_level_code'})
                                            }}
                                    >
                                        {evaluateLevel}
                                    </Select>

                                </FormItem>
                            </Col>
                            <Col span={2} pull={3}>
                                <span className="star">*</span>
                            </Col>
                        </Col>
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="考评人：">
                                    <Input
                                        value={evalData.evaluate_people}
                                        disabled
                                        onChange={(e) => {
                                            actions[modelName].handleChange({
                                                value: e.target.value,
                                                key: 'evaluate_people'
                                            })
                                        }}
                                        placeholder="考评人"/>

                                </FormItem>
                            </Col>
                        </Col>
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="考评时间：">
                                    <Input
                                        value={evalData.evaluate_time}
                                        disabled
                                        onChange={(e) => {
                                            actions[modelName].handleChange({
                                                value: e.target.value,
                                                key: 'evaluate_time'
                                            })
                                        }}
                                        placeholder="考评时间"/>

                                </FormItem>
                            </Col>
                        </Col>
                        <Col span={8}>
                            <Col span={22}>
                                <FormItem {...formItemLayout} label="修改时间：">
                                    <Input
                                        value={evalData.modify_time}
                                        disabled
                                        onChange={(e) => {
                                            actions[modelName].handleChange({
                                                value: e.target.value,
                                                key: 'modify_time'
                                            })
                                        }}
                                        placeholder="修改时间"/>

                                </FormItem>
                            </Col>
                        </Col>
                    </Row>
                    <Row >
                        <Col span={22} style={{marginLeft:55}}>
                            <FormItem labelCol={{span: 1}}
                                      wrapperCol={{span: 20}}
                                      label="考评描述：">
                                <div style={{height: 520}}>
                                    <LzEditor
                                        cbReceiver={(e)=>{evalData.evaluate_description=e}}
                                        active={true} lang="en"
                                        importContent={evalData.evaluate_description}
                                    />
                                </div>
                            </FormItem>
                        </Col>
                    </Row>
                </Form>



                <Row>

                    <Col span={8} offset={10}>
                        <Button size="large" icon="save" onClick={() => {
                            actions[modelName].save(evalData)
                        }}>保存</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button size="large" icon="close-circle"
                                onClick={() => {
                                    actions.tabsTmpl.closeCurTab()
                                }}
                        >关闭</Button>
                    </Col>
                </Row>
            </div>

        )
    }
)

export default CreatePlanEvaluation;
export {createCreatePlanEvalModel};