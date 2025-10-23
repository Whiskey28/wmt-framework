package com.wmt.demo.mock;

import com.wmt.framework.common.biz.system.permission.PermissionCommonApi;
import com.wmt.framework.common.biz.system.permission.dto.DeptDataPermissionRespDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Collections;

/**
 * Mock implementation of PermissionCommonApi for demo purposes
 * 
 * @author WMT
 */
@Slf4j
@Component
public class MockPermissionCommonApi implements PermissionCommonApi {

    @Override
    public boolean hasAnyPermissions(Long userId, String... permissions) {
        log.debug("Mock check permissions for user: {}, permissions: {}", userId, permissions);
        return true; // Mock: allow all permissions
    }

    @Override
    public boolean hasAnyRoles(Long userId, String... roles) {
        log.debug("Mock check roles for user: {}, roles: {}", userId, roles);
        return true; // Mock: allow all roles
    }

    @Override
    public DeptDataPermissionRespDTO getDeptDataPermission(Long userId) {
        log.debug("Mock get dept data permission for user: {}", userId);
        DeptDataPermissionRespDTO respDTO = new DeptDataPermissionRespDTO();
        respDTO.setAll(true); // Mock: allow all departments
        respDTO.setSelf(false);
        respDTO.setDeptIds(Collections.emptySet());
        return respDTO;
    }
}

