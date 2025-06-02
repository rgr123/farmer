<template>
  <div class="ChatRoom">
    <div class="chat-header">
      <el-button type="primary" size="small" @click="goToAIChat">Chat 一下 🤖</el-button>
    </div>
    <div class="chat-box">
      <div
        v-for="msg in messages"
        :key="msg.time + msg.user"
        class="message"
        :class="getMessageClass(msg)"
      >
        <img :src="msg.avatar" class="avatar" />
        <div class="bubble">
          <div class="bubble-header">
            <span class="name">{{ msg.user }}</span>
            <span class="time">{{ msg.time }}</span>
          </div>
          <div class="content">{{ msg.content }}</div>
        </div>
      </div>
    </div>
    <div class="input-area">
      <el-input v-model="inputMessage" @keyup.enter.native="sendMessage" placeholder="输入内容..." class="input-box" />
      <el-button type="primary" @click="sendMessage" class="send-button">发送</el-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      socket: null,
      messages: [],
      inputMessage: '',
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
    };
  },
  created() {
    this.connectWebSocket();
    this.loadHistory();
  },
  methods: {
    async loadHistory() {
      try {
        const response = await fetch("http://localhost:9090/message/history");
        if (response.ok) {
          const result = await response.json();
          this.messages = result.data || [];
          this.scrollToBottom();
        } else {
          console.error("加载历史消息失败:", response.statusText);
        }
      } catch (error) {
        console.error("加载历史消息时发生错误:", error);
      }
    },
    connectWebSocket() {
      this.socket = new WebSocket("ws://localhost:9090/chat");

      this.socket.onopen = () => {
        console.log("WebSocket 连接成功");
      };

      this.socket.onmessage = (event) => {
        try {
          const message = JSON.parse(event.data);
          this.messages.push(message);
          this.scrollToBottom();
        } catch (error) {
          console.error("接收到的消息不是有效的 JSON:", event.data);
        }
      };

      this.socket.onerror = (error) => {
        console.error("WebSocket 连接错误:", error);
      };

      this.socket.onclose = () => {
        console.warn("WebSocket 连接已关闭，尝试重新连接...");
        setTimeout(() => {
          this.connectWebSocket();
        }, 3000);
      };
    },
    sendMessage() {
      if (!this.inputMessage.trim()) return;

      if (this.socket.readyState !== WebSocket.OPEN) {
        console.error("WebSocket 连接未打开，无法发送消息");
        return;
      }

      const message = {
        user: this.user.username,
        avatar: this.user.avatar,
        content: this.inputMessage,
        time: new Date().toLocaleString(),
      };

      this.socket.send(JSON.stringify(message));
      this.inputMessage = '';
    },
    scrollToBottom() {
      this.$nextTick(() => {
        setTimeout(() => {
          const box = this.$el.querySelector(".chat-box");
          if (box) box.scrollTop = box.scrollHeight;
        }, 100);
      });
    },
    getMessageClass(msg) {
      const currentUser = this.user.username?.trim?.();
      const messageUser = msg.user?.trim?.();
      return messageUser === currentUser ? 'my-message' : 'other-message';
    },
    goToAIChat() {
    this.$router.push('/front/ChatAI');
}
  },
  beforeDestroy() {
    if (this.socket) {
      this.socket.close();
    }
  }
};
</script>

<style scoped>
.ChatRoom {
  position: fixed;
  top: 100px;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  flex-direction: column;
  background-color: #fff;
}
.chat-header {
  padding: 10px;
  background: #fff;
  border-bottom: 1px solid #eee;
}
.chat-box {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background-color: #fff;
}
.message {
  display: flex;
  margin-bottom: 12px;
}
.my-message {
  flex-direction: row-reverse;
}
.my-message .bubble {
  background-color: #d2f8d2;
}
.other-message .bubble {
  background-color: #fff;
}
.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
}
.bubble {
  padding: 10px 15px;
  border-radius: 10px;
  max-width: 70%;
  margin: 0 10px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
.bubble-header {
  display: flex;
  justify-content: space-between;
  gap: 30px;
  font-size: 13px;
  margin-bottom: 4px;
}
.content {
  font-size: 15px;
}
.input-area {
  display: flex;
  padding: 10px;
  border-top: 1px solid #eee;
  background: #fff;
}
.input-box {
  flex: 1;
}
.send-button {
  margin-left: 10px;
}
</style>
