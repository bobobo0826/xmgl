import React from 'react'
import {Transfer, Button} from 'antd';
import BaseComponent from '../../BaseComponent'
var employeeList=[];
var data;
class SelectEmployee extends BaseComponent {
    constructor(props) {
        super(props)
        this.getDeptAndEmployee = this.getDeptAndEmployee.bind(this);
        this.renderFooter = this.renderFooter.bind(this);
        this.getEmployee = this.getEmployee.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.state = {
            employeeData: [],
            targetKeys: this.props.employees,//右边的员工id
            employees: this.props.employees,
        }
    }

    getDeptAndEmployee() {
        var _this = this;
        fetch('/api/task/getDeptAndEmployee', {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                token: this.token,
            },
        }).then((response) => { //详情参见Promise，也是es6的新特性，使用Promise可以减少代码嵌套，且代码看起来更符合逻辑。
            response
                .json()//这个json一样，尝试将从response中读取出数据转换为对象，也返回一个Promise对象
                .then((responseJson) => {
                    _this.setState({
                        list: responseJson.rows,
                    });
                    employeeList = this.state.list;
                    this.getEmployee();

                })
                .catch((error) => {
                    console.log(error);
                });
        }).catch((error) => {
            console.log(error);
        });


    }

    componentDidMount() {
        this.getDeptAndEmployee();
    }

    getEmployee() {
        const employeeData = [];

        for (let i = 0; i < employeeList.length; i++) {
            data = {
                key: employeeList[i].id,
                title: employeeList[i].dept_name,
                description: employeeList[i].employee_name,
                chosen: 0,
            };

            employeeData.push(data);
        }
        this.setState({employeeData});
    }

    //改变之前执行
    handleChange(targetKeys) {
        const employeesJson = [];    //传给父组件的员工数据
        for (let i = 0; i < employeeList.length; i++) {
            for (let j = 0; j < targetKeys.length; j++) {
                if (employeeList[i].id === targetKeys[j]) {
                    employeesJson.push({
                        id: employeeList[i].id,
                        dept: employeeList[i].dept_name,
                        name: employeeList[i].employee_name,
                    });
                    break;
                }
            }
        }
        this.setState({
                targetKeys: targetKeys,
            },
            () => {
                if (employeesJson) {
                    this.props.updatePerson(JSON.stringify(employeesJson));
                }
            });
    }

    renderFooter() {
        return (
            <Button
                size="small"
                style={{float: 'right', margin: 5}}
                onClick={this.getEmployee}
            >
                reload
            </Button>
        );
    }
    componentWillReceiveProps(nextProps){
        this.setState({
            employees: nextProps.employees,
            targetKeys: nextProps.employees
        })
    }
    componentWillMount() {}
    render() {
        return (
            <Transfer
                dataSource={this.state.employeeData}
                showSearch
                listStyle={{
                    width: 193,
                    height: 280,
                }}
                titles={['未选择', '已选择']}
                operations={['选择', '取消']}
                targetKeys={this.state.targetKeys}
                onChange={this.handleChange}
                render={item => `${item.title}-${item.description}`}
                footer={this.renderFooter}
                notFoundContent={"选择员工"}
            />
        );
    }
}


export default SelectEmployee