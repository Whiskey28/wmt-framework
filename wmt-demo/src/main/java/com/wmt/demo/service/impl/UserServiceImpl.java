package com.wmt.demo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wmt.demo.entity.User;
import com.wmt.demo.entity.UserExcelVO;
import com.wmt.demo.mapper.UserMapper;
import com.wmt.demo.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 用户服务实现
 *
 * @author WMT
 */
@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Override
    @Cacheable(value = "user", key = "#username")
    public User getByUsername(String username) {
        log.info("查询用户: {}", username);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username);
        return getOne(wrapper);
    }

    @Override
    @CacheEvict(value = "user", allEntries = true)
    public Long createUser(User user) {
        log.info("创建用户: {}", user.getUsername());
        save(user);
        return user.getId();
    }

    @Override
    public List<UserExcelVO> exportUsers() {
        List<User> users = list();
        List<UserExcelVO> result = new ArrayList<>();
        for (User user : users) {
            UserExcelVO vo = new UserExcelVO();
            vo.setUsername(user.getUsername());
            vo.setNickname(user.getNickname());
            vo.setEmail(user.getEmail());
            vo.setMobile(user.getMobile());
            vo.setStatus(user.getStatus() == 1 ? "正常" : "禁用");
            result.add(vo);
        }
        return result;
    }

}

