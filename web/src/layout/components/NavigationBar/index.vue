<script lang="ts" setup>
import { computed } from "vue"
import { useRouter } from "vue-router"
import { useAppStore } from "@/store/modules/app"
import { useSettingsStore } from "@/store/modules/settings"
import { useUserStore } from "@/store/modules/user"
import { UserFilled } from "@element-plus/icons-vue"
import Breadcrumb from "../Breadcrumb/index.vue"
import Hamburger from "../Hamburger/index.vue"

const router = useRouter()
const appStore = useAppStore()
const settingsStore = useSettingsStore()
const userStore = useUserStore()

const sidebar = computed(() => {
    return appStore.sidebar
})

const toggleSidebar = () => {
    appStore.toggleSidebar(false)
}
const logout = () => {
    userStore.logout()
    router.push("/login")
}

const userInfo = () => {
   router.push("/user/info")
}
</script>

<template>
    <div class="navigation-bar">
        <Hamburger :is-active="sidebar.opened" class="hamburger" @toggle-click="toggleSidebar" />
        <Breadcrumb class="breadcrumb" />
        <div class="right-menu">
            <el-dropdown class="right-menu-item">
                <div class="right-menu-avatar">
                    <el-avatar :icon="UserFilled" :size="30" />
                    <span>{{ userStore.username }}</span>
                </div>
                <template #dropdown>
                    <el-dropdown-menu>
                        <el-dropdown-item divided @click="userInfo">个人中心</el-dropdown-item>
                        <el-dropdown-item divided @click="logout">
                            <span style="display: block">退出登录</span>
                        </el-dropdown-item>
                    </el-dropdown-menu>
                </template>
            </el-dropdown>
        </div>
    </div>
</template>

<style lang="scss" scoped>
.navigation-bar {
    height: var(--v3-navigationbar-height);
    overflow: hidden;
    background: #fff;

    .hamburger {
        display: flex;
        align-items: center;
        height: 100%;
        float: left;
        padding: 0 15px;
        cursor: pointer;
    }

    .breadcrumb {
        float: left;

        // 参考 Bootstrap 的响应式设计 WIDTH = 576
        @media screen and (max-width: 576px) {
            display: none;
        }
    }

    .right-menu {
        float: right;
        margin-right: 10px;
        height: 100%;
        display: flex;
        align-items: center;
        color: #606266;

        .right-menu-item {
            padding: 0 10px;
            cursor: pointer;

            .right-menu-avatar {
                display: flex;
                align-items: center;

                .el-avatar {
                    margin-right: 10px;
                }

                span {
                    font-size: 16px;
                }
            }
        }
    }
}
</style>
