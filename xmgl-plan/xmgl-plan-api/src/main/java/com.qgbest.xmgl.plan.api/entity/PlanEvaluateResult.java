package com.qgbest.xmgl.plan.api.entity;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
/**
 * Created by quangao on 2017/10/13.
 */
@Data
@Entity
@Table(name = "plan_evaluate_result")
public class PlanEvaluateResult {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "plan_id")
    private Integer plan_id;
    @Column(name = "average_score")
    private Integer average_score;
    @Column(name = "modify_time")
    private String modify_time;
    @Column(name = "plan_name")
    private String plan_name;
}
