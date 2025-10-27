# WMT Excel Starter

基于FastExcel的Excel操作组件，提供Excel导入导出、数据转换、样式设置等功能。

## 功能特性

- 📊 **Excel导入导出**: 支持Excel文件的导入和导出
- 🔄 **数据转换**: 支持数据字典、枚举等数据转换
- 🎨 **样式设置**: 支持Excel样式设置和格式化
- 📝 **注解驱动**: 基于注解的Excel配置
- 🔍 **数据校验**: 支持Excel数据校验
- 📱 **多格式支持**: 支持.xlsx、.xls等格式
- 🔧 **配置灵活**: 支持多种配置方式
- 🛡️ **安全处理**: 支持Excel安全处理

## 快速开始

### 1. 添加依赖

在项目的 `pom.xml` 中添加依赖：

```xml
<dependency>
    <groupId>com.wmt</groupId>
    <artifactId>wmt-spring-boot-starter-excel</artifactId>
    <version>${wmt.version}</version>
</dependency>
```

### 2. 创建Excel实体类

```java
@Data
@ExcelProperty("用户信息")
public class UserExcelVO {
    
    @ExcelProperty("用户ID")
    private Long id;
    
    @ExcelProperty("用户名")
    private String username;
    
    @ExcelProperty("邮箱")
    private String email;
    
    @ExcelProperty("手机号")
    private String mobile;
    
    @ExcelProperty("状态")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_STATUS)
    private Integer status;
    
    @ExcelProperty("创建时间")
    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
```

### 3. 导出Excel

```java
@RestController
public class UserController {
    
    @GetMapping("/users/export")
    public void exportUsers(HttpServletResponse response) throws IOException {
        // 查询用户数据
        List<UserDO> users = userService.getUsers();
        
        // 转换为Excel VO
        List<UserExcelVO> excelData = BeanUtils.toBeanList(users, UserExcelVO.class);
        
        // 导出Excel
        ExcelUtils.write(response, "用户列表.xlsx", "用户信息", UserExcelVO.class, excelData);
    }
}
```

### 4. 导入Excel

```java
@RestController
public class UserController {
    
    @PostMapping("/users/import")
    public CommonResult<String> importUsers(@RequestParam("file") MultipartFile file) throws IOException {
        // 读取Excel数据
        List<UserExcelVO> excelData = ExcelUtils.read(file, UserExcelVO.class);
        
        // 处理导入数据
        String result = userService.importUsers(excelData);
        
        return CommonResult.success(result);
    }
}
```

### 5. 使用数据转换

```java
@Data
@ExcelProperty("用户信息")
public class UserExcelVO {
    
    @ExcelProperty("状态")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_STATUS)
    private Integer status;
    
    @ExcelProperty("用户类型")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_TYPE)
    private Integer userType;
    
    @ExcelProperty("部门")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.DEPT)
    private Long deptId;
}
```

### 6. 自定义数据转换

```java
@Component
public class CustomExcelColumnSelectFunction implements ExcelColumnSelectFunction {
    
    @Override
    public List<String> getOptions() {
        return Arrays.asList("启用", "禁用");
    }
    
    @Override
    public String getFunctionName() {
        return "USER_STATUS";
    }
}
```

## 配置说明

### 基础配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.excel.max-import-rows` | int | 10000 | 最大导入行数 |
| `wmt.excel.max-export-rows` | int | 100000 | 最大导出行数 |
| `wmt.excel.template-path` | String | /templates/excel | 模板路径 |

### 样式配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `wmt.excel.style.header-background-color` | String | #F0F0F0 | 表头背景色 |
| `wmt.excel.style.header-font-color` | String | #000000 | 表头字体色 |
| `wmt.excel.style.data-font-size` | int | 12 | 数据字体大小 |

## 核心功能

### Excel导入导出

#### ExcelUtils工具类

```java
public class ExcelUtils {
    
    /**
     * 导出Excel
     */
    public static <T> void write(HttpServletResponse response, String filename, String sheetName, 
                                 Class<T> head, List<T> data) throws IOException {
        FastExcelFactory.write(response.getOutputStream(), head)
                .autoCloseStream(false)
                .registerWriteHandler(new ColumnWidthMatchStyleStrategy())
                .registerWriteHandler(new SelectSheetWriteHandler(head))
                .registerConverter(new LongStringConverter())
                .sheet(sheetName).doWrite(data);
        
        response.addHeader("Content-Disposition", "attachment;filename=" + HttpUtils.encodeUtf8(filename));
        response.setContentType("application/vnd.ms-excel;charset=UTF-8");
    }
    
    /**
     * 导入Excel
     */
    public static <T> List<T> read(MultipartFile file, Class<T> head) throws IOException {
        return FastExcelFactory.read(file.getInputStream(), head, null)
                .autoCloseStream(false)
                .doReadAllSync();
    }
}
```

#### 使用ExcelUtils

```java
@RestController
public class UserController {
    
    @GetMapping("/users/export")
    public void exportUsers(HttpServletResponse response) throws IOException {
        List<UserDO> users = userService.getUsers();
        List<UserExcelVO> excelData = BeanUtils.toBeanList(users, UserExcelVO.class);
        
        ExcelUtils.write(response, "用户列表.xlsx", "用户信息", UserExcelVO.class, excelData);
    }
    
    @PostMapping("/users/import")
    public CommonResult<String> importUsers(@RequestParam("file") MultipartFile file) throws IOException {
        List<UserExcelVO> excelData = ExcelUtils.read(file, UserExcelVO.class);
        String result = userService.importUsers(excelData);
        return CommonResult.success(result);
    }
}
```

### 数据转换

#### 数据字典转换

```java
@Data
@ExcelProperty("用户信息")
public class UserExcelVO {
    
    @ExcelProperty("状态")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_STATUS)
    private Integer status;
    
    @ExcelProperty("用户类型")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_TYPE)
    private Integer userType;
}
```

#### 枚举转换

```java
@Data
@ExcelProperty("用户信息")
public class UserExcelVO {
    
    @ExcelProperty("状态")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_STATUS)
    private Integer status;
}
```

#### 自定义转换

```java
@Component
public class CustomExcelColumnSelectFunction implements ExcelColumnSelectFunction {
    
    @Override
    public List<String> getOptions() {
        return Arrays.asList("启用", "禁用");
    }
    
    @Override
    public String getFunctionName() {
        return "USER_STATUS";
    }
}
```

### 样式设置

#### 列宽自动调整

```java
@Component
public class ColumnWidthMatchStyleStrategy implements WriteHandler {
    
    @Override
    public void afterSheetCreate(WriteWorkbookHolder writeWorkbookHolder, 
                                WriteSheetHolder writeSheetHolder) {
        // 自动调整列宽
        Sheet sheet = writeSheetHolder.getSheet();
        for (int i = 0; i < sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row != null) {
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    Cell cell = row.getCell(j);
                    if (cell != null) {
                        int columnWidth = cell.getStringCellValue().length();
                        sheet.setColumnWidth(j, columnWidth * 256);
                    }
                }
            }
        }
    }
}
```

#### 下拉框设置

```java
@Component
public class SelectSheetWriteHandler implements WriteHandler {
    
    @Override
    public void afterSheetCreate(WriteWorkbookHolder writeWorkbookHolder, 
                                WriteSheetHolder writeSheetHolder) {
        // 设置下拉框
        Sheet sheet = writeSheetHolder.getSheet();
        DataValidationHelper helper = sheet.getDataValidationHelper();
        
        // 创建下拉框数据
        DataValidationConstraint constraint = helper.createExplicitListConstraint(
            new String[]{"启用", "禁用"}
        );
        
        // 设置下拉框范围
        CellRangeAddressList regions = new CellRangeAddressList(1, 1000, 4, 4);
        DataValidation validation = helper.createValidation(constraint, regions);
        
        sheet.addValidationData(validation);
    }
}
```

## 注解说明

### @ExcelProperty

Excel属性注解：

```java
@ExcelProperty(
    value = "用户名",           // 列名
    index = 0,                // 列索引
    converter = StringConverter.class  // 转换器
)
private String username;
```

### @ExcelColumnSelect

Excel列选择注解：

```java
@ExcelColumnSelect(
    function = ExcelColumnSelectFunction.USER_STATUS,  // 选择函数
    allowBlank = true                                 // 是否允许空白
)
private Integer status;
```

### @DateTimeFormat

日期时间格式注解：

```java
@DateTimeFormat("yyyy-MM-dd HH:mm:ss")
private LocalDateTime createTime;
```

## 工具类

### ExcelUtils

Excel工具类：

```java
// 导出Excel
ExcelUtils.write(response, "用户列表.xlsx", "用户信息", UserExcelVO.class, excelData);

// 导入Excel
List<UserExcelVO> excelData = ExcelUtils.read(file, UserExcelVO.class);

// 读取Excel（带校验）
List<UserExcelVO> excelData = ExcelUtils.readWithValidation(file, UserExcelVO.class);
```

### DictFrameworkUtils

数据字典工具类：

```java
// 获取字典标签
String label = DictFrameworkUtils.getDictLabel("user_status", "1");

// 获取字典值
String value = DictFrameworkUtils.getDictValue("user_status", "启用");
```

## 最佳实践

### 1. Excel实体类设计

```java
@Data
@ExcelProperty("用户信息")
public class UserExcelVO {
    
    @ExcelProperty("用户ID")
    private Long id;
    
    @ExcelProperty("用户名")
    private String username;
    
    @ExcelProperty("邮箱")
    private String email;
    
    @ExcelProperty("手机号")
    private String mobile;
    
    @ExcelProperty("状态")
    @ExcelColumnSelect(function = ExcelColumnSelectFunction.USER_STATUS)
    private Integer status;
    
    @ExcelProperty("创建时间")
    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
```

### 2. 导入导出设计

```java
@RestController
public class UserController {
    
    @GetMapping("/users/export")
    public void exportUsers(HttpServletResponse response) throws IOException {
        List<UserDO> users = userService.getUsers();
        List<UserExcelVO> excelData = BeanUtils.toBeanList(users, UserExcelVO.class);
        
        ExcelUtils.write(response, "用户列表.xlsx", "用户信息", UserExcelVO.class, excelData);
    }
    
    @PostMapping("/users/import")
    public CommonResult<String> importUsers(@RequestParam("file") MultipartFile file) throws IOException {
        List<UserExcelVO> excelData = ExcelUtils.read(file, UserExcelVO.class);
        String result = userService.importUsers(excelData);
        return CommonResult.success(result);
    }
}
```

### 3. 数据校验设计

```java
@Service
public class UserService {
    
    public String importUsers(List<UserExcelVO> excelData) {
        int successCount = 0;
        int failCount = 0;
        StringBuilder errorMsg = new StringBuilder();
        
        for (int i = 0; i < excelData.size(); i++) {
            UserExcelVO excelVO = excelData.get(i);
            try {
                // 数据校验
                validateUserData(excelVO);
                
                // 创建用户
                UserDO user = BeanUtils.toBean(excelVO, UserDO.class);
                userMapper.insert(user);
                successCount++;
                
            } catch (Exception e) {
                failCount++;
                errorMsg.append("第").append(i + 1).append("行：").append(e.getMessage()).append("\n");
            }
        }
        
        return String.format("导入完成，成功：%d条，失败：%d条", successCount, failCount);
    }
}
```

### 4. 错误处理

```java
@Service
public class UserService {
    
    public String importUsers(List<UserExcelVO> excelData) {
        int successCount = 0;
        int failCount = 0;
        StringBuilder errorMsg = new StringBuilder();
        
        for (int i = 0; i < excelData.size(); i++) {
            UserExcelVO excelVO = excelData.get(i);
            try {
                // 数据校验
                validateUserData(excelVO);
                
                // 创建用户
                UserDO user = BeanUtils.toBean(excelVO, UserDO.class);
                userMapper.insert(user);
                successCount++;
                
            } catch (Exception e) {
                failCount++;
                errorMsg.append("第").append(i + 1).append("行：").append(e.getMessage()).append("\n");
            }
        }
        
        return String.format("导入完成，成功：%d条，失败：%d条", successCount, failCount);
    }
}
```

## 故障排除

### 常见问题

1. **Excel导入失败**
   - 检查Excel文件格式是否正确
   - 确认实体类注解配置是否正确
   - 验证数据转换器是否正确

2. **Excel导出失败**
   - 检查响应头设置是否正确
   - 确认数据格式是否正确
   - 验证样式设置是否正确

3. **数据转换失败**
   - 检查数据字典配置是否正确
   - 确认转换器是否正确实现
   - 验证数据格式是否正确

4. **样式设置不生效**
   - 检查样式处理器是否正确注册
   - 确认样式配置是否正确
   - 验证Excel版本是否支持

### 日志配置

```yaml
logging:
  level:
    com.wmt.framework.excel: DEBUG
    cn.idev.excel: DEBUG
```

## 版本兼容性

- Spring Boot: 2.7.x
- FastExcel: 1.3.x
- Java: 8+

## 许可证

本项目基于 MIT 许可证开源。
