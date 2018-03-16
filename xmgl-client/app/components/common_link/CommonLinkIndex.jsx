import React from "react"
import {LeftMenuTemplate, Page404, TmplFunc} from '../Components.tmpl'
import "../hook";
const menuid = TmplFunc.getUrlParam("menuid");
let CommonLinkIndex = () => <Page404 />;
if (menuid) {
    CommonLinkIndex = () => (
        <LeftMenuTemplate menuid = {menuid}/>
    );
}
export default CommonLinkIndex