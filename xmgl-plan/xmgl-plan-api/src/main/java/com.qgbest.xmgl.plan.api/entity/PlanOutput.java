package com.qgbest.xmgl.plan.api.entity;

import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;

/**
 * Created by wangchao on 2017/10/12.
 */
@Data
@Entity
@Table(name = "plan_output")
public class PlanOutput {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", length = 32, nullable = false, unique = true)
    private Integer id;

    @Column(name = "plan_id")
    private Integer plan_id;

    @Column(name = "output_category")
    private String output_category;

    @Column(name = "order_num")
    private String order_num;

    @Column(name = "output_type")
    private String output_type;

    @Column(name = "doc_name")
    private String doc_name;

    @Column(name = "output_desc")
    private String output_desc;

    @Column(name = "attachment")
    @Type(type= "com.qgbest.xmgl.common.service.utils.StringJsonUserType")
    private String attachment;

    @Override
    public boolean equals(Object o) {//未比较附件信息的改变
        if (this == o) return true;
        if (!(o instanceof PlanOutput)) return false;
        if (!super.equals(o)) return false;

        PlanOutput that = (PlanOutput) o;

        if (!getId().equals(that.getId())) return false;
        if (getPlan_id() != null ? !getPlan_id().equals(that.getPlan_id()) : that.getPlan_id() != null) return false;
        if (getOutput_category() != null ? !getOutput_category().equals(that.getOutput_category()) : that.getOutput_category() != null)
            return false;
        if (getOrder_num() != null ? !getOrder_num().equals(that.getOrder_num()) : that.getOrder_num() != null)
            return false;
        if (getOutput_type() != null ? !getOutput_type().equals(that.getOutput_type()) : that.getOutput_type() != null)
            return false;
        if (getDoc_name() != null ? !getDoc_name().equals(that.getDoc_name()) : that.getDoc_name() != null)
            return false;
        return getOutput_desc() != null ? getOutput_desc().equals(that.getOutput_desc()) : that.getOutput_desc() == null;
    }
}
