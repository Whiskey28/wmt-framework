# 基于本框架的Vue3实战教学

> 以你当前项目框架为例，从零到一掌握Vue3核心能力

---

## 📋 目录

1. [框架概览](#1-框架概览)
2. [路由管理（Vue Router）](#2-路由管理vue-router)
3. [API对接（Axios封装）](#3-api对接axios封装)
4. [状态管理（Pinia）](#4-状态管理pinia)
5. [完整案例：用户管理功能](#5-完整案例用户管理功能)
6. [实战练习](#6-实战练习)

---

## 1. 框架概览

### 1.1 项目结构

```
src/
├── api/              # API接口定义
│   ├── system/      # 系统管理相关API
│   ├── crm/         # CRM相关API
│   └── ...
├── views/           # 页面组件
│   ├── system/     # 系统管理页面
│   │   └── user/   # 用户管理
│   └── ...
├── router/          # 路由配置
│   ├── index.ts    # 路由主文件
│   └── modules/    # 路由模块
├── store/          # 状态管理（Pinia）
│   ├── index.ts    # Store主文件
│   └── modules/    # Store模块
├── config/         # 配置文件
│   └── axios/      # Axios配置
├── components/     # 公共组件
├── utils/          # 工具函数
└── main.ts         # 入口文件
```

### 1.2 技术栈

- **Vue 3** + **TypeScript**：核心框架
- **Vue Router**：路由管理
- **Pinia**：状态管理
- **Axios**：HTTP请求
- **Element Plus**：UI组件库
- **Vite**：构建工具

---

## 2. 路由管理（Vue Router）

### 2.1 路由配置（`src/router/index.ts`）

**框架中的路由配置：**

```typescript
import { createRouter, createWebHistory } from 'vue-router'
import remainingRouter from './modules/remaining'

// 创建路由实例
const router = createRouter({
  history: createWebHistory(import.meta.env.VITE_BASE_PATH),
  strict: true,
  routes: remainingRouter as RouteRecordRaw[],
  scrollBehavior: () => ({ left: 0, top: 0 })
})

export default router
```

**关键点解析：**

1. **`createWebHistory`**：使用HTML5历史模式（URL不带#）
   - 对比：`createWebHashHistory` 会生成带#的URL（如：`/user#/list`）
   - 本框架使用：`createWebHistory`（URL更美观：`/user/list`）

2. **`routes`**：路由表配置
   - 从 `modules/remaining.ts` 导入静态路由
   - 动态路由在权限控制中动态添加

### 2.2 路由定义（`src/router/modules/remaining.ts`）

**框架中的路由定义示例：**

```typescript
const remainingRouter: AppRouteRecordRaw[] = [
  {
    path: '/redirect',
    component: Layout,
    name: 'Redirect',
    children: [
      {
        path: '/redirect/:path(.*)',
        name: 'Redirect',
        component: () => import('@/views/Redirect/Redirect.vue'),
        meta: {}
      }
    ],
    meta: {
      hidden: true,
      noTagsView: true
    }
  },
  {
    path: '/login',
    component: () => import('@/views/Login/Login.vue'),
    name: 'Login',
    meta: {
      hidden: true
    }
  }
]
```

**路由配置说明：**

- **`path`**：路由路径
- **`component`**：组件（支持懒加载：`() => import(...)`）
- **`name`**：路由名称（用于编程式导航）
- **`meta`**：路由元信息
  - `hidden: true`：不在侧边栏显示
  - `noTagsView: true`：不在标签页显示

### 2.3 路由守卫（`src/permission.ts`）

**框架中的路由守卫：**

```typescript
// 路由加载前
router.beforeEach(async (to, from, next) => {
  start()  // 开始进度条
  loadStart()  // 开始页面加载动画
  
  if (getAccessToken()) {
    // 已登录
    if (to.path === '/login') {
      next({ path: '/' })  // 已登录，跳转到首页
    } else {
      // 检查用户信息是否已加载
      const userStore = useUserStoreWithOut()
      if (!userStore.getIsSetUser) {
        // 加载用户信息
        await userStore.setUserInfoAction()
        // 动态添加路由
        await permissionStore.generateRoutes()
        permissionStore.getAddRouters.forEach((route) => {
          router.addRoute(route)
        })
      }
      next()
    }
  } else {
    // 未登录
    if (whiteList.indexOf(to.path) !== -1) {
      next()  // 白名单路由，允许访问
    } else {
      next(`/login?redirect=${to.fullPath}`)  // 跳转到登录页
    }
  }
})

// 路由加载后
router.afterEach((to) => {
  useTitle(to?.meta?.title as string)  // 设置页面标题
  done()  // 结束进度条
  loadDone()  // 结束页面加载动画
})
```

**路由守卫的作用：**

1. **权限控制**：检查登录状态，未登录跳转到登录页
2. **动态路由**：根据用户权限动态添加路由
3. **页面标题**：根据路由meta设置页面标题
4. **加载动画**：显示/隐藏加载动画

### 2.4 路由跳转

**在组件中使用路由：**

```vue
<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

// 方式1：编程式导航
const goToUserList = () => {
  router.push('/system/user')  // 跳转到用户列表
}

// 方式2：带参数跳转
const goToUserDetail = (id: number) => {
  router.push({
    path: '/system/user/detail',
    query: { id }  // URL参数：/system/user/detail?id=123
  })
  
  // 或者使用params（需要在路由中定义）
  router.push({
    name: 'UserDetail',
    params: { id }  // 路径参数：/system/user/detail/123
  })
}

// 方式3：模板中使用
</script>

<template>
  <!-- 声明式导航 -->
  <router-link to="/system/user">用户列表</router-link>
  
  <!-- 按钮跳转 -->
  <el-button @click="goToUserList">跳转到用户列表</el-button>
</template>
```

---

## 3. API对接（Axios封装）

### 3.1 Axios配置（`src/config/axios/index.ts`）

**框架中的Axios封装：**

```typescript
import request from '@/config/axios'

// GET请求
export const getUserPage = (params: PageParam) => {
  return request.get({ url: '/system/user/page', params })
}

// POST请求
export const createUser = (data: UserVO) => {
  return request.post({ url: '/system/user/create', data })
}

// PUT请求
export const updateUser = (data: UserVO) => {
  return request.put({ url: '/system/user/update', data })
}

// DELETE请求
export const deleteUser = (id: number) => {
  return request.delete({ url: '/system/user/delete?id=' + id })
}
```

**封装的好处：**

1. **统一接口**：所有API调用都通过 `request` 对象
2. **类型安全**：TypeScript类型定义
3. **统一处理**：错误处理、token添加等都在拦截器中处理

### 3.2 请求拦截器（`src/config/axios/service.ts`）

**框架中的请求拦截器：**

```typescript
service.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // 1. 添加Token
    if (getAccessToken() && !isToken) {
      config.headers.Authorization = 'Bearer ' + getAccessToken()
    }
    
    // 2. 设置租户ID（多租户系统）
    if (tenantEnable && tenantEnable === 'true') {
      const tenantId = getTenantId()
      if (tenantId) config.headers['tenant-id'] = tenantId
    }
    
    // 3. 防止GET请求缓存
    if (config.method?.toUpperCase() === 'GET') {
      config.headers['Cache-Control'] = 'no-cache'
    }
    
    return config
  }
)
```

**请求拦截器的作用：**

- **自动添加Token**：每个请求自动携带登录token
- **设置租户ID**：多租户系统自动设置租户标识
- **防止缓存**：GET请求防止浏览器缓存

### 3.3 响应拦截器

**框架中的响应拦截器：**

```typescript
service.interceptors.response.use(
  async (response: AxiosResponse<any>) => {
    const { data } = response
    const code = data.code || result_code
    
    // 1. 处理401（未授权）
    if (code === 401) {
      // 尝试刷新token
      if (!isRefreshToken) {
        isRefreshToken = true
        try {
          const refreshTokenRes = await refreshToken()
          setToken(refreshTokenRes.data.data)
          // 重新发送原请求
          return service(response.config)
        } catch (e) {
          // 刷新失败，跳转登录
          handleAuthorized()
        } finally {
          isRefreshToken = false
        }
      }
    }
    
    // 2. 处理其他错误
    if (code !== 200) {
      ElNotification.error({ title: data.msg })
      return Promise.reject('error')
    }
    
    // 3. 成功返回数据
    return data
  },
  (error: AxiosError) => {
    // 网络错误处理
    let { message } = error
    if (message === 'Network Error') {
      message = '网络错误'
    } else if (message.includes('timeout')) {
      message = '请求超时'
    }
    ElMessage.error(message)
    return Promise.reject(error)
  }
)
```

**响应拦截器的作用：**

- **自动刷新Token**：401时自动刷新token并重试请求
- **统一错误处理**：所有错误统一提示
- **数据格式化**：统一返回数据格式

### 3.4 在组件中使用API

**框架中的实际使用示例：**

```vue
<script setup lang="ts">
import * as UserApi from '@/api/system/user'
import { message } from '@/utils/message'

// 获取列表
const getList = async () => {
  loading.value = true
  try {
    const data = await UserApi.getUserPage(queryParams)
    list.value = data.list
    total.value = data.total
  } finally {
    loading.value = false
  }
}

// 创建用户
const handleCreate = async () => {
  try {
    await UserApi.createUser(formData)
    message.success('创建成功')
    await getList()  // 刷新列表
  } catch (error) {
    // 错误已在拦截器中处理，这里不需要再处理
  }
}
</script>
```

---

## 4. 状态管理（Pinia）

### 4.1 Store配置（`src/store/index.ts`）

**框架中的Store配置：**

```typescript
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

const store = createPinia()
store.use(piniaPluginPersistedstate)  // 持久化插件

export { store }
```

**关键点：**

- **`pinia-plugin-persistedstate`**：数据持久化插件
  - 自动将Store数据保存到localStorage
  - 页面刷新后数据不丢失

### 4.2 User Store（`src/store/modules/user.ts`）

**框架中的User Store：**

```typescript
export const useUserStore = defineStore('admin-user', {
  state: (): UserInfoVO => ({
    permissions: new Set<string>(),  // 权限集合
    roles: [],                        // 角色列表
    isSetUser: false,                 // 是否已设置用户信息
    user: {                           // 用户信息
      id: 0,
      avatar: '',
      nickname: '',
      deptId: 0
    }
  }),
  
  getters: {
    getPermissions(): Set<string> {
      return this.permissions
    },
    getUser(): UserVO {
      return this.user
    }
  },
  
  actions: {
    // 设置用户信息
    async setUserInfoAction() {
      if (!getAccessToken()) {
        this.resetState()
        return null
      }
      const userInfo = await getInfo()  // 调用API获取用户信息
      this.permissions = new Set(userInfo.permissions)
      this.roles = userInfo.roles
      this.user = userInfo.user
      this.isSetUser = true
      wsCache.set(CACHE_KEY.USER, userInfo)  // 缓存到localStorage
    },
    
    // 登出
    async loginOut() {
      await loginOut()
      removeToken()
      deleteUserCache()
      this.resetState()
    }
  }
})
```

**Store结构说明：**

1. **`state`**：定义状态数据
2. **`getters`**：计算属性（类似Vue的computed）
3. **`actions`**：方法（可以异步）

### 4.3 在组件中使用Store

**框架中的实际使用：**

```vue
<script setup lang="ts">
import { useUserStoreWithOut } from '@/store/modules/user'

const userStore = useUserStoreWithOut()

// 获取用户信息
const user = computed(() => userStore.getUser)

// 检查权限
const hasPermission = (permission: string) => {
  return userStore.getPermissions.has(permission)
}

// 调用Store方法
const loadUserInfo = async () => {
  await userStore.setUserInfoAction()
}
</script>

<template>
  <div>
    <p>用户名：{{ user.nickname }}</p>
    <p v-if="hasPermission('system:user:create')">
      有创建用户权限
    </p>
  </div>
</template>
```

---

## 5. 完整案例：用户管理功能

### 5.1 列表页面（`src/views/system/user/index.vue`）

**框架中的用户列表页面结构：**

```vue
<template>
  <!-- 搜索区域 -->
  <ContentWrap>
    <el-form :model="queryParams" :inline="true" ref="queryFormRef">
      <el-form-item label="用户名称" prop="username">
        <el-input
          v-model="queryParams.username"
          placeholder="请输入用户名称"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button @click="handleQuery">搜索</el-button>
        <el-button @click="resetQuery">重置</el-button>
        <el-button type="primary" @click="openForm('create')">
          新增
        </el-button>
      </el-form-item>
    </el-form>
  </ContentWrap>

  <!-- 表格区域 -->
  <ContentWrap>
    <el-table v-loading="loading" :data="list">
      <el-table-column label="用户编号" prop="id" />
      <el-table-column label="用户名称" prop="username" />
      <el-table-column label="用户昵称" prop="nickname" />
      <el-table-column label="操作" width="160">
        <template #default="scope">
          <el-button @click="openForm('update', scope.row.id)">
            修改
          </el-button>
          <el-button type="danger" @click="handleDelete(scope.row.id)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <Pagination
      :total="total"
      v-model:page="queryParams.pageNo"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />
  </ContentWrap>

  <!-- 表单对话框 -->
  <UserForm ref="formRef" @success="getList" />
</template>

<script setup lang="ts">
import * as UserApi from '@/api/system/user'
import UserForm from './UserForm.vue'

// 数据定义
const list = ref([])
const total = ref(0)
const loading = ref(false)
const queryParams = reactive({
  pageNo: 1,
  pageSize: 10,
  username: undefined
})

// 方法定义
const getList = async () => {
  loading.value = true
  try {
    const data = await UserApi.getUserPage(queryParams)
    list.value = data.list
    total.value = data.total
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.pageNo = 1
  getList()
}

const openForm = (type: 'create' | 'update', id?: number) => {
  formRef.value?.open(type, id)
}

const handleDelete = async (id: number) => {
  try {
    await message.delConfirm()
    await UserApi.deleteUser(id)
    message.success('删除成功')
    await getList()
  } catch {}
}

// 生命周期
onMounted(() => {
  getList()
})
</script>
```

### 5.2 API定义（`src/api/system/user/index.ts`）

**框架中的API定义：**

```typescript
import request from '@/config/axios'

// 类型定义
export interface UserVO {
  id: number
  username: string
  nickname: string
  mobile: string
  email: string
  status: number
}

// API方法
export const getUserPage = (params: PageParam) => {
  return request.get({ url: '/system/user/page', params })
}

export const getUser = (id: number) => {
  return request.get({ url: '/system/user/get?id=' + id })
}

export const createUser = (data: UserVO) => {
  return request.post({ url: '/system/user/create', data })
}

export const updateUser = (data: UserVO) => {
  return request.put({ url: '/system/user/update', data })
}

export const deleteUser = (id: number) => {
  return request.delete({ url: '/system/user/delete?id=' + id })
}
```

### 5.3 表单组件（`src/views/system/user/UserForm.vue`）

**框架中的表单组件：**

```vue
<template>
  <Dialog v-model="dialogVisible" :title="dialogTitle">
    <el-form
      ref="formRef"
      :model="formData"
      :rules="formRules"
      label-width="80px"
    >
      <el-form-item label="用户昵称" prop="nickname">
        <el-input v-model="formData.nickname" placeholder="请输入用户昵称" />
      </el-form-item>
      <el-form-item label="手机号码" prop="mobile">
        <el-input v-model="formData.mobile" placeholder="请输入手机号码" />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button type="primary" @click="submitForm">确定</el-button>
      <el-button @click="dialogVisible = false">取消</el-button>
    </template>
  </Dialog>
</template>

<script setup lang="ts">
import * as UserApi from '@/api/system/user'

// 数据定义
const dialogVisible = ref(false)
const formType = ref<'create' | 'update'>('create')
const formData = reactive({
  id: undefined,
  nickname: '',
  mobile: ''
})

// 表单验证规则
const formRules = {
  nickname: [
    { required: true, message: '请输入用户昵称', trigger: 'blur' }
  ],
  mobile: [
    { required: true, message: '请输入手机号码', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号码格式不正确', trigger: 'blur' }
  ]
}

// 方法定义
const open = async (type: 'create' | 'update', id?: number) => {
  formType.value = type
  dialogVisible.value = true
  
  if (type === 'update' && id) {
    await loadData(id)
  } else {
    resetForm()
  }
}

const loadData = async (id: number) => {
  const data = await UserApi.getUser(id)
  Object.assign(formData, data)
}

const submitForm = async () => {
  if (!formRef.value) return
  const valid = await formRef.value.validate()
  if (!valid) return

  if (formType.value === 'create') {
    await UserApi.createUser(formData)
    message.success('创建成功')
  } else {
    await UserApi.updateUser(formData)
    message.success('修改成功')
  }
  
  dialogVisible.value = false
  emit('success')
}

// 暴露方法给父组件
defineExpose({ open })

// 发送事件给父组件
const emit = defineEmits<{
  success: []
}>()
</script>
```

---

## 6. 实战练习

### 练习1：理解路由跳转

**任务：** 在用户列表页面，点击"修改"按钮后，跳转到用户详情页

**步骤：**

1. 在路由配置中添加详情页路由
2. 在列表页使用 `router.push` 跳转
3. 在详情页使用 `route.params` 获取参数

**参考代码：**

```vue
<!-- 列表页 -->
<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const goToDetail = (id: number) => {
  router.push({
    path: '/system/user/detail',
    query: { id }
  })
}
</script>

<!-- 详情页 -->
<script setup lang="ts">
import { useRoute } from 'vue-router'

const route = useRoute()
const userId = computed(() => route.query.id)
</script>
```

### 练习2：封装新的API

**任务：** 为"部门管理"功能封装API

**步骤：**

1. 创建 `src/api/system/dept/index.ts`
2. 定义类型和API方法
3. 在组件中使用

**参考代码：**

```typescript
// src/api/system/dept/index.ts
import request from '@/config/axios'

export interface DeptVO {
  id: number
  name: string
  parentId: number
}

export const getDeptPage = (params: PageParam) => {
  return request.get({ url: '/system/dept/page', params })
}

export const createDept = (data: DeptVO) => {
  return request.post({ url: '/system/dept/create', data })
}
```

### 练习3：使用Store管理全局状态

**任务：** 创建一个"主题切换"的Store

**步骤：**

1. 创建 `src/store/modules/theme.ts`
2. 定义主题状态和方法
3. 在组件中使用

**参考代码：**

```typescript
// src/store/modules/theme.ts
export const useThemeStore = defineStore('theme', {
  state: () => ({
    theme: 'light'  // light | dark
  }),
  actions: {
    toggleTheme() {
      this.theme = this.theme === 'light' ? 'dark' : 'light'
    }
  }
})
```

---

## 🎯 核心要点总结

### 1. 路由管理
- ✅ 使用 `createRouter` 创建路由实例
- ✅ 使用 `router.push` 进行编程式导航
- ✅ 使用 `router.beforeEach` 进行权限控制
- ✅ 支持动态路由（根据权限添加）

### 2. API对接
- ✅ 使用 `request.get/post/put/delete` 封装API
- ✅ 请求拦截器自动添加Token
- ✅ 响应拦截器统一处理错误
- ✅ 支持Token自动刷新

### 3. 状态管理
- ✅ 使用 `defineStore` 定义Store
- ✅ 使用 `state/getters/actions` 组织代码
- ✅ 支持数据持久化（localStorage）
- ✅ 在组件中使用 `useStore` 获取Store

### 4. 完整功能开发流程
1. **定义API**：在 `src/api` 中定义接口
2. **创建页面**：在 `src/views` 中创建页面组件
3. **配置路由**：在 `src/router` 中添加路由
4. **使用Store**：如需全局状态，在 `src/store` 中定义

---

## 📚 下一步学习

完成以上内容后，你已经掌握了：

- ✅ Vue Router路由管理
- ✅ Axios API对接
- ✅ Pinia状态管理
- ✅ 完整功能开发流程

**建议下一步：**

1. **实际项目练习**：基于框架开发一个新功能（如：客户管理）
2. **深入理解**：阅读框架中其他模块的代码
3. **优化提升**：学习框架中的最佳实践

**祝你开发顺利！** 🚀

