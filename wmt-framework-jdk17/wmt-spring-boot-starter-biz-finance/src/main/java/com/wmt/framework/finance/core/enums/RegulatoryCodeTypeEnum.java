package com.wmt.framework.finance.core.enums;

import com.wmt.framework.common.core.ArrayValuable;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

/**
 * 国民经济行业分类层级（GB/T 4754-2017）
 *
 * @author wmt
 */
@AllArgsConstructor
@Getter
public enum RegulatoryCodeTypeEnum implements ArrayValuable<Integer> {

    CATEGORY(1, "门类"),
    MAJOR(2, "大类"),
    MIDDLE(3, "中类"),
    MINOR(4, "小类"),
    ;

    public static final Integer[] ARRAYS = Arrays.stream(values()).map(RegulatoryCodeTypeEnum::getType).toArray(Integer[]::new);

    /**
     * 类型
     */
    private final Integer type;
    /**
     * 名字
     */
    private final String name;

    @Override
    public Integer[] array() {
        return ARRAYS;
    }

}
