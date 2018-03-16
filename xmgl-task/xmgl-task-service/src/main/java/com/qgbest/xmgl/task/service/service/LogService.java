package com.qgbest.xmgl.task.service.service;

import com.qgbest.xmgl.common.utils.DateUtils;
import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.task.api.constants.ServiceConstants;
import com.qgbest.xmgl.task.api.entity.FormOperate;
import com.qgbest.xmgl.task.api.entity.FormOperateType;
import com.qgbest.xmgl.task.api.entity.FormType;
import com.qgbest.xmgl.task.service.dao.FormOperateRepository;
import com.qgbest.xmgl.task.service.dao.FormOperateTypeRepository;
import com.qgbest.xmgl.task.service.dao.LogRepository;
import com.qgbest.xmgl.task.service.dao.LogRepositoryExtend;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by xw on 2017/5/11 0011.
 */
@Service
@Transactional
public class LogService {
    @Autowired
    private LogRepository logRepository;
    @Autowired
    private FormOperateRepository formOperateRepository;
    @Autowired
    private LogRepositoryExtend logRepositoryExtend;
    @Autowired
    private FormOperateTypeRepository formOperateTypeRepository;

    private static Object lock = new Object();


    /**
     * 新增日志
     * @param operateTypeName 操作名称
     * @param bussinessId 业务ID
     * @param oldObject 旧model
     * @param newObject 新model
     * @param formTypeName 模块名称
     * @param userName 用户信息
     * @param operaterDescrip 操作信息
     * @param operaterTitle 日志标题
     */
    @Async
    public void addLog( String operateTypeName, String bussinessId,String oldObject,String newObject,String formTypeName,String userName,Integer userId,String operaterDescrip, String operaterTitle) {
        synchronized (lock) {
            FormType formType =getFormType(formTypeName);
            if (formType == null)
                return ;
            int formTypeId = formType.getId();
            FormOperate logMessage = new FormOperate();
            logMessage.setBusinesspk(bussinessId);
            logMessage.setTitle(operaterTitle);
            logMessage.setOperatetime(DateUtils.getCurDateTime());
            if (!userName.equals("")) {
                logMessage.setDatapermission(userName);
                logMessage.setOperator(String.valueOf(userId));
            }
            logMessage.setFormtype(formTypeId);
            if (ServiceConstants.add_operate.equals(operateTypeName) || ServiceConstants.delete_operate.equals(operateTypeName) || ServiceConstants.modify_operate.equals(operateTypeName))
            {
                System.out.println("--------------"+operateTypeName+"\n"+formTypeId+"\n"+logMessage+"\n"+oldObject+"\n"+newObject+"\n"+operaterDescrip+"\n"+formTypeId);
                addLog(operateTypeName, formTypeId, logMessage, oldObject, newObject, operaterDescrip, formTypeId);
            }
            else {
                try {
                    throw new Exception("找不到该操作类型");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

    }

    /**
     * 保存日志
     * @param operateTypeName
     * @param formType
     * @param logMessage
     * @param oldObject
     * @param newObject
     * @param operaterDescrip
     * @param formTypeId
     */
    private void addLog(String operateTypeName, Integer formType, FormOperate logMessage, String oldObject,
                        String newObject, String operaterDescrip, Integer formTypeId) {
        FormOperateType formOperateType = getFormOperateType(operateTypeName, formType);
        if (formOperateType != null) {
            logMessage.setOperatetypeid(formOperateType.getOperatetypeid());
            if (operaterDescrip!=null&&!operaterDescrip.equals("")) {
                logMessage.setOperaterdescrip(operaterDescrip);
            } else {
                String changeContentStr = getLogDetailObj(oldObject, newObject, operateTypeName,
                        formOperateType.getOperatetypeid(), formTypeId);
                if (changeContentStr==null||changeContentStr.equals("")) {
                    return;
                } else {
                    logMessage.setOperaterdescrip(changeContentStr);
                }
            }
            // 设置变更内容
            if(oldObject!=null&&!oldObject.equals("null")){
                logMessage.setOldmodel(oldObject);
            }
            if(newObject!=null&&!newObject.equals("null")){
                logMessage.setNewmodel(newObject);
            }
            logMessage.setActiontype(operateTypeName);
            addFormOperateLog(logMessage);
        }
    }
    /**
     * 获取日志模块操作
     * @param operateTypeName
     * @param formType
     * @return
     */
    private FormOperateType getFormOperateType(String operateTypeName, Integer formType) {
        List<Object> FormOperateTypeList =getFormOperateTypeList(formType, operateTypeName);
        FormOperateType formOperateType = null;
        if (null != FormOperateTypeList && FormOperateTypeList.size() > 0) {

           // formOperateType = (FormOperateType) FormOperateTypeList.get(0);
            formOperateType =(FormOperateType) JsonUtil.fromJson(JsonUtil.toJson(FormOperateTypeList.get(0)),
                    FormOperateType.class);
        } else {
            try {
                throw new Exception("找不到该操作类型");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return formOperateType;
    }

    /**
     * 组装日志内容
     * @param oldObject
     * @param newObject
     * @param operateTypeName
     * @param operateTypeId
     * @param fromTypeId
     * @return
     */
    private String getLogDetailObj(String oldObject, String newObject, String operateTypeName, Integer operateTypeId,
                                  Integer fromTypeId) {
        String changeContentStr = "";
        try {
            FormOperateType formOperateType =getFormOperateTypeListById(operateTypeId);
            FormType formType =getFormOperateTypeById(fromTypeId);
            if (formType == null)
                return null;
            String mainTableShowType = formOperateType.getMaintableshowtype();
            List compareFieldList =getCompareFieldList(formType.getId());
            if (mainTableShowType==null||mainTableShowType.equals(""))
                return null;
            else if (mainTableShowType.equals("ADD")) {
                changeContentStr = "添加了一条记录";
            } else if (mainTableShowType.equals("DELETE")) {
                changeContentStr = "删除了一条记录";
            } else {
                String propertyName = "";
                String fieldType = "";
                String fieldDisName = "";
                String hasHypeLink = "";
                // changeContentStr += getTableHeader();
                for (int i = 0; i < compareFieldList.size(); i++) {
                    Map compareFieldMap = (Map) compareFieldList.get(i);
                    propertyName = compareFieldMap.get("fieldname").toString();
                    fieldType = compareFieldMap.get("fieldtype").toString();
                    fieldDisName = compareFieldMap.get("fielddesc").toString();
                    hasHypeLink = compareFieldMap.get("hashyperlink").toString();
                    String oldValue = String
                            .valueOf((JsonUtil.fromJsonToMap(oldObject)).get(propertyName));
//					oldValue = getDateNameById(oldValue, fromTypeId, propertyName, "");
                    String newValue = String
                            .valueOf((JsonUtil.fromJsonToMap(newObject)).get(propertyName));
//					newValue = getDateNameById(newValue, fromTypeId, propertyName, "");
                    if (!"jsonb".equals(fieldType)) {
                        if ("1".equals(hasHypeLink)) {
                            if (!equals(oldValue, newValue)) {
                                oldValue = getDateNameById(oldValue, fromTypeId, propertyName, "");
                                newValue = getDateNameById(newValue, fromTypeId, propertyName, "");
                                changeContentStr += fieldDisName + ":";
                                if (oldValue!=null&&!oldValue.equals("") && !"null".equals(oldValue)) {
                                    changeContentStr += oldValue + "被修改为:" + newValue + "  ;";
                                } else {
                                    changeContentStr += "新增:" + newValue + "  ;";
                                }
                            }

                        } else {
                            if (!equals(oldValue, newValue)) {
                                changeContentStr += fieldDisName + ":";
                                if (oldValue!=null&& !oldValue.equals("")&& !"null".equals(oldValue)) {
                                    changeContentStr += oldValue + "被修改为:" + newValue + "  ;";
                                } else {
                                    changeContentStr += "新增:" + newValue + "  ;";
                                }
                            }
                        }
                    } else {
                        String newStr = String
                                .valueOf((JsonUtil.fromJsonToMap(newObject)).get(propertyName));
                        String oldStr = String
                                .valueOf((JsonUtil.fromJsonToMap(oldObject)).get(propertyName));
                        if (newStr!=null&&!newStr.equals("")&&!newStr.equals("null") && oldStr!=null&&!oldStr.equals("")&&!oldStr.equals("null")) {
                            List jsonCompareFieldList =getJsonCompareFieldList(Integer.valueOf(String.valueOf(compareFieldMap.get("id"))).intValue());
                            if (newStr.substring(0, 1).equals("[")) {
                                List newList = JsonUtil.fromJsonToList(newStr);
                                List oldList = JsonUtil.fromJsonToList(oldStr);
                                changeContentStr += compareJson(jsonCompareFieldList, newList, oldList, fieldDisName,
                                        fromTypeId, propertyName);
                            } else {
                                List newList = JsonUtil.fromJsonToList("[" + newStr + "]");
                                List oldList = JsonUtil.fromJsonToList("[" + oldStr + "]");
                                changeContentStr += compareJson(jsonCompareFieldList, newList, oldList, fieldDisName,
                                        fromTypeId, propertyName);
                            }
                        }

                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return changeContentStr;
    }

    /**
     * 比较字段
     * @param jsonCompareFieldList
     * @param newList
     * @param oldList
     * @param fieldDisName
     * @param fromTypeId
     * @param propertyName
     * @return
     */
    private String compareJson(List jsonCompareFieldList, List newList, List oldList, String fieldDisName,
                               Integer fromTypeId, String propertyName) {
        String changeContentStr = "";
        String keyField = "";
        String titleField = "";
        String titleFieldDsc = "";
        // 找出json中主键
        if (jsonCompareFieldList.size() > 0) {
            for (int m = 0; m < jsonCompareFieldList.size(); m++) {
                Map jsonCompareFieldMap = (Map) jsonCompareFieldList.get(m);
                if ("1".equals(jsonCompareFieldMap.get("iskey"))) {
                    keyField = String.valueOf(jsonCompareFieldMap.get("fieldname"));
                    break;
                }
            }
            // 找出json中主要显示字段
            for (int m = 0; m < jsonCompareFieldList.size(); m++) {
                Map jsonCompareFieldMap = (Map) jsonCompareFieldList.get(m);
                if ("1".equals(jsonCompareFieldMap.get("istitle"))) {
                    titleField = String.valueOf(jsonCompareFieldMap.get("fieldname"));
                    titleFieldDsc = String.valueOf(jsonCompareFieldMap.get("fielddesc"));
                    break;
                }
            }
            // 对于json字段有四种可能
            // 1.老字段为空 新字段为空 没有操作
            // 2.老字段为空 新字段不为空 则为添加
            // 3.老字段不为空 新字段为空 删除
            // 4.老字段不为空 新字段不为空 增删改
            if (oldList==null || oldList.size() <= 0) {
                if (newList!=null&&newList.size()>0) {
                    // 添加了新纪录
                    changeContentStr += fieldDisName + "增加了:" + "  ";
                    for (int j = 0; j < newList.size(); j++) {
                        Map compareFieldNewMap = (Map) newList.get(j);
                        changeContentStr += getDateNameById(String.valueOf(compareFieldNewMap.get(titleField)),
                                fromTypeId, propertyName, "") + ",";
                    }
                    changeContentStr += changeContentStr.substring(0, changeContentStr.length() - 1);
                }
            } else {
                if (newList==null|| newList.size() <= 0) {
                    // 做了全部删除操作
                    changeContentStr += fieldDisName + "删除了:" + "  ";
                    for (int j = 0; j < oldList.size(); j++) {
                        Map compareFieldNewMap = (Map) oldList.get(j);
                        changeContentStr += getDateNameById(String.valueOf(compareFieldNewMap.get(titleField)),
                                fromTypeId, propertyName, "") + ",";
                    }
                    changeContentStr += changeContentStr.substring(0, changeContentStr.length() - 1);
                } else {
                    // 新老数据比较：1.新增几条2.删除几条3.修改原有数据
                    int isHavaRecord = 0;
                    int isHavaChanger = 0;
                    for (int j = 0; j < oldList.size(); j++) {
                        Map oldListMap = (Map) oldList.get(j);
                        for (int k = 0; k < newList.size(); k++) {
                            Map newListMap = (Map) newList.get(k);
                            if (oldList.size() == 1) {
                                changeContentStr = excuate(jsonCompareFieldList, newListMap, oldListMap, fromTypeId,
                                        isHavaChanger, changeContentStr, fieldDisName, propertyName);
                            } else {
                                if (oldListMap!=null) {
                                    if (newListMap.get(keyField).equals(oldListMap.get(keyField))) {
                                        changeContentStr = excuate(jsonCompareFieldList, newListMap, oldListMap,
                                                fromTypeId, isHavaChanger, changeContentStr, fieldDisName,
                                                propertyName);
                                    } else {
                                        // 如果主键数值不一样则继续寻找-----
                                        continue;
                                    }
                                }
                            }
                            isHavaRecord++;
                        }
                        // 如果新数据和老数据有对应记录说明这条记录没有被删除，相反这条记录被删除了
                        if (isHavaRecord == 1) {
                            isHavaRecord = 0;
                        } else {
                            changeContentStr += fieldDisName + " 删除了:" + titleFieldDsc + "为： "
                                    + getDateNameById(String.valueOf(oldListMap.get(titleField)), fromTypeId,
                                    titleField, propertyName)
                                    + "  ;";
                        }
                    }
                    isHavaRecord = 0;
                    if (newList.size() > 1) {
                        for (int j = 0; j < newList.size(); j++) {
                            Map newListMap = (Map) newList.get(j);
                            for (int k = 0; k < oldList.size(); k++) {
                                Map oldListMap = (Map) oldList.get(k);
                                if (newListMap.get(keyField).equals(oldListMap.get(keyField))) {
                                    isHavaRecord++;
                                } else {
                                    // 如果主键数值不一样则继续寻找-----
                                    continue;
                                }
                            }
                            // 如果新数据和老数据有对应记录说明这条记录不是新增，相反这条记录是新增的
                            if (isHavaRecord == 1) {
                                isHavaRecord = 0;
                            } else {
                                changeContentStr += fieldDisName + " 新增了:" + titleFieldDsc + "为： "
                                        + getDateNameById(String.valueOf(newListMap.get(titleField)), fromTypeId,
                                        titleField, propertyName)
                                        + "  ;";
                            }
                        }
                    }
                }
            }
        }

        return changeContentStr;
    }
    private String excuate(List jsonCompareFieldList, Map newListMap, Map oldListMap, Integer fromTypeId,
                           Integer isHavaChanger, String changeContentStr, String fieldDisName, String propertyName) {
        // 此处比较相同记录被修改的地方！
        for (int m = 0; m < jsonCompareFieldList.size(); m++) {
            Map jsonCompareFieldMap = (Map) jsonCompareFieldList.get(m);
            String fieldType = jsonCompareFieldMap.get("isjsonfiled").toString();
            if (!"1".equals(fieldType)) {
                String oldValue = "";
                String newValue = "";
                System.out.println("!!!!!!!!!!!"+jsonCompareFieldMap.get("fieldname"));
                System.out.println("!!!!!!!!!!!"+oldListMap);
                if(oldListMap.get(jsonCompareFieldMap.get("fieldname"))!=null){
                    oldValue = String.valueOf(oldListMap.get(jsonCompareFieldMap.get("fieldname").toString()));
                }
                if(newListMap.get(jsonCompareFieldMap.get("fieldname"))!=null){
                    newValue = String.valueOf(newListMap.get(jsonCompareFieldMap.get("fieldname").toString()));
                }

                if (!equals(oldValue, newValue)) {
                    oldValue = getDateNameById(oldValue, fromTypeId, jsonCompareFieldMap.get("fieldname").toString(),
                            propertyName);
                    newValue = getDateNameById(newValue, fromTypeId, jsonCompareFieldMap.get("fieldname").toString(),
                            propertyName);
                    if (isHavaChanger == 0) {
                        changeContentStr += fieldDisName + "中 ：";
                        isHavaChanger++;
                    }
                    changeContentStr += jsonCompareFieldMap.get("fielddesc").toString();
                    if (oldValue!=null&&!oldValue.equals("")) {
                        changeContentStr += oldValue + "被修改为:" + newValue + "  ;";
                    } else {
                        changeContentStr += "新增:" + newValue + "  ;";
                    }

                }
            } else {
                List newList1 = JsonUtil
                        .fromJsonToList(newListMap.get(jsonCompareFieldMap.get("fieldname")).toString());

                List oldList1 = JsonUtil
                        .fromJsonToList(oldListMap.get(jsonCompareFieldMap.get("fieldname")).toString());
                List jsonCompareFieldList1 =getJsonCompareFieldList(Integer.valueOf(jsonCompareFieldMap.get("id").toString()));
                changeContentStr += compareJson(jsonCompareFieldList1, newList1, oldList1, fieldDisName, fromTypeId,
                        propertyName);
            }

        }
        return changeContentStr;
    }

    /**
     * 根据日志模块code获取日志模块名称
     * @param type 日志模块code
     * @return
     */
    public FormType getFormType(String type) {
        return this.logRepository.getFormType(type);
    }

    /**
     * 新建日志
     * @param formOperate 日志model
     */
    public void addFormOperateLog(FormOperate formOperate) {
        this.formOperateRepository.save(formOperate);
    }

    /**
     * 获取日志模块操作
     * @param type
     * @param typeName
     * @return
     */
    public List getFormOperateTypeList(Integer type,String typeName) {
        return this.logRepositoryExtend.getFormOperateTypeList(type,typeName);
    }

    /**
     * 根据ID 获取日志模块操作
     * @param id
     * @return
     */
    public FormOperateType getFormOperateTypeListById(int id) {
        return this.formOperateTypeRepository.getFormOperateTypeListById(id);
    }
    public FormType getFormOperateTypeById(int type) {
        return this.logRepository.getFormOperateTypeById(type);
    }

    /**
     * 获取json比较字段
     * @param id
     * @return
     */
    public List getJsonCompareFieldList(Integer id) {
        return this.logRepositoryExtend.getJsonCompareFieldList(id);
    }
    /**
     * 获取比较字段
     * @param id
     * @return
     */
    public List getCompareFieldList(Integer id) {
        return this.logRepositoryExtend.getCompareFieldList(id);
    }
    public List getDateNameById(Integer id,String fieldName,String parentName) {
        return this.logRepositoryExtend.getDateNameById(id, fieldName, parentName);
    }

    /**
     * 字典表翻译
     * @param oldvalue
     * @param dicTableName
     * @param dicKeyField
     * @param dicValueField
     * @return
     */
    public List getDicDateNameById(String oldvalue, String dicTableName, String dicKeyField, String dicValueField,String dicBusinessType) {
        return this.logRepositoryExtend.getDicDateNameById(oldvalue, dicTableName, dicKeyField, dicValueField,dicBusinessType);
    }


    private Boolean equals(String str1, String str2) {
        if (str1 == null)
            str1 = "";
        if (str2 == null)
            str2 = "";
        if (str1.equals(str2))
            return true;
        else
            return false;
    }
    private String getDateNameById(String oldvalue, int fromTypeId, String fieldName, String parentName) {
        String newValue = oldvalue;
        List list =getDateNameById(fromTypeId, fieldName, parentName);
        if (list.size() > 0) {
            Map map = new HashMap();
            map = (Map) list.get(0);
            String dicTableName = String.valueOf(map.get("dic_tab_name"));
            String dicKeyField = String.valueOf(map.get("dic_tab_key_field"));
            String dicValueField = String.valueOf(map.get("dic_tab_value_field"));
            String dicBusinessType = String.valueOf(map.get("dic_business_type"));
            // 如果字典表名称不为空说明此字段需要翻译
            if (dicTableName!=null&&!dicTableName.equals("")&&!dicTableName.equals("null")) {
                List newList =getDicDateNameById(oldvalue, dicTableName, dicKeyField, dicValueField,dicBusinessType);
                if (newList.size() > 0) {
                    Map  newMap = (Map) newList.get(0);
                    newValue = String.valueOf(newMap.get(dicValueField));
                }
            }
        }
        if ("null".equals(newValue)) {
            newValue = "";
        }
        return newValue;
    }
}
