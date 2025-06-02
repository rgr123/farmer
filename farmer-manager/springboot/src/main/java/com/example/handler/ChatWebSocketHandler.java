package com.example.handler;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.entity.Message;
import org.springframework.web.socket.CloseStatus;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import com.example.service.MessageService;

import org.springframework.stereotype.Component;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private static final List<WebSocketSession> sessions = new CopyOnWriteArrayList<>();

    private final MessageService messageService;

    public ChatWebSocketHandler(MessageService messageService) {
        this.messageService = messageService;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        System.out.println("新用户连接: " + session.getId());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
        System.out.println("用户断开连接: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        System.out.println("收到消息: " + payload);

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Message chatMessage = objectMapper.readValue(payload, Message.class);

            // 保存消息到数据库
            messageService.add(chatMessage);

            // 广播消息
            for (WebSocketSession webSocketSession : sessions) {
                if (webSocketSession.isOpen()) {
                    webSocketSession.sendMessage(new TextMessage(objectMapper.writeValueAsString(chatMessage)));
                } else {
                    sessions.remove(webSocketSession); // 移除已关闭的会话
                }
            }
        } catch (Exception e) {
            System.err.println("JSON 解析失败: " + e.getMessage());
            session.sendMessage(new TextMessage("消息格式错误，请发送有效的 JSON 数据"));
        }
    }
}