package com.wmt.demo.entity;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

/**
 * 用户Excel导入导出VO
 *
 * @author WMT
 */
@Data
public class UserExcelVO {

    @ExcelProperty("用户名")
    private String username;

    @ExcelProperty("昵称")
    private String nickname;

    @ExcelProperty("邮箱")
    private String email;

    @ExcelProperty("手机号")
    private String mobile;

    @ExcelProperty("状态")
    private String status;

}

