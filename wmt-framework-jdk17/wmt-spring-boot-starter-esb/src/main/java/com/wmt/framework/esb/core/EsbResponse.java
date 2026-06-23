package com.wmt.framework.esb.core;

import com.wmt.framework.esb.core.model.EsbAppHead;
import com.wmt.framework.esb.core.model.EsbSysHead;
import lombok.Data;

import java.io.Serializable;

/**
 * ESB 调用完整响应。
 *
 * @param <T> Body 类型
 */
@Data
public class EsbResponse<T> implements Serializable {

    private EsbSysHead sysHead;

    private EsbAppHead appHead;

    private T body;

}
