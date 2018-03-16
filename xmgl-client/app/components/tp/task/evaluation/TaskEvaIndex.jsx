import React from 'react'
import factory from '../../../ComponentFactory'
import TaskEvaluateResult,{taskEvaluateResultModel} from './TaskEvaluateResult'
import {actions} from "mirrorx";

const TaskEvaIndex = function(){
    let name = "taskEvaluateResult";
    if(!actions[name]){
        taskEvaluateResultModel(name);
    }
    return (
        <div>
            <TaskEvaluateResult modelName = {name}/>
        </div>)
}

factory.register('TaskEvaIndex',<TaskEvaIndex />)
export default TaskEvaIndex