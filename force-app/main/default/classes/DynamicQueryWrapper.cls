/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-11-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class DynamicQueryWrapper {
    public class WrapperClass { 
        String fieldApiName;
        String operator;
        List<String> value;
        String dataType;
        
        public WrapperClass(String fieldApiName, String operator, List<String> value, String dataType) {
            this.fieldApiName = fieldApiName;
            this.operator = operator;
            this.value = value;
            this.dataType = dataType;
        }
    }

    public static List<Id> queryRecords(String objectName, List<WrapperClass> conditions) {
        Map<String, List<String>> nameBind = new Map<String, List<String>>();
        String strQuery = 'SELECT Id FROM ' + objectName + ' WHERE ';
        
        // For IN / NOT IN
        for(Integer i = 0; i < conditions.size(); i++) {
            strQuery += conditions[i].fieldApiName + ' ' + conditions[i].operator + ' ' + ':nBind' + i;
            
            if(i < conditions.size() - 1) {
                strQuery += ' AND ';
            }
            
            nameBind.put('nBind' + i, conditions[i].value);
        }
        
        System.debug(strQuery);
        System.debug(nameBind);
        
        List<SObject> queriedRecords = Database.queryWithBinds(strQuery, nameBind, AccessLevel.USER_MODE);
        
        List<Id> objId = new List<Id>();
        for(SObject record : queriedRecords) {
            objId.add(record.Id);
        }
        
        System.debug(objId);
        
        return objId;
    }
}