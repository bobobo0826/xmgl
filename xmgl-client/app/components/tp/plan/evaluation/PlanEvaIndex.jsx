import React from 'react'
import factory from '../../../ComponentFactory'
import PlanEvaluateResult,{planEvaluateResultModel} from './PlanEvaluateResult'
import {actions} from "mirrorx";

const PlanEvaIndex = function(){
    let name = "planEvaluateResult";
    if(!actions[name]){
        planEvaluateResultModel(name);
    }
    return (
        <div>
            <PlanEvaluateResult modelName = {name}/>
        </div>
    )
}

factory.register('PlanEvaIndex',<PlanEvaIndex />)
export default PlanEvaIndex