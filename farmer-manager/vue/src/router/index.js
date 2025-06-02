import Vue from 'vue'
import Router from 'vue-router'


Vue.use(Router)

// 解决导航栏或者底部导航tabBar中的vue-router在3.0版本以上频繁点击菜单报错的问题。
const originalPush = Router.prototype.push
Router.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}

const routes = [
  {
    path: '/',
    name: 'Manager',
    component: () => import('../views/Manager.vue'),
    redirect: '/login',  // 重定向到主页
    children: [
      { path: '403', name: 'NoAuth', meta: { name: '无权限' }, component: () => import('../views/manager/403') },
      { path: 'home', name: 'ManagerHome', meta: { name: '系统首页' }, component: () => import('../views/manager/Home') },
      { path: 'admin', name: 'Admin', meta: { name: '管理员信息' }, component: () => import('../views/manager/Admin') },
      { path: 'adminPerson', name: 'AdminPerson', meta: { name: '个人信息' }, component: () => import('../views/manager/AdminPerson') },
      { path: 'password', name: 'Password', meta: { name: '修改密码' }, component: () => import('../views/manager/Password') },
      { path: 'notice', name: 'Notice', meta: { name: '公告信息' }, component: () => import('../views/manager/Notice') },
      { path: 'information', name: 'Information', meta: { name: '扶贫资讯' }, component: () => import('../views/manager/Information') },
      { path: 'user', name: 'User', meta: { name: '用户信息' }, component: () => import('../views/manager/User') },
      { path: 'policy', name: 'Policy', meta: { name: '扶贫政策' }, component: () => import('../views/manager/Policy') },
      { path: 'agritainment', name: 'Agritainment', meta: { name: '农家乐信息' }, component: () => import('../views/manager/Agritainment') },
      { path: 'goods', name: 'Goods', meta: { name: '商品信息' }, component: () => import('../views/manager/Goods') },
      { path: 'orders', name: 'ManagerOrders', meta: { name: '订单信息' }, component: () => import('../views/manager/Orders.vue') },
      { path: 'poorapply', name: 'Poorapply', meta: { name: '扶贫申请' }, component: () => import('../views/manager/PoorApply.vue') },
      { path: 'projectapply', name: 'Projectapply', meta: { name: '扶贫项目' }, component: () => import('../views/manager/ProjectApply.vue') },
      { path: 'comment', name: 'Comment', meta: { name: '政策管理' }, component: () => import('../views/manager/Comment.vue') }
    ]
  },
  {
    path: '/front',
    name: 'Front',
    component: () => import('../views/Front.vue'),
    children: [
      { path: '', name: 'FrontHome', meta: { name: '系统首页' }, component: () => import('../views/front/Home') },
      { path: 'Person', name: 'FrontPerson', meta: { name: '个人信息' }, component: () => import('../views/front/Person.vue') },
      { path: 'InformationDetail', name: 'FrontInformationDetail', meta: { name: '资讯详情' }, component: () => import('../views/front/InformationDetail') },
      { path: 'PolicyDetail', name: 'FrontPolicyDetail', meta: { name: '政策详情' }, component: () => import('../views/front/PolicyDetail') },
      { path: 'AgritainmentDetail', name: 'FrontAgritainmentDetail', meta: { name: '农家乐信息' }, component: () => import('../views/front/AgritainmentDetail.vue') },
      { path: 'Orders', name: 'FrontOrders', meta: { name: '订单信息' }, component: () => import('../views/front/Orders.vue') },
      { path: 'Apply', name: 'FrontApply', meta: { name: '贫困户申请' }, component: () => import('../views/front/Apply.vue') },
      { path: 'Praise', name: 'FrontPraise', meta: { name: '点赞' }, component: () => import('../views/front/Praise.vue') },
      { path: 'UploadGoods', name: 'FrontGoodsUpload', meta: { name: '上架货物' }, component: () => import('../views/front/UploadGoods.vue') },
      { path: 'ChatRoom', name: 'FrontChatRoom', meta: { name: '聊天室' }, component: () => import('../views/front/ChatRoom.vue') },
      { path: 'ChatAI', name: 'FrontChatAI', meta: { name: 'AI 聊天室' }, component: () => import('../views/front/ChatWithAI.vue') },
    ]
  },
  { path: '/login', name: 'Login', meta: { name: '登录' }, component: () => import('../views/Login.vue') },
  { path: '/register', name: 'Register', meta: { name: '注册' }, component: () => import('../views/Register.vue') }
]

const router = new Router({
    mode: 'history',
    base: '/',
    routes
})

export default router