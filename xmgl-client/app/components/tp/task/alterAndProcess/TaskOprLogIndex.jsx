import React from 'react'
import factory from '../../../ComponentFactory'
import {createTaskProcessModel} from "./TaskProcess";
import TaskProcess from "./TaskProcess";
import {actions} from "mirrorx";

const TaskOprLogIndex = function(){
    let modelName = "taskOprLog";
    if(!actions[modelName]){
        createTaskProcessModel(modelName);
    }
    return (
        <div>
            <TaskProcess modelName = {modelName}/>
        </div>)
}

factory.register('TaskOprLogIndex',<TaskOprLogIndex />)