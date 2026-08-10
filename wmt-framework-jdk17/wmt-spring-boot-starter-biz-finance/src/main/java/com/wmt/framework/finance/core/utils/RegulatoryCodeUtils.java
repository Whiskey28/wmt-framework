package com.wmt.framework.finance.core.utils;

import cn.hutool.core.io.resource.ResourceUtil;
import cn.hutool.core.lang.Assert;
import cn.hutool.core.text.csv.CsvRow;
import cn.hutool.core.text.csv.CsvUtil;
import cn.hutool.core.util.StrUtil;
import com.wmt.framework.finance.core.RegulatoryCode;
import com.wmt.framework.finance.core.enums.RegulatoryCodeTypeEnum;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import static com.wmt.framework.common.util.collection.CollectionUtils.convertList;

/**
 * 监管集市码表工具类（所属行业代码 / GB/T 4754-2017）
 *
 * @author wmt
 */
@Slf4j
public class RegulatoryCodeUtils {

    @SuppressWarnings("InstantiationOfUtilityClass")
    private final static RegulatoryCodeUtils INSTANCE = new RegulatoryCodeUtils();

    /**
     * 代码 → 节点
     */
    private static Map<String, RegulatoryCode> codes;
    /**
     * 门类根节点（A–T）
     */
    private static List<RegulatoryCode> roots;

    private RegulatoryCodeUtils() {
        long now = System.currentTimeMillis();
        codes = new HashMap<>();
        roots = new ArrayList<>();

        List<CsvRow> rows = CsvUtil.getReader().read(ResourceUtil.getUtf8Reader("regulatory-code.csv")).getRows();
        rows.remove(0); // header
        for (CsvRow row : rows) {
            RegulatoryCode node = new RegulatoryCode(row.get(0), row.get(1), Integer.valueOf(row.get(2)),
                    null, new ArrayList<>());
            codes.put(node.getCode(), node);
        }

        for (CsvRow row : rows) {
            RegulatoryCode node = codes.get(row.get(0));
            String parentCode = row.get(3);
            if (StrUtil.isBlank(parentCode)) {
                roots.add(node);
                continue;
            }
            RegulatoryCode parent = codes.get(parentCode);
            Assert.notNull(parent, "{}:找不到父节点 {}", node.getCode(), parentCode);
            Assert.isTrue(node != parent, "{}:父子节点相同", node.getCode());
            node.setParent(parent);
            parent.getChildren().add(node);
        }
        log.info("启动加载 RegulatoryCodeUtils 成功，共 {} 条，根节点 {} 个，耗时 ({}) 毫秒",
                codes.size(), roots.size(), System.currentTimeMillis() - now);
    }

    /**
     * 获得指定代码对应的节点
     *
     * @param code 行业代码
     * @return 节点；不存在时返回 null
     */
    public static RegulatoryCode getRegulatoryCode(String code) {
        return codes.get(code);
    }

    /**
     * 获得门类根节点列表（国民经济行业分类第一层）
     *
     * @return 根节点列表
     */
    public static List<RegulatoryCode> getRootList() {
        return roots;
    }

    /**
     * 获取指定类型的节点列表
     *
     * @param type 类型
     * @param func 转换函数
     * @param <T>  结果类型
     * @return 结果列表
     */
    public static <T> List<T> getByType(RegulatoryCodeTypeEnum type, Function<RegulatoryCode, T> func) {
        return convertList(codes.values(), func, node -> type.getType().equals(node.getType()));
    }

}
