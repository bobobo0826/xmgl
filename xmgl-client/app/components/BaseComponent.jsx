import React from 'react'

class BaseComponent extends React.Component {

    token = sessionStorage.getItem('api_token')
    getAccessToken() {
        return this.token
    }
    clearToken()
    {
        sessionStorage.removeItem('api_token')
    }
    old_web_host = "http://192.168.117.105:8080"



}
export default BaseComponent