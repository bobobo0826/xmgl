import React from 'react'
import PlanInfo, {createPlanInfoModel} from './PlanInfo'
import {Row} from 'antd';
import factory from '../../ComponentFactory'
import {getJson} from "../../request";
import {actions} from "mirrorx";


const CreatePlanIndex = function () {
    let name;
    do {
        name = `newPlan${Math.random()}`;
    }while (actions[name]);
    if (!actions[name]) {
        createPlanInfoModel(name);
    }
    return (
        <div style={{'marginTop': '20px'}}>
            <PlanInfo planId = {-1} modelName = {name}/>
        </div>)
}
factory.register('CreatePlanIndex', <CreatePlanIndex />)
export default CreatePlanIndex