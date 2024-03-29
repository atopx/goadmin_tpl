import router from "@/router"
import { whiteList } from "@/config/white-list"
import { getToken } from "@/utils/cache/cookies"
import NProgress from "nprogress"
import "nprogress/nprogress.css"
import { useUserStoreHook } from "@/store/modules/user"

NProgress.configure({ showSpinner: false })

router.beforeEach(async (to, _from, next) => {
    NProgress.start()
    // 判断该用户是否登录
    const token = getToken()
    if (token.expireTime > 0 ) {
        if (to.path === "/login") {
            // 如果已经登录，并准备进入 Login 页面，则重定向到主页
            next({ path: "/" })
            NProgress.done()
        } else {
            // 判断是否过期, 如果过期则尝试刷新token
            if (Date.now() > token.expireTime) {
                useUserStoreHook().refreshToken({ refresh_token: useUserStoreHook().token.refreshToken })
            }
            next()
        }
    } else {
        // 如果没有 Token
        if (whiteList.indexOf(to.path) !== -1) {
            // 如果在免登录的白名单中，则直接进入
            next()
        } else {
            // 其他没有访问权限的页面将被重定向到登录页面
            next("/login")
            NProgress.done()
        }
    }
})

router.afterEach(() => {
    NProgress.done()
})
