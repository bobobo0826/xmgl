package com.qgbest.xmgl.worklog.service.service;


import com.qgbest.xmgl.common.utils.JsonUtil;
import com.qgbest.xmgl.worklog.service.dao.DicRepository;
import com.qgbest.xmgl.worklog.service.dao.SysdataGridDefaultRepository;
import com.qgbest.xmgl.worklog.service.dao.SysdataGridPersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import redis.clients.jedis.Jedis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by xw on 2017/6/19.
 */
@Service
@Transactional
public class RedisService {
    @Autowired
    private DicRepository dicRepository;
    @Autowired
    private SysdataGridDefaultRepository sysdataGridDefaultRepository;
  /*  @Autowired
    private SysdataGridQueryRepository sysdataGridQueryRepository;*/
    @Autowired
    private SysdataGridPersonRepository sysdataGridPersonRepository;
    public Map redisDicSet(String key){
        Jedis jedis = new Jedis();
        jedis.select(0);
        List list = dicRepository.getDicListByBusinessCode(key);
        if (list!=null&&list.size()>0){
            for (int i=0;i<list.size();i++){
                Map map = (Map)list.get(i);
                String value = JsonUtil.toJson(map);
                jedis.lpush(key,value);
            }
        }
        Map map = new HashMap<>();
        map.put("success", "成功");
        return map;
    }
    //取字典缓存
    public List redisDicGet(String key){
        Jedis jedis = new Jedis();
        List result = new ArrayList();
        jedis.select(0);
        List<String> list = jedis.lrange(key,0,-1);
        if(list != null)
        {
            for(String tmp:list)
            {
                Map a = JsonUtil.fromJsonToMap(tmp);
                result.add(a);
            }
        }
        return result;
    }
    //加系统列表缓存
    public Map redisSysConfigSet(String module_code){
        Jedis jedis = new Jedis();
        jedis.select(1);
        List list = sysdataGridDefaultRepository.getBaseJson(module_code);
        if (list!=null&&list.size()>0){
            for (int i=0;i<list.size();i++){
                Map map = (Map)list.get(i);
                String key = "sysdata_grid_default_config_"+module_code;
                String value =map.get("conf_val").toString();
                jedis.set(key, value);
            }
        }
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }
    //取列表缓存
    public String redisSysConfigGet(String key){
        Jedis jedis = new Jedis();
        jedis.select(1);
        String value = jedis.get("sysdata_grid_default_config_" + key);
        return value;
    }

   /* //加系统列表缓存
    public Map redisSysQuerySet(String module_code){
        Jedis jedis = new Jedis();
        jedis.select(1);
        List list = sysdataGridQueryRepository.getBaseJson(module_code);
        if (list.size()>0&&list!=null){
            for (int i=0;i<list.size();i++){
                Map map = (Map)list.get(i);
                String key = "sysdata_grid_query_config_"+module_code;
                String value =map.get("base_json").toString();
                jedis.set(key, value);
            }
        }
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }*/
    //取列表缓存
    public String redisSysQueryGet(String key){
        Jedis jedis = new Jedis();
        jedis.select(1);
        String value = jedis.get("sysdata_grid_query_config_" + key);
        return value;
    }

    //加系统列表缓存
    public Map redisSysPersonQuerySet(Integer key){
        Jedis jedis = new Jedis();
        jedis.select(1);
        List list = sysdataGridPersonRepository.findConfValById(key);
        if (list!=null&&list.size()>0){
            for (int i=0;i<list.size();i++){
                Map map = (Map)list.get(i);
                String keys = "sysdata_grid_person_config_"+key;
                String value =map.get("conf_val").toString();
                jedis.set(keys, value);
            }
        }
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }
    //取列表缓存
    public String redisSysPersonQueryGet(Integer key){
        Jedis jedis = new Jedis();
        jedis.select(1);
        String value = jedis.get("sysdata_grid_person_config_"+key);
        return value;
    }

    public Map updateDicRedis(String key,List value){

        Jedis jedis = new Jedis();
        jedis.select(0);
        if (value!=null&&value.size()>0){
            for (int i=0;i<value.size();i++){
                Map map = (Map)value.get(i);
                String values = value.get(i).toString();
                jedis.lpush(key, values);
            }
        }
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }
    public Map updateSysConfigRedis(String key,String value){
        Jedis jedis = new Jedis();
        jedis.select(1);
        jedis.set("sysdata_grid_default_config_" + key, value);
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }
    public Map updateSysQueryRedis(String key,String value){
        Jedis jedis = new Jedis();
        jedis.select(1);
        jedis.set("sysdata_grid_query_config_" + key, value);
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }
    public Map updateSysPersonQueryRedis(String key,String value){
        Jedis jedis = new Jedis();
        jedis.select(1);
        jedis.set("sysdata_grid_person_config_" + key, value);
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }
    /**
     * 是否存在缓存
     * @param key
     * @return
     */
    public Boolean isExistCache(String key){
        Jedis jedis = new Jedis();
        Boolean isExist = jedis.exists(key);
        return isExist;
    }

    /**
     * 删除缓存
     * @param key
     */
    public void deleteRedisCache(String key){
        Jedis jedis = new Jedis();
        jedis.del(key);
    }
   /* public void getSelectRedis(){
        Jedis jedis = new Jedis();
        jedis.select(0);
        Set s= jedis.keys("*");
        Iterator it = s.iterator();
        List listP = new ArrayList<>();
 
        while(it.hasNext()){
            String key = (String)it.next();
            List value = jedis.lrange(key, 0, -1);
            try {
                Dictionary dictionary = (Dictionary)JsonUtil.fromJson(value.get(0).toString(), Dictionary.class);
                IndexWriter in = new IndexWriter(jedis);
                in.addIdAndIndexItem(key, dictionary.getData_code());
                in.writer();
                Suggest ss1 = new Suggest(jedis);
                ss1.write(dictionary.getData_code());
 
                SuggestSearch ss = new SuggestSearch(jedis);
                List<String> list = ss.search("y");
                System.out.print("list========="+list);
                if (list!=null&&list.size()>0){
                    String keyss = list.get(0).toString();
                    System.out.print("keyss========"+keyss);
                    IndexSearch indexSearch = new IndexSearch(jedis);
                    List keysss = indexSearch.search(keyss);
                    System.out.print("keyssss===="+keysss);
                    List dicList = jedis.lrange(keysss.get(0).toString(), 0, -1);
                    System.out.print("dicList============"+dicList);
                    listP.add(dicList.get(0));
                }
                jedis.del(dictionary.getData_code(),"tempKey");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        System.out.print("list========="+listP);
 
    }
    //加系统列表缓存
    public Map redisSySet(){
        Jedis jedis = new Jedis();
        jedis.select(2);
        List list = this.dicRepositoryExtends.getCSList();
        if (list.size()>0&&list!=null){
            for (int i=0;i<list.size();i++){
                Map map = (Map)list.get(i);
                String key = "ts_module"+map.get("id");
                String value =JsonUtil.toJson(map);
                jedis.set(key, value);
            }
        }
        Map map = new HashMap<>();
        map.put("success","成功");
        return map;
    }*/
}