package com.wmt.framework.finance.core;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.wmt.framework.finance.core.enums.RegulatoryCodeTypeEnum;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

/**
 * 监管集市码表节点（当前为所属行业代码 / GB/T 4754-2017）
 *
 * <p>数据可见 resources/regulatory-code.csv 文件
 *
 * @author wmt
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString(exclude = {"parent"})
public class RegulatoryCode {

    /**
     * 代码，例如 A、A01、A011、A0111
     */
    private String code;
    /**
     * 名称
     */
    private String name;
    /**
     * 类型
     *
     * <p>枚举 {@link RegulatoryCodeTypeEnum}
     */
    private Integer type;

    /**
     * 父节点
     */
    @JsonManagedReference
    private RegulatoryCode parent;
    /**
     * 子节点
     */
    @JsonBackReference
    private List<RegulatoryCode> children;

}
