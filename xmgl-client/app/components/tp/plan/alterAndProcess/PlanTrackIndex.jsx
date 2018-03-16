import React from 'react'
import factory from '../../../ComponentFactory'
import PlanTrack, {createPlanTrackModel} from './PlanTrack'
import {actions} from "mirrorx"

const PlanTrackIndex = function(){
    let name = "planTrack";
    if(!actions[name]){
        createPlanTrackModel(name);
    }
    return(
        <div>
            <PlanTrack modelName = {name}/>
        </div>)
}

factory.register('PlanTrackIndex',<PlanTrackIndex />)