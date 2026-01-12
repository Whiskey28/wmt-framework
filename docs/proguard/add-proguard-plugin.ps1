# 批量为所有 jar 类型的子模块添加 ProGuard 插件声明
$moduleFiles = Get-ChildItem -Path "wmt-framework\wmt-spring-boot-starter-*" -Filter "pom.xml" -Recurse
$moduleFiles += Get-ChildItem -Path "wmt-framework\wmt-common" -Filter "pom.xml" -Recurse

$pluginDeclaration = @"
    <build>
        <plugins>
            <!-- ProGuard代码混淆插件，从父pom的pluginManagement继承配置 -->
            <plugin>
                <groupId>com.github.wvengen</groupId>
                <artifactId>proguard-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
"@

foreach ($file in $moduleFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # 检查是否是 jar 类型
    if ($content -match 'packaging>jar<') {
        # 检查是否已经包含插件声明
        if ($content -notmatch 'proguard-maven-plugin') {
            # 替换 </project> 标签
            $newContent = $content -replace '</project>', $pluginDeclaration
            Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
            Write-Host "已为 $($file.Name) 添加 ProGuard 插件声明"
        } else {
            Write-Host "$($file.Name) 已包含 ProGuard 插件声明，跳过"
        }
    }
}

Write-Host "完成！"

