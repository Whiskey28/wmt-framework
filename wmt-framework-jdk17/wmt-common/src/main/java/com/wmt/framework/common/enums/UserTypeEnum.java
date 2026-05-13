package com.wmt.framework.common.enums;

import cn.hutool.core.util.ArrayUtil;
import com.wmt.framework.common.core.ArrayValuable;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

/**
 * 全局用户类型枚举
 */
@AllArgsConstructor
@Getter
public enum UserTypeEnum implements ArrayValuable<Integer> {

    MEMBER(1, "会员"), // 面向 c 端，普通用户
    ADMIN(2, "管理员"), // 面向 b 端，管理后台
    /**
     * 普惠金融等独立 C 端通道：与 {@link com.wmt.framework.web.config.WebProperties#getPfbApi()} 前缀 /pfb-api 对应；
     * Token 的 userId 通常仍为 system_users.id，与 MEMBER 的 userId 空间区分靠 userType。
     */
    PFB(3, "普惠金融小程序");


    public static final Integer[] ARRAYS = Arrays.stream(values()).map(UserTypeEnum::getValue).toArray(Integer[]::new);

    /**
     * 类型
     */
    private final Integer value;
    /**
     * 类型名
     */
    private final String name;

    public static UserTypeEnum valueOf(Integer value) {
        return ArrayUtil.firstMatch(userType -> userType.getValue().equals(value), UserTypeEnum.values());
    }

    @Override
    public Integer[] array() {
        return ARRAYS;
    }
}
