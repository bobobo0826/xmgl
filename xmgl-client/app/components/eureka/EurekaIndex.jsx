import React from "react"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let EurekaIndex = () => <Page404 />;
if (menuid) {
    EurekaIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default EurekaIndex