package com.qgbest.xmgl.employee.api.entity;
import lombok.Data;

import javax.persistence.*;

/**
 * Created by quangao on 2017/5/9.
 *
 *
 */
@Data
@Entity
@Table(name="d_common_dic")
public class Dictionary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 64,nullable = false,unique = true)
    private Integer id;
    @Column(name = "data_name",length = 32)
    private String data_name;
    @Column(name="data_desc",length =32 )
    private String data_desc;
    @Column(name="data_code",length = 32)
    private String data_code;
    @Column(name="is_used",length =32)
    private Integer is_used;
    @Column(name="business_type",length=32)
    private String business_type;
    @Column(name="business_name",length=32)
    private String business_name;
    @Column(name="parent_code",length=32)
    private String parent_code;


}
