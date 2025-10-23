package com.wmt.demo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wmt.demo.entity.User;
import com.wmt.demo.entity.UserExcelVO;

import java.util.List;

/**
 * 用户服务接口
 *
 * @author WMT
 */
public interface UserService extends IService<User> {

    /**
     * 根据用户名查询用户
     */
    User getByUsername(String username);

    /**
     * 创建用户
     */
    Long createUser(User user);

    /**
     * 导出用户列表
     */
    List<UserExcelVO> exportUsers();

}

