package com.wmt.framework.finance.core.utils;

import com.wmt.framework.finance.core.RegulatoryCode;
import com.wmt.framework.finance.core.enums.RegulatoryCodeTypeEnum;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

/**
 * {@link RegulatoryCodeUtils} 的单元测试
 *
 * @author wmt
 */
public class RegulatoryCodeUtilsTest {

    @Test
    public void testGetRootList() {
        List<RegulatoryCode> roots = RegulatoryCodeUtils.getRootList();
        assertEquals(20, roots.size());
        assertEquals("A", roots.get(0).getCode());
        assertEquals(RegulatoryCodeTypeEnum.CATEGORY.getType(), roots.get(0).getType());
    }

    @Test
    public void testIndustryHierarchy() {
        RegulatoryCode minor = RegulatoryCodeUtils.getRegulatoryCode("A0111");
        assertNotNull(minor);
        assertEquals("稻谷种植", minor.getName());
        assertEquals(RegulatoryCodeTypeEnum.MINOR.getType(), minor.getType());
        assertEquals("A011", minor.getParent().getCode());
        assertEquals("A01", minor.getParent().getParent().getCode());
        assertEquals("A", minor.getParent().getParent().getParent().getCode());
        assertNull(minor.getParent().getParent().getParent().getParent());
    }

    @Test
    public void testMissingMiddleFallback() {
        // 数据中无中类 A019，小类 A0190 应回挂到大类 A01
        RegulatoryCode node = RegulatoryCodeUtils.getRegulatoryCode("A0190");
        assertNotNull(node);
        assertEquals("A01", node.getParent().getCode());
        assertEquals(RegulatoryCodeTypeEnum.MAJOR.getType(), node.getParent().getType());
    }

}
