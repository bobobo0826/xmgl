import React from 'react'

class ComponentFactory
{
    components = {}
    register(key,obj)
    {
        this.components[key] = obj
    }
    getComponents = function (key) {
       return this.components[key]
    }
}

export default  new ComponentFactory()