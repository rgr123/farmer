<template>
  <div>
    <div class="front-notice"><i class="el-icon-bell" style="margin-right: 2px"></i>公告：{{ top }}</div>
    <!--头部-->
    <div class="front-header">
      <div class="front-header-left">
        <img src="@/assets/imgs/logo.png" alt="">
        <div class="title" @click="navTo('/front')">中国助农扶贫网</div>
      </div>
      <div class="front-header-center">
        <div class="front-header-nav">
        </div>
      </div>
      <div style="text-align: right; margin: 20px 40px 0 0">
        <el-button type="success" icon="el-icon-chat-dot-round" @click="navTo('/front/ChatRoom')">进入聊天室</el-button>
      </div>
      <div class="front-header-right">
        <div v-if="!user.username">
          <el-button @click="$router.push('/login')">登录</el-button>
          <el-button @click="$router.push('/register')">注册</el-button>
        </div>
        <div v-else>
          <el-dropdown>
            <div class="front-header-dropdown">
              <img :src="user.avatar" alt="">
              <div style="margin-left: 10px">
                <span>{{ user.name }}</span><i class="el-icon-arrow-down" style="margin-left: 5px"></i>
              </div>
            </div>

            <el-dropdown-menu slot="dropdown">
              <template v-if="user.role === 'USER'">
               <el-dropdown-item>
                 <div style="text-decoration: none" @click="navTo('/front/Person')">个人中心</div>
               </el-dropdown-item>
               <el-dropdown-item>
                  <div style="text-decoration: none" @click="navTo('/front/Orders')">我的订单</div>
                </el-dropdown-item>
               <el-dropdown-item>
                  <div style="text-decoration: none" @click="navTo('/front/Apply')">申请</div>
               </el-dropdown-item>
                <el-dropdown-item>
                  <div style="text-decoration: none" @click="navTo('/front/Praise')">历史点赞</div>
               </el-dropdown-item>
               <el-dropdown-item>
                  <div style="text-decoration: none" @click="navTo('/front/UploadGoods')">上架货物</div>
               </el-dropdown-item>
              </template>

              <template v-else-if="user.role === 'ADMIN'">
                <el-dropdown-item>
                  <div style="text-decoration: none" @click="navTo('/home')">后台管理</div>
                </el-dropdown-item>
              </template>
              <el-dropdown-item>
                <div style="text-decoration: none" @click="logout">退出</div>
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>
    </div>
    <!--主体-->
    <div class="main-body">
      <router-view ref="child" @update:user="updateUser" />
    </div>
  </div>

</template>

<script>

export default {
  name: "FrontLayout",

  data () {
    return {
      top: '',
      notice: [],
      user: JSON.parse(localStorage.getItem("xm-user") || '{}'),
    }
  },

  mounted() {
    this.loadNotice()
  },
  methods: {
    loadNotice() {
      this.$request.get('/notice/selectAll').then(res => {
        this.notice = res.data
        let i = 0
        if (this.notice && this.notice.length) {
          this.top = this.notice[0].content
          setInterval(() => {
            this.top = this.notice[i].content
            i++
            if (i === this.notice.length) {
              i = 0
            }
          }, 2500)
        }
      })
    },
    updateUser() {
      this.user = JSON.parse(localStorage.getItem('xm-user') || '{}')   // 重新获取下用户的最新信息
    },
    // 退出登录
    logout() {
      localStorage.removeItem("xm-user");
      this.$router.push("/login");
    },
    navTo(url) {
      this.$router.push(url);
    }
  }

}
</script>

<style scoped>
  @import "@/assets/css/front.css";
</style>