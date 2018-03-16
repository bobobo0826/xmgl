import React from 'react'

class Qingjia extends React.Component
{
    constructor(props)
    {
        super(props)
        this.state = {
            content : '请假管理'
        }
    }
    componentDidMount()
    {
        var _this = this;
        fetch('/auth/getDevToken', {
            method: 'POST',
            mode: 'no-cors',
            headers: {
                'Access-Control-Allow-Origin': '*',
                "Content-Type": "application/json"
            },
            body: JSON.stringify({'username': 'root', 'password': '1'})
        }).then((response) => {
            console.log(response)
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            }
            return response.json()
        }).then((obj) => {
            return fetch('/xmgl-permission/manage/moduleRole/getModuleList',{
                headers : {
                    'Access-Control-Allow-Origin': '*',
                    'token' : obj.token
                },
                mode: 'no-cors'
            })
        }).then((response) => {
            console.log(response)
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            }
            return response.json()
        }).then((obj) => {
            _this.setState({
                content : JSON.stringify(obj)
            });
        }).catch((error) => {
            console.log(error);
        });
    }
    render() {
        return (
            <h1>{this.state.content}</h1>
        )
    }
}
export default Qingjia