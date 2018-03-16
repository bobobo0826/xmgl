import React from 'react'
import factory from '../../../ComponentFactory'
import {actions} from "mirrorx";

import PlanEmployeeEvaResult,{planEmployeeEvaResultModel} from './PlanEmployeeEvaResult'

const PlanEmployeeEvaIndex = function(){
    let name = "planEmployeeEvaResult";
    if(!actions[name]){
        planEmployeeEvaResultModel(name);
    }
    return (
        <div>
            <PlanEmployeeEvaResult modelName = {name}/>
        </div>)
}

factory.register('PlanEmployeeEvaIndex',<PlanEmployeeEvaIndex />)
export default PlanEmployeeEvaIndex