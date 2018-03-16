package com.qgbest.xmgl.task.api.entity;
import lombok.Data;
import org.hibernate.annotations.Type;

import javax.persistence.*;
/**
 * Created by quangao on 2017/9/28.
 */
@Data
@Entity
@Table(name = "task_evaluate_result")
public class TaskEvaluateResult {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id",length = 32,nullable = false,unique = true)
    private Integer id;
    @Column(name = "task_id")
    private Integer task_id;
    @Column(name = "average_score")
    private Integer average_score;
    @Column(name = "modify_time")
    private String modify_time;
    @Column(name = "task_name")
    private String task_name;
}
