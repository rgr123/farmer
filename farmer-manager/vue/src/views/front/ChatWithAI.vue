<template> 
  <div class="chat-ai-container">
    <div class="header">
      <el-button type="primary" size="small" @click="$router.push('/front/ChatRoom')">
        返回聊天室
      </el-button>
    </div>

    <div class="messages" ref="messageBox">
      <div
        v-for="(msg, index) in messages"
        :key="index"
        :class="['msg', msg.user === '我' ? 'my-msg' : 'ai-msg']"
      >
        <div class="meta">
          <span class="user">{{ msg.user }}</span>
          <span class="time">{{ msg.time }}</span>
        </div>
        <div class="bubble">
          <span v-if="msg.loading">💬 {{ msg.content }}</span>
          <span v-else>{{ msg.content }}</span>
        </div>
      </div>
    </div>

    <div class="input-area">
      <el-input
        v-model="input"
        @keyup.enter.native="send"
        placeholder="请输入你想问的问题..."
        class="input-box"
      />
      <el-button type="primary" @click="send" class="send-button">发送</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChatWithAI',
  data() {
    return {
      input: '',
      messages: [],
    };
  },
  methods: {
    async send() {
      const content = this.input.trim();
      if (!content) return;

      const now = new Date().toLocaleString();

      // 用户消息
      this.messages.push({ user: '我', content, time: now });
      this.input = '';
      this.scrollToBottom();

      // 获取 token
      const user = JSON.parse(localStorage.getItem('xm-user'));
      const token = user ? user.token : null;
      if (!token) {
        this.messages.push({
          user: '系统',
          content: '未登录，请先登录。',
          time: new Date().toLocaleString(),
        });
        return;
      }

      // 添加“正在输入...”消息
      const loadingMsgIndex = this.messages.length;
      this.messages.push({
        user: 'AI',
        content: '正在输入...',
        time: new Date().toLocaleString(),
        loading: true,
      });
      this.scrollToBottom();

      try {
        const res = await this.$request.post(
          '/api/ai/chat',
          { message: content },
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        // 替换“正在输入...”为真实回复
        this.$set(this.messages, loadingMsgIndex, {
          user: 'AI',
          content: res.data,
          time: new Date().toLocaleString(),
        });
      } catch (error) {
        this.$set(this.messages, loadingMsgIndex, {
          user: '系统',
          content: `调用 AI 接口失败：${error.response?.data || error.message}`,
          time: new Date().toLocaleString(),
        });
      }

      this.scrollToBottom();
    },
    scrollToBottom() {
      this.$nextTick(() => {
        const box = this.$refs.messageBox;
        if (box) {
          box.scrollTop = box.scrollHeight;
        }
      });
    },
  },
};
</script>

<style scoped>
.chat-ai-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #f4f6f9;
  font-family: 'Helvetica Neue', sans-serif;
}

.header {
  padding: 12px 20px;
  background: #ffffff;
  border-bottom: 1px solid #e0e0e0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
}

.messages {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #eef1f5;
  display: flex;
  flex-direction: column;
}

.msg {
  display: flex;
  flex-direction: column;
  margin-bottom: 18px;
  word-break: break-word;
}

.my-msg {
  align-items: flex-end;
}

.ai-msg {
  align-items: flex-start;
}

/* 通用 meta 样式 */
.meta {
  display: flex;
  font-size: 13px;
  color: #999;
  margin-bottom: 4px;
  gap: 10px;
}

/* 我的消息：右对齐 */
.my-msg .meta {
  justify-content: flex-end;
  text-align: right;
}

/* AI 消息：左对齐 */
.ai-msg .meta {
  justify-content: flex-start;
  text-align: left;
}

.bubble {
  max-width: 75%;
  padding: 12px 16px;
  border-radius: 18px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
  white-space: pre-wrap;
  line-height: 1.6;
  font-size: 15px;
  transition: background 0.3s;
}

.my-msg .bubble {
  background: #d1f7c4;
}

.ai-msg .bubble {
  background: #d8eaff;
}

.input-area {
  display: flex;
  padding: 12px 16px;
  border-top: 1px solid #e0e0e0;
  background: #ffffff;
  position: sticky;
  bottom: 0;
  z-index: 10;
}

.input-box {
  flex: 1;
  font-size: 15px;
}

.send-button {
  margin-left: 10px;
  font-size: 15px;
  padding: 10px 16px;
}
</style>
