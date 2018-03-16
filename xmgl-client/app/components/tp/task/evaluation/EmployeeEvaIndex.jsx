import React from 'react'
import factory from '../../../ComponentFactory'
import {actions} from "mirrorx";
import EmployeeEvaluateResultList,{employeeEvaluateResultModel}from './EmployeeEvaluateResultList'

const EmployeeEvaIndex = function(){
    let name = "employeeEvaluateResult";
    if(!actions[name]){
        employeeEvaluateResultModel(name);
    }
    return (
        <div>
            <EmployeeEvaluateResultList modelName = {name}/>
        </div>)
}

factory.register('EmployeeEvaIndex',<EmployeeEvaIndex />)
export default EmployeeEvaIndex