import React from 'react';
import BaseComponent from '../../BaseComponent'

class ToolBox extends BaseComponent
{
    constructor(props)
    {
        super(props);
        this.state = {
            items: this.props.items || []
        }
    }
    render(){
        let listItems = this.state.items.map(item =>
            <button key={'btn_' + item.text} type="button" className={'btn ' + item.className} onClick={item.action}>{item.text}</button>
        );
        return(
            <div className={this.state.items.length ? 'list-action' : 'hidden' }>
                {listItems}
            </div>
        );
    }
}
export default ToolBox;