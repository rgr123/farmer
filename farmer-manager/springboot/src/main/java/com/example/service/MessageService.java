package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.entity.Message;
import com.example.mapper.MessageMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service
public class MessageService {

    @Resource
    private MessageMapper messageMapper;

    /**
     * 查询所有历史消息
     */
    public List<Message> getAllMessages() {
        return messageMapper.getAllMessages(); // 从数据库查询所有消息
    }

    /**
     * 新增消息
     */
    @Transactional
    public void add(Message message) {
        message.setTime(DateUtil.now()); // 设置当前时间
        messageMapper.insert(message); // 保存消息到数据库
    }
}