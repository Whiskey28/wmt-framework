package com.wmt.demo.controller;

import com.wmt.framework.common.pojo.CommonResult;
import com.wmt.demo.entity.User;
import com.wmt.demo.entity.UserExcelVO;
import com.wmt.demo.service.UserService;
import com.wmt.framework.excel.core.util.ExcelUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * 用户管理Controller
 *
 * @author WMT
 */
@Slf4j
@Tag(name = "用户管理")
@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    /**
     * 获取用户列表
     */
    @Operation(summary = "获取用户列表")
    @GetMapping("/list")
    public CommonResult<List<User>> list() {
        List<User> users = userService.list();
        return CommonResult.success(users);
    }

    /**
     * 根据ID获取用户
     */
    @Operation(summary = "根据ID获取用户")
    @GetMapping("/{id}")
    public CommonResult<User> getById(@PathVariable Long id) {
        User user = userService.getById(id);
        return CommonResult.success(user);
    }

    /**
     * 根据用户名获取用户（使用Redis缓存）
     */
    @Operation(summary = "根据用户名获取用户")
    @GetMapping("/username/{username}")
    public CommonResult<User> getByUsername(@PathVariable String username) {
        User user = userService.getByUsername(username);
        return CommonResult.success(user);
    }

    /**
     * 创建用户
     */
    @Operation(summary = "创建用户")
    @PostMapping
    public CommonResult<Long> create(@RequestBody User user) {
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        Long id = userService.createUser(user);
        return CommonResult.success(id);
    }

    /**
     * 更新用户
     */
    @Operation(summary = "更新用户")
    @PutMapping
    public CommonResult<Boolean> update(@RequestBody User user) {
        user.setUpdateTime(LocalDateTime.now());
        boolean result = userService.updateById(user);
        return CommonResult.success(result);
    }

    /**
     * 删除用户
     */
    @Operation(summary = "删除用户")
    @DeleteMapping("/{id}")
    public CommonResult<Boolean> delete(@PathVariable Long id) {
        boolean result = userService.removeById(id);
        return CommonResult.success(result);
    }

    /**
     * 测试Redis缓存
     */
    @Operation(summary = "测试Redis缓存")
    @PostMapping("/redis/test")
    public CommonResult<String> testRedis(@RequestParam String key, @RequestParam String value) {
        redisTemplate.opsForValue().set(key, value, 300, TimeUnit.SECONDS);
        Object result = redisTemplate.opsForValue().get(key);
        return CommonResult.success("存储成功，读取值：" + result);
    }

    /**
     * 导出用户Excel
     */
    @Operation(summary = "导出用户Excel")
    @GetMapping("/export")
    public void export(HttpServletResponse response) throws IOException {
        List<UserExcelVO> data = userService.exportUsers();
        ExcelUtils.write(response, "用户列表.xlsx", "用户数据", UserExcelVO.class, data);
    }

}

